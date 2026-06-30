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

function EconomyService.deductCredits(player, amount)
	if amount <= 0 then return end
	balances[player] = math.max(0, (balances[player] or 0) - amount)
	pushUpdate(player)
end

-- ── SellOre handler ─────────────────────────────────────────────────────────
-- Two modes:
--   SellOre:FireServer()             → sell all (no args)
--   SellOre:FireServer(oreType, qty) → sell a specific quantity of one ore type
-- All values are re-validated server-side — no client number is trusted.

SellOre.OnServerEvent:Connect(function(player, oreType, quantity)
	local InventoryService = getInventoryService()
	local inv = InventoryService.getInventory(player)
	if not inv or next(inv.items) == nil then return end

	if oreType ~= nil then
		-- ── Partial sell ──────────────────────────────────────────────────
		if type(oreType) ~= "string" then return end
		local oreData = OreConfig[oreType]
		if not oreData then return end

		local requested = (type(quantity) == "number") and math.floor(quantity) or 0
		if requested <= 0 then return end
		requested = math.min(requested, inv.items[oreType] or 0)
		if requested <= 0 then return end

		local removed = InventoryService.removeOre(player, oreType, requested)
		if removed <= 0 then return end

		local earned = oreData.BaseValue * removed
		EconomyService.addCredits(player, earned)
		print(string.format("[EconomyService] %s sold %d × %s for ₡%d (balance: ₡%d)",
			player.Name, removed, oreType, earned, balances[player]))
	else
		-- ── Sell all ──────────────────────────────────────────────────────
		local total = 0
		for t, qty in pairs(inv.items) do
			local oreData = OreConfig[t]
			if oreData then total += oreData.BaseValue * qty end
		end
		if total <= 0 then return end

		InventoryService.clearInventory(player)
		EconomyService.addCredits(player, total)
		print(string.format("[EconomyService] %s sold all inventory for ₡%d (balance: ₡%d)",
			player.Name, total, balances[player]))
	end
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
