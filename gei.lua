local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local GodMode = false
local Noclip = false
local FakeFloor = nil

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MobileCheatMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 180)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true 

local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0, 160, 0, 45)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18
    b.BorderSizePixel = 0
    return b
end

local GodBtn = createBtn("GodMode: OFF", UDim2.new(0, 10, 0, 15), Color3.fromRGB(200, 50, 50))
local NoclipBtn = createBtn("Noclip: OFF", UDim2.new(0, 10, 0, 65), Color3.fromRGB(200, 50, 50))
local ResetBtn = createBtn("Reset Character", UDim2.new(0, 10, 0, 115), Color3.fromRGB(60, 60, 60))

-- Toggle Logic
GodBtn.MouseButton1Click:Connect(function()
    GodMode = not GodMode
    GodBtn.Text = "GodMode: " .. (GodMode and "ON" or "OFF")
    GodBtn.BackgroundColor3 = GodMode and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    NoclipBtn.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = Noclip and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    -- Handle Invisible Floor creation/deletion
    if Noclip then
        FakeFloor = Instance.new("Part")
        FakeFloor.Name = "NoclipFloor"
        FakeFloor.Size = Vector3.new(10, 1, 10)
        FakeFloor.Transparency = 1
        FakeFloor.CanCollide = true
        FakeFloor.Anchored = true
        FakeFloor.Parent = workspace
    else
        if FakeFloor then
            FakeFloor:Destroy()
            FakeFloor = nil
        end
    end
end)

ResetBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end)

-- Main Loop
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    -- God Mode Logic
    if GodMode then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = 1000000 
            hum.Health = 1000000
        end
    end
    
    -- NoClip & Floor Logic
    if Noclip then
        -- Make player parts non-collidable
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Keep the invisible floor under the player
        if FakeFloor and hrp then
            FakeFloor.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
        end
    end
end)
