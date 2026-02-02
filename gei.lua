-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local Flying = false
local Noclip = false
local FlySpeed = 50
local Camera = workspace.CurrentCamera

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileSupportGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Legacy support (works on most mobile executors)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Mobile Cheat Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame

-- Helper Function for Buttons
local function createButton(name, pos, text, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = MainFrame
    return btn
end

local FlyBtn = createButton("FlyBtn", UDim2.new(0.05, 0, 0.2, 0), "Flight: OFF", Color3.fromRGB(200, 50, 50))
local NoclipBtn = createButton("NoclipBtn", UDim2.new(0.05, 0, 0.4, 0), "NoClip: OFF", Color3.fromRGB(200, 50, 50))
local SpeedUpBtn = createButton("SpeedUp", UDim2.new(0.05, 0, 0.6, 0), "Speed: " .. FlySpeed, Color3.fromRGB(70, 70, 70))
local CloseBtn = createButton("Close", UDim2.new(0.05, 0, 0.8, 0), "Minimize", Color3.fromRGB(50, 50, 50))

--- Logic Functions ---

-- Toggle Flight
FlyBtn.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyBtn.Text = "Flight: " .. (Flying and "ON" or "OFF")
    FlyBtn.BackgroundColor3 = Flying and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    if Flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlightVelocity"
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlightGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 9000
        bg.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        bg.Parent = LocalPlayer.Character.HumanoidRootPart
        
        LocalPlayer.Character.Humanoid.PlatformStand = true
    else
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if hrp:FindFirstChild("FlightVelocity") then hrp.FlightVelocity:Destroy() end
            if hrp:FindFirstChild("FlightGyro") then hrp.FlightGyro:Destroy() end
        end
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

-- Toggle NoClip
NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    NoclipBtn.Text = "NoClip: " .. (Noclip and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = Noclip and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- Modify Speed
SpeedUpBtn.MouseButton1Click:Connect(function()
    FlySpeed = FlySpeed + 25
    if FlySpeed > 250 then FlySpeed = 25 end
    SpeedUpBtn.Text = "Speed: " .. FlySpeed
end)

-- Close/Minimize
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Flight & NoClip Loop
RunService.Stepped:Connect(function()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
        
        hrp.FlightVelocity.Velocity = (Camera.CFrame.LookVector * moveDir.Z + Camera.CFrame.RightVector * moveDir.X) * FlySpeed
        hrp.FlightGyro.CFrame = Camera.CFrame
    end
    
    if Noclip then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
