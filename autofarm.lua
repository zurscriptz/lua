local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

getgenv().Config = {
    AutoFarm = false,
    AutoSummon = false,
    AutoEvolve = false,
    AutoUpgrade = true,
    AutoStart = true,
    FarmSpeed = 50,
    TargetDistance = 50,
    SelectedMap = "Planet Green",
    SelectedMode = "Infinite",
}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EvenesceFarm"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 620, 0, 380)
Main.Position = UDim2.new(0.5, -310, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
TopBar.Parent = Main

local Logo = Instance.new("TextLabel")
Logo.Text = "  ⚡ Evenesce"
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 16
Logo.TextColor3 = Color3.fromRGB(140, 130, 255)
Logo.BackgroundTransparency = 1
Logo.Size = UDim2.new(0, 150, 1, 0)
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TopBar

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(0, 160, 0, 24)
Search.Position = UDim2.new(0, 12, 0, 48)
Search.PlaceholderText = "🔍 Search"
Search.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Search.TextColor3 = Color3.fromRGB(255,255,255)
Search.Parent = Main
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 6)

-- Sidebar (Left)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -80)
Sidebar.Position = UDim2.new(0, 0, 0, 80)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Sidebar.Parent = Main

local function MakeSideButton(name, icon, y, active)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = "  "..icon.."  "..name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = active and Color3.fromRGB(28, 28, 40) or Color3.fromRGB(16, 16, 22)
    btn.TextColor3 = active and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,170)
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    if active then
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, 3, 1, 0)
        bar.BackgroundColor3 = Color3.fromRGB(140,130,255)
        bar.Parent = btn
    end
    return btn
end

MakeSideButton("Farm", "◉", 0, true)
MakeSideButton("Summon", "✦", 38, false)
MakeSideButton("Evolve", "⬆", 76, false)
MakeSideButton("Player", "👤", 114, false)
MakeSideButton("Misc", "⚙", 152, false)

-- Tabs Top (Legit / Combat style)
local TabFarm = Instance.new("TextButton")
TabFarm.Text = "Farm"
TabFarm.Size = UDim2.new(0, 80, 0, 26)
TabFarm.Position = UDim2.new(0, 145, 0, 48)
TabFarm.BackgroundTransparency = 1
TabFarm.Font = Enum.Font.GothamBold
TabFarm.TextSize = 14
TabFarm.TextColor3 = Color3.fromRGB(255,255,255)
TabFarm.Parent = Main

local TabSummon = Instance.new("TextButton")
TabSummon.Text = "Summon"
TabSummon.Size = UDim2.new(0, 80, 0, 26)
TabSummon.Position = UDim2.new(0, 225, 0, 48)
TabSummon.BackgroundTransparency = 1
TabSummon.Font = Enum.Font.GothamMedium
TabSummon.TextSize = 14
TabSummon.TextColor3 = Color3.fromRGB(120,120,140)
TabSummon.Parent = Main

-- Helper to make Section
local function MakeSection(title, posX, posY, sizeX, sizeY)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, sizeX, 0, sizeY)
    f.Position = UDim2.new(0, posX, 0, posY)
    f.BackgroundColor3 = Color3.fromRGB(19, 19, 26)
    f.Parent = Main
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local t = Instance.new("TextLabel")
    t.Text = title
    t.Font = Enum.Font.GothamBold
    t.TextSize = 13
    t.TextColor3 = Color3.fromRGB(200,200,220)
    t.BackgroundTransparency = 1
    t.Position = UDim2.new(0, 10, 0, 6)
    t.Size = UDim2.new(1, -10, 0, 20)
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = f
    return f
end

local function MakeToggle(parent, text, y, default, callback)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(180,180,200)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, y)
    label.Size = UDim2.new(0, 150, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 32, 0, 18)
    toggle.Position = UDim2.new(1, -42, 0, y+1)
    toggle.Text = ""
    toggle.BackgroundColor3 = default and Color3.fromRGB(140,130,255) or Color3.fromRGB(60,60,75)
    toggle.Parent = parent
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 9)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = default and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 7)

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(140,130,255) or Color3.fromRGB(60,60,75)
        knob.Position = state and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 2, 0, 2)
        callback(state)
    end)
    return toggle
end

local function MakeSlider(parent, text, y, valueText, percent)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(180,180,200)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, y)
    label.Size = UDim2.new(0, 120, 0, 18)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local val = Instance.new("TextLabel")
    val.Text = valueText
    val.Font = Enum.Font.GothamMedium
    val.TextSize = 12
    val.TextColor3 = Color3.fromRGB(255,255,255)
    val.BackgroundTransparency = 1
    val.Position = UDim2.new(1, -70, 0, y)
    val.Size = UDim2.new(0, 60, 0, 18)
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.Parent = parent

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, 4)
    bg.Position = UDim2.new(0, 10, 0, y+22)
    bg.BackgroundColor3 = Color3.fromRGB(45,45,60)
    bg.Parent = parent
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(140,130,255)
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 2)
end

-- SECTION 1: Auto Farm (Left - like Aimbot in your pic)
local FarmSection = MakeSection("Auto Farm", 145, 85, 220, 160)
MakeToggle(FarmSection, "Enable auto farm", 30, false, function(v) getgenv().Config.AutoFarm = v end)
MakeSlider(FarmSection, "Farm speed", 60, "50%", 0.5)
MakeSlider(FarmSection, "Place delay", 95, "120ms", 0.4)

-- Dropdown style for Map
local MapLabel = Instance.new("TextLabel")
MapLabel.Text = "Map"
MapLabel.Font = Enum.Font.GothamMedium
MapLabel.TextSize = 12
MapLabel.TextColor3 = Color3.fromRGB(180,180,200)
MapLabel.BackgroundTransparency = 1
MapLabel.Position = UDim2.new(0, 10, 0, 128)
MapLabel.Size = UDim2.new(0, 100, 0, 18)
MapLabel.TextXAlignment = Enum.TextXAlignment.Left
MapLabel.Parent = FarmSection

local MapBtn = Instance.new("TextButton")
MapBtn.Text = "Planet Green  ▼"
MapBtn.Font = Enum.Font.GothamMedium
MapBtn.TextSize = 12
MapBtn.TextColor3 = Color3.fromRGB(255,255,255)
MapBtn.BackgroundColor3 = Color3.fromRGB(28,28,38)
MapBtn.Size = UDim2.new(1, -20, 0, 22)
MapBtn.Position = UDim2.new(0, 10, 0, 148)
MapBtn.Parent = FarmSection
-- wait, FarmSection height is 160, adjust
FarmSection.Size = UDim2.new(0, 220, 0, 185)

-- SECTION 2: Auto Summon (Right - like Triggerbot in your pic)
local SummonSection = MakeSection("Auto Summon", 380, 85, 220, 160)
MakeToggle(SummonSection, "Enable auto summon", 30, false, function(v) getgenv().Config.AutoSummon = v end)
MakeSlider(SummonSection, "Delay", 60, "120ms", 0.4)
-- Banner input like Whitelist in your pic
local BannerBox = Instance.new("TextBox")
BannerBox.PlaceholderText = "Banner Name"
BannerBox.Size = UDim2.new(1, -20, 0, 24)
BannerBox.Position = UDim2.new(0, 10, 0, 95)
BannerBox.BackgroundColor3 = Color3.fromRGB(28,28,38)
BannerBox.TextColor3 = Color3.fromRGB(255,255,255)
BannerBox.Parent = SummonSection
Instance.new("UICorner", BannerBox).CornerRadius = UDim.new(0, 6)

local AddBtn = Instance.new("TextButton")
AddBtn.Text = "Start Summoning"
AddBtn.Size = UDim2.new(1, -20, 0, 24)
AddBtn.Position = UDim2.new(0, 10, 0, 125)
AddBtn.BackgroundColor3 = Color3.fromRGB(28,28,38)
AddBtn.TextColor3 = Color3.fromRGB(255,255,255)
AddBtn.Font = Enum.Font.GothamMedium
AddBtn.TextSize = 12
AddBtn.Parent = SummonSection
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 6)

-- SECTION 3: Auto Evolve (Bottom Left - like Hitbox)
local EvolveSection = MakeSection("Auto Evolve", 145, 285, 220, 85)
MakeToggle(EvolveSection, "Enable auto evolve", 30, false, function(v) getgenv().Config.AutoEvolve = v end)
MakeSlider(EvolveSection, "Check every", 55, "10s", 0.3)

-- SECTION 4: Assistance (Bottom Right - like Assistance in pic)
local AssistSection = MakeSection("Assistance", 380, 285, 220, 85)
MakeToggle(AssistSection, "Anti-AFK", 30, true, function(v) end)
MakeSlider(AssistSection, "Auto Upgrade", 55, "100%", 1)

-- Draggable
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Evenesce Farm UI Loaded ✅")
