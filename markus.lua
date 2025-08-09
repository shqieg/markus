-- Markus Script v1.2 (Toggle UI)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старый GUI
if playerGui:FindFirstChild("MarkusScriptUI") then
    playerGui.MarkusScriptUI:Destroy()
end

-- Создаем основной GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MarkusScriptUI"
screenGui.ResetOnSpawn = false

-- Кнопка активации (буква M)
local activateBtn = Instance.new("TextButton", screenGui)
activateBtn.Name = "ActivateButton"
activateBtn.Size = UDim2.new(0, 50, 0, 50)
activateBtn.Position = UDim2.new(0, 20, 0.5, -25)
activateBtn.Text = "M"
activateBtn.Font = Enum.Font.GothamBlack
activateBtn.TextSize = 24
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
activateBtn.BackgroundTransparency = 0.5
activateBtn.ZIndex = 10
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(1, 0)

-- Главное меню (изначально скрыто)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Анимация твина
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Text = "MARKUS SCRIPT"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

-- Кнопка ESP (пример функции)
local espButton = Instance.new("TextButton", mainFrame)
espButton.Size = UDim2.new(0.9, 0, 0, 40)
espButton.Position = UDim2.new(0.05, 0, 0, 40)
espButton.Text = "ESP: OFF"
espButton.Font = Enum.Font.Gotham
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", espButton).CornerRadius = UDim.new(0, 6)

-- Логика переключения меню
local menuVisible = false
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        mainFrame.Visible = true
        local tween = TweenService:Create(
            mainFrame,
            tweenInfo,
            {Position = UDim2.new(0.5, -125, 0.5, -150)}
        )
        tween:Play()
    else
        local tween = TweenService:Create(
            mainFrame,
            tweenInfo,
            {Position = UDim2.new(0.5, -125, 0.5, 200)}
        )
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
        tween:Play()
    end
end

-- Управление
activateBtn.MouseButton1Click:Connect(toggleMenu)

-- Горячая клавиша M
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        toggleMenu()
    end
end)

-- Пример ESP (упрощенный)
local espEnabled = false
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    -- Здесь должна быть логика ESP
end)

print("Markus Script loaded! Press M to toggle menu")
