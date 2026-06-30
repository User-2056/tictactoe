-- MiningController: Client-side mining interaction and visual feedback.
-- Responsibilities:
--   * Detects pickaxe clicks on ore vein primaries AND their satellite children
--   * Plays hit/break sounds; triggers dust particles
--   * Progressive satellite disintegration: pieces break off at HP thresholds,
--     fly outward, and fade — remaining pieces crack and darken as damage accumulates
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

local damagedVeins    = {}
local HEALTH_BAR_RANGE = 22

-- Visual config for ore-piece satellites per ore type
local SAT_ORE_CFG = {
	stone = nil,
	coal  = { Material = Enum.Material.Slate,         Color = Color3.fromRGB(28,  26,  28 ) },
	iron  = { Material = Enum.Material.CorrodedMetal, Color = Color3.fromRGB(110, 70,  50 ) },
	gold  = { Material = Enum.Material.Foil,          Color = Color3.fromRGB(220, 180, 30 ) },
}

-- Which satellite piece breaks off at each health threshold, per ore type.
-- Listed in descending threshold order (first entry triggers first).
-- Thresholds are tuned to hit evenly-spaced hit counts for each ore's HP pool:
--   stone (100 HP, 4 hits@MP1): Rock2 at hit 2
--   coal  (150 HP, 6 hits@MP1): Ore2 at hit 2, Ore1 at hit 4
--   iron  (250 HP, 10 hits@MP1): Ore2 at hit 3, Ore1 at hit 7
--   gold  (500 HP, 20 hits@MP1): Ore3 at hit 6, Ore2 at hit 11, Ore1 at hit 16
local BREAK_SCHEDULE = {
	stone = {
		{ name = "Rock2", threshold = 0.55 },
	},
	coal = {
		{ name = "Ore2", threshold = 0.70 },
		{ name = "Ore1", threshold = 0.35 },
	},
	iron = {
		{ name = "Ore2", threshold = 0.70 },
		{ name = "Ore1", threshold = 0.35 },
	},
	gold = {
		{ name = "Ore3", threshold = 0.70 },
		{ name = "Ore2", threshold = 0.45 },
		{ name = "Ore1", threshold = 0.20 },
	},
}

-- Pieces already broken off this life cycle; cleared on respawn
local brokenPieces = {}  -- { ["VeinName-ChildName"] = true }

-- Original satellite CFrames and sizes cached at load for restoring after break
local satOriginalCFrames = {}  -- { [veinName] = { [childName] = CFrame } }
local satOriginalSizes   = {}  -- { [veinName] = { [childName] = Vector3 } }

-- ── Initialisation scan ───────────────────────────────────────────────────────

for _, part in ipairs(mineFolder:GetChildren()) do
	if not (part:IsA("BasePart") and part:GetAttribute("OreType")) then continue end

	local cframes, sizes = {}, {}
	for _, child in ipairs(part:GetChildren()) do
		if child:IsA("BasePart") then
			cframes[child.Name] = child.CFrame
			sizes[child.Name]   = child.Size
		end
	end
	satOriginalCFrames[part.Name] = cframes
	satOriginalSizes[part.Name]   = sizes

	local gui = part:FindFirstChild("VeinHealthBar")
	if gui then
		gui.Size        = UDim2.new(0, 64, 0, 7)
		gui.StudsOffset = Vector3.new(0, 3.8, 0)
	end
end

-- ── Tool interaction ──────────────────────────────────────────────────────────

local mouse = player:GetMouse()

local function findVeinPart(target)
	if not target then return nil end
	if target.Parent == mineFolder and target:GetAttribute("OreType") then
		return target
	end
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

-- ── Break-off animation ───────────────────────────────────────────────────────
-- The piece flies radially away from the vein centre (direction derived from
-- its offset relative to the primary), rises slightly, then fades out.
-- Using the geometric direction makes the scatter deterministic — every client
-- sees the same piece fly the same way, which looks correct in multiplayer.

local function breakOffPiece(primaryPart, child)
	child.CanCollide = false

	-- Radial outward direction from the cluster centre
	local offset = child.Position - primaryPart.Position
	local dir    = offset.Magnitude > 0.5 and offset.Unit or Vector3.new(1, 0, 0)

	-- Fly 3 studs outward + 2 studs up, shrink to 20 % of original size
	local targetCF   = CFrame.new(child.Position + dir * 3 + Vector3.new(0, 2, 0))
		* (child.CFrame - child.CFrame.Position)  -- preserve orientation
	local targetSize = child.Size * 0.2

	TweenService:Create(
		child,
		TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ CFrame = targetCF, Size = targetSize, Transparency = 1 }
	):Play()
end

-- ── Satellite crack-stage helper ──────────────────────────────────────────────
-- Only updates satellites that have NOT already broken off.

local function updateSatelliteCracks(veinName, part, healthPct)
	local oreType = part:GetAttribute("OreType")
	local satCfg  = oreType and SAT_ORE_CFG[oreType]

	for _, child in ipairs(part:GetChildren()) do
		if not child:IsA("BasePart") then continue end
		if brokenPieces[veinName .. "-" .. child.Name] then continue end

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

	-- Progressive satellite disintegration: break off pieces at HP thresholds
	local oreType  = part:GetAttribute("OreType")
	local schedule = oreType and BREAK_SCHEDULE[oreType]
	if schedule then
		for _, entry in ipairs(schedule) do
			local key = veinName .. "-" .. entry.name
			if not brokenPieces[key] and healthPct <= entry.threshold then
				brokenPieces[key] = true
				local piece = part:FindFirstChild(entry.name)
				if piece and piece:IsA("BasePart") then
					breakOffPiece(part, piece)
				end
			end
		end
	end

	-- Update crack stages on pieces that are still present
	updateSatelliteCracks(veinName, part, healthPct)
end)

-- ── Break effect ──────────────────────────────────────────────────────────────
-- Larger dust burst; remaining (not yet broken-off) satellites shrink and fade.

Ore_VeinBroke.OnClientEvent:Connect(function(veinName)
	damagedVeins[veinName] = nil
	local part = mineFolder:FindFirstChild(veinName)
	if not part then return end

	local dust = part:FindFirstChild("DustEffect")
	if dust then dust:Emit(28) end

	local sound = part:FindFirstChild("BreakSound")
	if sound then sound:Play() end

	for _, child in ipairs(part:GetChildren()) do
		if not child:IsA("BasePart") then continue end
		local key = veinName .. "-" .. child.Name
		if brokenPieces[key] then continue end  -- already gone; skip
		child.CanCollide = false
		TweenService:Create(
			child,
			TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{ Size = Vector3.new(0.05, 0.05, 0.05), Transparency = 1 }
		):Play()
	end
end)

-- ── Respawn ───────────────────────────────────────────────────────────────────

Ore_VeinSpawned.OnClientEvent:Connect(function(veinName, newOreType)
	damagedVeins[veinName] = nil

	-- Clear break-off state for this vein so pieces trigger again next life
	for key in pairs(brokenPieces) do
		if key:sub(1, #veinName + 1) == veinName .. "-" then
			brokenPieces[key] = nil
		end
	end

	local part = mineFolder:FindFirstChild(veinName)
	if not part then return end

	local satCfg     = SAT_ORE_CFG[newOreType]
	local origCF     = satOriginalCFrames[veinName] or {}
	local origSizes  = satOriginalSizes[veinName]   or {}

	for _, child in ipairs(part:GetChildren()) do
		if not child:IsA("BasePart") then continue end

		-- Restore to original world CFrame and size (undoes fly-away tweens)
		if origCF[child.Name]    then child.CFrame = origCF[child.Name]    end
		if origSizes[child.Name] then child.Size   = origSizes[child.Name] end
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
