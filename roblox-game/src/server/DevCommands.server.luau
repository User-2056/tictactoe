-- DevCommands: Studio-only developer chat commands.
-- Silently exits in published games. Only responds to the named dev account.
--
-- Commands:
--   /credits <amount>   — add N credits to your balance

local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")

if not RunService:IsStudio() then return end

local DEV_NAME = "Thxnderz_z"

local function getEconomy()
	return require(script.Parent.Services.EconomyService)
end

local function handleChat(player, msg)
	local amount = msg:match("^/credits%s+(%d+)$")
	if amount then
		local n = tonumber(amount)
		if n and n > 0 then
			getEconomy().addCredits(player, n)
			print(string.format("[DevCommands] Gave %s ₡%d", player.Name, n))
		end
	end
end

local function watchPlayer(player)
	if player.Name ~= DEV_NAME then return end
	player.Chatted:Connect(function(msg) handleChat(player, msg) end)
end

Players.PlayerAdded:Connect(watchPlayer)
for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end

print("[DevCommands] Loaded (Studio only) — /credits <amount>")
