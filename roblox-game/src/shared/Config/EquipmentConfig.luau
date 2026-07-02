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
				HandleSize     = Vector3.new(0.35, 0.35, 1.6),
				HandleColor    = Color3.fromRGB(94, 68, 42),    -- worn dark brown
				HandleMaterial = Enum.Material.Wood,
				HeadSize       = Vector3.new(1.3, 0.6, 0.6),
				HeadColor      = Color3.fromRGB(112, 108, 100), -- lighter warm grey -- "dark stone" but still visible against the handle/shadows
				HeadMaterial   = Enum.Material.Slate,
				Bands          = {},
			},
		},
		{
			Id = "iron_pickaxe", Name = "Iron Pickaxe", MiningPower = 2, Cost = 2500, Tier = 2,
			Visual = {
				HandleSize     = Vector3.new(0.38, 0.38, 1.7),
				HandleColor    = Color3.fromRGB(120, 86, 53),   -- richer polished wood
				HandleMaterial = Enum.Material.Wood,
				HeadSize       = Vector3.new(1.4, 0.65, 0.65),
				HeadColor      = Color3.fromRGB(170, 170, 175), -- clean silver
				HeadMaterial   = Enum.Material.Metal,
				Bands          = {
					{ Size = Vector3.new(0.14, 0.48, 0.48), Color = Color3.fromRGB(80, 80, 86), Material = Enum.Material.Metal, OffsetZ = -0.3 },
				},
			},
		},
		{
			Id = "steel_pickaxe", Name = "Steel Pickaxe", MiningPower = 4, Cost = 25000, Tier = 3,
			Visual = {
				HandleSize     = Vector3.new(0.42, 0.42, 1.8),
				HandleColor    = Color3.fromRGB(55, 55, 60),    -- dark, fully metal-clad
				HandleMaterial = Enum.Material.Metal,
				HeadSize       = Vector3.new(1.6, 0.7, 0.68),
				HeadColor      = Color3.fromRGB(70, 74, 80),    -- dark steel, kept just bright enough to read against shadow
				HeadMaterial   = Enum.Material.DiamondPlate,    -- industrial texture
				Bands          = {
					{ Size = Vector3.new(0.14, 0.52, 0.52), Color = Color3.fromRGB(30, 30, 34), Material = Enum.Material.DiamondPlate, OffsetZ = -0.4 },
					{ Size = Vector3.new(0.14, 0.5, 0.5), Color = Color3.fromRGB(30, 30, 34), Material = Enum.Material.DiamondPlate, OffsetZ = 0.5 },
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
