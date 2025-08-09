-- Markus Script v1.3 (ESP + Fly)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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

-- Кнопка активации (M)
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

-- Главное меню
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, 200) -- Начальная позиция (скрыто)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Анимация
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Text = "MARKUS SCRIPT v1.3"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

-- Функция создания кнопок
local function CreateButton(text, yPos, color)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Переключение меню
local menuVisible = false
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, -125, 0.5, -175)}):Play()
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
-- РАБОЧИЙ ESP --
----------------------
local espButton = CreateButton("ESP: OFF", 40, Color3.fromRGB(120, 0, 200))
local espEnabled = false
local espCache = {}

local function createESP(character)
    if not character or character == player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "MarkusESP"
    highlight.Adornee = character
    highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
    highlight.FillColor = Color3.fromRGB(255, 0, 0, 0.1)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    table.insert(espCache, highlight)
end

local function clearESP()
    for _, esp in pairs(espCache) do
        esp:Destroy()
    end
    espCache = {}
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    
    if espEnabled then
        -- Существующие игроки
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                createESP(plr.Character)
            end
        end
        
        -- Новые игроки
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                if espEnabled then
                    createESP(char)
                end
            end)
        end)
    else
        clearESP()
    end
end)

----------------------
-- УЛУЧШЕННЫЙ ПОЛЕТ --
----------------------
local flyButton = CreateButton("FLY: OFF", 85, Color3.fromRGB(0, 100, 255))
local flySpeed = 50 -- Настройка скорости
local flyEnabled = false
local flyConn

local function startFlying()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.PlatformStand = true
    
    local bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
    bodyGyro.P = 1000
    bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10000
    
    flyConn = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        
        local root = character.HumanoidRootPart
        local cam = Workspace.CurrentCamera.CFrame.LookVector
        
        -- Управление
        local direction = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += cam end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= cam end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += CFrame.new(cam).RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= CFrame.new(cam).RightVector end
        
        -- Применение движения
        if direction.Magnitude > 0 then
            root.Velocity = direction.Unit * flySpeed
        else
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "FLY: " .. (flyEnabled and "ON" or "OFF")
    
    if flyEnabled then
        startFlying()
    else
        if flyConn then flyConn:Disconnect() end
        local character = player.Character
        if character then
            character.Humanoid.PlatformStand = false
            for _, v in pairs(character.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyGyro") then v:Destroy() end
            end
        end
    end
end)

-- Инфо
CreateButton("Speed: "..flySpeed, 130).MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 10
    if flySpeed > 100 then flySpeed = 20 end
    flyButton.Text = "Speed: "..flySpeed
end)

print("Markus Script loaded! Press M to toggle menu")
