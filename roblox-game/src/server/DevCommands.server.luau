-- DevCommands: Studio-only developer chat commands.
-- Silently exits in published games. Only responds to the named dev account.
--
-- Commands:
--   /credits <amount>          — add N credits to your balance
--   /ore <type> <amount>       — add N of a specific ore to your bag (bypasses weight cap)

local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

if not RunService:IsStudio() then return end

local DEV_NAME = "Thxnderz_z"

local function getEconomy()
	return require(ServerScriptService.Services.EconomyService)
end

local function getInventory()
	return require(ServerScriptService.Services.InventoryService)
end

local OreConfig = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("OreConfig"))

local function handleChat(player, msg)
	-- /credits <amount>
	local credits = msg:match("^/credits%s+(%d+)$")
	if credits then
		local n = tonumber(credits)
		if n and n > 0 then
			getEconomy().addCredits(player, n)
			print(string.format("[DevCommands] Gave %s ₡%d", player.Name, n))
		end
		return
	end

	-- /ore <type> <amount>
	local oreType, oreAmt = msg:match("^/ore%s+(%a+)%s+(%d+)$")
	if oreType and oreAmt then
		oreType = oreType:lower()
		local n = tonumber(oreAmt)
		if not n or n <= 0 then return end
		if not OreConfig[oreType] then
			print(string.format("[DevCommands] Unknown ore type '%s'. Valid: stone, coal, iron, gold", oreType))
			return
		end

		local IS  = getInventory()
		local inv = IS.getInventory(player)
		if not inv then return end

		-- Temporarily expand capacity so the add always succeeds
		local neededWeight = inv.currentWeight + OreConfig[oreType].Weight * n
		local oldMax       = inv.maxWeight
		if neededWeight > oldMax then
			IS.setMaxWeight(player, neededWeight + 1)
		end
		IS.addOre(player, oreType, n)
		if neededWeight > oldMax then
			IS.setMaxWeight(player, oldMax)
		end

		print(string.format("[DevCommands] Gave %s %d × %s", player.Name, n, oreType))
		return
	end
end

local function watchPlayer(player)
	if player.Name ~= DEV_NAME then return end
	player.Chatted:Connect(function(msg) handleChat(player, msg) end)
end

Players.PlayerAdded:Connect(watchPlayer)
for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end

print("[DevCommands] Loaded (Studio only) — /credits <n>  |  /ore <type> <n>")
