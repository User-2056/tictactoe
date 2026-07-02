-- Bootstrap: First server script to run. Creates all RemoteEvents, then loads services.
-- RemoteEvents are split into two directions:
--   C->S  client fires to request an action   (MineOre, SellOre, …)
--   S->C  server fires to push state/effects  (Ore_VeinHit, Ore_VeinBroke, …)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = Instance.new("Folder")
Remotes.Name = "Remotes"
Remotes.Parent = ReplicatedStorage

local remoteNames = {
	-- Client -> Server requests
	"MineOre",
	"SellOre",
	"PurchaseEquipment",
	"AcceptContract",
	"UnlockLicence",
	"CollectDrillOutput",
	-- Server -> All clients  (mining feedback)
	"Ore_VeinHit",      -- payload: veinName, healthPct (0-1)
	"Ore_VeinBroke",    -- payload: veinName
	"Ore_VeinSpawned",  -- payload: veinName, newOreType
	-- Server -> Mining player only
	"Ore_OreAwarded",   -- payload: oreType, amount
	-- Server -> Owning player only  (inventory)
	"Inv_Update",       -- payload: items (table), currentWeight, maxWeight
	"Inv_Full",         -- no payload; triggers the "bag full" notification
	-- Server -> Mining player only  (blocked hit feedback)
	"Ore_HitBlocked",   -- payload: veinName; inventory full, hit did no damage
	-- Server -> Owning player only  (economy)
	"Eco_CreditsUpdate", -- payload: balance (number)
	-- Server -> Owning player only  (equipment)
	"Eq_Update",         -- payload: pickaxeId, backpackId, ownedPickaxes[], ownedBackpacks[]
	-- Client -> Server  (equipment)
	"EquipItem",         -- payload: itemType ("pickaxe"|"backpack"), itemId
}

for _, name in ipairs(remoteNames) do
	local event = Instance.new("RemoteEvent")
	event.Name = name
	event.Parent = Remotes
end

print("[Bootstrap] Created Remotes folder with", #remoteNames, "RemoteEvents")

-- Sync/connectivity test block -- ask to remove once confirmed visible.
local testBlock          = Instance.new("Part")
testBlock.Name           = "SyncTestBlock"
testBlock.Size            = Vector3.new(10, 10, 10)
testBlock.Position        = Vector3.new(0, 30, 0)
testBlock.Anchored        = true
testBlock.BrickColor      = BrickColor.new("Really red")
testBlock.Material        = Enum.Material.Neon
testBlock.Parent          = workspace
print("[Bootstrap] Created 10x10x10 red SyncTestBlock at (0, 30, 0)")

local Services = script.Parent.Services

local serviceNames = {
	"InventoryService",  -- no lazy deps; must load first
	"EquipmentService",  -- lazy-requires Economy + Inventory; OreService needs it per-request
	"EconomyService",    -- lazy-requires Inventory
	"OreService",        -- lazy-requires Inventory + Equipment
	"MarketService",
	"ContractService",
	"RegionService",
	"DataService",
	"StarterOutfitService",
}

for _, name in ipairs(serviceNames) do
	require(Services[name])
end

print("[Bootstrap] All services loaded — Mining Corporation server is ready!")
