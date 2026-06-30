-- EquipmentService: Tracks which pickaxe and backpack each player has equipped.
-- Handles PurchaseEquipment remote. All validation is server-side — credits are
-- checked and deducted here; the client never controls what tier a player has.
-- MiningPower is a multiplier; OreService applies it against its base damage (25).

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipmentConfig   = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("EquipmentConfig"))
local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local PurchaseEquipment = Remotes:WaitForChild("PurchaseEquipment")
local Eq_Update         = Remotes:WaitForChild("Eq_Update")

-- Fast lookup tables by Id
local pickaxeById  = {}
for _, p in ipairs(EquipmentConfig.Pickaxes)  do pickaxeById[p.Id]  = p end
local backpackById = {}
for _, b in ipairs(EquipmentConfig.Backpacks) do backpackById[b.Id] = b end

-- keyed by Player → { pickaxeId = string, backpackId = string }
local equipped = {}

local EquipmentService = {}

-- Lazy-require to avoid load-order coupling
local function getEconomy()
	return require(script.Parent.EconomyService)
end
local function getInventory()
	return require(script.Parent.InventoryService)
end

local function pushUpdate(player)
	local eq = equipped[player]
	if not eq then return end
	Eq_Update:FireClient(player, eq.pickaxeId, eq.backpackId)
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
-- Payload: itemType ("pickaxe" | "backpack"), itemId (Id string from config)
-- Server recalculates everything — no client value is trusted.

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

	local eq = equipped[player]
	if not eq then return end

	-- Starter items (Cost=0) are default-owned; cannot be purchased
	if item.Cost <= 0 then return end

	-- Must be a higher tier than the currently equipped item
	local currentId   = itemType == "pickaxe" and eq.pickaxeId or eq.backpackId
	local currentItem = lookupTable[currentId]
	if currentItem and item.Tier <= currentItem.Tier then return end

	-- Validate and deduct credits
	local EconomyService = getEconomy()
	if EconomyService.getBalance(player) < item.Cost then return end
	EconomyService.deductCredits(player, item.Cost)

	-- Equip and propagate
	if itemType == "pickaxe" then
		eq.pickaxeId = itemId
	else
		eq.backpackId = itemId
		getInventory().setMaxWeight(player, item.Capacity)
	end

	pushUpdate(player)
	print(string.format("[EquipmentService] %s purchased %s for ₡%d", player.Name, item.Name, item.Cost))
end)

-- ── Player lifecycle ────────────────────────────────────────────────────────

local function initPlayer(player)
	equipped[player] = { pickaxeId = "starter_pickaxe", backpackId = "starter_backpack" }
	pushUpdate(player)
end

local function removePlayer(player)
	equipped[player] = nil
end

Players.PlayerAdded:Connect(initPlayer)
Players.PlayerRemoving:Connect(removePlayer)
for _, player in ipairs(Players:GetPlayers()) do
	initPlayer(player)
end

print("[EquipmentService] Loaded")
return EquipmentService
