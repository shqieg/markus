-- Markus Script v4.3 (PC + Mobile)
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

-- Кнопка активации
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

-- Главное меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = isMobile and UDim2.new(0, 300, 0, 450) or UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Анимация
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "MARKUS SCRIPT v4.3"
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
    tabFrame.Size = UDim2.new(1, 0, 1, -55)
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
local mainTab = CreateTab("Main", UDim2.new(0.33, 5, 0, 5))
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

SwitchTab("Visual")

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

-- Функция создания кнопок
local function CreateButton(text, yPos, parentFrame)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, isMobile and 45 or 35)
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
    sliderFrame.Size = UDim2.new(0.9, 0, 0, isMobile and 60 or 50)
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
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = isMobile and 14 or 12
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    slider.Parent = sliderFrame
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 5)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - minValue)/(maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Parent = slider
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new((defaultValue - minValue)/(maxValue - minValue), -10, 0, -5)
    handle.Text = ""
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Parent = slider
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateValue(x)
        local absoluteX = x - slider.AbsolutePosition.X
        local ratio = math.clamp(absoluteX / slider.AbsoluteSize.X, 0, 1)
        local value = math.floor(minValue + (maxValue - minValue) * ratio)
        valueLabel.Text = tostring(value)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        handle.Position = UDim2.new(ratio, -10, 0, -5)
        return value
    end
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateValue(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)
    
    return {
        frame = sliderFrame,
        getValue = function()
            return tonumber(valueLabel.Text)
        end,
        setValue = function(newValue)
            local ratio = (newValue - minValue)/(maxValue - minValue)
            valueLabel.Text = tostring(newValue)
            fill.Size = UDim2.new(ratio, 0, 1, 0)
            handle.Position = UDim2.new(ratio, -10, 0, -5)
        end
    }
end

-- Переключение меню
local menuVisible = false
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, tweenInfo, {
            Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, isMobile and -225 or -200)
        }):Play()
    else
        TweenService:Create(mainFrame, tweenInfo, {
            Position = UDim2.new(0.5, isMobile and -150 or -125, 0.5, 200)
        }):Play()
        task.delay(0.3, function() mainFrame.Visible = false end)
    end
end

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

local chamsButton = CreateButton("Chams: OFF", 70, visualTab)
local chamsEnabled = false
local chamsCache = {}

local function createESP(character)
    if not character or character == player.Character then return end
    
    SafeCall(function()
        local highlight = Instance.new("Highlight")
        highlight.Name = "MarkusESP"
        highlight.Adornee = character
        highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
        highlight.FillTransparency = 1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        table.insert(espCache, highlight)
    end)
end

local function createChams(character)
    if not character or character == player.Character then return end
    
    SafeCall(function()
        local highlight = Instance.new("Highlight")
        highlight.Name = "MarkusChams"
        highlight.Adornee = character
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        table.insert(chamsCache, highlight)
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

local function clearChams()
    SafeCall(function()
        for _, chams in pairs(chamsCache) do
            if chams and chams.Parent then
                chams:Destroy()
            end
        end
        chamsCache = {}
    end)
end

local function updateESP()
    SafeCall(function()
        clearESP()
        clearChams()
        if espEnabled or chamsEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    if espEnabled then createESP(plr.Character) end
                    if chamsEnabled then createChams(plr.Character) end
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

chamsButton.MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    chamsButton.Text = "Chams: " .. (chamsEnabled and "ON" or "OFF")
    updateESP()
end)

----------------------
-- Основные функции --
----------------------
-- Speed Hack с регулировкой
local speedSlider = CreateSlider("Speed: 16", 10, mainTab, 16, 100, 16)
local speedEnabled = false
local originalWalkSpeed = 16
local speedConnection

local function setSpeed(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            originalWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = speedSlider.getValue()
            
            speedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if humanoid.WalkSpeed ~= speedSlider.getValue() then
                    humanoid.WalkSpeed = speedSlider.getValue()
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

local speedButton = CreateButton("Speed: OFF", 80, mainTab)
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
    setSpeed(speedEnabled)
end)

-- Бесконечный прыжок (Inf Jump)
local infJumpButton = CreateButton("Inf Jump: OFF", 150, mainTab)
local infJumpEnabled = false
local infJumpConnection

local function setInfJump(enabled)
    SafeCall(function()
        if enabled then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local character = player.Character
                if not character then return end
                
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end)
end

infJumpButton.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpButton.Text = "Inf Jump: " .. (infJumpEnabled and "ON" or "OFF")
    setInfJump(infJumpEnabled)
end)

-- No Hit (неуязвимость)
local noHitButton = CreateButton("No Hit: OFF", 220, mainTab)
local noHitEnabled = false
local noHitConnection

local function setNoHit(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            noHitConnection = humanoid.Touched:Connect(function()
                humanoid.Health = humanoid.MaxHealth
            end)
        else
            if noHitConnection then
                noHitConnection:Disconnect()
                noHitConnection = nil
            end
        end
    end)
end

noHitButton.MouseButton1Click:Connect(function()
    noHitEnabled = not noHitEnabled
    noHitButton.Text = "No Hit: " .. (noHitEnabled and "ON" or "OFF")
    setNoHit(noHitEnabled)
end)

-- Aimbot (прицеливание на паутину)
local aimbotButton = CreateButton("Aimbot: OFF", 290, mainTab)
local aimbotEnabled = false
local aimbotConnection

local function findWebShooter()
    local character = player.Character
    if not character then return nil end
    
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("web") or tool.Name:lower():find("shooter")) then
            return tool
        end
    end
    
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("web") or tool.Name:lower():find("shooter")) then
            return tool
        end
    end
    
    return nil
end

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    local character = player.Character
    if not character then return nil end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = plr
                end
            end
        end
    end
    
    return closestPlayer
end

local function setAimbot(enabled)
    SafeCall(function()
        if enabled then
            aimbotConnection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
                    local webShooter = findWebShooter()
                    if not webShooter then
                        warn("Web shooter not found!")
                        return
                    end
                    
                    local targetPlayer = getClosestPlayer()
                    if not targetPlayer or not targetPlayer.Character then return end
                    
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not targetRoot then return end
                    
                    -- Активируем инструмент
                    webShooter.Parent = player.Character
                    
                    -- Наводимся на цель
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        task.wait(0.1)
                        humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                    end
                    
                    -- Поворачиваем персонажа к цели
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local direction = (targetRoot.Position - rootPart.Position).Unit
                        rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + Vector3.new(direction.X, 0, direction.Z))
                    end
                    
                    -- Используем инструмент
                    webShooter:Activate()
                    
                    -- Возвращаем управление
                    if humanoid then
                        task.wait(0.2)
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end)
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
                aimbotConnection = nil
            end
        end
    end)
end

aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotButton.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    setAimbot(aimbotEnabled)
end)

----------------------
-- Развлекательные функции --
----------------------
-- Визуальный спин
local spinButton = CreateButton("Visual Spin: OFF", 10, funTab)
local spinEnabled = false
local spinSpeed = 5
local spinConnections = {}

local function setSpin(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        if enabled then
            -- Останавливаем предыдущие соединения
            for _, conn in pairs(spinConnections) do
                conn:Disconnect()
            end
            spinConnections = {}
            
            -- Создаем эффект кручения
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            local spinConn = RunService.Heartbeat:Connect(function(delta)
                if rootPart and rootPart.Parent then
                    rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                end
            end)
            
            table.insert(spinConnections, spinConn)
        else
            -- Останавливаем все соединения
            for _, conn in pairs(spinConnections) do
                conn:Disconnect()
            end
            spinConnections = {}
        end
    end)
end

spinButton.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    spinButton.Text = "Visual Spin: " .. (spinEnabled and "ON" or "OFF")
    setSpin(spinEnabled)
end)

-- Большая голова
local bigHeadButton = CreateButton("Big Head: OFF", 70, funTab)
local bigHeadEnabled = false
local originalHeadScale = Vector3.new(1, 1, 1)
local headScale = Vector3.new(2, 2, 2) -- Увеличение в 2 раза

local function setBigHead(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local head = character:FindFirstChild("Head")
        if not head then return end
        
        if enabled then
            originalHeadScale = head.Size
            head.Size = headScale
        else
            head.Size = originalHeadScale
        end
    end)
end

bigHeadButton.MouseButton1Click:Connect(function()
    bigHeadEnabled = not bigHeadEnabled
    bigHeadButton.Text = "Big Head: " .. (bigHeadEnabled and "ON" or "OFF")
    setBigHead(bigHeadEnabled)
end)

-- Fly
local flyButton = CreateButton("Fly: OFF", 130, funTab)
local flyEnabled = false
local flySpeed = 50
local flyConnections = {}
local bodyVelocity

local function setFly(enabled)
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if enabled then
            -- Останавливаем предыдущие соединения
            for _, conn in pairs(flyConnections) do
                conn:Disconnect()
            end
            flyConnections = {}
            
            -- Создаем BodyVelocity для полета
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.P = 1000
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
            
            -- Управление полетом
            local flyForward = false
            local flyBackward = false
            local flyLeft = false
            local flyRight = false
            local flyUp = false
            local flyDown = false
            
            -- Обработчики ввода для ПК
            if isPC then
                local keyConn = UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then flyForward = true end
                    if input.KeyCode == Enum.KeyCode.S then flyBackward = true end
                    if input.KeyCode == Enum.KeyCode.A then flyLeft = true end
                    if input.KeyCode == Enum.KeyCode.D then flyRight = true end
                    if input.KeyCode == Enum.KeyCode.Space then flyUp = true end
                    if input.KeyCode == Enum.KeyCode.LeftShift then flyDown = true end
                end)
                
                local keyEndConn = UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then flyForward = false end
                    if input.KeyCode == Enum.KeyCode.S then flyBackward = false end
                    if input.KeyCode == Enum.KeyCode.A then flyLeft = false end
                    if input.KeyCode == Enum.KeyCode.D then flyRight = false end
                    if input.KeyCode == Enum.KeyCode.Space then flyUp = false end
                    if input.KeyCode == Enum.KeyCode.LeftShift then flyDown = false end
                end)
                
                table.insert(flyConnections, keyConn)
                table.insert(flyConnections, keyEndConn)
            end
            
            -- Обработчики ввода для мобильных устройств
            if isMobile then
                -- Создаем кнопки управления полетом
                local flyControls = Instance.new("Frame")
                flyControls.Size = UDim2.new(1, 0, 1, 0)
                flyControls.BackgroundTransparency = 1
                flyControls.Parent = screenGui
                
                -- Кнопки WASD
                local upBtn = Instance.new("TextButton")
                upBtn.Size = UDim2.new(0, 80, 0, 80)
                upBtn.Position = UDim2.new(0.5, -40, 0.8, -160)
                upBtn.Text = "↑"
                upBtn.Font = Enum.Font.GothamBold
                upBtn.TextSize = 30
                upBtn.BackgroundTransparency = 0.7
                upBtn.Parent = flyControls
                
                local downBtn = Instance.new("TextButton")
                downBtn.Size = UDim2.new(0, 80, 0, 80)
                downBtn.Position = UDim2.new(0.5, -40, 0.8, -40)
                downBtn.Text = "↓"
                downBtn.Font = Enum.Font.GothamBold
                downBtn.TextSize = 30
                downBtn.BackgroundTransparency = 0.7
                downBtn.Parent = flyControls
                
                local leftBtn = Instance.new("TextButton")
                leftBtn.Size = UDim2.new(0, 80, 0, 80)
                leftBtn.Position = UDim2.new(0.3, -40, 0.8, -100)
                leftBtn.Text = "←"
                leftBtn.Font = Enum.Font.GothamBold
                leftBtn.TextSize = 30
                leftBtn.BackgroundTransparency = 0.7
                leftBtn.Parent = flyControls
                
                local rightBtn = Instance.new("TextButton")
                rightBtn.Size = UDim2.new(0, 80, 0, 80)
                rightBtn.Position = UDim2.new(0.7, -40, 0.8, -100)
                rightBtn.Text = "→"
                rightBtn.Font = Enum.Font.GothamBold
                rightBtn.TextSize = 30
                rightBtn.BackgroundTransparency = 0.7
                rightBtn.Parent = flyControls
                
                -- Кнопки вверх/вниз
                local ascendBtn = Instance.new("TextButton")
                ascendBtn.Size = UDim2.new(0, 80, 0, 80)
                ascendBtn.Position = UDim2.new(0.9, -40, 0.8, -160)
                ascendBtn.Text = "↑"
                ascendBtn.Font = Enum.Font.GothamBold
                ascendBtn.TextSize = 30
                ascendBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                ascendBtn.BackgroundTransparency = 0.7
                ascendBtn.Parent = flyControls
                
                local descendBtn = Instance.new("TextButton")
                descendBtn.Size = UDim2.new(0, 80, 0, 80)
                descendBtn.Position = UDim2.new(0.9, -40, 0.8, -40)
                descendBtn.Text = "↓"
                descendBtn.Font = Enum.Font.GothamBold
                descendBtn.TextSize = 30
                descendBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                descendBtn.BackgroundTransparency = 0.7
                descendBtn.Parent = flyControls
                
                -- Обработчики кнопок
                upBtn.MouseButton1Down:Connect(function() flyForward = true end)
                upBtn.MouseButton1Up:Connect(function() flyForward = false end)
                downBtn.MouseButton1Down:Connect(function() flyBackward = true end)
                downBtn.MouseButton1Up:Connect(function() flyBackward = false end)
                leftBtn.MouseButton1Down:Connect(function() flyLeft = true end)
                leftBtn.MouseButton1Up:Connect(function() flyLeft = false end)
                rightBtn.MouseButton1Down:Connect(function() flyRight = true end)
                rightBtn.MouseButton1Up:Connect(function() flyRight = false end)
                ascendBtn.MouseButton1Down:Connect(function() flyUp = true end)
                ascendBtn.MouseButton1Up:Connect(function() flyUp = false end)
                descendBtn.MouseButton1Down:Connect(function() flyDown = true end)
                descendBtn.MouseButton1Up:Connect(function() flyDown = false end)
                
                table.insert(flyConnections, flyControls)
            end
            
            -- Обновление полета
            local flyConn = RunService.Heartbeat:Connect(function()
                if not bodyVelocity or not bodyVelocity.Parent then return end
                
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                local camera = workspace.CurrentCamera
                local cf = camera.CFrame
                local direction = Vector3.new()
                
                if flyForward then direction = direction + cf.LookVector end
                if flyBackward then direction = direction - cf.LookVector end
                if flyLeft then direction = direction - cf.RightVector end
                if flyRight then direction = direction + cf.RightVector end
                if flyUp then direction = direction + Vector3.new(0, 1, 0) end
                if flyDown then direction = direction - Vector3.new(0, 1, 0) end
                
                direction = direction.Unit * flySpeed
                bodyVelocity.Velocity = direction
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            end)
            
            table.insert(flyConnections, flyConn)
        else
            -- Останавливаем все соединения
            for _, conn in pairs(flyConnections) do
                conn:Disconnect()
            end
            flyConnections = {}
            
            -- Удаляем BodyVelocity
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            
            -- Удаляем кнопки управления (для мобильных)
            for _, child in pairs(screenGui:GetChildren()) do
                if child:IsA("Frame") and child.Name == "" then
                    child:Destroy()
                end
            end
        end
    end)
end

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    setFly(flyEnabled)
end)

-- Обработчики персонажа
local function handleCharacter(character)
    task.wait(1) -- Даем время для полной загрузки персонажа
    
    -- Восстанавливаем скорость
    if speedEnabled then
        setSpeed(true)
    end
    
    -- Восстанавливаем бесконечный прыжок
    if infJumpEnabled then
        setInfJump(true)
    end
    
    -- Восстанавливаем ESP и Chams
    if espEnabled or chamsEnabled then
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
    
    -- Восстанавливаем полет
    if flyEnabled then
        setFly(true)
    end
    
    -- Восстанавливаем неуязвимость
    if noHitEnabled then
        setNoHit(true)
    end
    
    -- Восстанавливаем аимбот
    if aimbotEnabled then
        setAimbot(true)
    end
end

player.CharacterAdded:Connect(handleCharacter)

-- Автообновление ESP и Chams
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if espEnabled or chamsEnabled then
            if espEnabled then createESP(char) end
            if chamsEnabled then createChams(char) end
        end
    end)
end)

-- Первоначальная загрузка
if player.Character then
    handleCharacter(player.Character)
end
updateESP()

print("Markus Script v4.3 loaded! "..(isMobile and "Tap M button" or "Press M
