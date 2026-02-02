local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ClickTP_Menu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 100)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Mobile draggable support

local Corner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TP Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

local GetToolBtn = Instance.new("TextButton", MainFrame)
GetToolBtn.Size = UDim2.new(0, 140, 0, 40)
GetToolBtn.Position = UDim2.new(0, 10, 0, 40)
GetToolBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
GetToolBtn.Text = "Get TP Tool"
GetToolBtn.TextColor3 = Color3.new(1, 1, 1)
GetToolBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", GetToolBtn)

-- Minimize Button
local MinBtn = Instance.new("TextButton", ScreenGui)
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(0, 10, 0.5, 0)
MinBtn.Text = "TP"
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--- TOOL CREATION ---
GetToolBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Backpack:FindFirstChild("Click TP") then return end
    
    local TPTool = Instance.new("Tool")
    TPTool.Name = "Click TP"
    TPTool.RequiresHandle = false
    TPTool.Parent = LocalPlayer.Backpack

    TPTool.Activated:Connect(function()
        local pos = Mouse.Hit.p
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Teleports slightly above the point to avoid getting stuck in the floor
            char.HumanoidRootPart.CFrame = CFrame.new(pos) + Vector3.new(0, 3, 0)
        end
    end)
end)
