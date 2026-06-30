-- MiningController: Client-side mining interaction and visual feedback.
-- Responsibilities:
--   * Detects pickaxe clicks on ore vein primaries AND their satellite children
--   * Plays hit/break sounds; triggers dust particles
--   * Drives satellite cluster visuals: crack stages, break shrink/fade, respawn restore
--   * Shows/hides the per-vein health bar based on player distance
--   * Shows a brief ore reward popup on vein break (once per break, no per-hit numbers)

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Remotes          = ReplicatedStorage:WaitForChild("Remotes")
local MineOre          = Remotes:WaitForChild("MineOre")
local Ore_VeinHit      = Remotes:WaitForChild("Ore_VeinHit")
local Ore_VeinBroke    = Remotes:WaitForChild("Ore_VeinBroke")
local Ore_VeinSpawned  = Remotes:WaitForChild("Ore_VeinSpawned")
local Ore_OreAwarded   = Remotes:WaitForChild("Ore_OreAwarded")
local Ore_HitBlocked   = Remotes:WaitForChild("Ore_HitBlocked")

local mineFolder = workspace:WaitForChild("StarterMine")

-- Veins that have taken at least one hit and not yet fully respawned.
-- Health bar is only shown for these when the player is nearby.
local damagedVeins    = {}
local HEALTH_BAR_RANGE = 22

-- Visual config for ore-piece satellites per ore type.
-- Rock-piece satellites always use Rock→Concrete→Slate material progression.
local SAT_ORE_CFG = {
	stone = nil,  -- stone has no ore satellite pieces; plain rock only
	coal  = { Material = Enum.Material.Slate,         Color = Color3.fromRGB(28,  26,  28 ) },
	iron  = { Material = Enum.Material.CorrodedMetal, Color = Color3.fromRGB(110, 70,  50 ) },
	gold  = { Material = Enum.Material.Foil,          Color = Color3.fromRGB(220, 180, 30 ) },
}

-- Original satellite sizes cached at load for restoring after break shrink animation
local satOriginalSizes = {}  -- { [veinName] = { [childName] = Vector3 } }

-- ── Initialisation scan ───────────────────────────────────────────────────────
-- Runs before Play starts; caches satellite sizes and tightens the health bar.

for _, part in ipairs(mineFolder:GetChildren()) do
	if not (part:IsA("BasePart") and part:GetAttribute("OreType")) then continue end

	local sizes = {}
	for _, child in ipairs(part:GetChildren()) do
		if child:IsA("BasePart") then
			sizes[child.Name] = child.Size
		end
	end
	satOriginalSizes[part.Name] = sizes

	-- Override the health bar that OreService will create at runtime.
	-- We shrink it and push it above the full cluster height, not just above the primary.
	-- OreService creates the BillboardGui once and never re-sets its properties after that,
	-- so this local override persists for the session.
	local gui = part:FindFirstChild("VeinHealthBar")
	if gui then
		gui.Size        = UDim2.new(0, 64, 0, 7)
		gui.StudsOffset = Vector3.new(0, 3.8, 0)
	end
end

-- ── Tool interaction ──────────────────────────────────────────────────────────
-- Roblox silences ClickDetectors when a Tool is equipped; clicks come through
-- Tool.Activated instead. Mouse.Target can be a satellite child of a vein, so we
-- walk up to the primary Part before firing the remote.

local mouse = player:GetMouse()

local function findVeinPart(target)
	if not target then return nil end
	-- Direct click on the primary vein part
	if target.Parent == mineFolder and target:GetAttribute("OreType") then
		return target
	end
	-- Click on a satellite that is a child of a primary vein part
	local p = target.Parent
	if p and p:IsA("BasePart") and p.Parent == mineFolder and p:GetAttribute("OreType") then
		return p
	end
	return nil
end

local function onPickaxeActivated()
	local veinPart = findVeinPart(mouse.Target)
	if not veinPart then return end
	MineOre:FireServer(veinPart.Name)
end

local function watchTool(item)
	if item:IsA("Tool") and item.Name == "Pickaxe" then
		item.Activated:Connect(onPickaxeActivated)
	end
end

local function onCharacterAdded(character)
	character.ChildAdded:Connect(watchTool)
	local existing = character:FindFirstChild("Pickaxe")
	if existing then watchTool(existing) end
end

local character = player.Character or player.CharacterAdded:Wait()
onCharacterAdded(character)
player.CharacterAdded:Connect(onCharacterAdded)

-- ── Satellite crack-stage helper ──────────────────────────────────────────────
-- Called on every hit. Rock-body satellites step through Rock→Concrete→Slate;
-- ore-piece satellites fade their colour toward grey as health drops.
-- Both changes are local-only; every client receives the same healthPct so they
-- stay in sync without any extra server involvement.

local function updateSatelliteCracks(part, healthPct)
	local oreType = part:GetAttribute("OreType")
	local satCfg  = oreType and SAT_ORE_CFG[oreType]

	for _, child in ipairs(part:GetChildren()) do
		if not child:IsA("BasePart") then continue end
		local role = child:GetAttribute("Role")

		if role == "rock" then
			if healthPct > 0.66 then
				child.Material = Enum.Material.Rock
				child.Color    = Color3.fromRGB(140, 135, 128)
			elseif healthPct > 0.33 then
				child.Material = Enum.Material.Concrete
				child.Color    = Color3.fromRGB(118, 113, 107)
			else
				child.Material = Enum.Material.Slate
				child.Color    = Color3.fromRGB(98, 95, 91)
			end

		elseif role == "ore" and satCfg then
			child.Color = satCfg.Color:Lerp(Color3.fromRGB(128, 126, 124), 1 - healthPct)
		end
	end
end

-- ── Blocked hit ───────────────────────────────────────────────────────────────

Ore_HitBlocked.OnClientEvent:Connect(function(veinName)
	damagedVeins[veinName] = true
	local part = mineFolder:FindFirstChild(veinName)
	if not part then return end
	local sound = part:FindFirstChild("HollowSound")
	if sound then sound:Play() end
end)

-- ── Hit effect ────────────────────────────────────────────────────────────────

Ore_VeinHit.OnClientEvent:Connect(function(veinName, healthPct)
	damagedVeins[veinName] = true
	local part = mineFolder:FindFirstChild(veinName)
	if not part then return end

	local dust = part:FindFirstChild("DustEffect")
	if dust then dust:Emit(6) end

	local sound = part:FindFirstChild("HitSound")
	if sound then sound:Play() end

	updateSatelliteCracks(part, healthPct)
end)

-- ── Break effect ──────────────────────────────────────────────────────────────
-- Larger dust burst, then satellite parts shrink and fade with a slight suck-in
-- (Back.In easing) rather than an instant pop — reads as more satisfying.

Ore_VeinBroke.OnClientEvent:Connect(function(veinName)
	damagedVeins[veinName] = nil
	local part = mineFolder:FindFirstChild(veinName)
	if not part then return end

	local dust = part:FindFirstChild("DustEffect")
	if dust then dust:Emit(28) end

	local sound = part:FindFirstChild("BreakSound")
	if sound then sound:Play() end

	for _, child in ipairs(part:GetChildren()) do
		if child:IsA("BasePart") then
			child.CanCollide = false
			TweenService:Create(
				child,
				TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In),
				{ Size = Vector3.new(0.05, 0.05, 0.05), Transparency = 1 }
			):Play()
		end
	end
end)

-- ── Respawn ───────────────────────────────────────────────────────────────────
-- Restores satellite sizes, visibility, material, and colour for the new ore type.
-- OreService already restores the primary Part's colour/material server-side.

Ore_VeinSpawned.OnClientEvent:Connect(function(veinName, newOreType)
	damagedVeins[veinName] = nil
	local part = mineFolder:FindFirstChild(veinName)
	if not part then return end

	local satCfg    = SAT_ORE_CFG[newOreType]
	local origSizes = satOriginalSizes[veinName] or {}

	for _, child in ipairs(part:GetChildren()) do
		if not child:IsA("BasePart") then continue end

		local orig = origSizes[child.Name]
		if orig then child.Size = orig end
		child.Transparency = 0

		local role = child:GetAttribute("Role")
		if role == "rock" then
			child.Material   = Enum.Material.Rock
			child.Color      = Color3.fromRGB(140, 135, 128)
			child.CanCollide = true
		elseif role == "ore" then
			child.Material   = satCfg and satCfg.Material or Enum.Material.Rock
			child.Color      = satCfg and satCfg.Color    or Color3.fromRGB(140, 135, 128)
			child.CanCollide = false
		end
	end
end)

-- ── Distance-based health bar visibility ──────────────────────────────────────

RunService.Heartbeat:Connect(function()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	for _, part in ipairs(mineFolder:GetChildren()) do
		if part:IsA("BasePart") then
			local gui = part:FindFirstChild("VeinHealthBar")
			if gui then
				local isDamaged = damagedVeins[part.Name] == true
				local inRange   = (root.Position - part.Position).Magnitude <= HEALTH_BAR_RANGE
				gui.Enabled     = isDamaged and inRange
			end
		end
	end
end)

-- ── Ore reward popup ──────────────────────────────────────────────────────────
-- Fired once per break (not per hit). Small, non-flashy text above centre screen.

Ore_OreAwarded.OnClientEvent:Connect(function(oreType, amount)
	local hud = playerGui:FindFirstChild("HUD")
	if not hud then return end

	local displayName = oreType:sub(1,1):upper() .. oreType:sub(2)

	local label = Instance.new("TextLabel")
	label.Size                   = UDim2.new(0, 180, 0, 28)
	label.Position               = UDim2.new(0.5, -90, 0.74, 0)
	label.BackgroundTransparency = 1
	label.TextColor3             = Color3.fromRGB(255, 225, 90)
	label.TextStrokeTransparency = 0.4
	label.Font                   = Enum.Font.GothamBold
	label.TextSize               = 17
	label.Text                   = string.format("+%d %s", amount, displayName)
	label.TextXAlignment         = Enum.TextXAlignment.Center
	label.TextTransparency       = 1
	label.ZIndex                 = 10
	label.Parent                 = hud

	TweenService:Create(label, TweenInfo.new(0.15), { TextTransparency = 0 }):Play()

	task.delay(1.1, function()
		local out = TweenService:Create(label, TweenInfo.new(0.35), {
			TextTransparency       = 1,
			TextStrokeTransparency = 1,
			Position               = UDim2.new(0.5, -90, 0.71, 0),
		})
		out:Play()
		out.Completed:Connect(function() label:Destroy() end)
	end)
end)

print("[MiningController] Loaded")
