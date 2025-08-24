local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Menu = {Open = false, ShowHitbox = true, ShowHealthBar = true}

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ESPMenu"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,200,0,120)
MainFrame.Position = UDim2.new(0,50,0,50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.Visible = Menu.Open
MainFrame.Parent = ScreenGui

local function createButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,180,0,30)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
end

createButton("Toggle Hitbox", UDim2.new(0,10,0,10), function() Menu.ShowHitbox = not Menu.ShowHitbox end)
createButton("Toggle HealthBar", UDim2.new(0,10,0,50), function() Menu.ShowHealthBar = not Menu.ShowHealthBar end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.M then
        Menu.Open = not Menu.Open
        MainFrame.Visible = Menu.Open
    end
end)

local function getRGBColor()
    local t = tick()
    return Color3.new(math.sin(t)*0.5+0.5, math.sin(t+2)*0.5+0.5, math.sin(t+4)*0.5+0.5)
end

local function createESP(player)
    local box = Instance.new("BillboardGui")
    box.Name = "ESPBox"
    box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    box.Size = UDim2.new(0,50,0,50)
    box.AlwaysOnTop = true
    box.Parent = player:WaitForChild("PlayerGui")

    local hitboxFrame = Instance.new("Frame")
    hitboxFrame.Size = UDim2.new(1,0,1,0)
    hitboxFrame.BorderSizePixel = 2
    hitboxFrame.BackgroundTransparency = 1
    hitboxFrame.BorderColor3 = getRGBColor()
    hitboxFrame.Parent = box

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1,0,0.1,0)
    healthBar.Position = UDim2.new(0,0,1,2)
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = box

    RunService.RenderStepped:Connect(function()
        if Menu.ShowHitbox then
            hitboxFrame.BorderColor3 = getRGBColor()
            box.Enabled = true
        else
            box.Enabled = false
        end
        if Menu.ShowHealthBar and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0.1,0)
            end
        end
    end)
end

for _,player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)
