local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- SAFETY CHECK: Wait for UI elements to exist
local gui = script.Parent
local mainPanel = gui:WaitForChild("MainPanel", 10)
local logoButton = gui:WaitForChild("LogoButton", 10)

if not mainPanel or not logoButton then
	warn("GUI elements not found! Check your names in the Explorer.")
	return
end

local flightBtn = mainPanel:WaitForChild("FlightToggle")
local noclipBtn = mainPanel:WaitForChild("NoclipToggle")
local minBtn = mainPanel:WaitForChild("MinButton")

-- Variables
local FLYING = false
local NOCLIP = false
local FLY_SPEED = 50

-- Physics Setup
local attachment = Instance.new("Attachment")
local linearVelocity = Instance.new("LinearVelocity")
local alignOrientation = Instance.new("AlignOrientation")

attachment.Parent = rootPart
linearVelocity.Attachment0 = attachment
linearVelocity.MaxForce = 0
linearVelocity.Parent = rootPart

alignOrientation.Attachment0 = attachment
alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
alignOrientation.MaxTorque = 0
alignOrientation.Responsiveness = 200
alignOrientation.Parent = rootPart

-- Flight Logic
local function toggleFlight()
	FLYING = not FLYING
	if FLYING then
		flightBtn.Text = "Flight: ON"
		flightBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	else
		flightBtn.Text = "Flight: OFF"
		flightBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		linearVelocity.MaxForce = 0
		alignOrientation.MaxTorque = 0
	end
end

-- Noclip Logic
local function toggleNoclip()
	NOCLIP = not NOCLIP
	noclipBtn.Text = NOCLIP and "Noclip: ON" or "Noclip: OFF"
	noclipBtn.BackgroundColor3 = NOCLIP and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 100, 100)
end

-- GUI Interactivity (Heart Buttons)
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

-- Loops
RunService.Stepped:Connect(function()
	if NOCLIP and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if FLYING then
		local camera = workspace.CurrentCamera
		linearVelocity.MaxForce = math.huge
		alignOrientation.MaxTorque = math.huge
		
		if humanoid.MoveDirection.Magnitude > 0 then
			linearVelocity.VectorVelocity = camera.CFrame.LookVector * FLY_SPEED
		else
			linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
		end
		alignOrientation.CFrame = camera.CFrame
	end
end)
