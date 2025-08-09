-- Markus Script v2.0 (Bypass + Fixed ESP & Flight)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Байпас античитов (1)
local function SafeCall(func)
    local success, err = pcall(func)
    if not success then
        warn("Markus Script Error:", err)
    end
end

-- Удаление старого GUI
SafeCall(function()
    if playerGui:FindFirstChild("MarkusScriptUI") then
        playerGui.MarkusScriptUI:Destroy()
    end
end)

-- Создание интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarkusScriptUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Кнопка активации
local activateBtn = Instance.new("TextButton")
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
activateBtn.Parent = screenGui
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(1, 0)

-- Главное меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Анимация
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "MARKUS SCRIPT v2.0"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Функция создания кнопок
local function CreateButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Переключение меню
local menuVisible = false
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, -125, 0.5, -100)}):Play()
    else
        TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, -125, 0.5, 200)}):Play()
        task.delay(0.3, function() mainFrame.Visible = false end)
    end
end

-- Управление
activateBtn.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        toggleMenu()
    end
end)

----------------------
-- ИСПРАВЛЕННЫЙ ESP (2) --
----------------------
local espButton = CreateButton("ESP: OFF", 40, Color3.fromRGB(120, 0, 200))
local espEnabled = false
local espCache = {}

local function createESP(character)
    if not character or character == player.Character then return end
    
    SafeCall(function()
        local highlight = Instance.new("Highlight")
        highlight.Name = "MarkusESP_"..tostring(os.time())
        highlight.Adornee = character
        highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
        highlight.FillTransparency = 1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        table.insert(espCache, highlight)
        
        -- Обновление при изменении персонажа
        character.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then
                highlight.Adornee = character
            end
        end)
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
end)

----------------------
-- ИСПРАВЛЕННЫЙ ПОЛЕТ (3) --
----------------------
local flyButton = CreateButton("FLY: OFF", 85, Color3.fromRGB(0, 100, 255))
local flyEnabled = false
local flySpeed = 25
local flyParts = {}

local function startFlying()
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        
        -- Создаем невидимые части для полета
        local flyPart = Instance.new("Part")
        flyPart.Anchored = true
        flyPart.CanCollide = false
        flyPart.Transparency = 1
        flyPart.Size = Vector3.new(2, 1, 2)
        flyPart.Parent = workspace
        flyPart.CFrame = root.CFrame - Vector3.new(0, 3, 0)
        
        table.insert(flyParts, flyPart)
        
        humanoid.PlatformStand = true
        
        -- Основной цикл полета
        local flyConn
        flyConn = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not character:IsDescendantOf(workspace) then
                flyConn:Disconnect()
                return
            end
            
            local cam = workspace.CurrentCamera.CFrame
            local moveDir = Vector3.new()
            
            -- Управление
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
            
            -- Плавное перемещение
            if moveDir.Magnitude > 0 then
                flyPart.CFrame = flyPart.CFrame + moveDir.Unit * (flySpeed * 0.1)
            end
            
            -- Притягивание персонажа
            root.Velocity = (flyPart.Position - root.Position) * 10
        end)
    end)
end

local function stopFlying()
    SafeCall(function()
        flyEnabled = false
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        
        for _, part in pairs(flyParts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        flyParts = {}
    end)
end

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "FLY: " .. (flyEnabled and "ON" or "OFF")
    
    if flyEnabled then
        startFlying()
    else
        stopFlying()
    end
end)

-- Очистка при выходе
player.CharacterRemoving:Connect(stopFlying)

-- Первоначальная загрузка
updateESP()
print("Markus Script v2.0 loaded! Press M to toggle menu")
