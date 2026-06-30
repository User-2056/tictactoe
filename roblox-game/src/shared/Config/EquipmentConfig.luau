-- EquipmentConfig: All mining equipment tiers available in the shop.
-- MiningPower is a multiplier applied to the base damage per swing (base = 25).
-- Capacity is the bag's carry weight limit in kg.
-- Cost = 0 items are owned by default (Starter tier); they cannot be purchased.

return {
	Pickaxes = {
		{ Id = "starter_pickaxe", Name = "Starter Pickaxe", MiningPower = 1, Cost = 0,     Tier = 1 },
		{ Id = "iron_pickaxe",    Name = "Iron Pickaxe",    MiningPower = 2, Cost = 2500,  Tier = 2 },
		{ Id = "steel_pickaxe",   Name = "Steel Pickaxe",   MiningPower = 4, Cost = 25000, Tier = 3 },
	},
	Backpacks = {
		{ Id = "starter_backpack",    Name = "Starter Backpack",    Capacity = 100,  Cost = 0,     Tier = 1 },
		{ Id = "small_backpack",      Name = "Small Backpack",      Capacity = 250,  Cost = 1500,  Tier = 2 },
		{ Id = "miner_backpack",      Name = "Miner's Backpack",    Capacity = 500,  Cost = 7500,  Tier = 3 },
		{ Id = "industrial_backpack", Name = "Industrial Backpack", Capacity = 1000, Cost = 35000, Tier = 4 },
	},
}
