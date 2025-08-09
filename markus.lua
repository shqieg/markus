-- Markus Script v1.1 (ESP Edition)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старый GUI
if playerGui:FindFirstChild("MarkusScriptUI") then
    playerGui.MarkusScriptUI:Destroy()
end

-- Создаем интерфейс
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MarkusScriptUI"
screenGui.ResetOnSpawn = false

-- Главное окно
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Text = "MARKUS SCRIPT v1.1"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

-- Кнопка ESP
local espButton = Instance.new("TextButton", mainFrame)
espButton.Size = UDim2.new(0.9, 0, 0, 40)
espButton.Position = UDim2.new(0.05, 0, 0, 40)
espButton.Text = "ESP: OFF"
espButton.Font = Enum.Font.Gotham
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", espButton).CornerRadius = UDim.new(0, 6)

-- Логика ESP
local espEnabled = false
local espCache = {}

local function createESP(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoidRootPart or not head then return end
    
    -- Бокс вокруг игрока
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "MarkusESPBox"
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.Size = humanoidRootPart.Size + Vector3.new(0.1, 0.1, 0.1)
    box.Transparency = 0.7
    box.Color3 = Color3.fromRGB(0, 255, 255)
    box.ZIndex = 10
    box.Parent = humanoidRootPart
    
    -- Тэг с именем
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MarkusESPTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local tagText = Instance.new("TextLabel", billboard)
    tagText.Text = character.Parent.Name
    tagText.Size = UDim2.new(1, 0, 1, 0)
    tagText.Font = Enum.Font.GothamBold
    tagText.TextSize = 14
    tagText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tagText.BackgroundTransparency = 1
    
    billboard.Parent = head
    
    table.insert(espCache, {box, billboard})
end

local function clearESP()
    for _, objects in pairs(espCache) do
        for _, obj in pairs(objects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
    end
    espCache = {}
end

local function toggleESP()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    
    if espEnabled then
        -- Обработка существующих игроков
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                createESP(plr.Character)
            end
        end
        
        -- Обработка новых игроков
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                if espEnabled then
                    createESP(char)
                end
            end)
        end)
        
        -- Обработка своего персонажа при респавне
        player.CharacterAdded:Connect(function(char)
            if espEnabled then
                for _, obj in pairs(char:GetDescendants()) do
                    if obj.Name == "MarkusESPBox" or obj.Name == "MarkusESPTag" then
                        obj:Destroy()
                    end
                end
            end
        end)
    else
        clearESP()
    end
end

espButton.MouseButton1Click:Connect(toggleESP)

-- Кнопка закрытия
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

print("Markus Script loaded! Created by shqieg")
