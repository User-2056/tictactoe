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
}

for _, name in ipairs(remoteNames) do
	local event = Instance.new("RemoteEvent")
	event.Name = name
	event.Parent = Remotes
end

print("[Bootstrap] Created Remotes folder with", #remoteNames, "RemoteEvents")

local Services = script.Parent.Services

local serviceNames = {
	"OreService",
	"InventoryService",
	"MarketService",
	"ContractService",
	"EquipmentService",
	"RegionService",
	"DataService",
}

for _, name in ipairs(serviceNames) do
	require(Services[name])
end

print("[Bootstrap] All services loaded — Mining Corporation server is ready!")
