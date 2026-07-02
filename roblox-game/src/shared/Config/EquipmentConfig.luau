-- EquipmentConfig: All mining equipment tiers available in the shop.
-- MiningPower is a multiplier applied to the base damage per swing (base = 25).
-- Capacity is the bag's carry weight limit in kg.
-- Cost = 0 items are owned by default (Starter tier); they cannot be purchased.
--
-- ToolName is the single source of truth for the pickaxe Tool instance's Name --
-- OreService (server-side mining validation), MiningController (client-side tool
-- detection), and PickaxeBuilder (tool construction) all reference this instead
-- of hardcoding the literal "Pickaxe" independently.
--
-- Each Pickaxe's Visual table drives PickaxeBuilder.build() -- adding a new tier
-- (Titanium, Quantum, ...) is purely a new Pickaxes entry with its own Visual
-- block; no code changes needed in PickaxeBuilder, EquipmentService, or ShopController.

return {
	ToolName = "Pickaxe",

	Pickaxes = {
		{
			Id = "starter_pickaxe", Name = "Starter Pickaxe", MiningPower = 1, Cost = 0, Tier = 1,
			Visual = {
				HandleSize     = Vector3.new(0.18, 0.18, 1.3),
				HandleColor    = Color3.fromRGB(94, 68, 42),    -- worn dark brown
				HandleMaterial = Enum.Material.Wood,
				HeadSize       = Vector3.new(3, 3, 3), -- TEMP DIAGNOSTIC: huge + neon, see if it shows up at all
				HeadColor      = Color3.fromRGB(255, 0, 255),
				HeadMaterial   = Enum.Material.Neon,
				Bands          = {},
			},
		},
		{
			Id = "iron_pickaxe", Name = "Iron Pickaxe", MiningPower = 2, Cost = 2500, Tier = 2,
			Visual = {
				HandleSize     = Vector3.new(0.2, 0.2, 1.4),
				HandleColor    = Color3.fromRGB(120, 86, 53),   -- richer polished wood
				HandleMaterial = Enum.Material.Wood,
				HeadSize       = Vector3.new(0.95, 0.26, 0.26),
				HeadColor      = Color3.fromRGB(170, 170, 175), -- clean silver
				HeadMaterial   = Enum.Material.Metal,
				Bands          = {
					{ Size = Vector3.new(0.08, 0.26, 0.26), Color = Color3.fromRGB(80, 80, 86), Material = Enum.Material.Metal, OffsetZ = -0.25 },
				},
			},
		},
		{
			Id = "steel_pickaxe", Name = "Steel Pickaxe", MiningPower = 4, Cost = 25000, Tier = 3,
			Visual = {
				HandleSize     = Vector3.new(0.22, 0.22, 1.5),
				HandleColor    = Color3.fromRGB(55, 55, 60),    -- dark, fully metal-clad
				HandleMaterial = Enum.Material.Metal,
				HeadSize       = Vector3.new(1.1, 0.3, 0.28),
				HeadColor      = Color3.fromRGB(60, 63, 68),    -- dark steel, kept just bright enough to read against shadow
				HeadMaterial   = Enum.Material.DiamondPlate,    -- industrial texture
				Bands          = {
					{ Size = Vector3.new(0.08, 0.3, 0.3), Color = Color3.fromRGB(30, 30, 34), Material = Enum.Material.DiamondPlate, OffsetZ = -0.35 },
					{ Size = Vector3.new(0.08, 0.28, 0.28), Color = Color3.fromRGB(30, 30, 34), Material = Enum.Material.DiamondPlate, OffsetZ = 0.45 },
				},
			},
		},
	},
	Backpacks = {
		{ Id = "starter_backpack",    Name = "Starter Backpack",    Capacity = 100,  Cost = 0,     Tier = 1 },
		{ Id = "small_backpack",      Name = "Small Backpack",      Capacity = 250,  Cost = 1500,  Tier = 2 },
		{ Id = "miner_backpack",      Name = "Miner's Backpack",    Capacity = 500,  Cost = 7500,  Tier = 3 },
		{ Id = "industrial_backpack", Name = "Industrial Backpack", Capacity = 1000, Cost = 35000, Tier = 4 },
	},
}
