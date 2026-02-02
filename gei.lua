local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local Flying = false
local Noclip = false
local FlySpeed = 50
local VerticalVelocity = 0 -- To handle Up/Down buttons

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MobileVerticalMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 280)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true 

local function createBtn(text, pos, size, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = size or UDim2.new(0, 160, 0, 40)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    return b
end

local FlyBtn = createBtn("Fly: OFF", UDim2.new(0, 10, 0, 10), nil, Color3.fromRGB(200, 50, 50))
local NoclipBtn = createBtn("Noclip: OFF", UDim2.new(0, 10, 0, 60), nil, Color3.fromRGB(200, 50, 50))
local SpeedBtn = createBtn("Speed: 50", UDim2.new(0, 10, 0, 110), nil, Color3.fromRGB(70, 70, 70))

-- Vertical Controls
local UpBtn = createBtn("▲ UP", UDim2.new(0, 10, 0, 160), UDim2.new(0, 75, 0, 50), Color3.fromRGB(60, 60, 60))
local DownBtn = createBtn("▼ DOWN", UDim2.new(0, 95, 0, 160), UDim2.new(0, 75, 0, 50), Color3.fromRGB(60, 60, 60))
local ResetBtn = createBtn("Reset Character", UDim2.new(0, 10, 0, 220), nil, Color3.fromRGB(150, 150, 50))

-- Vertical Logic
UpBtn.MouseButton1Down:Connect(function() VerticalVelocity = 1 end)
UpBtn.MouseButton1Up:Connect(function() VerticalVelocity = 0 end)
DownBtn.MouseButton1Down:Connect(function() VerticalVelocity = -1 end)
DownBtn.MouseButton1Up:Connect(function() VerticalVelocity = 0 end)

ResetBtn.MouseButton1Click:Connect(function() LocalPlayer.Character:BreakJoints() end)

FlyBtn.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyBtn.Text = "Fly: " .. (Flying and "ON" or "OFF")
    FlyBtn.BackgroundColor3 = Flying and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = Flying
        char.Humanoid.AutoRotate = not Flying -- Stops spinning glitch
        if not Flying then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp:FindFirstChild("FVelocity") then hrp.FVelocity:Destroy() end
                if hrp:FindFirstChild("FGyro") then hrp.FGyro:Destroy() end
            end
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    NoclipBtn.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = Noclip and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

SpeedBtn.MouseButton1Click:Connect(function()
    FlySpeed = (FlySpeed >= 250) and 25 or FlySpeed + 25
    SpeedBtn.Text = "Speed: " .. FlySpeed
end)

-- Main Loop
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end 
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    
    if Flying and hrp and hum then
        if not hrp:FindFirstChild("FVelocity") then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "FVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local bg = Instance.new("BodyGyro", hrp)
            bg.Name = "FGyro"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        end
        
        -- Movement calculation
        local cameraDir = Camera.CFrame.LookVector
        local moveVector = Vector3.new(0, 0, 0)
        
        -- If moving joystick
        if hum.MoveDirection.Magnitude > 0 then
            moveVector = cameraDir * FlySpeed
        end
        
        -- Add Vertical Button influence
        local finalVelocity = moveVector + Vector3.new(0, VerticalVelocity * FlySpeed, 0)
        
        hrp.FVelocity.Velocity = finalVelocity
        hrp.FGyro.CFrame = Camera.CFrame
    end
    
    if Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
