-- StarterOutfitService: Gives brand-new players a default miner appearance
-- (hard hat + industrial work colours) on their very first character spawn.
--
-- "New" vs "returning" is tracked with a single DataStore flag per player
-- (MinerStarterOutfit_v1). We only ever WRITE that flag once, the first time
-- a player is granted the outfit; we never touch it again after that, and we
-- never re-check or reapply anything for returning players. This means we
-- only ever ADD to a first-time player's appearance after Roblox has finished
-- loading their own avatar (CharacterAppearanceLoaded fires after that), so
-- nothing the player customised through Roblox's avatar system is removed or
-- replaced -- we're layering a hat + recoloured limbs on top of it once.

local DataStoreService = game:GetService("DataStoreService")
local Players          = game:GetService("Players")

local outfitStore = DataStoreService:GetDataStore("MinerStarterOutfit_v1")

local SAFETY_YELLOW = Color3.fromRGB(255, 205, 15)
local SHIRT_COLOR    = BrickColor.new("Dark stone grey")
local PANTS_COLOR    = BrickColor.new("Reddish brown")

-- Per-player session state (keyed by UserId):
--   sessionGranted[id]      = true if this player was determined to be new at join time.
--                             Stays true for the whole session so the outfit is
--                             reapplied on every respawn, not just the first spawn.
--   writtenThisSession[id]  = true once the DataStore flag has been persisted,
--                             so we only write once even across multiple respawns.
local sessionGranted     = {}
local writtenThisSession = {}

local function createHardHat()
	local accessory = Instance.new("Accessory")
	accessory.Name = "MinerHardHat"
	accessory.AccessoryType = Enum.AccessoryType.Hat

	local handle          = Instance.new("Part")
	handle.Name           = "Handle"
	handle.Size           = Vector3.new(1.7, 1.1, 1.7)
	handle.Color          = SAFETY_YELLOW
	handle.Material       = Enum.Material.SmoothPlastic
	handle.CanCollide     = false
	handle.CanQuery       = false
	handle.Massless       = true
	handle.Parent         = accessory

	local mesh    = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Dome
	mesh.Scale    = Vector3.new(1, 0.6, 1)
	mesh.Parent   = handle

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

local function onCharacterAppearanceLoaded(player, character)
	if not sessionGranted[player.UserId] then return end

	applyOutfit(character)

	if not writtenThisSession[player.UserId] then
		writtenThisSession[player.UserId] = true
		local ok, err = pcall(function()
			outfitStore:SetAsync(tostring(player.UserId), true)
		end)
		if not ok then
			warn("[StarterOutfitService] Failed to persist outfit flag for", player.Name, ":", err)
		end
	end
end

local function onPlayerAdded(player)
	local ok, alreadyHasOutfit = pcall(function()
		return outfitStore:GetAsync(tostring(player.UserId))
	end)

	if not ok then
		warn("[StarterOutfitService] Could not read outfit flag for", player.Name, "-", alreadyHasOutfit)
		warn("[StarterOutfitService] Fix: Game Settings -> Security -> Enable Studio Access to API Services")
		-- Fail closed: if we can't tell whether this player is new, don't touch
		-- their appearance rather than risk overriding a returning player.
		sessionGranted[player.UserId] = false
	else
		sessionGranted[player.UserId] = not alreadyHasOutfit
	end

	player.CharacterAppearanceLoaded:Connect(function(character)
		onCharacterAppearanceLoaded(player, character)
	end)

	-- Guard against a race: if the character (and its appearance) already
	-- loaded before we connected above -- e.g. the local player in Studio
	-- Play testing, who's already in Players:GetPlayers() with a spawned
	-- Character by the time this service starts -- apply immediately too.
	if player.Character then
		onCharacterAppearanceLoaded(player, player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

print("[StarterOutfitService] Loaded")

return {}
