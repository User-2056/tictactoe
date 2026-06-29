--!strict
-- MarketUI.luau
-- Compact corner panel showing today's ore prices.
-- Updates when Market_PricesUpdated fires.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared    = ReplicatedStorage:WaitForChild("Shared")
local RE        = require(Shared.RemoteEvents)
local OreConfig = require(Shared.Config.OreConfig)

local MarketUI = {}

local ORDER  = { "stone", "coal", "iron", "gold" }
local labels: { [string]: TextLabel } = {}

local function build()
    local gui = Instance.new("ScreenGui")
    gui.Name         = "MarketUI"
    gui.ResetOnSpawn = false
    gui.Parent       = Players.LocalPlayer:WaitForChild("PlayerGui")

    local fr = Instance.new("Frame")
    fr.Size     = UDim2.new(0, 190, 0, 122)
    fr.Position = UDim2.new(1, -200, 0, 10)
    fr.BackgroundColor3       = Color3.fromRGB(15, 15, 15)
    fr.BackgroundTransparency = 0.4
    fr.Parent = gui
    Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel")
    title.Size               = UDim2.new(1, 0, 0, 22)
    title.BackgroundTransparency = 1
    title.TextColor3         = Color3.fromRGB(255, 215, 0)
    title.Font               = Enum.Font.GothamBold
    title.TextSize           = 13
    title.Text               = "Today's Prices"
    title.Parent             = fr

    for i, key in ipairs(ORDER) do
        local lbl = Instance.new("TextLabel")
        lbl.Size           = UDim2.new(1, -8, 0, 22)
        lbl.Position       = UDim2.new(0, 4, 0, 22 + (i - 1) * 23)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3     = Color3.fromRGB(200, 200, 200)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font           = Enum.Font.Gotham
        lbl.TextSize       = 12
        lbl.Text           = (OreConfig.Ores[key] :: any).displayName .. ": " ..
                             tostring((OreConfig.Ores[key] :: any).basePrice)
        lbl.Parent         = fr
        labels[key]        = lbl
    end
end

function MarketUI.init(RemoteProxy: any)
    build()

    RemoteProxy.connect(RE.MARKET_PRICES_UPDATED, function(p: any)
        for key, lbl in pairs(labels) do
            lbl.Text = (OreConfig.Ores[key] :: any).displayName ..
                       ": " .. tostring(p[key] or (OreConfig.Ores[key] :: any).basePrice)
        end
    end)
end

return MarketUI
