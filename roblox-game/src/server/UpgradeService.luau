--!strict
-- UpgradeService.luau
-- Validates and applies pickaxe and inventory capacity upgrades.
-- All validation is server-side; clients only fire a request remote.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)
local RE            = require(Shared.RemoteEvents)
local PickaxeConfig = require(Shared.Config.PickaxeConfig)
local UpgradeConfig = require(Shared.Config.UpgradeConfig)

local UpgradeService = {}

local DataService: any

local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

local function reject(player: Player, msg: string)
    getRemote(RE.UPGRADE_RESULT):FireClient(player, { success = false, message = msg })
end

function UpgradeService.handlePickaxeUpgrade(player: Player, requestedTier: string)
    local tierData = PickaxeConfig.Tiers[requestedTier]
    if not tierData then reject(player, "Invalid tier.") return end

    local data: any = DataService.getPlayerData(player)
    if not data then return end

    local currentTier = PickaxeConfig.Tiers[data.pickaxeTier]
    if tierData.tier ~= currentTier.tier + 1 then
        reject(player, "Must upgrade in order.") return
    end
    if data.money < tierData.cost then
        reject(player, "Not enough money.") return
    end

    DataService.updatePlayerData(player, function(d: any)
        d.money       -= tierData.cost
        d.pickaxeTier  = requestedTier
    end)

    getRemote(RE.UPGRADE_RESULT):FireClient(player, {
        success = true,
        type    = "pickaxe",
        newTier = requestedTier,
        message = "Upgraded to " .. tierData.displayName .. "!",
    })
end

function UpgradeService.handleCapacityUpgrade(player: Player)
    local data: any = DataService.getPlayerData(player)
    if not data then return end

    local newTier  = data.capacityTier + 1
    local tierData = UpgradeConfig.Tiers[newTier]

    if not tierData then reject(player, "Already at max capacity.") return end
    if data.money < tierData.cost then reject(player, "Not enough money.") return end

    DataService.updatePlayerData(player, function(d: any)
        d.money        -= tierData.cost
        d.capacityTier  = newTier
    end)

    getRemote(RE.UPGRADE_RESULT):FireClient(player, {
        success = true,
        type    = "capacity",
        newTier = newTier,
        message = string.format("Bag upgraded to %d slots!", tierData.capacity),
    })
end

function UpgradeService.init()
    DataService = require(script.Parent.DataService)
    print("[UpgradeService] Initialised.")
end

return UpgradeService
