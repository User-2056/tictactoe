--!strict
-- init.client.luau
-- Client bootstrap. Waits for the server RemoteEvents folder,
-- then initialises all client modules in dependency order.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)

local remoteFolder = Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME, 15)
if not remoteFolder then
    warn("[Client] RemoteEvents folder not found. Is the server running?")
    return
end

local RemoteProxy   = require(script.RemoteProxy)
local HUDController = require(script.HUDController)
local MiningClient  = require(script.MiningClient)
local InventoryUI   = require(script.InventoryUI)
local MarketUI      = require(script.MarketUI)
local ShopUI        = require(script.ShopUI)
local ContractUI    = require(script.ContractUI)

RemoteProxy.init(remoteFolder)
HUDController.init(RemoteProxy)
MiningClient.init(RemoteProxy)
InventoryUI.init(RemoteProxy)
MarketUI.init(RemoteProxy)
ShopUI.init(RemoteProxy)
ContractUI.init(RemoteProxy)

print("[Client] Mining Corporation client initialised.")
