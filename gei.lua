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
ScreenGui.Name = "GeminiAggressiveMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true 

local Corner = Instance.new("UICorner", MainFrame)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Text = "GOD STATUS: INACTIVE"
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
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

local GodBtn = createBtn("Toggle God (Aggressive)", UDim2.new(0, 10, 0, 40), Color3.fromRGB(60, 60, 60))
local NoclipBtn = createBtn("Noclip: OFF", UDim2.new(0, 10, 0, 85), Color3.fromRGB(180, 40, 40))
local TPBtn = createBtn("Get Click TP Tool", UDim2.new(0, 10, 0, 130), Color3.fromRGB(0, 100, 180))
local ResetBtn = createBtn("Reset Character", UDim2.new(0, 10, 0, 175), Color3.fromRGB(40, 40, 40))

--- AGGRESSIVE ANTI-DEATH CORE ---
RunService.RenderStepped:Connect(function()
    if GodMode and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Spams state enable to fight server-side death triggers
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            
            if humanoid.Health <= 0.1 then
                humanoid.Health = 100
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            -- Constantly forces health to a high value
            humanoid.MaxHealth = 9e9
            humanoid.Health = 9e9
        end
    end
end)

--- BUTTON FUNCTIONS ---
GodBtn.MouseButton1Click:Connect(function()
    GodMode = not GodMode
    StatusLabel.Text = "GOD STATUS: " .. (GodMode and "ACTIVE (SPAMMING)" or "INACTIVE")
    StatusLabel.TextColor3 = GodMode and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    GodBtn.BackgroundColor3 = GodMode and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(60, 60, 60)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    NoclipBtn.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = Noclip and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 40, 40)
    
    if Noclip then
        FakeFloor = Instance.new("Part")
        FakeFloor.Name = "SafetyFloor"
        FakeFloor.Size = Vector3.new(12, 1, 12)
        FakeFloor.Transparency = 1
        FakeFloor.Anchored = true
        FakeFloor.Parent = workspace
    else
        if FakeFloor then FakeFloor:Destroy() FakeFloor = nil end
    end
end)

TPBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Backpack:FindFirstChild("Click TP") then return end
    local Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.Name = "Click TP"
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p) + Vector3.new(0, 3, 0)
        end
    end)
end)

ResetBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end)

--- NOCLIP / FLOOR LOOP ---
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            if FakeFloor then
                FakeFloor.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
            end
        end
    end
end)
