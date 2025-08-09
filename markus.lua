-- Markus Script v4.0 (Blue UI + Fixed Flight)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Определение устройства
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local isPC = not isMobile

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

-- Цвета интерфейса
local BLUE_COLOR = Color3.fromRGB(0, 150, 255)
local DARK_BLUE = Color3.fromRGB(0, 50, 100)

-- Создание основного GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarkusScriptUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Главное меню (голубой прямоугольник)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = BLUE_COLOR
mainFrame.BackgroundTransparency = 0.2
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Обводка
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = BLUE_COLOR
stroke.Thickness = 2

-- Заголовок с ником игрока
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 40)
titleFrame.BackgroundColor3 = DARK_BLUE
titleFrame.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = player.Name
title.Size = UDim2.new(1, 0, 1, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = titleFrame

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = DARK_BLUE
closeBtn.Parent = titleFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Контейнер для кнопок
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 1, -45)
buttonContainer.Position = UDim2.new(0, 0, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- Функция создания кнопок
local function CreateButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = DARK_BLUE
    btn.BackgroundTransparency = 0.5
    btn.Parent = buttonContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = BLUE_COLOR
    btnStroke.Thickness = 1
    
    return btn
end

-- Кнопка активации (M)
local activateBtn = Instance.new("TextButton")
activateBtn.Name = "ActivateButton"
activateBtn.Size = isMobile and UDim2.new(0, 80, 0, 80) or UDim2.new(0, 50, 0, 50)
activateBtn.Position = isMobile and UDim2.new(0, 20, 1, -100) or UDim2.new(0, 20, 0.5, -25)
activateBtn.Text = "M"
activateBtn.Font = Enum.Font.GothamBlack
activateBtn.TextSize = isMobile and 30 or 24
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.BackgroundColor3 = BLUE_COLOR
activateBtn.BackgroundTransparency = 0.5
activateBtn.ZIndex = 10
activateBtn.Parent = screenGui
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 4)

-- Переключение меню
local menuVisible = false
local function toggleMenu()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
end

activateBtn.MouseButton1Click:Connect(toggleMenu)
if isPC then
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.M then
            toggleMenu()
        end
    end)
end
closeBtn.MouseButton1Click:Connect(toggleMenu)

----------------------
-- РАБОЧИЙ ПОЛЕТ --
----------------------
local flyButton = CreateButton("FLY: OFF", 10)
local flyEnabled = false
local flySpeed = 25
local flyConn, bodyGyro, bodyVelocity

-- Джойстик для мобильных
local touchJoystick
if isMobile then
    touchJoystick = Instance.new("Frame")
    touchJoystick.Size = UDim2.new(0, 150, 0, 150)
    touchJoystick.Position = UDim2.new(0, 50, 1, -200)
    touchJoystick.BackgroundTransparency = 0.7
    touchJoystick.BackgroundColor3 = BLUE_COLOR
    touchJoystick.Visible = false
    touchJoystick.Parent = screenGui
    Instance.new("UICorner", touchJoystick).CornerRadius = UDim.new(1, 0)
    
    local joystickInner = Instance.new("Frame")
    joystickInner.Size = UDim2.new(0, 50, 0, 50)
    joystickInner.Position = UDim2.new(0.5, -25, 0.5, -25)
    joystickInner.BackgroundColor3 = DARK_BLUE
    joystickInner.Parent = touchJoystick
    Instance.new("UICorner", joystickInner).CornerRadius = UDim.new(1, 0)
end

local function startFlying()
    SafeCall(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        
        humanoid.PlatformStand = true
        
        -- Физические компоненты
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 10000
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10000
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000
        bodyVelocity.Parent = root
        
        -- Управление для PC
        if isPC then
            flyConn = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                
                local cam = Camera.CFrame
                local moveDir = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    bodyVelocity.Velocity = moveDir.Unit * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
                
                bodyGyro.CFrame = cam
            end)
        end
        
        -- Управление для мобильных
        if isMobile then
            touchJoystick.Visible = true
            local touchStartPos, touchPos, joystickActive
            
            UserInputService.TouchStarted:Connect(function(input, processed)
                if processed then return end
                local touchPos = input.Position
                local joystickPos = touchJoystick.AbsolutePosition
                local joystickSize = touchJoystick.AbsoluteSize
                
                if touchPos.X >= joystickPos.X and touchPos.X <= joystickPos.X + joystickSize.X and
                   touchPos.Y >= joystickPos.Y and touchPos.Y <= joystickPos.Y + joystickSize.Y then
                    joystickActive = true
                    touchStartPos = Vector2.new(joystickPos.X + joystickSize.X/2, joystickPos.Y + joystickSize.Y/2)
                end
            end)
            
            UserInputService.TouchMoved:Connect(function(input, processed)
                if not joystickActive or processed then return end
                
                touchPos = input.Position
                local joystickInner = touchJoystick:FindFirstChild("JoystickInner")
                if not joystickInner then return end
                
                local maxDist = 50
                local delta = touchPos - touchStartPos
                local distance = math.min(delta.Magnitude, maxDist)
                local direction = delta.Unit
                
                joystickInner.Position = UDim2.new(
                    0.5, direction.X * distance - 25,
                    0.5, direction.Y * distance - 25
                )
                
                -- Применение движения
                local cam = Camera.CFrame
                local moveDir = Vector3.new(
                    direction.X,
                    0,
                    direction.Y
                )
                
                bodyVelocity.Velocity = cam:VectorToWorldSpace(moveDir) * flySpeed
                bodyGyro.CFrame = cam
            end)
            
            UserInputService.TouchEnded:Connect(function(input, processed)
                if not joystickActive then return end
                joystickActive = false
                local joystickInner = touchJoystick:FindFirstChild("JoystickInner")
                if joystickInner then
                    joystickInner.Position = UDim2.new(0.5, -25, 0.5, -25)
                end
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end)
        end
    end)
end

local function stopFlying()
    SafeCall(function()
        if flyConn then flyConn:Disconnect() end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                if bodyGyro then bodyGyro:Destroy() end
                if bodyVelocity then bodyVelocity:Destroy() end
            end
        end
        
        if isMobile and touchJoystick then
            touchJoystick.Visible = false
        end
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

print("Markus Script v4.0 loaded!")
