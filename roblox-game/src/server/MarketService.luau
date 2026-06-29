--!strict
-- MarketService.luau
-- Deterministic daily prices seeded by UTC day number.
-- Recalculates automatically at midnight. Broadcasts to all clients on change.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Shared       = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)
local RE            = require(Shared.RemoteEvents)
local OreConfig     = require(Shared.Config.OreConfig)
local MarketConfig  = require(Shared.Config.MarketConfig)

local MarketService = {}

local prices:  { [string]: number } = {}
local lastDay = -1

local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

local function recalculate()
    local day = math.floor(os.time() / 86400)
    local rng = Random.new(day)
    for key, data in pairs(OreConfig.Ores) do
        local mult = rng:NextNumber(MarketConfig.minMultiplier, MarketConfig.maxMultiplier)
        prices[key] = math.max(1, math.round(data.basePrice * mult))
    end
    lastDay = day
    print("[MarketService] Prices recalculated for day", day)
end

function MarketService.init()
    recalculate()

    task.spawn(function()
        while true do
            task.wait(60)
            local day = math.floor(os.time() / 86400)
            if day ~= lastDay then
                recalculate()
                MarketService.broadcastPrices()
            end
        end
    end)

    print("[MarketService] Initialised.")
end

function MarketService.getCurrentPrices(): { [string]: number }
    return prices
end

function MarketService.broadcastPrices()
    getRemote(RE.MARKET_PRICES_UPDATED):FireAllClients(prices)
end

function MarketService.sendPricesToPlayer(player: Player)
    getRemote(RE.MARKET_PRICES_UPDATED):FireClient(player, prices)
end

return MarketService
