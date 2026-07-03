-- ShopController: Frontier Mining Supplies shop — opened by ProximityPrompt on the kiosk.
-- Reads EquipmentConfig from ReplicatedStorage for display; fires PurchaseEquipment to server.
-- Layout: category sidebar (Pickaxes/Backpacks) -> item list -> selected-item preview pane
-- with the purchase/equip action, matching the reference board's shop mockup.
-- Refreshes automatically when Eq_Update or Eco_CreditsUpdate arrive.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local PurchaseEquipment = Remotes:WaitForChild("PurchaseEquipment")
local EquipItem         = Remotes:WaitForChild("EquipItem")
local Eq_Update         = Remotes:WaitForChild("Eq_Update")
local Eco_CreditsUpdate = Remotes:WaitForChild("Eco_CreditsUpdate")

local EquipmentConfig = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("EquipmentConfig"))

-- ── State ────────────────────────────────────────────────────────────────────

local cachedBalance      = 0
local equippedPickaxeId  = "starter_pickaxe"
local equippedBackpackId = "starter_backpack"
local ownedPickaxes      = { ["starter_pickaxe"]  = true }
local ownedBackpacks     = { ["starter_backpack"] = true }
local pendingPurchaseId  = nil   -- set when purchase fires; cleared when Eq_Update confirms it
local isShopOpen         = false

local selectedType = "pickaxe"
local selectedItem = EquipmentConfig.Pickaxes[1]

-- Forward-declared: makeTab/makeListRow's click handlers reference these before
-- they're assigned below, and selectItem/selectCategory call each other.
local refreshPreview, refreshList, selectItem, selectCategory

-- ── Helpers ──────────────────────────────────────────────────────────────────

local function addCorner(inst, r)
	local c           = Instance.new("UICorner")
	c.CornerRadius    = UDim.new(0, r)
	c.Parent          = inst
end

local function addStroke(inst, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.3
	s.Parent = inst
end

local function fmtNum(n)
	local s = tostring(math.floor(n)):reverse()
	return (s:gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

-- ── Visual tokens ────────────────────────────────────────────────────────────
-- Exact hex from the reference board's style guide -- shared with SellController
-- so both dialogs read as one system.

local PANEL   = Color3.fromRGB(30, 35, 43)    -- #1E232B
local PANEL_2 = Color3.fromRGB(44, 49, 58)    -- #2C313A
local BORDER  = Color3.fromRGB(62, 68, 77)    -- #3E444D
local GOLD    = Color3.fromRGB(255, 193, 7)   -- #FFC107
local GREEN   = Color3.fromRGB(76, 175, 80)   -- #4CAF50
local WHITE   = Color3.fromRGB(255, 255, 255)
local LIGHT   = Color3.fromRGB(176, 184, 193) -- #B0B8C1
local RED     = Color3.fromRGB(217, 83, 79)   -- #D9534F
local BLUE    = Color3.fromRGB(93, 173, 226)  -- #5DADE2
local PURPLE  = Color3.fromRGB(155, 89, 182)

-- Gameplay rarity (separate from an item's physical tierColor, which drives the
-- icon/list-row accents) -- one consistent ramp across pickaxes and backpacks.
local RARITY_COLOR = {
	Common    = LIGHT,
	Uncommon  = GREEN,
	Rare      = BLUE,
	Epic      = PURPLE,
}

-- Backpacks have no Visual table to draw a tier color from (pickaxes do -- see
-- below), so this ramp stands in for one: grey -> bronze -> silver -> gold.
local BACKPACK_TIER_COLOR = {
	[1] = Color3.fromRGB(140, 140, 148),
	[2] = Color3.fromRGB(176, 124, 62),
	[3] = Color3.fromRGB(196, 199, 204),
	[4] = Color3.fromRGB(215, 175, 30),
}

local function getTierColor(itemType, item)
	if itemType == "pickaxe" then
		-- Reuse the pickaxe's own HeadColor so the tag/icon always matches the
		-- tool you'd actually be holding -- no separate ramp to keep in sync.
		return (item.Visual and item.Visual.HeadColor) or Color3.fromRGB(160, 160, 170)
	end
	return BACKPACK_TIER_COLOR[item.Tier] or Color3.fromRGB(160, 160, 170)
end

-- Procedural silhouette (pickaxe cross / backpack body+flap), sized as a
-- fraction of whatever container it's given so it works at badge or hero scale.
local function buildIcon(container, itemType, color)
	local parts = {}
	if itemType == "pickaxe" then
		local handle = Instance.new("Frame")
		handle.Size         = UDim2.new(0.16, 0, 0.62, 0)
		handle.AnchorPoint   = Vector2.new(0.5, 0.5)
		handle.Position      = UDim2.new(0.58, 0, 0.56, 0)
		handle.Rotation      = 45
		handle.BackgroundColor3 = color
		handle.BorderSizePixel  = 0
		handle.ZIndex        = 56
		handle.Parent         = container
		addCorner(handle, 2)
		table.insert(parts, handle)

		local head = Instance.new("Frame")
		head.Size         = UDim2.new(0.16, 0, 0.4, 0)
		head.AnchorPoint   = Vector2.new(0.5, 0.5)
		head.Position      = UDim2.new(0.4, 0, 0.32, 0)
		head.Rotation      = -45
		head.BackgroundColor3 = color
		head.BorderSizePixel  = 0
		head.ZIndex        = 56
		head.Parent         = container
		addCorner(head, 2)
		table.insert(parts, head)
	else
		local body = Instance.new("Frame")
		body.Size         = UDim2.new(0.5, 0, 0.44, 0)
		body.AnchorPoint   = Vector2.new(0.5, 0.5)
		body.Position      = UDim2.new(0.5, 0, 0.58, 0)
		body.BackgroundColor3 = color
		body.BorderSizePixel  = 0
		body.ZIndex        = 56
		body.Parent         = container
		addCorner(body, 4)
		table.insert(parts, body)

		local flap = Instance.new("Frame")
		flap.Size         = UDim2.new(0.32, 0, 0.26, 0)
		flap.AnchorPoint   = Vector2.new(0.5, 0.5)
		flap.Position      = UDim2.new(0.5, 0, 0.28, 0)
		flap.BackgroundColor3 = color
		flap.BorderSizePixel  = 0
		flap.ZIndex        = 56
		flap.Parent         = container
		addCorner(flap, 3)
		table.insert(parts, flap)
	end
	return parts
end

local function makeIconBadge(parent, size, position, itemType, color)
	local badge = Instance.new("Frame")
	badge.Size               = size
	badge.Position           = position
	badge.BackgroundColor3   = color
	badge.BackgroundTransparency = 0.8
	badge.BorderSizePixel    = 0
	badge.ZIndex             = 54
	badge.Parent             = parent
	addCorner(badge, 8)
	addStroke(badge, color, 1, 0.4)
	buildIcon(badge, itemType, color)
	return badge
end

-- ── Build ScreenGui ───────────────────────────────────────────────────────────

local shopScreen              = Instance.new("ScreenGui")
shopScreen.Name               = "ShopScreen"
shopScreen.ResetOnSpawn       = false
shopScreen.ZIndexBehavior     = Enum.ZIndexBehavior.Sibling
shopScreen.Enabled            = false
shopScreen.Parent             = playerGui

-- Semi-transparent backdrop (also closes shop when clicked outside dialog)
local dim                     = Instance.new("TextButton")
dim.Name                      = "Dim"
dim.Size                      = UDim2.new(1, 0, 1, 0)
dim.BackgroundColor3          = Color3.fromRGB(0, 0, 0)
dim.BackgroundTransparency    = 0.5
dim.BorderSizePixel           = 0
dim.Text                      = ""
dim.ZIndex                    = 50
dim.Parent                    = shopScreen

-- Main dialog
local dialog                  = Instance.new("Frame")
dialog.Name                   = "Dialog"
dialog.Size                   = UDim2.new(0, 760, 0, 480)
dialog.Position               = UDim2.new(0.5, -380, 0.5, -240)
dialog.BackgroundColor3       = PANEL
dialog.BorderSizePixel        = 0
dialog.ZIndex                 = 51
dialog.Parent                 = shopScreen
addCorner(dialog, 12)
addStroke(dialog, BORDER, 1, 0.4)

-- Header: title text directly on the panel + a solid red close button
local titleLabel              = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, -56, 0, 24)
titleLabel.Position           = UDim2.new(0, 16, 0, 16)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3         = WHITE
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextSize           = 17
titleLabel.Text               = "FRONTIER MINING SUPPLIES"
titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
titleLabel.ZIndex             = 52
titleLabel.Parent             = dialog

local closeBtn                = Instance.new("TextButton")
closeBtn.Name                 = "CloseBtn"
closeBtn.Size                 = UDim2.new(0, 28, 0, 28)
closeBtn.Position             = UDim2.new(1, -44, 0, 16)
closeBtn.BackgroundColor3     = RED
closeBtn.Text                 = "✕"
closeBtn.TextColor3           = WHITE
closeBtn.Font                 = Enum.Font.GothamBold
closeBtn.TextSize             = 14
closeBtn.ZIndex               = 52
closeBtn.Parent               = dialog
addCorner(closeBtn, 6)

-- Upgrade confirmation sound (short positive chime)
local upgradeSound            = Instance.new("Sound")
upgradeSound.SoundId          = "rbxassetid://104144989520923"
upgradeSound.Volume           = 0.7
upgradeSound.Parent           = shopScreen

-- ── Three-column content area: sidebar | preview | list ───────────────────────

local CONTENT_TOP = 56
local SIDEBAR_W   = 116
local PREVIEW_W   = 268
local COL_GAP     = 16
local OUTER_PAD   = 16

-- Sidebar — category tabs
local sidebar                 = Instance.new("Frame")
sidebar.Name                  = "Sidebar"
sidebar.Size                  = UDim2.new(0, SIDEBAR_W, 1, -CONTENT_TOP - OUTER_PAD)
sidebar.Position               = UDim2.new(0, OUTER_PAD, 0, CONTENT_TOP)
sidebar.BackgroundTransparency = 1
sidebar.ZIndex                 = 52
sidebar.Parent                 = dialog

local sidebarLayout            = Instance.new("UIListLayout")
sidebarLayout.SortOrder        = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding          = UDim.new(0, 8)
sidebarLayout.Parent           = sidebar

local tabs = {}   -- itemType -> { frame, label, iconParts }

local function makeTab(itemType, label, order)
	local tab              = Instance.new("Frame")
	tab.Name                = itemType .. "Tab"
	tab.Size                = UDim2.new(1, 0, 0, 44)
	tab.BackgroundColor3    = PANEL_2
	tab.BorderSizePixel     = 0
	tab.LayoutOrder         = order
	tab.ZIndex              = 52
	tab.Parent               = sidebar
	addCorner(tab, 8)

	local iconHolder         = Instance.new("Frame")
	iconHolder.Size          = UDim2.new(0, 20, 0, 20)
	iconHolder.Position      = UDim2.new(0, 12, 0.5, -10)
	iconHolder.BackgroundTransparency = 1
	iconHolder.ZIndex        = 53
	iconHolder.Parent        = tab

	local iconParts = buildIcon(iconHolder, itemType, LIGHT)

	local lbl                = Instance.new("TextLabel")
	lbl.Size                 = UDim2.new(1, -40, 1, 0)
	lbl.Position              = UDim2.new(0, 40, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3            = LIGHT
	lbl.Font                  = Enum.Font.GothamBold
	lbl.TextSize               = 13
	lbl.TextXAlignment         = Enum.TextXAlignment.Left
	lbl.Text                   = label
	lbl.ZIndex                 = 53
	lbl.Parent                 = tab

	local btn                 = Instance.new("TextButton")
	btn.Size                  = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text                   = ""
	btn.ZIndex                 = 54
	btn.Parent                 = tab

	tabs[itemType] = { frame = tab, label = lbl, iconParts = iconParts }
	btn.MouseButton1Click:Connect(function()
		selectCategory(itemType)
	end)
end

-- Preview pane — selected item's hero card
local preview                  = Instance.new("Frame")
preview.Name                    = "Preview"
preview.Size                    = UDim2.new(0, PREVIEW_W, 1, -CONTENT_TOP - OUTER_PAD)
preview.Position                = UDim2.new(0, OUTER_PAD + SIDEBAR_W + COL_GAP, 0, CONTENT_TOP)
preview.BackgroundColor3        = PANEL_2
preview.BorderSizePixel         = 0
preview.ZIndex                  = 52
preview.Parent                  = dialog
addCorner(preview, 10)
addStroke(preview, BORDER, 1, 0.5)

local previewIconHolder         = Instance.new("Frame")
previewIconHolder.Size          = UDim2.new(0, 76, 0, 76)
previewIconHolder.Position      = UDim2.new(0.5, -38, 0, 20)
previewIconHolder.BackgroundTransparency = 1
previewIconHolder.ZIndex        = 53
previewIconHolder.Parent        = preview

local previewName                = Instance.new("TextLabel")
previewName.Size                 = UDim2.new(1, -24, 0, 24)
previewName.Position             = UDim2.new(0, 12, 0, 104)
previewName.BackgroundTransparency = 1
previewName.TextColor3           = WHITE
previewName.Font                 = Enum.Font.GothamBold
previewName.TextSize             = 17
previewName.TextXAlignment       = Enum.TextXAlignment.Center
previewName.Text                 = ""
previewName.ZIndex               = 53
previewName.Parent               = preview

local previewTier                 = Instance.new("TextLabel")
previewTier.Size                  = UDim2.new(0, 84, 0, 18)
previewTier.Position              = UDim2.new(0.5, -42, 0, 124)
previewTier.BorderSizePixel       = 0
previewTier.Font                  = Enum.Font.GothamBold
previewTier.TextSize              = 11
previewTier.TextColor3            = WHITE
previewTier.TextStrokeColor3      = PANEL
previewTier.TextStrokeTransparency = 0.4
previewTier.Text                  = ""
previewTier.ZIndex                = 53
previewTier.Parent                = preview
addCorner(previewTier, 9)

local previewDescription           = Instance.new("TextLabel")
previewDescription.Size            = UDim2.new(1, -24, 0, 44)
previewDescription.Position        = UDim2.new(0, 12, 0, 148)
previewDescription.BackgroundTransparency = 1
previewDescription.Font            = Enum.Font.Gotham
previewDescription.TextSize        = 12
previewDescription.TextColor3      = LIGHT
previewDescription.TextXAlignment  = Enum.TextXAlignment.Left
previewDescription.TextYAlignment  = Enum.TextYAlignment.Top
previewDescription.TextWrapped     = true
previewDescription.Text            = ""
previewDescription.ZIndex          = 53
previewDescription.Parent          = preview

local previewStat                 = Instance.new("TextLabel")
previewStat.Size                  = UDim2.new(1, -24, 0, 18)
previewStat.Position              = UDim2.new(0, 12, 0, 196)
previewStat.BackgroundTransparency = 1
previewStat.Font                  = Enum.Font.GothamBold
previewStat.TextSize              = 13
previewStat.TextColor3            = WHITE
previewStat.TextXAlignment        = Enum.TextXAlignment.Left
previewStat.Text                  = ""
previewStat.ZIndex                = 53
previewStat.Parent                = preview

local previewStat2                 = Instance.new("TextLabel")
previewStat2.Size                  = UDim2.new(1, -24, 0, 18)
previewStat2.Position              = UDim2.new(0, 12, 0, 216)
previewStat2.BackgroundTransparency = 1
previewStat2.Font                  = Enum.Font.GothamBold
previewStat2.TextSize              = 13
previewStat2.TextColor3            = WHITE
previewStat2.TextXAlignment        = Enum.TextXAlignment.Left
previewStat2.Text                  = ""
previewStat2.ZIndex                = 53
previewStat2.Parent                = preview

local previewDivider               = Instance.new("Frame")
previewDivider.Size                = UDim2.new(1, -24, 0, 1)
previewDivider.Position            = UDim2.new(0, 12, 0, 242)
previewDivider.BackgroundColor3    = BORDER
previewDivider.BorderSizePixel     = 0
previewDivider.ZIndex              = 53
previewDivider.Parent              = preview

local previewPrice                 = Instance.new("TextLabel")
previewPrice.Size                  = UDim2.new(1, -24, 0, 26)
previewPrice.Position              = UDim2.new(0, 12, 0, 256)
previewPrice.BackgroundTransparency = 1
previewPrice.Font                  = Enum.Font.GothamBold
previewPrice.TextSize              = 20
previewPrice.TextColor3            = GOLD
previewPrice.TextXAlignment        = Enum.TextXAlignment.Left
previewPrice.Text                  = ""
previewPrice.ZIndex                = 53
previewPrice.Parent                = preview

local previewActionBtn             = Instance.new("TextButton")
previewActionBtn.Size              = UDim2.new(1, -24, 0, 36)
previewActionBtn.Position          = UDim2.new(0, 12, 0, 290)
previewActionBtn.BorderSizePixel   = 0
previewActionBtn.Font              = Enum.Font.GothamBold
previewActionBtn.TextSize          = 14
previewActionBtn.ZIndex            = 53
previewActionBtn.Parent            = preview
addCorner(previewActionBtn, 8)

-- List column — every item in the selected category; stretches to fill
-- whatever width remains after the sidebar and preview pane
local listCol                     = Instance.new("Frame")
listCol.Name                       = "ItemList"
listCol.Size                       = UDim2.new(1, -(OUTER_PAD + SIDEBAR_W + COL_GAP + PREVIEW_W + COL_GAP + OUTER_PAD), 1, -CONTENT_TOP - OUTER_PAD)
listCol.Position                   = UDim2.new(0, OUTER_PAD + SIDEBAR_W + COL_GAP + PREVIEW_W + COL_GAP, 0, CONTENT_TOP)
listCol.BackgroundTransparency     = 1
listCol.ZIndex                     = 52
listCol.Parent                     = dialog

local listHeader                   = Instance.new("TextLabel")
listHeader.Size                    = UDim2.new(1, 0, 0, 22)
listHeader.BackgroundTransparency  = 1
listHeader.TextColor3              = LIGHT
listHeader.Font                    = Enum.Font.GothamBold
listHeader.TextSize                = 12
listHeader.TextXAlignment          = Enum.TextXAlignment.Left
listHeader.Text                    = "PICKAXES"
listHeader.ZIndex                  = 52
listHeader.Parent                  = listCol

local listRows                     = Instance.new("Frame")
listRows.Size                      = UDim2.new(1, 0, 1, -26)
listRows.Position                  = UDim2.new(0, 0, 0, 26)
listRows.BackgroundTransparency    = 1
listRows.ZIndex                    = 52
listRows.Parent                    = listCol

local listLayout                   = Instance.new("UIListLayout")
listLayout.SortOrder                = Enum.SortOrder.LayoutOrder
listLayout.Padding                  = UDim.new(0, 6)
listLayout.Parent                   = listRows

-- ── List row builder ───────────────────────────────────────────────────────────

local rowEntries = {}   -- { frame, stroke, tag, itemType, item }

local function makeListRow(itemType, item, order)
	local row                  = Instance.new("Frame")
	row.Name                    = item.Id
	row.Size                    = UDim2.new(1, 0, 0, 44)
	row.BackgroundColor3        = PANEL
	row.BorderSizePixel         = 0
	row.LayoutOrder              = order
	row.ZIndex                   = 53
	row.Parent                   = listRows
	addCorner(row, 8)
	local rowStroke               = Instance.new("UIStroke")
	rowStroke.Color                = BORDER
	rowStroke.Thickness             = 1
	rowStroke.Transparency          = 0.5
	rowStroke.Parent                = row

	local tierColor                = getTierColor(itemType, item)
	makeIconBadge(row, UDim2.new(0, 28, 0, 28), UDim2.new(0, 8, 0.5, -14), itemType, tierColor)

	local nameLabel                 = Instance.new("TextLabel")
	nameLabel.Size                   = UDim2.new(1, -140, 1, 0)
	nameLabel.Position               = UDim2.new(0, 46, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3             = WHITE
	nameLabel.Font                   = Enum.Font.GothamBold
	nameLabel.TextSize               = 13
	nameLabel.TextXAlignment         = Enum.TextXAlignment.Left
	nameLabel.Text                   = item.Name
	nameLabel.ZIndex                 = 54
	nameLabel.Parent                 = row

	local tag                        = Instance.new("TextLabel")
	tag.Size                         = UDim2.new(0, 84, 1, 0)
	tag.Position                     = UDim2.new(1, -94, 0, 0)
	tag.BackgroundTransparency       = 1
	tag.Font                         = Enum.Font.GothamBold
	tag.TextSize                     = 13
	tag.TextXAlignment               = Enum.TextXAlignment.Right
	tag.ZIndex                       = 54
	tag.Parent                       = row

	local btn                        = Instance.new("TextButton")
	btn.Size                         = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency       = 1
	btn.Text                         = ""
	btn.ZIndex                       = 55
	btn.Parent                       = row
	btn.MouseButton1Click:Connect(function()
		selectItem(itemType, item)
	end)

	table.insert(rowEntries, { frame = row, stroke = rowStroke, tag = tag, itemType = itemType, item = item })
end

-- ── Refresh: preview pane ─────────────────────────────────────────────────────

refreshPreview = function()
	local item = selectedItem
	if not item then return end

	local tierColor = getTierColor(selectedType, item)

	for _, child in ipairs(previewIconHolder:GetChildren()) do child:Destroy() end
	buildIcon(previewIconHolder, selectedType, tierColor)

	previewName.Text        = item.Name
	previewTier.Text         = item.Rarity or "Common"
	previewTier.BackgroundColor3 = RARITY_COLOR[item.Rarity] or LIGHT

	previewDescription.Text = item.Description or ""

	if selectedType == "pickaxe" then
		previewStat.Text  = string.format("Mining Power   ×%d", item.MiningPower)
		previewStat2.Text = item.SwingSpeed and string.format("Swing Speed   %.1fs", item.SwingSpeed) or ""
	else
		previewStat.Text  = string.format("Capacity   %d kg", item.Capacity)
		previewStat2.Text = ""
	end

	local isEquipped = (selectedType == "pickaxe"  and equippedPickaxeId  == item.Id)
	               or  (selectedType == "backpack" and equippedBackpackId == item.Id)
	local isOwned    = (selectedType == "pickaxe"  and ownedPickaxes[item.Id])
	               or  (selectedType == "backpack" and ownedBackpacks[item.Id])
	local canAfford  = cachedBalance >= item.Cost

	if isOwned or item.Cost <= 0 then
		previewPrice.Text = "Owned"
		previewPrice.TextColor3 = LIGHT
	else
		previewPrice.Text = "₡" .. fmtNum(item.Cost)
		previewPrice.TextColor3 = canAfford and GOLD or LIGHT
	end

	if isEquipped then
		previewActionBtn.Text             = "EQUIPPED"
		previewActionBtn.BackgroundColor3 = GREEN
		previewActionBtn.TextColor3       = WHITE
		previewActionBtn.AutoButtonColor  = false
	elseif isOwned then
		previewActionBtn.Text             = "EQUIP"
		previewActionBtn.BackgroundColor3 = GOLD
		previewActionBtn.TextColor3       = PANEL
		previewActionBtn.AutoButtonColor  = true
	elseif canAfford then
		previewActionBtn.Text             = "PURCHASE"
		previewActionBtn.BackgroundColor3 = GREEN
		previewActionBtn.TextColor3       = WHITE
		previewActionBtn.AutoButtonColor  = true
	else
		previewActionBtn.Text             = "PURCHASE"
		previewActionBtn.BackgroundColor3 = PANEL
		previewActionBtn.TextColor3       = LIGHT
		previewActionBtn.AutoButtonColor  = false
	end
end

-- ── Refresh: list rows (tags + selection highlight) ───────────────────────────

refreshList = function()
	for _, entry in ipairs(rowEntries) do
		local item       = entry.item
		local kind       = entry.itemType

		local isEquipped = (kind == "pickaxe"  and equippedPickaxeId  == item.Id)
		               or  (kind == "backpack" and equippedBackpackId == item.Id)
		local isOwned    = (kind == "pickaxe"  and ownedPickaxes[item.Id])
		               or  (kind == "backpack" and ownedBackpacks[item.Id])
		local canAfford  = cachedBalance >= item.Cost
		local isSelected = (kind == selectedType) and (item.Id == selectedItem.Id)

		if isEquipped then
			entry.tag.Text = "Equipped"
			entry.tag.TextColor3 = GREEN
		elseif isOwned or item.Cost <= 0 then
			entry.tag.Text = "Owned"
			entry.tag.TextColor3 = GREEN
		else
			entry.tag.Text = "₡" .. fmtNum(item.Cost)
			entry.tag.TextColor3 = canAfford and GOLD or LIGHT
		end

		if isSelected then
			entry.frame.BackgroundColor3 = PANEL_2
			entry.stroke.Color = GOLD
			entry.stroke.Transparency = 0
		else
			entry.frame.BackgroundColor3 = PANEL
			entry.stroke.Color = BORDER
			entry.stroke.Transparency = 0.5
		end
	end
end

-- ── Category switching ─────────────────────────────────────────────────────────

selectItem = function(itemType, item)
	selectedType = itemType
	selectedItem = item
	refreshPreview()
	refreshList()
end

selectCategory = function(itemType)
	for kind, tabData in pairs(tabs) do
		local active = (kind == itemType)
		tabData.frame.BackgroundColor3 = active and GOLD or PANEL_2
		tabData.label.TextColor3       = active and PANEL or LIGHT
		for _, part in ipairs(tabData.iconParts) do
			part.BackgroundColor3 = active and PANEL or LIGHT
		end
	end

	for _, child in ipairs(listRows:GetChildren()) do
		if not child:IsA("UIListLayout") then child:Destroy() end
	end
	rowEntries = {}

	local list = itemType == "pickaxe" and EquipmentConfig.Pickaxes or EquipmentConfig.Backpacks
	listHeader.Text = itemType == "pickaxe" and "PICKAXES" or "BACKPACKS"
	for i, item in ipairs(list) do
		makeListRow(itemType, item, i)
	end

	selectItem(itemType, list[1])
end

-- Build tabs and populate the default category
makeTab("pickaxe", "Pickaxes", 1)
makeTab("backpack", "Backpacks", 2)
selectCategory("pickaxe")

previewActionBtn.MouseButton1Click:Connect(function()
	local item = selectedItem
	if not item then return end

	local isEquipped = (selectedType == "pickaxe"  and equippedPickaxeId  == item.Id)
	               or  (selectedType == "backpack" and equippedBackpackId == item.Id)
	if isEquipped then return end

	local isOwned = (selectedType == "pickaxe"  and ownedPickaxes[item.Id])
	            or  (selectedType == "backpack" and ownedBackpacks[item.Id])

	if isOwned then
		EquipItem:FireServer(selectedType, item.Id)
	else
		if cachedBalance < item.Cost then return end
		pendingPurchaseId = item.Id
		PurchaseEquipment:FireServer(selectedType, item.Id)
	end
end)

-- ── Equip flash ───────────────────────────────────────────────────────────────
-- Brief glow on the newly-equipped pickaxe so buying an upgrade reads as an event,
-- not a silent stat change. Polls briefly for the tool to appear in Character since
-- the server's tool swap and this Eq_Update remote can arrive a frame or two apart.

local function flashPickaxeInHand()
	task.spawn(function()
		local character = player.Character
		if not character then return end

		local tool
		for _ = 1, 20 do
			tool = character:FindFirstChild(EquipmentConfig.ToolName)
			if tool then break end
			task.wait(0.05)
		end
		if not tool then return end

		-- Adornee the Handle specifically, not the Tool -- Tool inherits from
		-- BackpackItem, not Model/BasePart, so a Highlight adorned directly to it
		-- is not guaranteed to render.
		local handlePart = tool:FindFirstChild("Handle")
		if not handlePart then return end

		local highlight               = Instance.new("Highlight")
		highlight.FillColor           = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency    = 0.15
		highlight.OutlineColor        = Color3.fromRGB(255, 240, 150)
		highlight.OutlineTransparency = 0
		highlight.Adornee             = handlePart
		highlight.Parent              = tool

		TweenService:Create(highlight, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
			FillTransparency    = 1,
			OutlineTransparency = 1,
		}):Play()

		task.delay(0.75, function()
			if highlight.Parent then highlight:Destroy() end
		end)
	end)
end

-- ── Upgrade toast ─────────────────────────────────────────────────────────────

local function showUpgradeToast(msg)
	local old = playerGui:FindFirstChild("UpgradeToast")
	if old then old:Destroy() end

	local toast               = Instance.new("ScreenGui")
	toast.Name                = "UpgradeToast"
	toast.ResetOnSpawn        = false
	toast.ZIndexBehavior      = Enum.ZIndexBehavior.Sibling
	toast.Parent              = playerGui

	local frame               = Instance.new("Frame")
	frame.Size                = UDim2.new(0, 360, 0, 46)
	frame.Position            = UDim2.new(0.5, -180, 0, 70)
	frame.BackgroundColor3    = Color3.fromRGB(40, 150, 70)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel     = 0
	frame.ZIndex              = 90
	frame.Parent              = toast
	addCorner(frame, 8)

	local label               = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3          = Color3.fromRGB(255, 255, 255)
	label.Font                = Enum.Font.GothamBold
	label.TextSize            = 14
	label.Text                = msg
	label.TextTransparency    = 1
	label.ZIndex              = 91
	label.Parent              = frame

	TweenService:Create(frame, TweenInfo.new(0.2), { BackgroundTransparency = 0.1 }):Play()
	TweenService:Create(label, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()

	task.delay(2.5, function()
		if not frame.Parent then return end
		TweenService:Create(frame, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
		local out = TweenService:Create(label, TweenInfo.new(0.4), { TextTransparency = 1 })
		out:Play()
		out.Completed:Connect(function()
			if toast.Parent then toast:Destroy() end
		end)
	end)
end

-- ── Open / close ──────────────────────────────────────────────────────────────

local function openShop()
	if isShopOpen then return end
	isShopOpen = true
	refreshPreview()
	refreshList()
	shopScreen.Enabled = true
end

local function closeShop()
	if not isShopOpen then return end
	isShopOpen = false
	shopScreen.Enabled = false
end

closeBtn.MouseButton1Click:Connect(closeShop)
dim.MouseButton1Click:Connect(closeShop)

-- ── Remote listeners ──────────────────────────────────────────────────────────

Eco_CreditsUpdate.OnClientEvent:Connect(function(balance)
	cachedBalance = balance
	if isShopOpen then
		refreshPreview()
		refreshList()
	end
end)

Eq_Update.OnClientEvent:Connect(function(pickaxeId, backpackId, ownedPickaxeList, ownedBackpackList)
	local prevPickaxe  = equippedPickaxeId
	local prevBackpack = equippedBackpackId
	equippedPickaxeId  = pickaxeId
	equippedBackpackId = backpackId

	ownedPickaxes  = {}
	ownedBackpacks = {}
	for _, id in ipairs(ownedPickaxeList  or {}) do ownedPickaxes[id]  = true end
	for _, id in ipairs(ownedBackpackList or {}) do ownedBackpacks[id] = true end

	if isShopOpen then
		refreshPreview()
		refreshList()
	end

	-- Show toast only when this Eq_Update is confirming a pending purchase
	if pendingPurchaseId then
		if pickaxeId ~= prevPickaxe then
			for _, p in ipairs(EquipmentConfig.Pickaxes) do
				if p.Id == pickaxeId then
					upgradeSound:Play()
					flashPickaxeInHand()
					showUpgradeToast(string.format("%s Equipped  —  Mining Power ×%d", p.Name, p.MiningPower))
					break
				end
			end
		elseif backpackId ~= prevBackpack then
			for _, b in ipairs(EquipmentConfig.Backpacks) do
				if b.Id == backpackId then
					upgradeSound:Play()
					showUpgradeToast(string.format("%s Equipped  —  %d kg Capacity", b.Name, b.Capacity))
					break
				end
			end
		end
		pendingPurchaseId = nil
	end
end)

-- ── ProximityPrompt wiring ────────────────────────────────────────────────────

local shopKiosk = workspace:WaitForChild("PickaxeShop", 10)
if shopKiosk then
	local prompt = shopKiosk:WaitForChild("ShopPrompt", 5)
	if prompt then
		prompt.RequiresLineOfSight   = false
		prompt.MaxActivationDistance = 10
		prompt.Triggered:Connect(function()
			openShop()
		end)
	else
		warn("[ShopController] ShopPrompt not found on PickaxeShop")
	end
else
	warn("[ShopController] PickaxeShop not found in Workspace")
end

print("[ShopController] Loaded")
