--!strict
-- RemoteHandler.luau
-- Binds all client -> server RemoteEvents to the appropriate service functions.
-- Mining and Selling fire via ProximityPrompt.Triggered and are NOT wired here.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)
local RE            = require(Shared.RemoteEvents)

local RemoteHandler = {}

local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

function RemoteHandler.init(
    _DataService   : any,
    _MiningService : any,
    _SellingService: any,
    UpgradeService : any,
    ContractService: any,
    _MarketService : any
)
    getRemote(RE.UPGRADE_PICKAXE).OnServerEvent:Connect(function(player: Player, tier: any)
        if type(tier) ~= "string" then return end
        UpgradeService.handlePickaxeUpgrade(player, tier)
    end)

    getRemote(RE.UPGRADE_CAPACITY).OnServerEvent:Connect(function(player: Player)
        UpgradeService.handleCapacityUpgrade(player)
    end)

    getRemote(RE.CONTRACT_REFRESH).OnServerEvent:Connect(function(player: Player)
        ContractService.refreshContracts(player)
    end)

    print("[RemoteHandler] All remote events bound.")
end

return RemoteHandler
