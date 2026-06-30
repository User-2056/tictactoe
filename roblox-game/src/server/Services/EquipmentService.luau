-- EquipmentService: Tracks owned and equipped items per player.
-- Ownership is permanent — buying adds to owned, never removes.
-- Equipped is which owned item is currently active.
-- Both PurchaseEquipment and EquipItem are validated server-side.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipmentConfig   = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("EquipmentConfig"))
local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local PurchaseEquipment = Remotes:WaitForChild("PurchaseEquipment")
local EquipItem         = Remotes:WaitForChild("EquipItem")
local Eq_Update         = Remotes:WaitForChild("Eq_Update")

-- Fast lookup tables by Id
local pickaxeById  = {}
for _, p in ipairs(EquipmentConfig.Pickaxes)  do pickaxeById[p.Id]  = p end
local backpackById = {}
for _, b in ipairs(EquipmentConfig.Backpacks) do backpackById[b.Id] = b end

-- keyed by Player
local owned    = {}  -- { Player → { pickaxes = {id→true}, backpacks = {id→true} } }
local equipped = {}  -- { Player → { pickaxeId, backpackId } }

local EquipmentService = {}

local function getEconomy()
	return require(script.Parent.EconomyService)
end
local function getInventory()
	return require(script.Parent.InventoryService)
end

local function pushUpdate(player)
	local eq  = equipped[player]
	local own = owned[player]
	if not eq or not own then return end

	local ownedPickaxeList  = {}
	local ownedBackpackList = {}
	for id in pairs(own.pickaxes)  do table.insert(ownedPickaxeList,  id) end
	for id in pairs(own.backpacks) do table.insert(ownedBackpackList, id) end

	Eq_Update:FireClient(player, eq.pickaxeId, eq.backpackId, ownedPickaxeList, ownedBackpackList)
end

-- ── Public API ─────────────────────────────────────────────────────────────

function EquipmentService.getMiningPower(player)
	local eq = equipped[player]
	local p  = eq and pickaxeById[eq.pickaxeId]
	return p and p.MiningPower or 1
end

function EquipmentService.getCapacity(player)
	local eq = equipped[player]
	local b  = eq and backpackById[eq.backpackId]
	return b and b.Capacity or 100
end

function EquipmentService.getEquipped(player)
	return equipped[player]
end

-- ── PurchaseEquipment handler ──────────────────────────────────────────────
-- Buying adds the item to owned and auto-equips it (new item is always better).

PurchaseEquipment.OnServerEvent:Connect(function(player, itemType, itemId)
	if type(itemType) ~= "string" or type(itemId) ~= "string" then return end

	local item
	local lookupTable
	if itemType == "pickaxe" then
		item        = pickaxeById[itemId]
		lookupTable = pickaxeById
	elseif itemType == "backpack" then
		item        = backpackById[itemId]
		lookupTable = backpackById
	else
		return
	end
	if not item then return end

	local own = owned[player]
	local eq  = equipped[player]
	if not own or not eq then return end

	local ownedSet = itemType == "pickaxe" and own.pickaxes or own.backpacks

	-- Starter items are free and already owned; can't purchase them
	if item.Cost <= 0 then return end
	-- Can't buy something already owned
	if ownedSet[itemId] then return end

	-- Validate and deduct credits
	local EconomyService = getEconomy()
	if EconomyService.getBalance(player) < item.Cost then return end
	EconomyService.deductCredits(player, item.Cost)

	-- Add to owned and auto-equip
	ownedSet[itemId] = true
	if itemType == "pickaxe" then
		eq.pickaxeId = itemId
	else
		eq.backpackId = itemId
		getInventory().setMaxWeight(player, item.Capacity)
	end

	pushUpdate(player)
	print(string.format("[EquipmentService] %s purchased %s for ₡%d", player.Name, item.Name, item.Cost))
end)

-- ── EquipItem handler ──────────────────────────────────────────────────────
-- Switches the equipped item to a different one the player already owns.

EquipItem.OnServerEvent:Connect(function(player, itemType, itemId)
	if type(itemType) ~= "string" or type(itemId) ~= "string" then return end

	local own = owned[player]
	local eq  = equipped[player]
	if not own or not eq then return end

	local lookupTable = itemType == "pickaxe" and pickaxeById or itemType == "backpack" and backpackById
	if not lookupTable then return end
	local item = lookupTable[itemId]
	if not item then return end

	local ownedSet = itemType == "pickaxe" and own.pickaxes or own.backpacks
	if not ownedSet[itemId] then return end  -- must own it

	if itemType == "pickaxe" then
		eq.pickaxeId = itemId
	else
		eq.backpackId = itemId
		getInventory().setMaxWeight(player, item.Capacity)
	end

	pushUpdate(player)
	print(string.format("[EquipmentService] %s equipped %s", player.Name, item.Name))
end)

-- ── Player lifecycle ────────────────────────────────────────────────────────

local function initPlayer(player)
	owned[player] = {
		pickaxes  = { ["starter_pickaxe"]  = true },
		backpacks = { ["starter_backpack"] = true },
	}
	equipped[player] = { pickaxeId = "starter_pickaxe", backpackId = "starter_backpack" }
	pushUpdate(player)
end

local function removePlayer(player)
	owned[player]    = nil
	equipped[player] = nil
end

Players.PlayerAdded:Connect(initPlayer)
Players.PlayerRemoving:Connect(removePlayer)
for _, player in ipairs(Players:GetPlayers()) do
	initPlayer(player)
end

print("[EquipmentService] Loaded")
return EquipmentService
