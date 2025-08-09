-- Markus Script v3.9 (PC + Mobile)
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

-- Заголовок (внизу)
local title = Instance.new("TextLabel")
title.Text = "MARKUS SCRIPT v3.9"
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 1, -25)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 14 or 12
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
    tabFrame.Size = UDim2.new(1, 0, 1, -55) -- Уменьшили высоту из-за заголовка внизу
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
        -- Проверяем, есть ли уже ESP для этого персонажа
        for _, esp in pairs(espCache) do
            if esp and esp.Parent == character then
                return
            end
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "MarkusESP_"..tostring(os.time())
        highlight.Adornee = character
        highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
        highlight.FillTransparency = 1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        -- Добавляем текстовый лейбл для имени игрока
        local playerName = Players:GetPlayerFromCharacter(character)
        if playerName then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "MarkusESP_Name"
            billboard.Adornee = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = character
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = playerName.Name
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 18
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Parent = billboard
        end
        
        table.insert(espCache, highlight)
        
        -- Для невидимых игроков добавляем дополнительный эффект
        local invisCheck = character:FindFirstChildWhichIsA("BodyColors") or character:FindFirstChildOfClass("Humanoid")
        if not invisCheck then
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Красный для невидимых
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.7
        end
    end)
end

local function clearESP()
    SafeCall(function()
        for _, esp in pairs(espCache) do
            if esp and esp.Parent then
                -- Удаляем также BillboardGui с именами
                local character = esp.Adornee
                if character then
                    local billboard = character:FindFirstChild("MarkusESP_Name")
                    if billboard then
                        billboard:Destroy()
                    end
                end
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
                if plr ~= player then
                    -- Проверяем текущего персонажа
                    if plr.Character then
                        createESP(plr.Character)
                    end
                    -- Подключаемся к будущим персонажам
                    plr.CharacterAdded:Connect(function(char)
                        if espEnabled then
                            createESP(char)
                        end
                    end)
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

-- Улучшенный визуальный спин
local spinButton = CreateButton("Visual Spin: OFF", 60, visualTab)
local spinEnabled = false
local spinSpeed = 10 -- Увеличим скорость
local spinParts = {}
local spinConnections = {}

local function setSpin(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        if enabled then
            -- Собираем все части для кручения
            spinParts = {}
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part ~= character:FindFirstChild("HumanoidRootPart") then
                    table.insert(spinParts, part)
                    
                    -- Добавляем свечение для эффекта
                    local glow = Instance.new("SurfaceGui", part)
                    glow.Face = Enum.NormalId.Front
                    glow.AlwaysOnTop = true
                    
                    local frame = Instance.new("Frame", glow)
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                    frame.BackgroundTransparency = 0.7
                    frame.BorderSizePixel = 0
                end
            end
            
            -- Создаем эффект кручения для каждой части
            for _, part in pairs(spinParts) do
                local spinConn = RunService.Heartbeat:Connect(function(delta)
                    if part and part.Parent then
                        part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                    end
                end)
                table.insert(spinConnections, spinConn)
            end
        else
            -- Останавливаем все соединения
            for _, conn in pairs(spinConnections) do
                conn:Disconnect()
            end
            spinConnections = {}
            
            -- Удаляем свечение
            for _, part in pairs(spinParts) do
                if part and part.Parent then
                    local glow = part:FindFirstChildOfClass("SurfaceGui")
                    if glow then
                        glow:Destroy()
                    end
                end
            end
            spinParts = {}
        end
    end)
end

spinButton.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    spinButton.Text = "Visual Spin: " .. (spinEnabled and "ON" or "OFF")
    setSpin(spinEnabled)
end)

----------------------
-- Основные функции --
----------------------
local speedButton = CreateButton("Speed: OFF", 10, mainTab)
local speedEnabled = false
local originalWalkSpeed = 16
local speedMultiplier = 1.5
local fakeSpringTool = nil
local speedConnection

local function createFakeSpringTool()
    if fakeSpringTool and fakeSpringTool.Parent then
        fakeSpringTool:Destroy()
    end
    
    fakeSpringTool = Instance.new("Tool")
    fakeSpringTool.Name = "Spring"
    fakeSpringTool.Grip = CFrame.new(0, 0, 0.5) * CFrame.Angles(math.pi/2, 0, 0)
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Anchored = false
    handle.Parent = fakeSpringTool
    
    fakeSpringTool.Parent = player.Character or player.Backpack
end

local function setSpeed(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            -- Создаем фейковую пружинку
            createFakeSpringTool()
            
            -- Устанавливаем скорость
            originalWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
            
            -- Следим за изменениями скорости
            speedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if humanoid.WalkSpeed ~= originalWalkSpeed * speedMultiplier then
                    humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
                end
            end)
        else
            -- Удаляем фейковую пружинку
            if fakeSpringTool then
                fakeSpringTool:Destroy()
                fakeSpringTool = nil
            end
            
            -- Восстанавливаем скорость
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
            
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
            end
        end
    end)
end

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
    setSpeed(speedEnabled)
end)

local jumpButton = CreateButton("2x Jump: OFF", 60, mainTab)
local jumpEnabled = false
local originalJumpPower = 50
local jumpMultiplier = 2
local jumpConnection

local function setJump(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            originalJumpPower = humanoid.JumpPower
            humanoid.JumpPower = originalJumpPower * jumpMultiplier
            
            jumpConnection = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                if humanoid.JumpPower ~= originalJumpPower * jumpMultiplier then
                    humanoid.JumpPower = originalJumpPower * jumpMultiplier
                end
            end)
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
            humanoid.JumpPower = originalJumpPower
        end
    end)
end

jumpButton.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    jumpButton.Text = "2x Jump: " .. (jumpEnabled and "ON" or "OFF")
    setJump(jumpEnabled)
end)

-- Анти-смерть
local antiDieButton = CreateButton("Anti Die: OFF", 110, mainTab)
local antiDieEnabled = false
local antiDieConnections = {}

local function setAntiDie(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            -- Сохраняем оригинальное здоровье
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            -- Защита от урона
            local function preventDamage()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
            
            -- Подключаем обработчики
            table.insert(antiDieConnections, humanoid.HealthChanged:Connect(function()
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end))
            
            table.insert(antiDieConnections, RunService.Heartbeat:Connect(preventDamage))
            
            -- Защита от удаления персонажа
            table.insert(antiDieConnections, character.AncestryChanged:Connect(function()
                if not character.Parent then
                    local newChar = player.Character or player.CharacterAdded:Wait()
                    setAntiDie(true) -- Повторно активируем для нового персонажа
                end
            end))
        else
            -- Отключаем все обработчики
            for _, conn in pairs(antiDieConnections) do
                conn:Disconnect()
            end
            antiDieConnections = {}
            
            -- Восстанавливаем стандартные настройки
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            
            if humanoid.MaxHealth > 100 then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end)
end

antiDieButton.MouseButton1Click:Connect(function()
    antiDieEnabled = not antiDieEnabled
    antiDieButton.Text = "Anti Die: " .. (antiDieEnabled and "ON" or "OFF")
    setAntiDie(antiDieEnabled)
end)

----------------------
-- Развлекательные функции --
----------------------
local bigHeadButton = CreateButton("Huge Head: OFF", 10, funTab)
local bigHeadEnabled = false
local originalHeadSize = Vector3.new(1, 1, 1)
local headScale = 3 -- Огромная голова
local headParts = {}

local function setBigHead(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        if enabled then
            -- Сохраняем оригинальные размеры
            headParts = {}
            
            -- Находим все части головы
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("head") or part.Parent:IsA("Accessory")) then
                    table.insert(headParts, {
                        part = part,
                        originalSize = part.Size,
                        originalMesh = part:FindFirstChildOfClass("SpecialMesh")
                    })
                    
                    -- Увеличиваем размер
                    part.Size = part.Size * headScale
                    
                    -- Увеличиваем меш если есть
                    local mesh = part:FindFirstChildOfClass("SpecialMesh")
                    if mesh then
                        mesh.Scale = mesh.Scale * headScale
                    end
                end
            end
        else
            -- Восстанавливаем оригинальные размеры
            for _, data in pairs(headParts) do
                if data.part and data.part.Parent then
                    data.part.Size = data.originalSize
                    
                    if data.originalMesh then
                        local mesh = data.part:FindFirstChildOfClass("SpecialMesh")
                        if mesh then
                            mesh.Scale = data.originalMesh.Scale
                        end
                    end
                end
            end
            headParts = {}
        end
    end)
end

bigHeadButton.MouseButton1Click:Connect(function()
    bigHeadEnabled = not bigHeadEnabled
    bigHeadButton.Text = "Huge Head: " .. (bigHeadEnabled and "ON" or "OFF")
    setBigHead(bigHeadEnabled)
end)

-- Обработчики персонажа
local function handleCharacter(character)
    task.wait(0.5)
    
    -- Восстанавливаем скорость
    if speedEnabled then
        setSpeed(true)
    end
    
    -- Восстанавливаем прыжок
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        if jumpEnabled then
            originalJumpPower = humanoid.JumpPower
            humanoid.JumpPower = originalJumpPower * jumpMultiplier
        end
        
        -- Восстанавливаем анти-смерть
        if antiDieEnabled then
            setAntiDie(true)
        end
    end
    
    -- Восстанавливаем ESP
    if espEnabled then
        task.wait(1)
        updateESP()
    end
    
    -- Восстанавливаем крутку
    if spinEnabled then
        setSpin(true)
    end
    
    -- Восстанавливаем большую голову
    if bigHeadEnabled then
        setBigHead(true)
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

print("Markus Script v3.9 loaded! "..(isMobile and "Tap M button" or "Press M key"))
