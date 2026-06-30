-- OreConfig: Defines every ore type in the game.
-- Each key is the ore's internal name used throughout the codebase.
--
-- Fields:
--   BaseValue      — base coin value per unit when sold at market (1.0x multiplier)
--   Weight         — carry weight per unit; used for bag capacity in Milestone 3
--   SpawnChance    — relative probability used when rolling a random ore at a spawn point
--   VeinHP         — total hit-points; reduced by Mining Power on each swing
--   RespawnSeconds — seconds before a broken vein spawns a fresh ore type
--   Color          — Part colour used in Workspace to represent this ore visually

return {
	stone = {
		BaseValue      = 5,
		Weight         = 1,
		SpawnChance    = 0.55,
		VeinHP         = 100,
		RespawnSeconds = 30,
		Color          = Color3.fromRGB(163, 162, 165),
	},
	coal = {
		BaseValue      = 12,
		Weight         = 2,
		SpawnChance    = 0.25,
		VeinHP         = 150,
		RespawnSeconds = 30,
		Color          = Color3.fromRGB(57, 52, 57),
	},
	iron = {
		BaseValue      = 30,
		Weight         = 3,
		SpawnChance    = 0.14,
		VeinHP         = 250,
		RespawnSeconds = 30,
		Color          = Color3.fromRGB(150, 100, 80),
	},
	gold = {
		BaseValue      = 90,
		Weight         = 5,
		SpawnChance    = 0.06,
		VeinHP         = 500,
		RespawnSeconds = 30,
		Color          = Color3.fromRGB(215, 175, 30),
	},
}
