local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- FIX: Robust waiting for UI elements
local gui = script.Parent
local mainPanel = gui:FindFirstChild("MainPanel") or gui:WaitForChild("MainPanel", 15)
local logoButton = gui:FindFirstChild("LogoButton") or gui:WaitForChild("LogoButton", 15)

if not mainPanel or not logoButton then
	warn("GUI Missing! Please name your Frame 'MainPanel' and your Logo 'LogoButton'.")
	return
end

local flightBtn = mainPanel:WaitForChild("FlightToggle")
local noclipBtn = mainPanel:WaitForChild("NoclipToggle")
local minBtn = mainPanel:WaitForChild("MinButton")

-- State Variables
local FLYING = false
local NOCLIP = false
local FLY_SPEED = 60

-- Physics Setup
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
	flightBtn.BackgroundColor3 = FLYING and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 85, 127)
	
	if not FLYING then
		linearVelocity.MaxForce = 0
		alignOrientation.MaxTorque = 0
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	else
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	end
end

local function toggleNoclip()
	NOCLIP = not NOCLIP
	noclipBtn.Text = NOCLIP and "Noclip: ON" or "Noclip: OFF"
	noclipBtn.BackgroundColor3 = NOCLIP and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 85, 127)
end

-- Mobile & PC Interaction (.Activated is best for both)
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
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if FLYING then
		local camera = workspace.CurrentCamera
		linearVelocity.MaxForce = 9999999
		alignOrientation.MaxTorque = 9999999
		alignOrientation.CFrame = camera.CFrame
		
		if humanoid.MoveDirection.Magnitude > 0 then
			linearVelocity.VectorVelocity = camera.CFrame.LookVector * FLY_SPEED
		else
			linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
		end
	end
end)
