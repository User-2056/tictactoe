-- StarterOutfitService: Gives every player a default miner appearance
-- (hard hat + industrial work colours) on every character spawn, regardless
-- of whether they're new or returning.

local Players = game:GetService("Players")

local SAFETY_YELLOW = Color3.fromRGB(255, 205, 15)
local SHIRT_COLOR    = BrickColor.new("Dark stone grey")
local PANTS_COLOR    = BrickColor.new("Reddish brown")

local function createHardHat()
	local accessory = Instance.new("Accessory")
	accessory.Name = "MinerHardHat"
	accessory.AccessoryType = Enum.AccessoryType.Hat

	-- The "hat" is just a squashed yellow ball -- no mesh asset dependency.
	local handle          = Instance.new("Part")
	handle.Name           = "Handle"
	handle.Shape          = Enum.PartType.Ball
	handle.Size           = Vector3.new(1.7, 1.05, 1.7)
	handle.Color          = SAFETY_YELLOW
	handle.Material       = Enum.Material.SmoothPlastic
	handle.CanCollide     = false
	handle.CanQuery       = false
	handle.Massless       = true
	handle.Parent         = accessory

	-- Roblox aligns accessories by matching an Attachment name on the Handle
	-- to the same-named Attachment on the character's Head ("HatAttachment").
	local attachment    = Instance.new("Attachment")
	attachment.Name     = "HatAttachment"
	attachment.Position = Vector3.new(0, -0.85, 0)
	attachment.Parent   = handle

	return accessory
end

local function applyOutfit(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- "Work clothes" via BodyColors rather than Shirt/Pants template assets --
	-- recolours torso+arms (shirt) and legs (pants). Head/skin colour is left
	-- untouched so the player's own face still shows. Any Shirt/Pants the
	-- player's own avatar came equipped with are removed first -- otherwise
	-- those textures render over BodyColors and our recolour is invisible.
	local shirt = character:FindFirstChildOfClass("Shirt")
	if shirt then shirt:Destroy() end
	local pants = character:FindFirstChildOfClass("Pants")
	if pants then pants:Destroy() end

	local colors = character:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
	colors.TorsoColor    = SHIRT_COLOR
	colors.RightArmColor = SHIRT_COLOR
	colors.LeftArmColor  = SHIRT_COLOR
	colors.RightLegColor = PANTS_COLOR
	colors.LeftLegColor  = PANTS_COLOR
	colors.Parent         = character

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
