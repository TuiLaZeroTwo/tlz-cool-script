local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local GodMode = false
local Noclip = false
local FakeFloor = nil

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "GeminiMobileMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true 

local Corner = Instance.new("UICorner", MainFrame)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Text = "Status: God OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextSize = 14

local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0, 180, 0, 40)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    Instance.new("UICorner", b)
    return b
end

local GodBtn = createBtn("Toggle Anti-Death", UDim2.new(0, 10, 0, 40), Color3.fromRGB(70, 70, 70))
local NoclipBtn = createBtn("Noclip: OFF", UDim2.new(0, 10, 0, 85), Color3.fromRGB(200, 50, 50))
local TPBtn = createBtn("Get Click TP Tool", UDim2.new(0, 10, 0, 130), Color3.fromRGB(0, 120, 200))
local ResetBtn = createBtn("Reset Character", UDim2.new(0, 10, 0, 175), Color3.fromRGB(50, 50, 50))

--- ANTI-DEATH LOGIC ---
local function ApplyAntiDeath(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    
    RunService.Stepped:Connect(function()
        if GodMode and humanoid and humanoid.Parent then
            if humanoid.Health <= 0 then
                humanoid.Health = 100
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            humanoid.MaxHealth = 1000000
            humanoid.Health = 1000000
        end
    end)
end

if LocalPlayer.Character then ApplyAntiDeath(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ApplyAntiDeath)

--- BUTTON FUNCTIONALITY ---
GodBtn.MouseButton1Click:Connect(function()
    GodMode = not GodMode
    StatusLabel.Text = "Status: God " .. (GodMode and "ACTIVE" or "OFF")
    StatusLabel.TextColor3 = GodMode and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    GodBtn.BackgroundColor3 = GodMode and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(70, 70, 70)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    NoclipBtn.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = Noclip and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    if Noclip then
        FakeFloor = Instance.new("Part")
        FakeFloor.Name = "NoclipFloor"
        FakeFloor.Size = Vector3.new(15, 1, 15)
        FakeFloor.Transparency = 1
        FakeFloor.CanCollide = true
        FakeFloor.Anchored = true
        FakeFloor.Parent = workspace
    else
        if FakeFloor then FakeFloor:Destroy() FakeFloor = nil end
    end
end)

TPBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Backpack:FindFirstChild("Click TP") then return end
    local Tool = Instance.new("Tool")
    Tool.Name = "Click TP"
    Tool.RequiresHandle = false
    Tool.Parent = LocalPlayer.Backpack
    Tool.Activated:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p) + Vector3.new(0, 3, 0)
        end
    end)
end)

ResetBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end)

--- NO-FALL / NOCLIP LOOP ---
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        if FakeFloor and hrp then
            FakeFloor.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
        end
    end
end)
