-- Bootstrap: This is the first server script that runs when the game starts.
-- It does two things:
--   1. Creates a "Remotes" folder in ReplicatedStorage and puts all RemoteEvents
--      inside it. RemoteEvents are how the client and server talk to each other
--      securely — the server creates them so clients cannot cheat.
--   2. Loads every service module so each one runs its startup code and prints
--      its name to the Output window, confirming everything loaded correctly.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Step 1: Create the Remotes folder with all RemoteEvents
local Remotes = Instance.new("Folder")
Remotes.Name = "Remotes"
Remotes.Parent = ReplicatedStorage

local remoteNames = {
	"MineOre",
	"SellOre",
	"PurchaseEquipment",
	"AcceptContract",
	"UnlockLicence",
	"CollectDrillOutput",
}

for _, name in ipairs(remoteNames) do
	local event = Instance.new("RemoteEvent")
	event.Name = name
	event.Parent = Remotes
end

print("[Bootstrap] Created Remotes folder with", #remoteNames, "RemoteEvents")

-- Step 2: Load every service (each service prints its own name below)
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
