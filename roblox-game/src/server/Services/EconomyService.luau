-- EconomyService: Tracks per-player Credits balances and handles ore selling.
-- Balances live in memory for the session; DataStore persistence comes in Milestone 6.
-- The SellOre handler recalculates the transaction value entirely from the
-- server-stored inventory — no number from the client is ever trusted.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OreConfig         = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("OreConfig"))
local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local Eco_CreditsUpdate = Remotes:WaitForChild("Eco_CreditsUpdate")
local SellOre           = Remotes:WaitForChild("SellOre")

-- keyed by Player instance → number (Credits balance)
local balances = {}

local EconomyService = {}

-- ── Internal ───────────────────────────────────────────────────────────────

local function pushUpdate(player)
	Eco_CreditsUpdate:FireClient(player, balances[player] or 0)
end

-- Lazy-require avoids load-order coupling with InventoryService
local function getInventoryService()
	return require(script.Parent.InventoryService)
end

-- ── Public API ─────────────────────────────────────────────────────────────

function EconomyService.addCredits(player, amount)
	if amount <= 0 then return end
	balances[player] = (balances[player] or 0) + amount
	pushUpdate(player)
end

function EconomyService.getBalance(player)
	return balances[player] or 0
end

-- ── SellOre handler ─────────────────────────────────────────────────────────
-- Client sends an empty SellOre event — no payload is used or trusted.
-- Server re-reads the actual stored inventory and calculates independently.

SellOre.OnServerEvent:Connect(function(player)
	local InventoryService = getInventoryService()
	local inv = InventoryService.getInventory(player)
	if not inv or next(inv.items) == nil then return end

	-- Recalculate total entirely from server-side data
	local total = 0
	for oreType, qty in pairs(inv.items) do
		local oreData = OreConfig[oreType]
		if oreData then
			total += oreData.BaseValue * qty
		end
	end

	if total <= 0 then return end

	-- Clear inventory first, then credit — both push their own client updates
	InventoryService.clearInventory(player)
	EconomyService.addCredits(player, total)

	print(string.format("[EconomyService] %s sold inventory for ₡%d (balance: ₡%d)",
		player.Name, total, balances[player]))
end)

-- ── Player lifecycle ───────────────────────────────────────────────────────

local function initPlayer(player)
	balances[player] = 0
	pushUpdate(player)
end

local function removePlayer(player)
	balances[player] = nil
end

Players.PlayerAdded:Connect(initPlayer)
Players.PlayerRemoving:Connect(removePlayer)
for _, player in ipairs(Players:GetPlayers()) do
	initPlayer(player)
end

print("[EconomyService] Loaded")
return EconomyService
