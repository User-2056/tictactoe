--!strict
-- ShopUI.luau
-- Opens when shop ProximityPrompt fires (client-side detection only).
-- Purchase requests sent to server via RemoteEvents for validation.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local RE            = require(Shared.RemoteEvents)
local GameConstants = require(Shared.GameConstants)
local PickaxeConfig = require(Shared.Config.PickaxeConfig)
local UpgradeConfig = require(Shared.Config.UpgradeConfig)

local ShopUI = {}

local gui:         ScreenGui
local currentData: any
local btns:        { [string]: TextButton } = {}

local function build(RemoteProxy: any): ScreenGui
    local g = Instance.new("ScreenGui")
    g.Name         = "ShopUI"
    g.ResetOnSpawn = false
    g.Enabled      = false
    g.Parent       = Players.LocalPlayer:WaitForChild("PlayerGui")

    local fr = Instance.new("Frame")
    fr.Size     = UDim2.new(0, 320, 0, 420)
    fr.Position = UDim2.new(0.5, -160, 0.5, -210)
    fr.BackgroundColor3       = Color3.fromRGB(12, 12, 12)
    fr.BackgroundTransparency = 0.12
    fr.Parent = g
    Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size               = UDim2.new(1, -40, 0, 34)
    title.BackgroundTransparency = 1
    title.TextColor3         = Color3.new(1, 1, 1)
    title.Font               = Enum.Font.GothamBold
    title.TextSize           = 18
    title.Text               = "Upgrade Shop"
    title.Parent             = fr

    local close = Instance.new("TextButton")
    close.Size     = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -34, 0, 2)
    close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    close.TextColor3       = Color3.new(1, 1, 1)
    close.Font             = Enum.Font.GothamBold
    close.TextSize         = 14
    close.Text             = "X"
    close.Parent           = fr
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
    close.Activated:Connect(function() g.Enabled = false end)

    local y = 38

    -- Pickaxe section
    local ph = Instance.new("TextLabel")
    ph.Size     = UDim2.new(1, -10, 0, 22)
    ph.Position = UDim2.new(0, 5, 0, y)
    ph.BackgroundTransparency = 1
    ph.TextColor3     = Color3.fromRGB(255, 200, 50)
    ph.TextXAlignment = Enum.TextXAlignment.Left
    ph.Font           = Enum.Font.GothamBold
    ph.TextSize       = 13
    ph.Text           = "Pickaxes"
    ph.Parent         = fr
    y += 24

    for _, key in ipairs(PickaxeConfig.Order) do
        if key == "Starter" then continue end
        local td: any = PickaxeConfig.Tiers[key]

        local row = Instance.new("Frame")
        row.Size     = UDim2.new(1, -10, 0, 42)
        row.Position = UDim2.new(0, 5, 0, y)
        row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        row.Parent   = fr
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local info = Instance.new("TextLabel")
        info.Size              = UDim2.new(0.68, 0, 1, 0)
        info.BackgroundTransparency = 1
        info.TextColor3        = Color3.fromRGB(220, 220, 220)
        info.TextXAlignment    = Enum.TextXAlignment.Left
        info.Font              = Enum.Font.Gotham
        info.TextSize          = 11
        info.Text              = string.format("  %s\n  Pwr %d  Spd %.1fx  %d coins",
            td.displayName, td.power, td.speed, td.cost)
        info.Parent            = row

        local btn = Instance.new("TextButton")
        btn.Size     = UDim2.new(0.3, -6, 0.65, 0)
        btn.Position = UDim2.new(0.7, 2, 0.175, 0)
        btn.BackgroundColor3 = Color3.fromRGB(50, 170, 50)
        btn.TextColor3       = Color3.new(1, 1, 1)
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 13
        btn.Text             = "Buy"
        btn.Parent           = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.Activated:Connect(function()
            RemoteProxy.fire(RE.UPGRADE_PICKAXE, key)
        end)

        btns["p_" .. key] = btn
        y += 48
    end

    -- Capacity section
    local ch = Instance.new("TextLabel")
    ch.Size     = UDim2.new(1, -10, 0, 22)
    ch.Position = UDim2.new(0, 5, 0, y)
    ch.BackgroundTransparency = 1
    ch.TextColor3     = Color3.fromRGB(80, 190, 255)
    ch.TextXAlignment = Enum.TextXAlignment.Left
    ch.Font           = Enum.Font.GothamBold
    ch.TextSize       = 13
    ch.Text           = "Inventory Bags"
    ch.Parent         = fr
    y += 24

    for tier = 2, UpgradeConfig.MaxTier do
        local td: any = UpgradeConfig.Tiers[tier]

        local row = Instance.new("Frame")
        row.Size     = UDim2.new(1, -10, 0, 34)
        row.Position = UDim2.new(0, 5, 0, y)
        row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        row.Parent   = fr
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local info = Instance.new("TextLabel")
        info.Size              = UDim2.new(0.68, 0, 1, 0)
        info.BackgroundTransparency = 1
        info.TextColor3        = Color3.fromRGB(220, 220, 220)
        info.TextXAlignment    = Enum.TextXAlignment.Left
        info.Font              = Enum.Font.Gotham
        info.TextSize          = 12
        info.Text              = string.format("  %d slots -- %d coins", td.capacity, td.cost)
        info.Parent            = row

        local btn = Instance.new("TextButton")
        btn.Size     = UDim2.new(0.3, -6, 0.65, 0)
        btn.Position = UDim2.new(0.7, 2, 0.175, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 120, 210)
        btn.TextColor3       = Color3.new(1, 1, 1)
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 13
        btn.Text             = "Buy"
        btn.Parent           = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.Activated:Connect(function()
            RemoteProxy.fire(RE.UPGRADE_CAPACITY)
        end)

        btns["c_" .. tostring(tier)] = btn
        y += 40
    end

    return g
end

local function refreshButtons(data: any)
    if not data then return end
    local curTier = PickaxeConfig.Tiers[data.pickaxeTier].tier

    for _, key in ipairs(PickaxeConfig.Order) do
        local btn = btns["p_" .. key]
        if not btn then continue end
        local td: any = PickaxeConfig.Tiers[key]
        local owned  = td.tier <= curTier
        local isNext = td.tier == curTier + 1
        local afford = data.money >= td.cost

        btn.Text = if owned then "Owned" else "Buy"
        btn.BackgroundColor3 = if owned then Color3.fromRGB(70, 70, 70)
            elseif isNext and afford then Color3.fromRGB(50, 170, 50)
            else Color3.fromRGB(140, 40, 40)
        btn.Active = isNext and afford and not owned
    end

    for tier = 2, UpgradeConfig.MaxTier do
        local btn = btns["c_" .. tostring(tier)]
        if not btn then continue end
        local td: any = UpgradeConfig.Tiers[tier]
        local owned  = tier <= data.capacityTier
        local isNext = tier == data.capacityTier + 1
        local afford = data.money >= td.cost

        btn.Text = if owned then "Owned" else "Buy"
        btn.BackgroundColor3 = if owned then Color3.fromRGB(70, 70, 70)
            elseif isNext and afford then Color3.fromRGB(40, 120, 210)
            else Color3.fromRGB(140, 40, 40)
        btn.Active = isNext and afford and not owned
    end
end

function ShopUI.init(RemoteProxy: any)
    gui = build(RemoteProxy)

    local function hookPrompt(d: Instance)
        if not d:IsA("ProximityPrompt") then return end
        local parent = d.Parent
        if parent and parent:IsA("BasePart") and parent:GetAttribute(GameConstants.SHOP_ATTRIBUTE) then
            d.Triggered:Connect(function()
                gui.Enabled = true
                refreshButtons(currentData)
            end)
        end
    end

    for _, d in ipairs(workspace:GetDescendants()) do hookPrompt(d) end
    workspace.DescendantAdded:Connect(hookPrompt)

    RemoteProxy.connect(RE.DATA_UPDATE, function(data: any)
        currentData = data
        if gui.Enabled then refreshButtons(data) end
    end)

    RemoteProxy.connect(RE.UPGRADE_RESULT, function(result: any)
        if result.success then
            print("[ShopUI] Success:", result.message)
        else
            warn("[ShopUI] Rejected:", result.message)
        end
    end)
end

return ShopUI
