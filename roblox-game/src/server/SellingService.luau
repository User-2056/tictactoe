--!strict
-- SellingService.luau
-- Finds sell zone Parts in Workspace (attribute IsSellZone = true).
-- Attaches a ProximityPrompt and converts inventory to money at market prices.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)
local RE            = require(Shared.RemoteEvents)

local SellingService = {}

local DataService:   any
local MarketService: any

local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

local function handleSell(player: Player)
    local data: any = DataService.getPlayerData(player)
    if not data then return end

    local prices = MarketService.getCurrentPrices()
    local total  = 0
    local breakdown: { [string]: number } = {}

    for oreKey, qty in pairs(data.inventory) do
        if qty > 0 and prices[oreKey] then
            local earned      = qty * prices[oreKey]
            breakdown[oreKey] = earned
            total            += earned
        end
    end

    if total == 0 then
        getRemote(RE.SELL_RESULT):FireClient(player, {
            success = false, moneyEarned = 0, message = "Nothing to sell.",
        })
        return
    end

    DataService.updatePlayerData(player, function(d: any)
        d.money += total
        for k in pairs(d.inventory) do d.inventory[k] = 0 end
    end)

    getRemote(RE.SELL_RESULT):FireClient(player, {
        success     = true,
        moneyEarned = total,
        breakdown   = breakdown,
        message     = string.format("Sold for %d coins!", total),
    })
end

function SellingService.init()
    DataService   = require(script.Parent.DataService)
    MarketService = require(script.Parent.MarketService)

    local function attachToZone(part: BasePart)
        local p = Instance.new("ProximityPrompt")
        p.ActionText            = "Sell All"
        p.ObjectText            = "Sell Zone"
        p.MaxActivationDistance = 10
        p.HoldDuration          = 0
        p.Parent                = part
        p.Triggered:Connect(function(player: Player) handleSell(player) end)
    end

    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") and d:GetAttribute(GameConstants.SELL_ZONE_ATTRIBUTE) then
            attachToZone(d :: BasePart)
        end
    end

    workspace.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") and d:GetAttribute(GameConstants.SELL_ZONE_ATTRIBUTE) then
            attachToZone(d :: BasePart)
        end
    end)

    print("[SellingService] Initialised.")
end

return SellingService
