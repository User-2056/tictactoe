--!strict
-- HUDController.luau
-- Persistent corner overlay: money, pickaxe tier, bag used/max.
-- Reacts to Data_Update. Replace the Frame with a Studio ScreenGui later.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local RE            = require(Shared.RemoteEvents)
local UpgradeConfig = require(Shared.Config.UpgradeConfig)

local HUDController = {}

local function formatMoney(n: number): string
    local s = tostring(math.floor(n)):reverse()
    return "coins: " .. (s:gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local function build()
    local gui = Instance.new("ScreenGui")
    gui.Name         = "HUD"
    gui.ResetOnSpawn = false
    gui.Parent       = Players.LocalPlayer:WaitForChild("PlayerGui")

    local fr = Instance.new("Frame")
    fr.Size     = UDim2.new(0, 240, 0, 80)
    fr.Position = UDim2.new(0, 10, 0, 10)
    fr.BackgroundColor3          = Color3.fromRGB(15, 15, 15)
    fr.BackgroundTransparency    = 0.35
    fr.Parent = gui
    Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 8)

    local function lbl(text: string, y: number): TextLabel
        local l = Instance.new("TextLabel")
        l.Size             = UDim2.new(1, -10, 0, 22)
        l.Position         = UDim2.new(0, 5, 0, y)
        l.BackgroundTransparency = 1
        l.TextColor3       = Color3.new(1, 1, 1)
        l.TextXAlignment   = Enum.TextXAlignment.Left
        l.Font             = Enum.Font.GothamBold
        l.TextSize         = 14
        l.Text             = text
        l.Parent           = fr
        return l
    end

    return {
        money    = lbl("coins: 0",        6),
        pickaxe  = lbl("Pickaxe: Starter", 28),
        capacity = lbl("Bag: 0 / 50",     50),
    }
end

function HUDController.init(RemoteProxy: any)
    local labels = build()

    RemoteProxy.connect(RE.DATA_UPDATE, function(data: any)
        labels.money.Text   = formatMoney(data.money or 0)
        labels.pickaxe.Text = "Pickaxe: " .. (data.pickaxeTier or "Starter")

        local total = 0
        for _, q in pairs(data.inventory or {}) do total += q end
        local cap = UpgradeConfig.Tiers[data.capacityTier or 1].capacity
        labels.capacity.Text = string.format("Bag: %d / %d", total, cap)
    end)
end

return HUDController
