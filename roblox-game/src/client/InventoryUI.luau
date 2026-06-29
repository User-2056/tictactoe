--!strict
-- InventoryUI.luau
-- Toggle with I key. Shows ore quantities and current market value.

local Players           = game:GetService("Players")
local UIS               = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared    = ReplicatedStorage:WaitForChild("Shared")
local RE        = require(Shared.RemoteEvents)
local OreConfig = require(Shared.Config.OreConfig)

local InventoryUI = {}

local ORDER = { "stone", "coal", "iron", "gold" }
local inv:    { [string]: number } = {}
local prices: { [string]: number } = {}
local rows:   { [string]: TextLabel } = {}
local totalLbl: TextLabel

local function build(): ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name         = "InventoryUI"
    gui.ResetOnSpawn = false
    gui.Enabled      = false
    gui.Parent       = Players.LocalPlayer:WaitForChild("PlayerGui")

    local fr = Instance.new("Frame")
    fr.Size     = UDim2.new(0, 270, 0, 200)
    fr.Position = UDim2.new(0.5, -135, 0.5, -100)
    fr.BackgroundColor3       = Color3.fromRGB(12, 12, 12)
    fr.BackgroundTransparency = 0.15
    fr.Parent = gui
    Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size               = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.TextColor3         = Color3.new(1, 1, 1)
    title.Font               = Enum.Font.GothamBold
    title.TextSize           = 15
    title.Text               = "Inventory  [I to close]"
    title.Parent             = fr

    local y = 30
    for _, key in ipairs(ORDER) do
        local lbl = Instance.new("TextLabel")
        lbl.Size             = UDim2.new(1, -10, 0, 26)
        lbl.Position         = UDim2.new(0, 5, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3       = Color3.fromRGB(220, 220, 220)
        lbl.TextXAlignment   = Enum.TextXAlignment.Left
        lbl.Font             = Enum.Font.Gotham
        lbl.TextSize         = 13
        lbl.Text             = (OreConfig.Ores[key] :: any).displayName .. ": 0"
        lbl.Parent           = fr
        rows[key]            = lbl
        y += 28
    end

    totalLbl = Instance.new("TextLabel")
    totalLbl.Size            = UDim2.new(1, -10, 0, 26)
    totalLbl.Position        = UDim2.new(0, 5, 0, y + 4)
    totalLbl.BackgroundTransparency = 1
    totalLbl.TextColor3      = Color3.fromRGB(80, 255, 100)
    totalLbl.TextXAlignment  = Enum.TextXAlignment.Left
    totalLbl.Font            = Enum.Font.GothamBold
    totalLbl.TextSize        = 14
    totalLbl.Text            = "Total: 0 coins"
    totalLbl.Parent          = fr

    return gui
end

local function refresh()
    local total = 0
    for _, key in ipairs(ORDER) do
        local qty   = inv[key] or 0
        local price = prices[key] or (OreConfig.Ores[key] :: any).basePrice
        local val   = qty * price
        total      += val
        if rows[key] then
            rows[key].Text = string.format("%s: %d  (%d coins)",
                (OreConfig.Ores[key] :: any).displayName, qty, val)
        end
    end
    if totalLbl then totalLbl.Text = "Total: " .. tostring(total) .. " coins" end
end

function InventoryUI.init(RemoteProxy: any)
    local gui = build()

    UIS.InputBegan:Connect(function(input: InputObject, processed: boolean)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.I then
            gui.Enabled = not gui.Enabled
        end
    end)

    RemoteProxy.connect(RE.DATA_UPDATE, function(data: any)
        if data.inventory then inv = data.inventory; refresh() end
    end)

    RemoteProxy.connect(RE.MARKET_PRICES_UPDATED, function(p: any)
        prices = p; refresh()
    end)
end

return InventoryUI
