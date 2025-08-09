-- Markus Script v3.5 (PC + Mobile)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Определяем тип устройства
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local isPC = UserInputService.MouseEnabled

-- Безопасное выполнение
local function SafeCall(func)
    local success, err = pcall(func)
    if not success then
        warn("Markus Script Error:", err)
        return false
    end
    return true
end

-- Удаление старого GUI
SafeCall(function()
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name:find("MarkusScript") then
            gui:Destroy()
        end
    end
end)

-- Создание интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarkusScriptUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Стили для разных устройств
local buttonSize = isMobile and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 50, 0, 50)
local buttonPos = isMobile and UDim2.new(0, 20, 1, -90) or UDim2.new(0, 20, 0.5, -25)
local buttonTextSize = isMobile and 30 or 24

-- Кнопка активации (черная с белой "M")
local activateBtn = Instance.new("TextButton")
activateBtn.Name = "ActivateButton"
activateBtn.Size = buttonSize
activateBtn.Position = buttonPos
activateBtn.Text = "M"
activateBtn.Font = Enum.Font.GothamBlack
activateBtn.TextSize = buttonTextSize
activateBtn.TextColor3 = Color3.new(1, 1, 1) -- Белый текст
activateBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Черный фон
activateBtn.BackgroundTransparency = 0.5
activateBtn.ZIndex = 10
activateBtn.Parent = screenGui
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(1, 0)

-- Главное меню (черное)
local mainFrame = Instance.new("Frame")
mainFrame.Size = isMobile and UDim2.new(0, 300, 0, 300) or UDim2.new(0, 250, 0, 250)
mainFrame.Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Темно-серый/черный
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Анимация
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "MARKUS SCRIPT v3.5"
title.Size = UDim2.new(1, 0, 0, 40)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 20 or 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Вкладки
local tabButtons = {}
local tabs = {}

local function CreateTab(name, position)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name.."Tab"
    tabBtn.Size = UDim2.new(0.33, -10, 0, 30)
    tabBtn.Position = position
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = isMobile and 14 or 12
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.Parent = mainFrame
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name.."Frame"
    tabFrame.Size = UDim2.new(1, 0, 1, -40)
    tabFrame.Position = UDim2.new(0, 0, 0, 40)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = mainFrame
    
    tabs[name] = tabFrame
    tabButtons[name] = tabBtn
    
    return tabFrame
end

-- Создаем вкладки
local visualTab = CreateTab("Visual", UDim2.new(0, 5, 0, 5))
local mainTab = CreateTab("Osnovnoe", UDim2.new(0.33, 5, 0, 5))
local funTab = CreateTab("Fun", UDim2.new(0.66, 5, 0, 5))

-- Функция переключения вкладок
local currentTab = "Visual"

local function SwitchTab(tabName)
    currentTab = tabName
    for name, frame in pairs(tabs) do
        frame.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 40)
    end
end

-- Активируем первую вкладку
SwitchTab("Visual")

-- Подключаем обработчики вкладок
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

-- Функция создания кнопок
local function CreateButton(text, yPos, parentFrame)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, isMobile and 50 or 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = isMobile and 16 or 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Parent = parentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Переключение меню
local menuVisible = false
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, tweenInfo, {
            Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, isMobile and -150 or -125)
        }):Play()
    else
        TweenService:Create(mainFrame, tweenInfo, {
            Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, 200)
        }):Play()
        task.delay(0.3, function() mainFrame.Visible = false end)
    end
end

-- Управление
activateBtn.MouseButton1Click:Connect(toggleMenu)
if isPC then
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.M then
            toggleMenu()
        end
    end)
end

----------------------
-- Визуальные функции --
----------------------
local espButton = CreateButton("ESP: OFF", 10, visualTab)
local espEnabled = false
local espCache = {}

local function createESP(character)
    if not character or character == player.Character then return end
    
    SafeCall(function()
        local highlight = Instance.new("Highlight")
        highlight.Name = "MarkusESP_"..tostring(os.time())
        highlight.Adornee = character
        highlight.OutlineColor = Color3.fromRGB(0, 150, 255) -- Синий ESP
        highlight.FillTransparency = 1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        table.insert(espCache, highlight)
    end)
end

local function clearESP()
    SafeCall(function()
        for _, esp in pairs(espCache) do
            if esp and esp.Parent then
                esp:Destroy()
            end
        end
        espCache = {}
    end)
end

local function updateESP()
    SafeCall(function()
        clearESP()
        if espEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    createESP(plr.Character)
                end
            end
        end
    end)
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    updateESP()
end)

----------------------
-- Основные функции --
----------------------
local speedButton = CreateButton("Speed: OFF", 10, mainTab)
local speedEnabled = false
local originalWalkSpeed = 16
local speedMultiplier = 1.5 -- Увеличение скорости на 50%

local function setSpeed(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        else
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end)
end

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
    setSpeed(speedEnabled)
end)

-- Сохраняем оригинальную скорость при загрузке
player.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        if speedEnabled then
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        end
    end
end)

----------------------
-- Развлекательные функции --
----------------------
-- Можно добавить дополнительные функции сюда
local exampleButton = CreateButton("Example", 10, funTab)
exampleButton.MouseButton1Click:Connect(function()
    print("Fun button clicked!")
end)

-- Автообновление ESP
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if espEnabled then
            createESP(char)
        end
    end)
end)

player.CharacterAdded:Connect(function()
    if espEnabled then
        task.wait(1)
        updateESP()
    end
    -- Восстанавливаем скорость если она была включена
    if speedEnabled then
        task.wait(0.5)
        setSpeed(true)
    end
end)

-- Первоначальная загрузка
updateESP()
print("Markus Script v3.5 loaded! "..(isMobile and "Tap M button" or "Press M key"))
