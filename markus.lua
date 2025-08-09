-- Markus Script v3.6 (PC + Mobile)
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
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
activateBtn.BackgroundTransparency = 0.5
activateBtn.ZIndex = 10
activateBtn.Parent = screenGui
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(1, 0)

-- Главное меню (черное)
local mainFrame = Instance.new("Frame")
mainFrame.Size = isMobile and UDim2.new(0, 300, 0, 300) or UDim2.new(0, 250, 0, 250)
mainFrame.Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Анимация
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "MARKUS SCRIPT v3.6"
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

-- Функция создания слайдера
local function CreateSlider(text, yPos, parentFrame, minValue, maxValue, defaultValue)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, isMobile and 60 or 45)
    sliderFrame.Position = UDim2.new(0.05, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parentFrame
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Gotham
    label.TextSize = isMobile and 14 or 12
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(defaultValue)
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -40, 0, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = isMobile and 14 or 12
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.Parent = sliderFrame
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - minValue)/(maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Parent = slider
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new((defaultValue - minValue)/(maxValue - minValue), -10, 0.5, -10)
    handle.Text = ""
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Parent = slider
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local currentValue = defaultValue
    
    local function updateValue(value)
        value = math.clamp(value, minValue, maxValue)
        currentValue = value
        valueLabel.Text = string.format("%.1f", value)
        fill.Size = UDim2.new((value - minValue)/(maxValue - minValue), 0, 1, 0)
        handle.Position = UDim2.new((value - minValue)/(maxValue - minValue), -10, 0.5, -10)
        return value
    end
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = input.Position.X - slider.AbsolutePosition.X
            local value = minValue + (pos / slider.AbsoluteSize.X) * (maxValue - minValue)
            updateValue(value)
        end
    end)
    
    if UserInputService.MouseEnabled then
        game:GetService("RunService").RenderStepped:Connect(function()
            if dragging then
                local pos = UserInputService:GetMouseLocation().X - slider.AbsolutePosition.X
                local value = minValue + (pos / slider.AbsoluteSize.X) * (maxValue - minValue)
                updateValue(value)
            end
        end)
    end
    
    return {
        GetValue = function() return currentValue end,
        SetValue = function(value) updateValue(value) end,
        Changed = handle.MouseButton1Up
    }
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
        highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
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
local speedMultiplier = 1.5
local speedConnection

local function setSpeed(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
            speedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if humanoid.WalkSpeed ~= originalWalkSpeed * speedMultiplier then
                    humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
                end
            end)
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end)
end

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
    setSpeed(speedEnabled)
end)

----------------------
-- Развлекательные функции --
----------------------
local spinButton = CreateButton("Spin: OFF", 10, funTab)
local spinEnabled = false
local spinSpeed = 5
local spinConnection

local spinSlider = CreateSlider("Spin Speed", 60, funTab, 1, 20, spinSpeed)
spinSlider.Changed:Connect(function()
    spinSpeed = spinSlider.GetValue()
end)

local function setSpin(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if enabled then
            spinConnection = RunService.Heartbeat:Connect(function(delta)
                if root then
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                end
            end)
        else
            if spinConnection then
                spinConnection:Disconnect()
                spinConnection = nil
            end
        end
    end)
end

spinButton.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    spinButton.Text = "Spin: " .. (spinEnabled and "ON" or "OFF")
    setSpin(spinEnabled)
end)

-- Обработчики персонажа
local function handleCharacter(character)
    task.wait(0.5)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        if speedEnabled then
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        end
    end
    
    if espEnabled then
        task.wait(1)
        updateESP()
    end
    
    if spinEnabled then
        setSpin(true)
    end
end

player.CharacterAdded:Connect(handleCharacter)

-- Автообновление ESP
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if espEnabled then
            createESP(char)
        end
    end)
end)

-- Первоначальная загрузка
if player.Character then
    handleCharacter(player.Character)
end
updateESP()

print("Markus Script v3.6 loaded! "..(isMobile and "Tap M button" or "Press M key"))
