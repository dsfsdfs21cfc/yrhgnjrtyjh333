local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

local localPlayer = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════
--  CONFIG
-- ══════════════════════════════════════════════════════════════

local WEBHOOK_1_25M   = "https://discord.com/api/webhooks/1454372752034365566/EmLdd5U_wxp6Ziy8gAAiGB7MHpeWPaDBZzS8vfAQSD2dWsB0ZyPAEfDYK0n869ObblnT"
local WEBHOOK_26_100M = "https://discord.com/api/webhooks/1456399330662682714/1HTEJNBTO1qhXMex8-5YBB1_Q5ekmyHtgvUJ886zitqpl6IC_aXhjKb5QgpjXns1s4uh"
local WEBHOOK_101M    = "https://discord.com/api/webhooks/1456399389336801463/kyZ8kGtNnSL3Ee1YJteiCWdKWA_KlVFdUNEVAAWr9_kkwGJc6r-3Xg7D8w56aUxRfa1q"
local WEBHOOK_SPECIAL = "https://discord.com/api/webhooks/1456411967941120194/5BhYfK-zbqoe_tG7SxHBXysz0IIJj1V4pPXh7LjnZz62vXTv5Z2AWDGT-CGii1xKjTEv"

local GAME_ID    = 109983668079237
local SERVER_URL = "https://raw.githubusercontent.com/Confilas/ghjnfthun/refs/heads/main/fghs"
local FPS_LIMIT  = 15

-- ══════════════════════════════════════════════════════════════
--  DEFAULTS
-- ══════════════════════════════════════════════════════════════

if setfpscap then pcall(setfpscap, FPS_LIMIT) end

local VDS_SEND_PASSWORD = "send_546564reaqw452151523333"
local VDS_URL = ""
local SECRET = "g45hAT436262155453"

local TELEPORT_SETTINGS = {
    GAME_ID = GAME_ID,
    PASTEFY_URL = SERVER_URL,
    COOLDOWN_TIME = 300,
    COUNTDOWN_TIME = 0,
    ERROR_RETRY_DELAY = 2,
    SUCCESS_DELAY = 3,
}

local WEBHOOKS = {
    {
        url = WEBHOOK_1_25M,
        title = "Low Income",
        color = 0x00ff80,
        min = 1_000_000,
        max = 25_000_000,
        sendServerInfo = false,
        sendTeleport = true,
    },
    {
        url = WEBHOOK_26_100M,
        title = "Medium Income",
        color = 0xffee00,
        min = 26_000_000,
        max = 100_000_000,
        sendServerInfo = false,
        sendTeleport = false,
        showJoinerAd = true,
    },
    {
        url = WEBHOOK_101M,
        title = "High Income",
        color = 0xff2d2d,
        min = 101_000_000,
        max = 10_000_000_000,
        sendServerInfo = false,
        sendTeleport = false,
        showJoinerAd = true,
    },
    {
        url = WEBHOOK_SPECIAL,
        title = "Special Brainrots",
        color = 0xd946ef,
        special = true,
        sendServerInfo = false,
        sendTeleport = true,
    },
}

-- ══════════════════════════════════════════════════════════════
--  SPECIAL BRAINROTS
-- ══════════════════════════════════════════════════════════════

local SPECIAL_BRAINROTS = {
    ["Garama and Madundung"]      = { min = 0, mutations = { "Bloodrot", "Candy", "Lava" } },
    ["Dragon Cannelloni"]         = { min = 0, mutations = {} },
    ["La Supreme Combinasion"]    = { min = 0, mutations = {} },
    ["Ketupat Kepat"]             = { min = 200_000_000, mutations = { "Yin Yang" } },
    ["Strawberry Elephant"]       = { min = 0, mutations = {} },
    ["Ketchuru and Musturu"]      = { min = 100_000_000, mutations = { "Bloodrot", "Candy", "Lava", "Yin Yang" } },
    ["Tralaledon"]                = { min = 0, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Tictac Sahur"]              = { min = 150_000_000, mutations = { "Bloodrot", "Candy", "Lava", "Yin Yang", "Galaxy" } },
    ["Burguro And Fryuro"]        = { min = 0, mutations = {} },
    ["La Secret Combinasion"]     = { min = 0, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Spooky and Pumpky"]         = { min = 0, mutations = {} },
    ["Meowl"]                     = { min = 0, mutations = {} },
    ["La Casa Boo"]               = { min = 0, mutations = {} },
    ["Headless Horseman"]         = { min = 0, mutations = {} },
    ["Los Tacoritas"]             = { min = 0, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Capitano Moby"]             = { min = 0, mutations = {} },
    ["Cooki and Milki"]           = { min = 0, mutations = { "Shiny" } },
    ["Fragrama and Chocrama"]     = { min = 0, mutations = {} },
    ["Guest 666"]                 = { min = 0, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Fishino Clownino"]          = { min = 0, mutations = {} },
    ["Tacorita Bicicleta"]        = { min = 250_000_000, mutations = { "Lava" } },
    ["La Jolly Grande"]           = { min = 300_000_000, mutations = {} },
    ["W or L"]                    = { min = 250_000_000, mutations = { "Candy", "Lava", "BloodRot", "Rainbow" } },
    ["Los Puggies"]               = { min = 300_000_000, mutations = { "Rainbow" } },
    ["La Taco Combinasion"]       = { min = 250_000_000, mutations = { "Candy", "Rainbow", "Galaxy" } },
    ["Chipso and Queso"]          = { min = 200_000_000, mutations = { "Candy" } },
    ["Mieteteira Bicicleteira"]   = { min = 400_000_000, mutations = {} },
    ["Los Mobilis"]               = { min = 400_000_000, mutations = {} },
    ["La Spooky Grande"]          = { min = 150_000_000, mutations = {} },
    ["Eviledon"]                  = { min = 300_000_000, mutations = { "Rainbow" } },
    ["Chillin Chili"]             = { min = 200_000_000, mutations = { "Candy" } },
    ["Money Money Puggy"]         = { min = 300_000_000, mutations = { "Bloodrot" } },
    ["Tang Tang Keletang"]        = { min = 250_000_000, mutations = { "Yin Yang" } },
    ["Los Primos"]                = { min = 0, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Orcaledon"]                 = { min = 150_000_000, mutations = { "Candy", "Lava", "Rainbow", "Galaxy" } },
    ["Las Sis"]                   = { min = 200_000_000, mutations = { "Candy", "Lava" } },
    ["La Extinct Grande"]         = { min = 200_000_000, mutations = {} },
    ["Los Bros"]                  = { min = 200_000_000, mutations = { "Candy", "Lava", "Rainbow" } },
    ["Spaghetti Tualetti"]        = { min = 500_000_000, mutations = { "Bloodrot", "Rainbow" } },
    ["Esok Sekolah"]              = { min = 500_000_000, mutations = {} },
    ["Nuclearo Dinossauro"]       = { min = 200_000_000, mutations = { "Cursed", "Bloodrot" } },
    ["Lavadorito Spinito"]        = { min = 150_000_000, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["La Ginger Sekolah"]         = { min = 200_000_000, mutations = { "Cursed", "Candy", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Reinito Sleighito"]         = { min = 0, mutations = {} },
    ["Dragon Gingerini"]          = { min = 0, mutations = {} },
    ["Festive 67"]                = { min = 0, mutations = {} },
    ["Ginger Gerat"]              = { min = 0, mutations = {} },
    ["Jolly Jolly Sahur"]         = { min = 0, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Skibidi Toilet"]            = { min = 0, mutations = {} },
    ["Tuff Toucan"]               = { min = 200_000_000, mutations = { "Cursed", "Bloodrot", "Candy", "Lava", "Yin Yang", "Radioactive", "Rainbow", "Galaxy" } },
    ["Cerberus"]                  = { min = 0, mutations = {} },
    ["Ketupat Bros"]              = { min = 0, mutations = {} },
    ["Hydra Dragon Cannelloni"]   = { min = 0, mutations = {} },
    ["Popuru and Fizzuru"]        = { min = 0, mutations = {} },
    ["Rosey and Teddy"]        = { min = 0, mutations = {} },
    ["Lovin Rose"]        = { min = 0, mutations = {} },
    ["Love Love bear"]        = { min = 0, mutations = {} },
    ["Love Love Bear"]        = { min = 0, mutations = {} }, 
    ["Rosetti Tualetti"]        = { min = 0, mutations = {} },
    ["La Romantic Grande"]        = { min = 0, mutations = {} },
}

-- ══════════════════════════════════════════════════════════════
--  OBJECTS
-- ══════════════════════════════════════════════════════════════

local OBJECT_NAMES = {
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleritos",
    "Las Tralaleritas", "Graipuss Medussi", "Torrtuginni Dragonfrutini",
    "Pot Hotspot", "La Grande Combinasion", "Garama and Madundung",
    "Secret Lucky Block", "Dragon Cannelloni", "Nuclearo Dinossauro",
    "Las Vaquitas Saturnitas", "Agarrini la Palini", "Los Hotspotsitos",
    "Esok Sekolah", "Nooo My Hotspot", "La Supreme Combinasion",
    "Admin Lucky Block", "Ketupat Kepat", "Strawberry Elephant",
    "Spaghetti Tualetti", "Ketchuru and Musturu", "La Secret Combinasion",
    "La Karkerkar Combinasion", "Los Bros", "La Extinct Grande",
    "Las Sis", "Tacorita Bicicleta", "Tictac Sahur",
    "Celularcini Viciosini", "Los Primos", "Tang Tang Keletang",
    "Money Money Puggy", "Burguro And Fryuro", "Chillin Chili",
    "Eviledon", "La Spooky Grande", "Los Mobilis",
    "Spooky and Pumpky", "Mieteteira Bicicleteira", "Meowl",
    "Chipso and Queso", "La Casa Boo", "Headless Horseman",
    "Mariachi Corazoni", "La Taco Combinasion", "Capitano Moby",
    "Guest 666", "Cooki and Milki", "Los Puggies",
    "Fragrama and Chocrama", "Los Spaghettis", "Los Tacoritas",
    "Orcaledon", "Lavadorito Spinito", "Los Planitos",
    "W or L", "Fishino Clownino", "Chicleteira Noelteira",
    "La Jolly Grande", "Los Chicleteiras", "Gobblino Uniciclino",
    "Los 67", "Los Spooky Combinasionas", "Swag Soda",
    "Los Combinasionas", "Los Burritos", "67",
    "Rang Ring Bus", "Los Nooo My Hotspotsitos", "Chicleteirina Bicicleteirina",
    "Noo My Candy", "Los Quesadillas", "Quesadillo Vampiro",
    "Quesadilla Crocodila", "Ho Ho Ho Sahur", "Horegini Boom",
    "Pot Pumpkin", "Pirulitoita Bicicleteira", "La Sahur Combinasion",
    "List List List Sahur", "Noo My Examine", "Cuadramat and Pakrahmatmamat",
    "Los Cucarachas", "1x1x1x1", "La Ginger Sekolah",
    "Reinito Sleighito", "Swaggy Bros", "Gingerbread Dragon",
    "Naughty Naughty", "Chimnino", "Noo my Present",
    "Los Candies", "Santa Hotspot", "Festive 67",
    "Burrito Bandito", "Perrito Burrito", "Trickolino",
    "La Vacca Jacko Linterino", "Los Karkeritos", "Karker Sahur",
    "job job job Sahur", "Frankentteo", "Pumpkini Spyderini",
    "Yess My Examine", "Guerriro Digitale", "Boatito Auratito",
    "Los Tortus", "Zombie Tralala", "Vulturino Skeletono",
    "La Cucaracha", "Extinct Tralalero", "Fragola La La La",
    "Los Spyderinis", "Blackhole Goat", "Chachechi",
    "Dul Dul Dul", "Sammyni Spyderini", "Jackorilla",
    "Trenostruzzo Turbo 4000", "Karkerkar Kurkur", "Los Matteos",
    "Bisonte Giuppitere", "Los 25", "25",
    "Dragon Gingerini", "Donkeyturbo Express", "Money Money Reindeer",
    "Jolly Jolly Sahur", "Los Jolly Combinasionas", "Ginger Gerat",
    "Skibidi Toilet", "Tuff Toucan", "Bunito Bunito Spinito",
    "Tung Tung Tung Sahur", "Bunnyman", "Please my Present",
    "Giftini Spyderini", "Cerberus", "Ay Mi Gatito",
    "AY MI GATITO MIAU MIAU", "Ketupat Bros", "Hydra Dragon Cannelloni",
    "bacuru and egguru", "Popuru and Fizzuru", "Los Trios",
    "Los Sekolahs", "Chill Puppy", "Spinny Hammy", "Los Mi Gatitos", "Arcadopus", "Mi Gatito", 
    "Love Love Love Sahur", "Noo my Heart", "Los Couples", "Spaghetti Floretti", "Rosetti Tualetti",
    "Luv Luv Luv", "Cupid Hotspot", "Rosey and Teddy", "Lovin Rose", "La Romantic Grande", "Love Love bear",
    "Chicleteira Cupideira","La Romantic Grande",
}

-- ══════════════════════════════════════════════════════════════
--  DERIVED LOOKUPS
-- ══════════════════════════════════════════════════════════════

local OBJECTS = {}
for _, name in ipairs(OBJECT_NAMES) do OBJECTS[name] = true end

-- ══════════════════════════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════════════════════════

local sentCache = {}
local SERVER_LIST = {}
local BLACKLIST = {}
local VDS_TOKEN_CACHE = { token = nil, expiresAt = 0 }
local serversReady = false

-- ══════════════════════════════════════════════════════════════
--  GUI (fullscreen black)
-- ══════════════════════════════════════════════════════════════

local CoreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportStatusGUI"
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = CoreGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0
bg.BorderSizePixel = 0
bg.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0.35, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "AURORA FINDER"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 32
titleLabel.Parent = bg

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 40)
statusLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Starting..."
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 20
statusLabel.TextWrapped = true
statusLabel.Parent = bg

pcall(function()
    TeleportService.TeleportInitFailed:Connect(function() end)
end)

-- ══════════════════════════════════════════════════════════════
--  UTILITIES
-- ══════════════════════════════════════════════════════════════

local function UpdateStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

local function newTable(n)
    return table.create and table.create(n) or {}
end

local bxor = bit32 and bit32.bxor or bit.bxor

local function xorBytes(str, key)
    local out = newTable(#str)
    local kl = #key
    for i = 1, #str do
        out[i] = string.char(bxor(string.byte(str, i), string.byte(key, (i - 1) % kl + 1)))
    end
    return table.concat(out)
end

local function toHex(str)
    local t = newTable(#str * 2)
    for i = 1, #str do
        t[i] = string.format("%02X", string.byte(str, i))
    end
    return table.concat(t)
end

local function EncryptJobId(jobId)
    return toHex(xorBytes(jobId, SECRET))
end

local function getRequester()
    return http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (KRNL_HTTP and KRNL_HTTP.request)
end

local function formatIncomeNumber(n)
    if not n then return "?" end
    if n >= 1e9 then
        local v = n / 1e9
        return (v % 1 == 0 and string.format("%dB/s", v) or string.format("%.1fB/s", v)):gsub("%.0B/s", "B/s")
    elseif n >= 1e6 then
        local v = n / 1e6
        return (v % 1 == 0 and string.format("%dM/s", v) or string.format("%.1fM/s", v)):gsub("%.0M/s", "M/s")
    elseif n >= 1e3 then
        local v = n / 1e3
        return (v % 1 == 0 and string.format("%dK/s", v) or string.format("%.1fK/s", v)):gsub("%.0K/s", "K/s")
    end
    return string.format("%d/s", n)
end

local function parseGenerationText(s)
    if type(s) ~= "string" or s == "" then return nil end
    local norm = s:gsub("%$", ""):gsub(",", ""):gsub("%s+", "")
    local num, suffix = norm:match("^([%-%d%.]+)([KkMmBb]?)/s$")
    if not num then return nil end
    local val = tonumber(num)
    if not val then return nil end
    local mult = { K = 1e3, k = 1e3, M = 1e6, m = 1e6, B = 1e9, b = 1e9 }
    return val * (mult[suffix] or 1)
end

local function grabText(inst)
    if not inst then return nil end
    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
        local ok, ct = pcall(function() return inst.ContentText end)
        if ok and type(ct) == "string" and #ct > 0 then return ct end
        local t = inst.Text
        if type(t) == "string" and #t > 0 then return t end
    end
    if inst:IsA("StringValue") then
        local v = inst.Value
        if type(v) == "string" and #v > 0 then return v end
    end
    return nil
end

local function isGuidName(s)
    return s:match("^[0-9a-fA-F]+%-%x+%-%x+%-%x+%-%x+$") ~= nil
end

-- ══════════════════════════════════════════════════════════════
--  SCANNING
-- ══════════════════════════════════════════════════════════════

local function getOverheadInfo(overhead)
    if not overhead then return nil, nil end
    local name
    local display = overhead:FindFirstChild("DisplayName")
    if display then name = grabText(display) end
    if not name then
        local any = overhead:FindFirstChildOfClass("TextLabel")
            or overhead:FindFirstChildOfClass("TextButton")
            or overhead:FindFirstChildOfClass("TextBox")
        name = any and grabText(any) or nil
    end
    local genText
    local gen = overhead:FindFirstChild("Generation")
    if gen then genText = grabText(gen) end
    if not genText then
        for _, child in ipairs(overhead:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                local t = grabText(child)
                if t and (t:match("%$") or t:match("/s")) then
                    genText = t
                    break
                end
            end
        end
    end
    return name, genText
end

local function scanPlots()
    local r = {}
    local Plots = Workspace:FindFirstChild("Plots")
    if not Plots then return r end
    for _, plot in ipairs(Plots:GetChildren()) do
        local Podiums = plot:FindFirstChild("AnimalPodiums")
        if Podiums then
            for _, podium in ipairs(Podiums:GetChildren()) do
                local Base = podium:FindFirstChild("Base")
                local Spawn = Base and Base:FindFirstChild("Spawn")
                local Att = Spawn and Spawn:FindFirstChild("Attachment")
                local OH = Att and Att:FindFirstChild("AnimalOverhead")
                if OH then
                    local name, gt = getOverheadInfo(OH)
                    local gn = gt and parseGenerationText(gt)
                    if name and gn then
                        table.insert(r, { name = name, gen = gn, location = "Plot" })
                    end
                end
            end
        end
    end
    return r
end

local function scanRunway()
    local r = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isGuidName(obj.Name) then
            local part = obj:FindFirstChild("Part")
            local info = part and part:FindFirstChild("Info")
            local oh = info and info:FindFirstChild("AnimalOverhead")
            if oh then
                local name, gt = getOverheadInfo(oh)
                local gn = gt and parseGenerationText(gt)
                if name and gn then
                    table.insert(r, { name = name, gen = gn, location = "Runway" })
                end
            end
        end
    end
    return r
end

local function scanAllOverheads()
    local r, seen = {}, {}
    for _, child in ipairs(Workspace:GetDescendants()) do
        if child.Name == "AnimalOverhead" and not seen[child] then
            seen[child] = true
            local name, gt = getOverheadInfo(child)
            local gn = gt and parseGenerationText(gt)
            if name and gn then
                table.insert(r, { name = name, gen = gn, location = "World" })
            end
        end
    end
    return r
end

local function scanPlayerGui()
    local r = {}
    local pg = localPlayer:FindFirstChild("PlayerGui")
    if not pg then return r end
    for _, child in ipairs(pg:GetDescendants()) do
        if child.Name == "AnimalOverhead" then
            local name, gt = getOverheadInfo(child)
            local gn = gt and parseGenerationText(gt)
            if name and gn then
                table.insert(r, { name = name, gen = gn, location = "GUI" })
            end
        end
    end
    return r
end

local function scanDebrisFolder()
    local r = {}
    local df = Workspace:FindFirstChild("Debris")
    if not df then return r end
    for _, inst in ipairs(df:GetChildren()) do
        if inst.Name == "FastOverheadTemplate" then
            local gui = inst:FindFirstChild("GUI")
            if gui then
                local ni = gui:FindFirstChild("DisplayName")
                local gi = gui:FindFirstChild("Generation")
                local name = ni and grabText(ni)
                local gt = gi and grabText(gi)
                local gn = gt and parseGenerationText(gt)
                if name and gn then
                    table.insert(r, { name = name, gen = gn, location = "DebrisFolder" })
                end
            end
        end
    end
    return r
end

local function collectAll(timeout)
    local t0 = os.clock()
    local collected = {}
    repeat
        collected = {}
        local sources = {}
        -- Run all scans in parallel
        local done = 0
        local total = 5
        task.spawn(function() local r = scanPlots()          for _, v in ipairs(r) do table.insert(sources, v) end done += 1 end)
        task.spawn(function() local r = scanRunway()         for _, v in ipairs(r) do table.insert(sources, v) end done += 1 end)
        task.spawn(function() local r = scanAllOverheads()   for _, v in ipairs(r) do table.insert(sources, v) end done += 1 end)
        task.spawn(function() local r = scanPlayerGui()      for _, v in ipairs(r) do table.insert(sources, v) end done += 1 end)
        task.spawn(function() local r = scanDebrisFolder()   for _, v in ipairs(r) do table.insert(sources, v) end done += 1 end)
        while done < total and os.clock() - t0 < timeout do task.wait() end
        collected = sources
        local seen, unique = {}, {}
        for _, item in ipairs(collected) do
            local key = item.name .. ":" .. tostring(item.gen) .. ":" .. (item.location or "")
            if not seen[key] then
                seen[key] = true
                table.insert(unique, item)
            end
        end
        collected = unique
        if #collected > 0 then break end
        task.wait(0.1)
    until os.clock() - t0 > timeout
    return collected
end

local function findAllPetMutations()
    local r = {}
    local pf = Workspace:FindFirstChild("Plots")
    if not pf then return r end
    for _, plot in ipairs(pf:GetChildren()) do
        if plot:IsA("Folder") or plot:IsA("Model") then
            for _, desc in ipairs(plot:GetDescendants()) do
                if desc:IsA("Model") and desc:GetAttribute("Mutation") then
                    table.insert(r, { PlotId = plot.Name, PetName = desc.Name, Mutation = desc:GetAttribute("Mutation") })
                end
            end
        end
    end
    return r
end

-- ══════════════════════════════════════════════════════════════
--  FILTERING & CLASSIFICATION
-- ══════════════════════════════════════════════════════════════

local function shouldShow(name, gen)
    if OBJECTS[name] then return true end
    return type(gen) == "number" and gen >= 1_000_000
end

local function hasRequiredMutation(name, mutation)
    local cfg = SPECIAL_BRAINROTS[name]
    if not cfg then return false end
    local muts = cfg.mutations or {}
    if #muts == 0 then return false end
    for _, m in ipairs(muts) do
        if mutation == m then return true end
    end
    return false
end

local function isSpecialBrainrot(name, gen, mutation)
    local cfg = SPECIAL_BRAINROTS[name]
    if not cfg then return false end
    if mutation and hasRequiredMutation(name, mutation) then return true end
    return gen >= cfg.min
end

local function generateCacheKey(obj)
    return obj.name .. ":" .. tostring(obj.gen) .. ":" .. (obj.mutation or "none")
end

local function filterNewObjects(objects)
    local r = {}
    for _, obj in ipairs(objects) do
        local key = generateCacheKey(obj)
        if not sentCache[key] then
            sentCache[key] = true
            table.insert(r, obj)
        end
    end
    return r
end

-- ══════════════════════════════════════════════════════════════
--  VDS & DISCORD
-- ══════════════════════════════════════════════════════════════

local function GetVDSToken()
    local req = getRequester()
    if not req then return nil end
    local now = os.time()
    if VDS_TOKEN_CACHE.token and VDS_TOKEN_CACHE.expiresAt > (now + 300) then
        return VDS_TOKEN_CACHE.token
    end
    local ok, resp = pcall(function()
        return req({
            Url = VDS_URL .. "/auth/send",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ password = VDS_SEND_PASSWORD }),
        })
    end)
    if ok and resp and resp.StatusCode == 200 then
        local s, data = pcall(function() return HttpService:JSONDecode(resp.Body) end)
        if s and data and data.token then
            VDS_TOKEN_CACHE.token = data.token
            VDS_TOKEN_CACHE.expiresAt = math.floor((data.expiresAt or (now * 1000 + 3600000)) / 1000)
            return data.token
        end
    end
    return nil
end

local function sendToVDS(filtered, wh)
    local req = getRequester()
    if not req or #filtered == 0 then return end
    local token = GetVDSToken()
    if not token then return end
    local payload = {
        jobId = EncryptJobId(tostring(game.JobId)),
        placeId = game.PlaceId,
        title = wh.title,
        color = wh.color,
        range = { min = wh.min, max = wh.max },
        special = wh.special or false,
        sendServerInfo = wh.sendServerInfo or false,
        time = os.time(),
        objects = {},
    }
    for _, obj in ipairs(filtered) do
        table.insert(payload.objects, {
            name = obj.name,
            gen = obj.gen,
            location = obj.location,
            mutation = obj.mutation or nil,
            important = OBJECTS[obj.name] or false,
            isSpecial = isSpecialBrainrot(obj.name, obj.gen, obj.mutation),
        })
    end
    pcall(function()
        return req({
            Url = VDS_URL .. "/brainrot",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Aurora-Token"] = token,
                ["X-Aurora-Role"] = "send",
            },
            Body = HttpService:JSONEncode(payload),
        })
    end)
end

local function buildDiscordEmbed(filtered, wh)
    local jobId = game.JobId
    local placeId = game.PlaceId

    local sorted = {}
    for _, obj in ipairs(filtered) do table.insert(sorted, obj) end
    table.sort(sorted, function(a, b) return a.gen > b.gen end)

    local lines = {}
    for i = 1, math.min(15, #sorted) do
        local obj = sorted[i]
        local mutStr = obj.mutation and ("  |  " .. obj.mutation) or ""
        local debrisStr = obj.location == "DebrisFolder" and "  |  DEBRIS" or ""
        table.insert(lines, string.format(
            "**%s — %s%s%s**",
            obj.name, formatIncomeNumber(obj.gen), mutStr, debrisStr
        ))
    end

    local desc = table.concat(lines, "\n")

    local fields = {}
    if wh.sendServerInfo then
        table.insert(fields, { name = "Server", value = "`" .. tostring(jobId) .. "`", inline = true })
    end
    if wh.sendTeleport then
        table.insert(fields, {
            name = "Teleport",
            value = string.format("```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s')\n```", placeId, jobId),
            inline = false,
        })
    elseif wh.showJoinerAd then
        table.insert(fields, {
            name = "Joiner",
            value = "[Buy here](https://discord.com/channels/1448597315207299126/1449995006315204891)",
            inline = false,
        })
    end

    return {
        username = "AURORA FINDER",
        embeds = { {
            title = wh.title,
            description = desc,
            color = wh.color,
            fields = (#fields > 0) and fields or nil,
            footer = { text = "Found: " .. #filtered .. "  |  " .. os.date("%H:%M:%S") },
            timestamp = DateTime.now():ToIsoDate(),
        } },
    }
end

local function sendDiscordNotificationByRange(filtered, wh, allowVDS)
    local req = getRequester()
    if not req or #filtered == 0 then return end

    local payload = buildDiscordEmbed(filtered, wh)

    pcall(function()
        return req({
            Url = wh.url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload),
        })
    end)

    if allowVDS then
        sendToVDS(filtered, wh)
    end
end

-- ══════════════════════════════════════════════════════════════
--  SCAN & NOTIFY
-- ══════════════════════════════════════════════════════════════

local function scanAndNotify()
    local allFound = collectAll(1.0)

    local muts = findAllPetMutations()
    local mutMap = {}
    for _, p in ipairs(muts) do mutMap[p.PetName] = p.Mutation end
    for _, obj in ipairs(allFound) do obj.mutation = mutMap[obj.name] end

    local groups = { {}, {}, {}, {} }
    local hasSpecial = false

    for _, obj in ipairs(allFound) do
        if OBJECTS[obj.name] and shouldShow(obj.name, obj.gen) and type(obj.gen) == "number" then
            if isSpecialBrainrot(obj.name, obj.gen, obj.mutation) then
                hasSpecial = true
                table.insert(groups[4], obj)
            end
        end
    end

    if hasSpecial then
        local new = filterNewObjects(groups[4])
        if #new > 0 then sendDiscordNotificationByRange(new, WEBHOOKS[4], false) end
        return
    end

    for _, obj in ipairs(allFound) do
        if OBJECTS[obj.name] and shouldShow(obj.name, obj.gen) and type(obj.gen) == "number" then
            for i = 1, 3 do
                if obj.gen >= WEBHOOKS[i].min and obj.gen <= WEBHOOKS[i].max then
                    table.insert(groups[i], obj)
                    break
                end
            end
        end
    end

    for i = 1, 3 do
        if #groups[i] > 0 then
            local new = filterNewObjects(groups[i])
            if #new > 0 then sendDiscordNotificationByRange(new, WEBHOOKS[i], true) end
        end
    end
end

-- ══════════════════════════════════════════════════════════════
--  TELEPORT
-- ══════════════════════════════════════════════════════════════

local function LoadServers()
    local ok, resp = pcall(function() return game:HttpGet(TELEPORT_SETTINGS.PASTEFY_URL) end)
    if not ok then return {} end
    local r = {}
    for id in string.gmatch(resp, "([a-f0-9%-]+)") do table.insert(r, id) end
    return r
end

local function IsServerAvailable(serverId)
    if not BLACKLIST[serverId] then return true end
    return (os.time() - BLACKLIST[serverId]) > TELEPORT_SETTINGS.COOLDOWN_TIME
end

local function TeleportLoop()
    while true do
        local available = {}
        for _, serverId in ipairs(SERVER_LIST) do
            if IsServerAvailable(serverId) then
                table.insert(available, serverId)
            end
        end

        if #available == 0 then
            UpdateStatus("All servers on cooldown, reloading...", Color3.fromRGB(255, 200, 100))
            task.wait(10)
            local fresh = LoadServers()
            if #fresh > 0 then SERVER_LIST = fresh end
            BLACKLIST = {}
        else
            local target = available[math.random(1, #available)]
            UpdateStatus("Connecting: " .. target:sub(1, 8) .. "...", Color3.fromRGB(200, 200, 255))

            local success = pcall(function()
                TeleportService:TeleportToPlaceInstance(TELEPORT_SETTINGS.GAME_ID, target, Players.LocalPlayer)
            end)

            if not success then
                BLACKLIST[target] = os.time()
                UpdateStatus("Failed, retrying...", Color3.fromRGB(255, 150, 150))
                task.wait(TELEPORT_SETTINGS.ERROR_RETRY_DELAY)
            else
                task.wait(TELEPORT_SETTINGS.SUCCESS_DELAY)
            end
        end
    end
end

-- ══════════════════════════════════════════════════════════════
--  MAIN
-- ══════════════════════════════════════════════════════════════

task.spawn(function()
    while not serversReady do
        SERVER_LIST = LoadServers()
        if #SERVER_LIST > 0 then
            serversReady = true
        else
            task.wait(10)
        end
    end
end)

UpdateStatus("Scanning...", Color3.fromRGB(150, 200, 255))
pcall(scanAndNotify)
UpdateStatus("Scan complete!", Color3.fromRGB(100, 255, 100))

if not serversReady then
    UpdateStatus("Waiting for servers...", Color3.fromRGB(255, 200, 100))
    while not serversReady do task.wait(0.1) end
end

UpdateStatus("Servers: " .. #SERVER_LIST .. " | Starting teleport...", Color3.fromRGB(150, 255, 150))

TeleportLoop()
