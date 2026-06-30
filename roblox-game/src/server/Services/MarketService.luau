-- MarketService: This module will eventually calculate daily ore sell prices.
-- Prices will change each in-game day using a seeded random number so every
-- player sees the same prices at the same time — no one gets an unfair advantage.
-- It will also broadcast updated prices to all clients so HUDs stay current.
local MarketService = {}

print("[MarketService] Loaded")

return MarketService
