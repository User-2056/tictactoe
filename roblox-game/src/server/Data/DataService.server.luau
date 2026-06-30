-- DataService (Data folder): This script tests whether Roblox's DataStore is
-- accessible from Studio. DataStore is the Roblox system used to save player
-- data permanently between sessions.
--
-- This script does NOT save or load any real player data yet — it just confirms
-- the connection works so you know real saving will be possible in later milestones.
--
-- IF YOU SEE A WARNING in the Output window:
--   Go to: Home tab → Game Settings → Security
--   Tick: "Enable Studio Access to API Services"
--   Then press Play again. The warning will go away.

local DataStoreService = game:GetService("DataStoreService")

local success, result = pcall(function()
	-- GetDataStore returns a reference to a named data store.
	-- "PlayerData_v1" is the name we will use for the real game later.
	-- The "v1" means version 1 — if we ever change the data format we bump
	-- this to "v2" so old saves don't conflict with new ones.
	return DataStoreService:GetDataStore("PlayerData_v1")
end)

if success then
	print("[DataService] DataStore connection confirmed — PlayerData_v1 is accessible.")
else
	warn("[DataService] DataStore connection failed:", result)
	warn("[DataService] Fix: Game Settings → Security → Enable Studio Access to API Services")
end
