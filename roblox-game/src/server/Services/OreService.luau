-- OreService: Server-authoritative mining logic.
-- Scans Workspace.StarterMine for Parts with an OreType attribute and owns them:
-- adds ClickDetectors, health bars, particles, and sounds; processes every mine
-- request from clients; awards ore on vein break; schedules weighted respawn.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")
local StarterPack       = game:GetService("StarterPack")

local OreConfig = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("OreConfig"))
local Remotes   = ReplicatedStorage:WaitForChild("Remotes")

local MINE_FOLDER   = "StarterMine"
local MINING_POWER  = 25   -- Tier 1 pickaxe damage per swing; full system in Milestone 5
local MINING_RANGE  = 12   -- studs; server validates this on every request
local PICKAXE_NAME  = "Pickaxe"

-- keyed by Part.Name  →  { part, oreType, currentHP, maxHP, active }
local veins = {}

-- ── Pickaxe tool ───────────────────────────────────────────────────────────

local function createPickaxeTool()
	local tool              = Instance.new("Tool")
	tool.Name               = PICKAXE_NAME
	tool.ToolTip            = "Basic Pickaxe  |  Mining Power 1"
	tool.CanBeDropped       = false
	tool.RequiresHandle     = true
	-- Position the grip so the player holds the lower third of the shaft
	tool.GripPos            = Vector3.new(0, 0, -0.4)

	-- Shaft (the handle the player grips)
	local shaft             = Instance.new("Part")
	shaft.Name              = "Handle"
	shaft.Size              = Vector3.new(0.2, 0.2, 1.4)
	shaft.Color             = Color3.fromRGB(106, 76, 47)
	shaft.Material          = Enum.Material.Wood
	shaft.Parent            = tool

	-- Head (the metal pick end, welded to the shaft)
	local head              = Instance.new("Part")
	head.Name               = "Head"
	head.Size               = Vector3.new(0.15, 0.5, 0.7)
	head.Color              = Color3.fromRGB(163, 162, 165)
	head.Material           = Enum.Material.Metal
	head.Parent             = tool

	local weld              = Instance.new("WeldConstraint")
	weld.Part0              = shaft
	weld.Part1              = head
	weld.Parent             = shaft
	-- Place head at the front tip of the shaft, rotated 90° so it sits crossways
	head.CFrame             = shaft.CFrame * CFrame.new(0, 0, 0.7) * CFrame.Angles(0, 0, math.rad(90))

	return tool
end

local function givePickaxe(player)
	local backpack = player:FindFirstChild("Backpack")
	if backpack and not backpack:FindFirstChild(PICKAXE_NAME) then
		createPickaxeTool().Parent = backpack
	end
end

-- StarterPack ensures the pickaxe is re-given automatically on every respawn
createPickaxeTool().Parent = StarterPack

-- Give to any players already in the game when this service loads
Players.PlayerAdded:Connect(givePickaxe)
for _, player in ipairs(Players:GetPlayers()) do
	givePickaxe(player)
end

-- ── Helpers ────────────────────────────────────────────────────────────────

local function rollOreType()
	-- Weighted random using SpawnChance values
	local total = 0
	for _, data in pairs(OreConfig) do total += data.SpawnChance end
	local roll = math.random() * total
	local cumulative = 0
	for oreType, data in pairs(OreConfig) do
		cumulative += data.SpawnChance
		if roll <= cumulative then return oreType end
	end
	return "stone"
end

local function crackedColor(oreType, healthPct)
	-- Lerp from the ore's natural colour toward light grey as HP falls
	return OreConfig[oreType].Color:Lerp(Color3.fromRGB(210, 210, 210), 1 - healthPct)
end

local function crackedMaterial(healthPct)
	-- Three visual stages: undamaged → concrete → slate
	if healthPct > 0.66 then return Enum.Material.SmoothPlastic
	elseif healthPct > 0.33 then return Enum.Material.Concrete
	else return Enum.Material.Slate
	end
end

-- ── Per-vein GUI & effects (created server-side so they replicate) ─────────

local function createHealthBar(part)
	local billboard = Instance.new("BillboardGui")
	billboard.Name          = "VeinHealthBar"
	billboard.Size          = UDim2.new(0, 80, 0, 10)
	billboard.StudsOffset   = Vector3.new(0, part.Size.Y / 2 + 1.4, 0)
	billboard.AlwaysOnTop   = false
	billboard.Enabled       = false  -- hidden until first hit
	billboard.Parent        = part

	local bg = Instance.new("Frame")
	bg.Name                 = "Background"
	bg.Size                 = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3     = Color3.fromRGB(30, 30, 30)
	bg.BorderSizePixel      = 0
	bg.Parent               = billboard

	local bar = Instance.new("Frame")
	bar.Name                = "Bar"
	bar.Size                = UDim2.new(1, 0, 1, 0)
	bar.BackgroundColor3    = Color3.fromRGB(0, 200, 50)
	bar.BorderSizePixel     = 0
	bar.Parent              = bg
end

local function setHealthBar(part, healthPct)
	-- Only updates the bar's size and colour; Enabled is managed client-side
	-- so each player can independently show/hide based on their distance.
	local gui = part:FindFirstChild("VeinHealthBar")
	if not gui then return end
	local bar = gui.Background and gui.Background:FindFirstChild("Bar")
	if not bar then return end
	bar.Size             = UDim2.new(math.max(0, healthPct), 0, 1, 0)
	bar.BackgroundColor3 = Color3.fromRGB(
		math.floor(200 * (1 - healthPct)),
		math.floor(200 * healthPct),
		0
	)
end

local function addEffects(part)
	-- Dust particles — emitted client-side via Emit(); Rate=0 means no auto-emission
	local dust              = Instance.new("ParticleEmitter")
	dust.Name               = "DustEffect"
	dust.Color              = ColorSequence.new(Color3.fromRGB(185, 165, 135))
	dust.Size               = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.35),
		NumberSequenceKeypoint.new(1, 0),
	})
	dust.Lifetime           = NumberRange.new(0.3, 0.6)
	dust.Speed              = NumberRange.new(4, 10)
	dust.SpreadAngle        = Vector2.new(70, 70)
	dust.Rate               = 0
	dust.Parent             = part

	-- Hit sound (short rock impact, 0.9s — ProSoundEffects)
	local hit               = Instance.new("Sound")
	hit.Name                = "HitSound"
	hit.SoundId             = "rbxassetid://9118617342"
	hit.Volume              = 0.55
	hit.RollOffMaxDistance  = 35
	hit.Parent              = part

	-- Break sound (rock drop/crack, 1.5s — ProSoundEffects)
	local brk               = Instance.new("Sound")
	brk.Name                = "BreakSound"
	brk.SoundId             = "rbxassetid://9118587494"
	brk.Volume              = 0.8
	brk.RollOffMaxDistance  = 45
	brk.Parent              = part
end

-- ── Vein lifecycle ─────────────────────────────────────────────────────────

local function initVein(part)
	local oreType = part:GetAttribute("OreType")
	if not oreType or not OreConfig[oreType] then return end

	-- Remove any ProximityPrompts left over from earlier milestones
	local pp = part:FindFirstChildOfClass("ProximityPrompt")
	if pp then pp:Destroy() end

	local config    = OreConfig[oreType]
	part.Color      = config.Color
	part.Material   = Enum.Material.SmoothPlastic
	part.Anchored   = true

	local cd                     = Instance.new("ClickDetector")
	cd.Name                      = "ClickDetector"
	cd.MaxActivationDistance     = MINING_RANGE
	cd.Parent                    = part

	createHealthBar(part)
	addEffects(part)

	veins[part.Name] = {
		part      = part,
		oreType   = oreType,
		currentHP = config.VeinHP,
		maxHP     = config.VeinHP,
		active    = true,
	}
end

local function respawnVein(veinState)
	if not veinState.part or not veinState.part.Parent then return end

	local newOreType   = rollOreType()
	local config       = OreConfig[newOreType]
	local part         = veinState.part

	veinState.oreType  = newOreType
	veinState.currentHP = config.VeinHP
	veinState.maxHP    = config.VeinHP
	veinState.active   = true

	part:SetAttribute("OreType", newOreType)
	part.Color         = config.Color
	part.Material      = Enum.Material.SmoothPlastic
	part.Transparency  = 0
	part.CanCollide    = true

	local cd = part:FindFirstChild("ClickDetector")
	if cd then cd.MaxActivationDistance = MINING_RANGE end

	setHealthBar(part, 1)

	Remotes.Ore_VeinSpawned:FireAllClients(part.Name, newOreType)
	print(string.format("[OreService] Vein %s respawned as %s", part.Name, newOreType))
end

-- Placeholder — real implementation in Milestone 3 (InventoryService)
local function awardOre(player, oreType, amount)
	print(string.format("[OreService] AWARD → %s received %d × %s", player.Name, amount, oreType))
	-- TODO Milestone 3: InventoryService.addOre(player, oreType, amount)
end

-- ── Remote handler ─────────────────────────────────────────────────────────

local function onMineOre(player, veinName)
	if type(veinName) ~= "string" then return end

	local veinState = veins[veinName]
	if not veinState or not veinState.active then return end

	-- Validate character exists and pickaxe is equipped (held, not just in backpack)
	local character = player.Character
	if not character then return end
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local equippedTool = character:FindFirstChildOfClass("Tool")
	if not equippedTool or equippedTool.Name ~= PICKAXE_NAME then return end

	-- Server-side range check
	if (root.Position - veinState.part.Position).Magnitude > MINING_RANGE + 4 then return end

	-- Apply damage
	veinState.currentHP = math.max(0, veinState.currentHP - MINING_POWER)
	local healthPct = veinState.currentHP / veinState.maxHP

	-- Update crack visuals on server (replicate to all clients automatically)
	veinState.part.Color    = crackedColor(veinState.oreType, healthPct)
	veinState.part.Material = crackedMaterial(healthPct)
	setHealthBar(veinState.part, healthPct)

	if veinState.currentHP <= 0 then
		-- ── Vein breaks ──
		veinState.active = false

		local cd = veinState.part:FindFirstChild("ClickDetector")
		if cd then cd.MaxActivationDistance = 0 end
		veinState.part.Transparency = 1
		veinState.part.CanCollide   = false  -- player walks through the broken vein

		awardOre(player, veinState.oreType, 1)

		Remotes.Ore_VeinBroke:FireAllClients(veinName)
		Remotes.Ore_OreAwarded:FireClient(player, veinState.oreType, 1)

		local respawnTime = OreConfig[veinState.oreType].RespawnSeconds
		task.delay(respawnTime, function() respawnVein(veinState) end)
	else
		-- ── Normal hit ──
		Remotes.Ore_VeinHit:FireAllClients(veinName, healthPct)
	end
end

Remotes.MineOre.OnServerEvent:Connect(onMineOre)

-- ── Scan Workspace.StarterMine ─────────────────────────────────────────────

local mineFolder = workspace:WaitForChild(MINE_FOLDER, 10)
local count = 0

if not mineFolder then
	warn("[OreService] Workspace folder '" .. MINE_FOLDER .. "' not found — 0 veins registered")
else
	for _, child in ipairs(mineFolder:GetChildren()) do
		if child:IsA("BasePart") and child:GetAttribute("OreType") then
			initVein(child)
			count += 1
		end
	end
end

local OreService = {}
print("[OreService] Loaded — " .. count .. " veins registered")
return OreService
