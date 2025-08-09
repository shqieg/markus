-- Markus Script UI Template
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старый UI
if playerGui:FindFirstChild("MarkusScriptUI") then
    playerGui.MarkusScriptUI:Destroy()
end

-- Создаем основной GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MarkusScriptUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Минималистичный заголовок
local header = Instance.new("Frame", screenGui)
header.Name = "Header"
header.Size = UDim2.new(0, 200, 0, 30)
header.Position = UDim2.new(0.5, -100, 0.1, 0)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.Active = true
header.Draggable = true

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "MARKUS SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1

-- Кнопка сворачивания
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.BorderSizePixel = 0

-- Основное меню
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 200)
mainFrame.Position = UDim2.new(0.5, -100, 0.1, 30)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.ClipsDescendants = true

-- Разделитель
local divider = Instance.new("Frame", mainFrame)
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 0)
divider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
divider.BorderSizePixel = 0

-- Контейнер для кнопок (ScrollFrame если нужно много функций)
local buttonContainer = Instance.new("Frame", mainFrame)
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, 0, 1, -5)
buttonContainer.Position = UDim2.new(0, 0, 0, 5)
buttonContainer.BackgroundTransparency = 1

-- Логика сворачивания
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "_"
    header.Size = isMinimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 30)
end)

-- Шаблон для кнопок (пример)
local function CreateButton(text, yPosition)
    local btn = Instance.new("TextButton", buttonContainer)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPosition)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 4)
    
    return btn
end

-- Здесь можно добавлять кнопки
-- CreateButton("ESP", 5)
-- CreateButton("Fly", 45)
-- CreateButton("Speed", 85)

