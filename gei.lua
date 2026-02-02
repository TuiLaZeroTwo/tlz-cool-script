local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") -- Used for the bypass
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local GodMode = false
local Noclip = false
local FakeFloor = nil

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "GeminiBypassMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 270)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame)

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
local CelestialBtn = createBtn("TP Celestial (Bypass)", UDim2.new(0, 10, 0, 175), Color3.fromRGB(100, 50, 150))
local ResetBtn = createBtn("Reset Character", UDim2.new(0, 10, 0, 220), Color3.fromRGB(40, 40, 40))

--- BYPASS TELEPORT LOGIC ---
local function bypassTeleport(targetPos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Temporary NoClip so you don't hit walls during the glide
    local oldNoclip = Noclip
    Noclip = true

    local distance = (hrp.Position - targetPos).Magnitude
    local speed = 150 -- Adjust this (higher = faster, lower = safer from bans)
    local duration = distance / speed

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos) + Vector3.new(0, 5, 0)})
    
    tween:Play()
    tween.Completed:Connect(function()
        Noclip = oldNoclip -- Restore previous Noclip state
    end)
end

CelestialBtn.MouseButton1Click:Connect(function()
    local target = workspace:FindFirstChild("Celestial", true)
    if target then
        local pos = target:IsA("BasePart") and target.Position or target:FindFirstChildWhichIsA("BasePart").Position
        bypassTeleport(pos)
    else
        CelestialBtn.Text = "Area Not Found!"
        task.wait(1)
        CelestialBtn.Text = "TP Celestial (Bypass)"
    end
end)

--- AGGRESSIVE ANTI-DEATH ---
RunService.RenderStepped:Connect(function()
    if GodMode and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            if hum.Health <= 0.1 then hum.Health = 100 hum:ChangeState(Enum.HumanoidStateType.Running) end
            hum.MaxHealth = 9e9
            hum.Health = 9e9
        end
    end
end)

--- OTHER BUTTONS ---
GodBtn.MouseButton1Click:Connect(function()
    GodMode = not GodMode
    GodBtn.BackgroundColor3 = GodMode and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(60, 60, 60)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    NoclipBtn.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = Noclip and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 40, 40)
    if Noclip then
        FakeFloor = Instance.new("Part", workspace)
        FakeFloor.Size = Vector3.new(12, 1, 12)
        FakeFloor.Transparency = 1
        FakeFloor.Anchored = true
    elseif FakeFloor then FakeFloor:Destroy() FakeFloor = nil end
end)

TPBtn.MouseButton1Click:Connect(function()
    local Tool = Instance.new("Tool", LocalPlayer.Backpack)
    Tool.Name = "Bypass Click TP"
    Tool.RequiresHandle = false
    Tool.Activated:Connect(function()
        bypassTeleport(Mouse.Hit.p) -- Uses bypass for click TP too!
    end)
end)

ResetBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        if FakeFloor and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            FakeFloor.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
        end
    end
end)
