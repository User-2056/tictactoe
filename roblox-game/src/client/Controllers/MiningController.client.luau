-- MiningController: Client-side mining interaction and visual feedback.
-- Responsibilities:
--   * Detects when the player clicks an ore vein and fires MineOre to the server
--   * Plays hit/break sounds and triggers dust particles (effects run on each client)
--   * Shows/hides the health bar per-player based on distance
--   * Shows a small, non-flashy ore reward popup when a vein is broken
-- The server owns all game logic; this controller only requests and responds.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for Bootstrap to create the Remotes folder (happens at server start)
local Remotes         = ReplicatedStorage:WaitForChild("Remotes")
local MineOre         = Remotes:WaitForChild("MineOre")
local Ore_VeinHit     = Remotes:WaitForChild("Ore_VeinHit")
local Ore_VeinBroke   = Remotes:WaitForChild("Ore_VeinBroke")
local Ore_VeinSpawned = Remotes:WaitForChild("Ore_VeinSpawned")
local Ore_OreAwarded  = Remotes:WaitForChild("Ore_OreAwarded")

local mineFolder = workspace:WaitForChild("StarterMine")

-- Tracks which veins have taken damage and haven't yet fully respawned.
-- The health bar is only shown when a vein is in this set AND the player is nearby.
local damagedVeins    = {}  -- { [veinName] = true }
local HEALTH_BAR_RANGE = 22  -- studs; slightly wider than mining range so bar stays visible while swinging

-- ── Helpers ──────────────────────────────────────────────────────────────────

local function findVein(name)
	return mineFolder:FindFirstChild(name)
end

-- ── Click interaction setup ───────────────────────────────────────────────────
-- OreService (server) adds a ClickDetector to each vein Part and it replicates.
-- We wait for it, then wire up click -> FireServer.

local function setupVein(part)
	if not (part:IsA("BasePart") and part:GetAttribute("OreType")) then return end

	local cd = part:WaitForChild("ClickDetector", 10)
	if not cd then return end

	cd.MouseClick:Connect(function()
		MineOre:FireServer(part.Name)
	end)
end

for _, child in ipairs(mineFolder:GetChildren()) do
	task.spawn(setupVein, child)
end

mineFolder.ChildAdded:Connect(function(child)
	task.spawn(setupVein, child)
end)

-- ── Hit effect: dust + sound ──────────────────────────────────────────────────

Ore_VeinHit.OnClientEvent:Connect(function(veinName, healthPct)
	damagedVeins[veinName] = true  -- mark so heartbeat can show the health bar

	local part = findVein(veinName)
	if not part then return end

	local dust = part:FindFirstChild("DustEffect")
	if dust then dust:Emit(6) end

	local sound = part:FindFirstChild("HitSound")
	if sound then sound:Play() end
end)

-- ── Break effect: large dust burst + break sound ──────────────────────────────

Ore_VeinBroke.OnClientEvent:Connect(function(veinName)
	damagedVeins[veinName] = nil  -- vein is gone; clear so bar won't reappear

	local part = findVein(veinName)
	if not part then return end

	local dust = part:FindFirstChild("DustEffect")
	if dust then dust:Emit(22) end

	local sound = part:FindFirstChild("BreakSound")
	if sound then sound:Play() end
end)

-- ── Respawn: new ore at full health — hide bar until it is hit again ──────────

Ore_VeinSpawned.OnClientEvent:Connect(function(veinName, newOreType)
	damagedVeins[veinName] = nil
	-- Color/Material/Transparency changes replicate from server automatically.
end)

-- ── Distance-based health bar visibility ─────────────────────────────────────
-- Runs every frame. Each client shows the bar only for veins it has personally
-- seen get hit AND that are within HEALTH_BAR_RANGE studs. No server involvement.

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
-- Small, brief text shown only to the player who broke the vein.
-- Not a per-hit number — fires once on break.

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

	TweenService:Create(label, TweenInfo.new(0.15), {TextTransparency = 0}):Play()

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
