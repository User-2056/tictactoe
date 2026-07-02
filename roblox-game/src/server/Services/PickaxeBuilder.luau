-- PickaxeBuilder: Constructs the visual Tool model for a given pickaxe tier.
-- Pure builder -- reads EquipmentConfig's per-tier Visual spec and returns an
-- unparented Tool. Adding a new tier (Titanium, Quantum, ...) is purely a new
-- Pickaxes entry in EquipmentConfig; nothing here needs to change.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipmentConfig = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("EquipmentConfig"))

local pickaxeById = {}
for _, p in ipairs(EquipmentConfig.Pickaxes) do pickaxeById[p.Id] = p end

local PickaxeBuilder = {}

function PickaxeBuilder.build(pickaxeId)
	local config = pickaxeById[pickaxeId]
	if not config then
		warn("[PickaxeBuilder] Unknown pickaxe id: " .. tostring(pickaxeId) .. " -- falling back to starter_pickaxe")
		pickaxeId = "starter_pickaxe"
		config    = pickaxeById[pickaxeId]
	end
	local visual = config.Visual

	local tool           = Instance.new("Tool")
	tool.Name            = EquipmentConfig.ToolName
	tool.ToolTip         = string.format("%s  |  Mining Power ×%d", config.Name, config.MiningPower)
	tool.CanBeDropped    = false
	tool.RequiresHandle  = true
	-- Position the grip so the player holds the lower third of the shaft
	tool.GripPos         = Vector3.new(0, 0, -0.4)
	tool:SetAttribute("PickaxeId", pickaxeId)

	-- Shaft (the handle the player grips)
	local handle          = Instance.new("Part")
	handle.Name           = "Handle"
	handle.Size           = visual.HandleSize
	handle.Color          = visual.HandleColor
	handle.Material       = visual.HandleMaterial
	handle.Parent         = tool

	-- Head (welded at the front tip of the shaft)
	local head             = Instance.new("Part")
	head.Name              = "Head"
	head.Size              = visual.HeadSize
	head.Color             = visual.HeadColor
	head.Material          = visual.HeadMaterial
	head.Parent            = tool

	-- Use Weld (not WeldConstraint) so C0 defines the offset explicitly.
	-- WeldConstraint captures whatever the *current* relative CFrame happens to be at the moment it
	-- goes live, not at creation time -- unreliable here since the tool moves from the Backpack
	-- (parts at origin) into the player's hand. Same gotcha documented in StarterOutfitService.luau's
	-- hat Brim/Ridge.
	-- Offset is handle-half-length PLUS head-half-depth so the head sits fully past the tip of the
	-- shaft instead of centered on it -- centering it on the tip buries half the head's volume
	-- inside the handle, which reads as "missing" rather than as a distinct piece at a glance.
	-- NEGATIVE Z: with this Tool's GripPos, +Z points back toward the character's hand/body, not
	-- away from it -- confirmed by testing, opposite of the "front tip" assumption in the comment
	-- above (which matched the original single-tier tool, but that tool's head was apparently never
	-- actually confirmed visible either). -Z is the side that reads as sticking out from the body.
	local headWeld         = Instance.new("Weld")
	headWeld.Part0          = handle
	headWeld.Part1          = head
	headWeld.C0             = CFrame.new(0, 0, -(visual.HandleSize.Z / 2 + visual.HeadSize.Z / 2))
	headWeld.Parent         = handle

	-- Reinforcement bands (Iron/Steel) -- flat rings wrapped around the handle, same
	-- rotated-Cylinder trick as StarterOutfitService's clothing trim rings. That helper
	-- rotates around Z (CFrame.Angles(0, 0, 90°)) because it wraps Y-long limbs; the
	-- Handle here is Z-long, so the rotation is around Y instead (CFrame.Angles(0, 90°, 0))
	-- to swing the Cylinder's default X-axis onto Z.
	for i, band in ipairs(visual.Bands or {}) do
		local ring           = Instance.new("Part")
		ring.Name            = "Band" .. i
		ring.Shape           = Enum.PartType.Cylinder
		ring.Size            = band.Size
		ring.Color           = band.Color
		ring.Material        = band.Material
		ring.Parent          = tool

		-- Same -Z flip as the head weld above -- OffsetZ in EquipmentConfig is written as
		-- "distance from handle center toward the head", so it needs the same sign correction.
		local ringWeld         = Instance.new("Weld")
		ringWeld.Part0          = handle
		ringWeld.Part1          = ring
		ringWeld.C0             = CFrame.new(0, 0, -band.OffsetZ) * CFrame.Angles(0, math.rad(90), 0)
		ringWeld.Parent         = handle
	end

	return tool
end

return PickaxeBuilder
