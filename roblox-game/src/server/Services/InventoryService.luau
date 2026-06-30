-- InventoryService: Per-player ore inventory with weight-based capacity.
-- All mutations happen server-side. Clients receive read-only snapshots
-- via Inv_Update after every change. The server never trusts client claims
-- about inventory state.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OreConfig  = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("OreConfig"))
local Remotes    = ReplicatedStorage:WaitForChild("Remotes")
local Inv_Update = Remotes:WaitForChild("Inv_Update")
local Inv_Full   = Remotes:WaitForChild("Inv_Full")

local STARTER_CAPACITY = 100  -- default until EquipmentService upgrades the backpack

-- keyed by Player →  { items = { [oreType] = qty }, currentWeight, maxWeight }
local inventories = {}

local InventoryService = {}

-- ── Internal ───────────────────────────────────────────────────────────────

local function pushUpdate(player)
	local inv = inventories[player]
	if not inv then return end
	local itemsCopy = {}
	for k, v in pairs(inv.items) do itemsCopy[k] = v end
	Inv_Update:FireClient(player, itemsCopy, inv.currentWeight, inv.maxWeight)
end

local function initPlayer(player)
	inventories[player] = {
		items         = {},
		currentWeight = 0,
		maxWeight     = STARTER_CAPACITY,
	}
	pushUpdate(player)
end

local function removePlayer(player)
	inventories[player] = nil
end

-- ── Public API ─────────────────────────────────────────────────────────────

-- Attempts to add `amount` units of `oreType` to `player`'s inventory.
-- Returns true if successful, false if there was not enough capacity.
-- When full, fires Inv_Full to the player instead of adding ore.
function InventoryService.addOre(player, oreType, amount)
	local inv = inventories[player]
	if not inv then return false end

	local oreData = OreConfig[oreType]
	if not oreData then return false end

	local addedWeight = oreData.Weight * amount

	if inv.currentWeight + addedWeight > inv.maxWeight then
		Inv_Full:FireClient(player)
		return false
	end

	inv.items[oreType]  = (inv.items[oreType] or 0) + amount
	inv.currentWeight   = inv.currentWeight + addedWeight
	pushUpdate(player)
	return true
end

function InventoryService.getInventory(player)
	return inventories[player]
end

-- Empties the player's inventory and pushes an Inv_Update to the client.
-- Called by EconomyService after a successful sell-all transaction.
function InventoryService.clearInventory(player)
	local inv = inventories[player]
	if not inv then return end
	inv.items         = {}
	inv.currentWeight = 0
	pushUpdate(player)
end

-- Updates the player's bag capacity; called by EquipmentService on backpack upgrade.
function InventoryService.setMaxWeight(player, capacity)
	local inv = inventories[player]
	if not inv then return end
	inv.maxWeight = capacity
	pushUpdate(player)
end

-- Removes a specific quantity of one ore type.
-- Quantity is clamped to what the player actually has.
-- Returns the amount actually removed (may be less than requested).
function InventoryService.removeOre(player, oreType, quantity)
	local inv = inventories[player]
	if not inv then return 0 end
	local oreData = OreConfig[oreType]
	if not oreData then return 0 end

	local available = inv.items[oreType] or 0
	local removing  = math.min(math.floor(quantity), available)
	if removing <= 0 then return 0 end

	inv.items[oreType]  = available - removing
	if inv.items[oreType] <= 0 then inv.items[oreType] = nil end
	inv.currentWeight   = math.max(0, inv.currentWeight - oreData.Weight * removing)
	pushUpdate(player)
	return removing
end

-- ── Player lifecycle ───────────────────────────────────────────────────────

Players.PlayerAdded:Connect(initPlayer)
Players.PlayerRemoving:Connect(removePlayer)

for _, player in ipairs(Players:GetPlayers()) do
	initPlayer(player)
end

print("[InventoryService] Loaded")
return InventoryService
