---------------------------------------------------
-- WAIT FOR GAME
---------------------------------------------------
repeat task.wait() until game:IsLoaded()

---------------------------------------------------
-- SERVICES
---------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

---------------------------------------------------
-- STATES
---------------------------------------------------
local autoFarmEnabled = false
local autoResetEnabled = false
local antiAFKEnabled = false

local farmSpeed = 50
local activeTween
local totalCollected = 0
local bagCount = 0
local bagMax = 50
local isFarming = false

---------------------------------------------------
-- CLEAN OLD GUI
---------------------------------------------------
pcall(function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui.Name == "SnowTokenGUI" then
            gui:Destroy()
        end
    end
end)

---------------------------------------------------
-- CREATE GUI
---------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SnowTokenGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 300)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 150, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 15)
TitleFix.Position = UDim2.new(0, 0, 1, -15)
TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "❄️ MM2 Snow Token Farm"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentFrame

---------------------------------------------------
-- UI FUNCTIONS
---------------------------------------------------
local function CreateToggle(name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ContentFrame
    
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleBG = Instance.new("Frame")
    ToggleBG.Size = UDim2.new(0, 44, 0, 22)
    ToggleBG.Position = UDim2.new(1, -52, 0.5, -11)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = ToggleFrame
    Instance.new("UICorner", ToggleBG).CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 2, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleBG
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local enabled = default
    
    local function Update()
        local pos = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local bg = enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 75)
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = pos}):Play()
        TweenService:Create(ToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = bg}):Play()
    end
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = ToggleFrame
    
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Update()
        callback(enabled)
    end)
    
    if default then Update() end
    return ToggleFrame
end

local function CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ContentFrame
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local Value = Instance.new("TextLabel")
    Value.Size = UDim2.new(0, 40, 0, 20)
    Value.Position = UDim2.new(1, -50, 0, 5)
    Value.BackgroundTransparency = 1
    Value.Text = tostring(default)
    Value.TextColor3 = Color3.fromRGB(100, 200, 255)
    Value.TextSize = 14
    Value.Font = Enum.Font.GothamBold
    Value.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, -20, 0, 6)
    SliderBG.Position = UDim2.new(0, 10, 0, 32)
    SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame
    Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBG
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBG
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = SliderBG
    
    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -7, 0.5, -7)
        Value.Text = tostring(val)
        callback(val)
    end
    
    Btn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
    end)
    Btn.MouseButton1Click:Connect(function()
        Update({Position = Vector2.new(player:GetMouse().X, 0)})
    end)
end

---------------------------------------------------
-- UI ELEMENTS
---------------------------------------------------
CreateToggle("Auto Farm Snow Token", false, function(v)
    autoFarmEnabled = v
    if v then
        print("[Farm] Started")
    else
        print("[Farm] Stopped")
    end
end)

CreateToggle("Auto Reset (Bag Full)", false, function(v)
    autoResetEnabled = v
end)

CreateSlider("Farm Speed", 10, 200, 50, function(v)
    farmSpeed = v
end)

CreateToggle("Anti-AFK", false, function(v)
    antiAFKEnabled = v
    if v then
        player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Stats Display
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "Stats"
StatsLabel.Size = UDim2.new(1, 0, 0, 40)
StatsLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
StatsLabel.Text = "❄️ Сумка: 0/50\n📊 Всего собрано: 0"
StatsLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
StatsLabel.TextSize = 13
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.Parent = ContentFrame
Instance.new("UICorner", StatsLabel).CornerRadius = UDim.new(0, 8)

local function updateStats()
    StatsLabel.Text = "❄️ Сумка: " .. bagCount .. "/" .. bagMax .. "\n📊 Всего собрано: " .. totalCollected
end

---------------------------------------------------
-- DRAGGING
---------------------------------------------------
local dragging, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
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

---------------------------------------------------
-- MINIMIZE
---------------------------------------------------
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = minimized and UDim2.new(0, 280, 0, 40) or UDim2.new(0, 280, 0, 300)
    }):Play()
    MinimizeBtn.Text = minimized and "+" or "—"
    ContentFrame.Visible = not minimized
end)

---------------------------------------------------
-- HELPERS
---------------------------------------------------
local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
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

---------------------------------------------------
-- COIN COLLECTED EVENT (ПРАВИЛЬНЫЙ!)
---------------------------------------------------
local CoinCollectedRemote = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Gameplay")
    and ReplicatedStorage.Remotes.Gameplay:FindFirstChild("CoinCollected")

if CoinCollectedRemote then
    CoinCollectedRemote.OnClientEvent:Connect(function(coinType, currentBag, maxBag, ...)
        if coinType == "SnowToken" then
            bagCount = currentBag
            bagMax = maxBag
            totalCollected += 1
            updateStats()
            
            print("[Collected] Bag:", bagCount, "/", bagMax)
            
            -- BAG FULL - AUTO RESET
            if bagCount >= bagMax then
                print("[BAG FULL!] Stopping farm...")
                autoFarmEnabled = false
                isFarming = false
                
                if autoResetEnabled then
                    print("[Auto Reset] Resetting character...")
                    task.wait(0.5)
                    
                    if player.Character then
                        player.Character:BreakJoints()
                    end
                end
            end
        end
    end)
    print("[Setup] CoinCollected listener ready")
else
    print("[Warning] CoinCollected remote not found!")
end

---------------------------------------------------
-- CHARACTER RESPAWN
---------------------------------------------------
player.CharacterAdded:Connect(function()
    bagCount = 0
    isFarming = false
    updateStats()
    print("[Respawn] Bag reset to 0")
end)

---------------------------------------------------
-- FARM LOOP
---------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.15)
        
        if autoFarmEnabled and not isFarming then
            local hrp = getHRP()
            if not hrp then continue end
            
            -- Check if bag is full
            if bagCount >= bagMax then
                print("[Farm] Bag full, waiting...")
                task.wait(1)
                continue
            end
            
            local token, dist = findNearestToken()
            
            if token and token:FindFirstChild("TouchInterest") then
                isFarming = true
                
                -- Disable collision
                pcall(function()
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
                
                -- Move to token
                if dist > 100 then
                    -- Teleport if far
                    hrp.CFrame = token.CFrame + Vector3.new(0, 2, 0)
                else
                    -- Tween if close
                    local time = math.clamp(dist / farmSpeed, 0.1, 3)
                    local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {
                        CFrame = token.CFrame + Vector3.new(0, 2, 0)
                    })
                    tween:Play()
                    
                    -- Wait for collection or token gone
                    local startTime = tick()
                    while token and token:FindFirstChild("TouchInterest") and (tick() - startTime) < 3 do
                        task.wait(0.05)
                    end
                    tween:Cancel()
                end
                
                isFarming = false
            end
        end
    end
end)

---------------------------------------------------
-- READY
---------------------------------------------------
