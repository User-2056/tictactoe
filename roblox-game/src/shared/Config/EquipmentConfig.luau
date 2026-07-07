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
			Rarity = "Common", SwingSpeed = 1.6,
			Description = "A basic pickaxe issued to every new miner. Gets the job done.",
			Visual = {
				-- Hand-modeled mesh (wood Handle + Slate Head) instead of procedural boxes --
				-- PickaxeBuilder clones ReplicatedStorage.Assets.CustomPickaxes.StarterPickaxeModel
				-- for any tier with Custom = true rather than building parts from Size/Color fields.
				-- Grip vectors were derived empirically in Play mode (verified with
				-- Vector3:Dot() against HumanoidRootPart.CFrame.LookVector, not just by eye --
				-- an earlier attempt LOOKED right in a screenshot but was actually backwards,
				-- holding the tool by the head with the handle sticking out): this model's long
				-- "handle" axis is local Y, not Z like the procedural tiers, and the Head sits
				-- on the +Y side of Handle, so GripForward must be +Y for the head to lead.
				Custom      = true,
				CustomModel = "StarterPickaxeModel",
				GripForward = Vector3.new(0, 1, 0),
				GripRight   = Vector3.new(1, 0, 0),
				GripUp      = Vector3.new(0, 0, 1),
				-- GripPos.Y alone (sliding along the handle's own length) was a dead end --
				-- measured via workspace:GetPartsInPart / closest-distance-to-RightUpperArm
				-- that it stayed embedded (~-0.62 studs) no matter how far that single axis
				-- was pushed (even the KNOWN-GOOD Iron/Steel tiers overlap RightHand/
				-- RightLowerArm; that's normal, the fist is supposed to wrap the grip -- but
				-- they clear RightUpperArm by +0.34, which ours didn't at any GripPos.Y).
				-- The fix needed a SIDEWAYS offset (local Z, i.e. GripUp) to actually move the
				-- handle off the arm's centerline: (0, 0.9, 1.0) clears RightUpperArm by +0.38,
				-- RightLowerArm/RightHand by +0.29, matching or beating the Iron reference.
				GripPos     = Vector3.new(0, 0.9, 1.0),
			},
		},
		{
			Id = "iron_pickaxe", Name = "Iron Pickaxe", MiningPower = 2, Cost = 2500, Tier = 2,
			Rarity = "Uncommon", SwingSpeed = 1.4,
			Description = "Sturdier and sharper than the starter pickaxe. A solid upgrade for steady progress.",
			Visual = {
				HandleSize     = Vector3.new(0.38, 0.38, 1.7),
				HandleColor    = Color3.fromRGB(150, 105, 55),  -- noticeably lighter/more golden than Starter's dark worn brown
				HandleMaterial = Enum.Material.Wood,
				HeadSize       = Vector3.new(1.4, 0.65, 0.65),
				HeadColor      = Color3.fromRGB(190, 195, 205), -- cool bright silver -- distinct from Starter's warm dull stone
				HeadMaterial   = Enum.Material.Metal,
				Bands          = {
					{ Size = Vector3.new(0.14, 0.48, 0.48), Color = Color3.fromRGB(80, 80, 86), Material = Enum.Material.Metal, OffsetZ = -0.3 },
				},
			},
		},
		{
			Id = "steel_pickaxe", Name = "Steel Pickaxe", MiningPower = 4, Cost = 25000, Tier = 3,
			Rarity = "Rare", SwingSpeed = 1.2,
			Description = "Reinforced steel head that swings harder and faster. Built for serious miners.",
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
		{ Id = "starter_backpack",    Name = "Starter Backpack",    Capacity = 100,  Cost = 0,     Tier = 1,
			Rarity = "Common", Description = "A small canvas sack. Fine for a quick trip, cramped for a real haul." },
		{ Id = "small_backpack",      Name = "Small Backpack",      Capacity = 250,  Cost = 1500,  Tier = 2,
			Rarity = "Uncommon", Description = "Extra pockets add meaningful carry capacity without slowing you down." },
		{ Id = "miner_backpack",      Name = "Miner's Backpack",    Capacity = 500,  Cost = 7500,  Tier = 3,
			Rarity = "Rare", Description = "A rugged frame pack built for full shifts underground." },
		{ Id = "industrial_backpack", Name = "Industrial Backpack", Capacity = 1000, Cost = 35000, Tier = 4,
			Rarity = "Epic", Description = "Heavy-duty industrial rig for hauling massive loads back to the surface." },
	},
}
