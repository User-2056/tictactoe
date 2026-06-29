--!strict
-- init.server.luau
-- Server bootstrap. Runs once on server start.
-- 1. Creates all RemoteEvent instances in ReplicatedStorage.Shared.
-- 2. Initialises services in dependency order.
-- 3. Wires the MiningService -> ContractService ore callback.
-- 4. Handles player lifecycle (load on join, save on leave).

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)
local RE            = require(Shared.RemoteEvents)

-- Build RemoteEvents folder ------------------------------------------------
local remoteFolder      = Instance.new("Folder")
remoteFolder.Name       = GameConstants.REMOTE_FOLDER_NAME
remoteFolder.Parent     = Shared

for _, name in pairs(RE) do
    if type(name) == "string" then
        local evt = Instance.new("RemoteEvent")
        evt.Name  = name
        evt.Parent = remoteFolder
    end
end

-- Services -----------------------------------------------------------------
local DataService     = require(script.DataService)
local MarketService   = require(script.MarketService)
local MiningService   = require(script.MiningService)
local SellingService  = require(script.SellingService)
local UpgradeService  = require(script.UpgradeService)
local ContractService = require(script.ContractService)
local RemoteHandler   = require(script.RemoteHandler)

DataService.init()
MarketService.init()

MiningService.init({
    onOreAwarded = function(player: Player, oreType: string, amount: number)
        ContractService.onOreAwarded(player, oreType, amount)
    end,
})

SellingService.init()
UpgradeService.init()
ContractService.init()
RemoteHandler.init(DataService, MiningService, SellingService, UpgradeService, ContractService, MarketService)

-- Player lifecycle ---------------------------------------------------------
Players.PlayerAdded:Connect(function(player: Player)
    DataService.loadPlayer(player)
    task.wait(2)
    ContractService.ensureContracts(player)
    MarketService.sendPricesToPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player: Player)
    DataService.savePlayer(player)
end)

-- Handle players who joined before this script finished loading
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        DataService.loadPlayer(player)
        task.wait(2)
        ContractService.ensureContracts(player)
        MarketService.sendPricesToPlayer(player)
    end)
end

print("[Server] Mining Corporation initialised.")
