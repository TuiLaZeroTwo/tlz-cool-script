local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Fix for Error 11: We use a loop to wait for the GUI to actually exist
local gui = script.Parent
while not gui:IsA("ScreenGui") do 
	gui = gui.Parent 
	task.wait() 
end

-- Strictly wait for your specific names
local mainPanel = gui:WaitForChild("MainPanel", 20)
local logoButton = gui:WaitForChild("LogoButton", 20)

if not mainPanel or not logoButton then
	warn("Check your names! MainPanel or LogoButton is missing.")
	return
end

local flightBtn = mainPanel:WaitForChild("FlightToggle")
local noclipBtn = mainPanel:WaitForChild("NoclipToggle")
local minBtn = mainPanel:WaitForChild("MinButton")

-- Variables
local FLYING, NOCLIP = false, false
local FLY_SPEED = 50

-- Physics
local attachment = Instance.new("Attachment", rootPart)
local linearVelocity = Instance.new("LinearVelocity", rootPart)
local alignOrientation = Instance.new("AlignOrientation", rootPart)

linearVelocity.Attachment0 = attachment
linearVelocity.MaxForce = 0
alignOrientation.Attachment0 = attachment
alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
alignOrientation.MaxTorque = 0

-- Toggle Functions
local function toggleFlight()
	FLYING = not FLYING
	flightBtn.Text = FLYING and "Flight: ON" or "Flight: OFF"
	flightBtn.BackgroundColor3 = FLYING and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
	humanoid:ChangeState(FLYING and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
end

local function toggleNoclip()
	NOCLIP = not NOCLIP
	noclipBtn.Text = NOCLIP and "Noclip: ON" or "Noclip: OFF"
	noclipBtn.BackgroundColor3 = NOCLIP and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
end

-- Heart Button Logic
minBtn.Activated:Connect(function()
	mainPanel.Visible = false
	logoButton.Visible = true
end)

logoButton.Activated:Connect(function()
	mainPanel.Visible = true
	logoButton.Visible = false
end)

flightBtn.Activated:Connect(toggleFlight)
noclipBtn.Activated:Connect(toggleNoclip)

-- Physics Loops
RunService.Stepped:Connect(function()
	if NOCLIP and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if FLYING then
		local camera = workspace.CurrentCamera
		linearVelocity.MaxForce = math.huge
		linearVelocity.VectorVelocity = (humanoid.MoveDirection.Magnitude > 0) and (camera.CFrame.LookVector * FLY_SPEED) or Vector3.zero
		alignOrientation.MaxTorque = math.huge
		alignOrientation.CFrame = camera.CFrame
	else
		linearVelocity.MaxForce = 0
		alignOrientation.MaxTorque = 0
	end
end)
