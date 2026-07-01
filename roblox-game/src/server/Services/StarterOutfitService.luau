-- StarterOutfitService: Gives every player a default miner appearance
-- (hard hat + industrial work clothes) on every character spawn, regardless
-- of whether they're new or returning.

local Players = game:GetService("Players")

local SAFETY_YELLOW = Color3.fromRGB(237, 178, 15)
local SAFETY_YELLOW_DARK = Color3.fromRGB(196, 140, 8)  -- brim/ridge shading
local SHIRT_COLOR    = Color3.fromRGB(88, 96, 104)   -- muted slate grey
local PANTS_COLOR    = Color3.fromRGB(74, 58, 46)    -- dark work-trouser brown
local BOOT_COLOR     = Color3.fromRGB(31, 27, 24)    -- near-black leather

-- R15 part names, grouped by what they represent on the outfit. Only torso +
-- upper arms get the shirt colour so it reads as a short-sleeve work shirt
-- with bare forearms/hands, rather than a full-body paint job.
local SHIRT_PARTS_R15 = { "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm" }
local PANTS_PARTS_R15 = { "LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg" }
local BOOT_PARTS_R15  = { "LeftFoot", "RightFoot" }

-- R6 fallback: single Torso/Arm/Leg parts, no separate forearm/hand/foot to
-- carve a sleeve or boot boundary out of, so the whole limb gets coloured.
local SHIRT_PARTS_R6 = { "Torso", "Left Arm", "Right Arm" }
local PANTS_PARTS_R6 = { "Left Leg", "Right Leg" }

local function colorParts(character, names, color)
	for _, name in ipairs(names) do
		local part = character:FindFirstChild(name)
		if part and part:IsA("BasePart") then
			part.Color = color
			part.Material = Enum.Material.Fabric
		end
	end
end

local function createHardHat()
	local accessory = Instance.new("Accessory")
	accessory.Name = "MinerHardHat"
	accessory.AccessoryType = Enum.AccessoryType.Hat

	-- Dome: the rounded shell, flattened so it reads as a helmet cap, not a ball.
	local handle          = Instance.new("Part")
	handle.Name           = "Handle"
	handle.Shape          = Enum.PartType.Ball
	handle.Size           = Vector3.new(1.55, 0.85, 1.55)
	handle.Color          = SAFETY_YELLOW
	handle.Material       = Enum.Material.SmoothPlastic
	handle.CanCollide     = false
	handle.CanQuery       = false
	handle.Massless       = true
	handle.Parent         = accessory

	-- Brim: a wide flat disc around the base -- this is what actually makes it
	-- read as a hard hat silhouette instead of a sphere sitting on the head.
	-- Uses a Weld with an explicit C0 offset (not WeldConstraint): WeldConstraint
	-- captures whatever the *current* relative CFrame happens to be at the moment
	-- it goes live, which is unreliable here since Handle gets repositioned onto
	-- the head later by AddAccessory -- Brim ended up stranded near world origin.
	-- Same gotcha already documented on the Pickaxe tool in OreService.luau.
	local brim       = Instance.new("Part")
	brim.Name        = "Brim"
	brim.Shape       = Enum.PartType.Cylinder
	brim.Size        = Vector3.new(0.16, 2.05, 2.05)
	brim.Color       = SAFETY_YELLOW_DARK
	brim.Material    = Enum.Material.SmoothPlastic
	brim.CanCollide  = false
	brim.CanQuery    = false
	brim.Massless    = true
	brim.Parent      = accessory

	local brimWeld   = Instance.new("Weld")
	brimWeld.Part0   = handle
	brimWeld.Part1   = brim
	-- Cylinder's length runs along local X by default; rotate it flat so the
	-- circular faces point up/down like a brim, then tuck it under the dome.
	brimWeld.C0      = CFrame.new(0, -0.32, 0) * CFrame.Angles(0, 0, math.rad(90))
	brimWeld.Parent  = handle

	-- Ridge: a small front-to-back raised strip, the detail most real
	-- construction/mining hard hats have along the crown.
	local ridge      = Instance.new("Part")
	ridge.Name       = "Ridge"
	ridge.Size       = Vector3.new(0.16, 0.22, 1.35)
	ridge.Color      = SAFETY_YELLOW_DARK
	ridge.Material   = Enum.Material.SmoothPlastic
	ridge.CanCollide = false
	ridge.CanQuery   = false
	ridge.Massless   = true
	ridge.Parent     = accessory

	local ridgeWeld  = Instance.new("Weld")
	ridgeWeld.Part0  = handle
	ridgeWeld.Part1  = ridge
	ridgeWeld.C0     = CFrame.new(0, 0.38, 0)
	ridgeWeld.Parent = handle

	-- Roblox aligns accessories by matching an Attachment name on the Handle
	-- to the same-named Attachment on the character's Head ("HatAttachment").
	local attachment    = Instance.new("Attachment")
	attachment.Name     = "HatAttachment"
	attachment.Position = Vector3.new(0, -0.8, 0)
	attachment.Parent   = handle

	return accessory
end

local function applyOutfit(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- Real Shirt/Pants textures (if the player's own avatar came equipped with
	-- any) render over any body-part recolour below, so strip them first.
	local shirt = character:FindFirstChildOfClass("Shirt")
	if shirt then shirt:Destroy() end
	local pants = character:FindFirstChildOfClass("Pants")
	if pants then pants:Destroy() end

	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		colorParts(character, SHIRT_PARTS_R15, SHIRT_COLOR)
		colorParts(character, PANTS_PARTS_R15, PANTS_COLOR)
		colorParts(character, BOOT_PARTS_R15, BOOT_COLOR)
	else
		colorParts(character, SHIRT_PARTS_R6, SHIRT_COLOR)
		colorParts(character, PANTS_PARTS_R6, PANTS_COLOR)
	end

	if not character:FindFirstChild("MinerHardHat") then
		humanoid:AddAccessory(createHardHat())
	end
end

local function onPlayerAdded(player)
	player.CharacterAppearanceLoaded:Connect(function(character)
		applyOutfit(character)
	end)

	-- Guard against a race: if the character (and its appearance) already
	-- loaded before we connected above -- e.g. the local player in Studio
	-- Play testing, who's already in Players:GetPlayers() with a spawned
	-- Character by the time this service starts -- apply immediately too.
	if player.Character then
		applyOutfit(player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

print("[StarterOutfitService] Loaded")

return {}
