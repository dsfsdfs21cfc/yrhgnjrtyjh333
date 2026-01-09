repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local farmSpeed = 22
local totalCollected = 0
local bagCount = 0
local bagMax = 50
local isResetting = false
local currentTween = nil

local lastCheckTime = os.time()
local lastCheckTotal = 0
local collectedThisPeriod = 0
local startTime = os.time()
local CHECK_INTERVAL = 5 * 60
local GAME_ID = 142823291

pcall(function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "SnowTokenGUI" then
            gui:Destroy()
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SnowTokenGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 155)
MainFrame.Position = UDim2.new(0.5, -125, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 150, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleLabel.Text = "❄️ MM2 Auto Farm"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

Instance.new("UICorner", TitleLabel).CornerRadius = UDim.new(0, 12)

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "Stats"
StatsLabel.Size = UDim2.new(1, -20, 0, 105)
StatsLabel.Position = UDim2.new(0, 10, 0, 40)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Загрузка..."
StatsLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
StatsLabel.TextSize = 13
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, mins, secs)
    else
        return string.format("%d:%02d", mins, secs)
    end
end

local function updateStats()
    local timeLeft = CHECK_INTERVAL - (os.time() - lastCheckTime)
    if timeLeft < 0 then timeLeft = 0 end
    
    local inGameTime = os.time() - startTime
    
    StatsLabel.Text = string.format(
        "❄️ Сумка: %d/%d\n📊 Всего: %d\n📈 За период: %d\n⏱️ В игре: %s\n🔄 Проверка: %s",
        bagCount,
        bagMax,
        totalCollected,
        collectedThisPeriod,
        formatTime(inGameTime),
        formatTime(timeLeft)
    )
    StatsLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
end

local dragging, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function disableAllCollisions()
    pcall(function()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            pcall(function()
                for _, part in pairs(otherPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end
end

local function findNearestToken()
    local hrp = getHRP()
    if not hrp then return nil, math.huge end
    
    local nearest, best = nil, math.huge
    
    for _, obj in pairs(Workspace:GetChildren()) do
        local container = obj:FindFirstChild("CoinContainer")
        if container then
            for _, coin in pairs(container:GetChildren()) do
                if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
                    local dist = (hrp.Position - coin.Position).Magnitude
                    if dist < best then
                        best = dist
                        nearest = coin
                    end
                end
            end
        end
    end
    
    return nearest, best
end

local function clickButton(btn)
    if not btn then return end
    
    pcall(function()
        if btn.AbsolutePosition and btn.AbsoluteSize then
            local pos = btn.AbsolutePosition + btn.AbsoluteSize / 2
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
            end)
        end
    end)
    
    pcall(function()
        if firesignal then
            firesignal(btn.MouseButton1Click)
        end
    end)
    
    pcall(function()
        if syn and syn.fire_signal then
            syn.fire_signal(btn.MouseButton1Click)
        end
    end)
    
    pcall(function()
        if getconnections then
            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do
                pcall(function() conn:Fire() end)
            end
        end
    end)
end

local function autoSelectPhone()
    pcall(function()
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then return end
        
        for _, gui in pairs(playerGui:GetDescendants()) do
            if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                local name = gui.Name:lower()
                local text = gui:IsA("TextButton") and gui.Text:lower() or ""
                local parent = gui.Parent and gui.Parent.Name:lower() or ""
                
                if name:find("phone") or text:find("phone") or name == "phone" or parent:find("phone") then
                    clickButton(gui)
                    return
                end
            end
        end
        
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("Frame") and gui.Visible then
                local name = gui.Name:lower()
                if name:find("phone") or name == "phone" then
                    for _, child in pairs(gui:GetDescendants()) do
                        if (child:IsA("TextButton") or child:IsA("ImageButton")) and child.Visible then
                            clickButton(child)
                            return
                        end
                    end
                end
            end
        end
        
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("ImageLabel") and gui.Visible then
                local name = gui.Name:lower()
                if name:find("phone") then
                    for _, child in pairs(gui:GetDescendants()) do
                        if (child:IsA("TextButton") or child:IsA("ImageButton")) and child.Visible then
                            clickButton(child)
                            return
                        end
                    end
                end
            end
        end
    end)
end

local function cancelCurrentTween()
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
end

local currentTarget = nil

local function tweenToToken(token)
    local hrp = getHRP()
    if not hrp or not token then return end
    
    if currentTarget == token and currentTween then return end
    
    cancelCurrentTween()
    currentTarget = token
    
    local dist = (hrp.Position - token.Position).Magnitude
    local time = math.clamp(dist / farmSpeed, 0.1, 10)
    
    currentTween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {
        CFrame = token.CFrame + Vector3.new(0, 2, 0)
    })
    currentTween:Play()
end

local function loadServers()
    local servers = {}
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", GAME_ID)
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        
        if ok and data and data.data then
            for _, srv in ipairs(data.data) do
                if srv.id and srv.id ~= game.JobId and srv.playing and srv.maxPlayers and srv.playing < srv.maxPlayers then
                    table.insert(servers, srv.id)
                end
            end
        end
    end
    
    return servers
end

local function teleportToNewServer()
    StatsLabel.Text = "🔄 Загрузка серверов..."
    StatsLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    local servers = loadServers()
    
    if #servers == 0 then
        StatsLabel.Text = "⚠️ Нет серверов\nПовтор через 10 сек..."
        task.wait(10)
        return teleportToNewServer()
    end
    
    local targetServer = servers[math.random(1, #servers)]
    
    StatsLabel.Text = "🚀 Телепорт...\n" .. targetServer:sub(1, 12) .. "..."
    StatsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    task.wait(1)
    
    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(GAME_ID, targetServer, player)
    end)
    
    if not success then
        StatsLabel.Text = "❌ Ошибка\nПовтор..."
        StatsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(3)
        return teleportToNewServer()
    end
end

local function checkFarmProgress()
    local currentTime = os.time()
    local elapsed = currentTime - lastCheckTime
    
    if elapsed >= CHECK_INTERVAL then
        if collectedThisPeriod == 0 then
            StatsLabel.Text = "⚠️ 0 снежинок за 5 мин!\n🔄 Смена сервера..."
            StatsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(2)
            teleportToNewServer()
        else
            lastCheckTime = currentTime
            collectedThisPeriod = 0
        end
    end
end

local CoinCollectedRemote = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Gameplay")
    and ReplicatedStorage.Remotes.Gameplay:FindFirstChild("CoinCollected")

if CoinCollectedRemote then
    CoinCollectedRemote.OnClientEvent:Connect(function(coinType, currentBag, maxBag)
        if coinType == "SnowToken" then
            bagCount = currentBag
            bagMax = maxBag
            totalCollected += 1
            collectedThisPeriod += 1
            currentTarget = nil
            cancelCurrentTween()
            updateStats()
            
            if bagCount >= bagMax and not isResetting then
                isResetting = true
                cancelCurrentTween()
                
                task.wait(0.3)
                
                if player.Character then
                    player.Character:BreakJoints()
                end
            end
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    bagCount = 0
    isResetting = false
    currentTween = nil
    currentTarget = nil
    updateStats()
    
    for i = 1, 10 do
        task.wait(0.3)
        autoSelectPhone()
    end
end)

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

RunService.Stepped:Connect(function()
    disableAllCollisions()
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        autoSelectPhone()
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        updateStats()
        checkFarmProgress()
    end
end)

task.spawn(function()
    while true do
        task.wait(0.15)
        
        if isResetting then
            task.wait(0.5)
            continue
        end
        
        local hrp = getHRP()
        if not hrp then continue end
        
        if bagCount >= bagMax then
            task.wait(0.5)
            continue
        end
        
        local token, dist = findNearestToken()
        
        if token and token:FindFirstChild("TouchInterest") then
            if currentTarget ~= token then
                tweenToToken(token)
            end
        else
            cancelCurrentTween()
            currentTarget = nil
        end
    end
end)

for i = 1, 20 do
    task.wait(0.3)
    autoSelectPhone()
end
