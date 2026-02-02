local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Create the GUI via script to avoid "nil" errors
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HeartFlightGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- The Main Panel
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 200, 0, 150)
mainPanel.Position = UDim2.new(0.5, -100, 0.5, -75)
mainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.Parent = mainPanel

-- The Logo (Heart)
local logoButton = Instance.new("TextButton")
logoButton.Name = "LogoButton"
logoButton.Size = UDim2.new(0, 60, 0, 60)
logoButton.Position = UDim2.new(0, 10, 0, 10)
logoButton.Text = "❤"
logoButton.TextScaled = true
logoButton.TextColor3 = Color3.fromRGB(255, 50, 50)
logoButton.BackgroundTransparency = 1
logoButton.Visible = false
logoButton.Parent = screenGui

-- Minimize Button (Inside Panel)
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -35, 0, 5)
minButton.Text = "❤"
minButton.TextColor3 = Color3.fromRGB(255, 50, 50)
minButton.BackgroundTransparency = 1
minButton.Parent = mainPanel

-- Flight Toggle
local flightBtn = Instance.new("TextButton")
flightBtn.Size = UDim2.new(0, 160, 0, 40)
flightBtn.Position = UDim2.new(0.5, -80, 0.3, 0)
flightBtn.Text = "Flight: OFF"
flightBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
flightBtn.Parent = mainPanel

-- Noclip Toggle
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0, 160, 0, 40)
noclipBtn.Position = UDim2.new(0.5, -80, 0.65, 0)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
noclipBtn.Parent = mainPanel

---------------- PHYSICS LOGIC ----------------

local FLYING = false
local NOCLIP = false
local FLY_SPEED = 50

local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local attachment = Instance.new("Attachment", rootPart)
local linearVelocity = Instance.new("LinearVelocity", rootPart)
local alignOrientation = Instance.new("AlignOrientation", rootPart)

linearVelocity.Attachment0 = attachment
linearVelocity.MaxForce = 0
alignOrientation.Attachment0 = attachment
alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
alignOrientation.MaxTorque = 0

minButton.Activated:Connect(function()
	mainPanel.Visible = false
	logoButton.Visible = true
end)

logoButton.Activated:Connect(function()
	mainPanel.Visible = true
	logoButton.Visible = false
end)

flightBtn.Activated:Connect(function()
	FLYING = not FLYING
	flightBtn.Text = FLYING and "Flight: ON" or "Flight: OFF"
	flightBtn.BackgroundColor3 = FLYING and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
	humanoid:ChangeState(FLYING and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
end)

noclipBtn.Activated:Connect(function()
	NOCLIP = not NOCLIP
	noclipBtn.Text = NOCLIP and "Noclip: ON" or "Noclip: OFF"
	noclipBtn.BackgroundColor3 = NOCLIP and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
end)

RunService.Stepped:Connect(function()
	if NOCLIP and character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if FLYING then
		local camera = workspace.CurrentCamera
		linearVelocity.MaxForce = 9999999
		alignOrientation.MaxTorque = 9999999
		alignOrientation.CFrame = camera.CFrame
		linearVelocity.VectorVelocity = (humanoid.MoveDirection.Magnitude > 0) and (camera.CFrame.LookVector * FLY_SPEED) or Vector3.zero
	else
		linearVelocity.MaxForce = 0
		alignOrientation.MaxTorque = 0
	end
end)
