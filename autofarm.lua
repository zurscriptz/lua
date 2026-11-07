getgenv().Config = {
    AutoFarm = true,
    AutoPlace = true,
    AutoUpgrade = true,
    AutoSell = true,
    AutoStart = true,
    AutoReplay = true,

    -- NEW FEATURES
    AutoSummon = true,
    SummonBanner = "Banner 1", -- Change to banner you want
    SummonAmount = 10, -- 1 or 10
    KeepSummoning = true,

    AutoEvolve = true,
    EvolveList = {"Cream", "Elf Mage", "Carrot"}, -- Units to auto evolve

    SmartPlacement = true, -- Auto finds best spot
    Map = "Planet Green",
    Mode = "Infinite",
    Units = {"Cream", "Elf Mage", "Carrot"},
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Workspace = game:GetService("Workspace")

-- Anti AFK
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ========== SMART PLACEMENT ==========
local function GetBestSpot()
    if not getgenv().Config.SmartPlacement then
        return Vector3.new(0, 0, 0)
    end
    -- Finds path and places near start / curve for max range
    local map = Workspace:FindFirstChild("Map")
    if map then
        local path = map:FindFirstChild("Path") or map:FindFirstChild("Waypoints")
        if path and #path:GetChildren() > 0 then
            local firstPoint = path:GetChildren()[1]
            -- Offset to side of path so tower can hit
            return firstPoint.Position + Vector3.new(4, 0, 4)
        end
        -- Fallback: Center of map
        local baseplate = map:FindFirstChild("Baseplate")
        if baseplate then return baseplate.Position + Vector3.new(0, 2, 0) end
    end
    return Vector3.new(0, 5, 0)
end

local function GetSmartSpots(count)
    local spots = {}
    local base = GetBestSpot()
    -- Spread units in triangle / hill formation
    local offsets = {
        Vector3.new(0, 0, 0),
        Vector3.new(4, 0, 0),
        Vector3.new(-4, 0, 0),
        Vector3.new(0, 0, 4),
        Vector3.new(0, 0, -4),
        Vector3.new(8, 0, 4),
    }
    for i = 1, count do
        spots[i] = base + (offsets[i] or Vector3.new(i*3, 0, 0))
    end
    return spots
end

-- ========== AUTO PLACE (SMART) ==========
task.spawn(function()
    while getgenv().Config.AutoFarm do
        task.wait(1)
        local spots = GetSmartSpots(#getgenv().Config.Units)
        for i, unit in ipairs(getgenv().Config.Units) do
            pcall(function()
                Remotes.PlaceTower:InvokeServer(unit, spots[i])
            end)
        end
        task.wait(2)
    end
end)

-- ========== AUTO UPGRADE ==========
task.spawn(function()
    while getgenv().Config.AutoFarm do
        task.wait(2)
        for _, tower in pairs(Workspace:FindFirstChild("Towers"):GetChildren()) do
            pcall(function()
                Remotes.UpgradeTower:InvokeServer(tower)
            end)
        end
    end
end)

-- ========== AUTO START / REPLAY ==========
task.spawn(function()
    while getgenv().Config.AutoFarm do
        task.wait(3)
        pcall(function()
            Remotes.StartGame:FireServer()
            Remotes.Replay:FireServer()
            Remotes.VoteStart:FireServer()
        end)
    end
end)

-- ========== AUTO SUMMON ==========
task.spawn(function()
    while getgenv().Config.AutoSummon do
        task.wait(5)
        pcall(function()
            -- Check gems first
            local gems = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Gems")
            if gems and gems.Value >= 100 then
                if getgenv().Config.SummonAmount == 10 then
                    Remotes.Summon10:InvokeServer(getgenv().Config.SummonBanner)
                else
                    Remotes.Summon:InvokeServer(getgenv().Config.SummonBanner)
                end
                print("Summoned! Gems left: "..gems.Value)
            end
        end)
        if not getgenv().Config.KeepSummoning then break end
    end
end)

-- ========== AUTO EVOLVE ==========
task.spawn(function()
    while getgenv().Config.AutoEvolve do
        task.wait(10)
        for _, unitName in ipairs(getgenv().Config.EvolveList) do
            pcall(function()
                -- Tries evolve, if missing mats it will just fail and retry later
                Remotes.EvolveUnit:InvokeServer(unitName)
                print("Tried to evolve: "..unitName)
            end)
        end
    end
end)

-- ========== AUTO CLAIM ==========
task.spawn(function()
    while getgenv().Config.AutoFarm do
        task.wait(5)
        pcall(function()
            Remotes.ClaimRewards:FireServer()
            Remotes.ClaimQuest:FireServer()
            Remotes.ClaimBattlePass:FireServer()
        end)
    end
end)

print("Anime Adventures Auto Farm V3.0 - LOADED ✅ | Summon + Evolve + Smart Placement ON")
