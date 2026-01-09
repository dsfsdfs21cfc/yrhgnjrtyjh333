repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local farmSpeed = 25
local totalCollected = 0
local bagCount = 0
local bagMax = 50
local isFarming = false
local isResetting = false

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
MainFrame.Size = UDim2.new(0, 250, 0, 100)
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
StatsLabel.Size = UDim2.new(1, -20, 0, 50)
StatsLabel.Position = UDim2.new(0, 10, 0, 40)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "❄️ Сумка: 0/50\n📊 Всего: 0"
StatsLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
StatsLabel.TextSize = 16
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

local function updateStats()
    StatsLabel.Text = "❄️ Сумка: " .. bagCount .. "/" .. bagMax .. "\n📊 Всего: " .. totalCollected
end

local dragging, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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

local function autoSelectPhone()
    pcall(function()
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then return end
        
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                local name = gui.Name:lower()
                local text = ""
                if gui:IsA("TextButton") then
                    text = gui.Text:lower()
                end
                
                if name:find("phone") or text:find("phone") then
                    pcall(function() firesignal(gui.MouseButton1Click) end)
                    pcall(function() gui.MouseButton1Click:Fire() end)
                    return
                end
            end
        end
        
        local mainGui = playerGui:FindFirstChild("MainGUI")
        if mainGui then
            local lobby = mainGui:FindFirstChild("Lobby")
            if lobby then
                local screens = lobby:FindFirstChild("Screens")
                if screens then
                    local christmas = screens:FindFirstChild("Christmas2025")
                    if christmas then
                        for _, btn in pairs(christmas:GetDescendants()) do
                            if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                                local btnName = btn.Name:lower()
                                if btnName:find("phone") then
                                    pcall(function() firesignal(btn.MouseButton1Click) end)
                                    pcall(function() btn.MouseButton1Click:Fire() end)
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
        
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            for _, remote in pairs(remotes:GetDescendants()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    local remoteName = remote.Name:lower()
                    if remoteName:find("phone") or remoteName:find("select") or remoteName:find("choose") then
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer("Phone")
                            else
                                remote:InvokeServer("Phone")
                            end
                        end)
                    end
                end
            end
        end
    end)
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
            updateStats()
            
            if bagCount >= bagMax and not isResetting then
                isResetting = true
                isFarming = false
                
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
    isFarming = false
    isResetting = false
    updateStats()
    
    task.wait(1)
    autoSelectPhone()
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
        task.wait(2)
        autoSelectPhone()
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        
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
        
        if token and token:FindFirstChild("TouchInterest") and not isFarming then
            isFarming = true
            
            if dist > 100 then
                hrp.CFrame = token.CFrame + Vector3.new(0, 2, 0)
            else
                local time = math.clamp(dist / farmSpeed, 0.1, 3)
                local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {
                    CFrame = token.CFrame + Vector3.new(0, 2, 0)
                })
                tween:Play()
                
                local startTime = tick()
                while token and token.Parent and token:FindFirstChild("TouchInterest") and (tick() - startTime) < 3 do
                    task.wait(0.05)
                end
                tween:Cancel()
            end
            
            isFarming = false
        end
    end
end)

task.wait(2)
autoSelectPhone()
