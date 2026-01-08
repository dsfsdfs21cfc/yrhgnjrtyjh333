local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local SETTINGS = {
    GAME_ID = 109983668079237,
    RETRY_DELAY = 0.2
}

local SERVER_LIST = {}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportStatusGUI"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 1, -130)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "⚡ AUTO TELEPORT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 60)
status.Position = UDim2.new(0, 10, 0, 35)
status.BackgroundTransparency = 1
status.Text = "Запуск..."
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.Parent = frame

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 15)
info.Position = UDim2.new(0, 10, 1, -20)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(120, 120, 120)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
closeButton.BorderSizePixel = 0
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = frame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 4)

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -125, 1, 130)}):Play()
    task.wait(0.3)
    screenGui:Destroy()
end)

local dragging, dragStartPos, frameStartPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        frame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, 
                                  frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local function UpdateStatus(text, color)
    status.Text = text
    status.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

local function UpdateInfo(text)
    info.Text = text
end

-- Ловим ошибки телепортации
local TELEPORT_FAILED = false

TeleportService.TeleportInitFailed:Connect(function(player, result)
    if player == Players.LocalPlayer then
        TELEPORT_FAILED = true
        UpdateStatus("⛔ " .. tostring(result) .. "\n🔄 Следующий...", Color3.fromRGB(255, 100, 100))
    end
end)

-- Загрузка 100 серверов (1 страница)
local function LoadServers()
    local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100"):format(SETTINGS.GAME_ID)
    local ok, res = pcall(game.HttpGet, game, url)
    
    if not ok then return {} end
    
    local success, data = pcall(HttpService.JSONDecode, HttpService, res)
    if not success or not data or not data.data then return {} end
    
    local servers = {}
    for _, srv in ipairs(data.data) do
        if srv.id then
            table.insert(servers, srv.id)
        end
    end
    return servers
end

local function TryTeleport(serverId)
    TELEPORT_FAILED = false
    UpdateStatus("🔗 " .. serverId:sub(1, 18) .. "...", Color3.fromRGB(150, 255, 150))
    
    pcall(TeleportService.TeleportToPlaceInstance, TeleportService, SETTINGS.GAME_ID, serverId, Players.LocalPlayer)
    
    for i = 1, 20 do
        task.wait(0.1)
        if TELEPORT_FAILED then return end
    end
end

-- ЗАПУСК
UpdateStatus("🔍 Загрузка...", Color3.fromRGB(200, 200, 255))
UpdateInfo("v4.1 | Fast")

SERVER_LIST = LoadServers()

if #SERVER_LIST == 0 then
    UpdateStatus("⚠ Нет серверов, повтор...", Color3.fromRGB(255, 200, 100))
    task.wait(3)
    SERVER_LIST = LoadServers()
end

UpdateInfo("Серверов: " .. #SERVER_LIST)

-- Бесконечный цикл
while true do
    if #SERVER_LIST > 0 then
        TryTeleport(SERVER_LIST[math.random(1, #SERVER_LIST)])
    else
        SERVER_LIST = LoadServers()
    end
    task.wait(SETTINGS.RETRY_DELAY)
end
