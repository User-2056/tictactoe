-- SellController: Atlas Ore Exchange sell dialog.
-- Main dialog: per-ore rows with individual [Sell] buttons + a SELL ALL button.
-- Qty picker: sub-modal with TextBox, Half, All shortcuts and live total preview.
-- Server recalculates all values from its own data — no client number is trusted.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local OreConfig = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("OreConfig"))

local Remotes    = ReplicatedStorage:WaitForChild("Remotes")
local SellOre    = Remotes:WaitForChild("SellOre")
local Inv_Update = Remotes:WaitForChild("Inv_Update")

local cachedItems = {}

local ORE_ORDER = { "stone", "coal", "iron", "gold" }
local ORE_COLOR = {
	stone = Color3.fromRGB(180, 178, 180),
	coal  = Color3.fromRGB(140, 140, 140),
	iron  = Color3.fromRGB(180, 130, 100),
	gold  = Color3.fromRGB(215, 175, 30),
}
local ROW_H   = 34
local ROW_GAP = 8

-- ── Helper ──────────────────────────────────────────────────────────────────

local function addCorner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = inst
end

local function addStroke(inst, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.3
	s.Parent = inst
end

-- ── Visual tokens ────────────────────────────────────────────────────────────
-- Exact hex from the reference board's style guide -- shared with ShopController
-- so both dialogs read as one system.

local PANEL   = Color3.fromRGB(30, 35, 43)    -- #1E232B
local PANEL_2 = Color3.fromRGB(44, 49, 58)    -- #2C313A
local BORDER  = Color3.fromRGB(62, 68, 77)    -- #3E444D
local GOLD    = Color3.fromRGB(255, 193, 7)   -- #FFC107
local GREEN   = Color3.fromRGB(76, 175, 80)   -- #4CAF50
local LIGHT   = Color3.fromRGB(176, 184, 193) -- #B0B8C1
local RED     = Color3.fromRGB(217, 83, 79)   -- #D9534F
local BLUE    = Color3.fromRGB(93, 173, 226)  -- #5DADE2

-- ── ScreenGui ──────────────────────────────────────────────────────────────

local sellScreen              = Instance.new("ScreenGui")
sellScreen.Name               = "SellScreen"
sellScreen.ResetOnSpawn       = false
sellScreen.ZIndexBehavior     = Enum.ZIndexBehavior.Sibling
sellScreen.Enabled            = false
sellScreen.Parent             = playerGui

local backdrop                = Instance.new("Frame")
backdrop.Size                 = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3     = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.55
backdrop.BorderSizePixel      = 0
backdrop.ZIndex               = 49
backdrop.Parent               = sellScreen

-- ── Main sell dialog ────────────────────────────────────────────────────────

local dialog                  = Instance.new("Frame")
dialog.Name                   = "Dialog"
dialog.Size                   = UDim2.new(0, 380, 0, 60)
dialog.AnchorPoint            = Vector2.new(0.5, 0.5)
dialog.Position               = UDim2.new(0.5, 0, 0.5, 0)
dialog.BackgroundColor3       = PANEL
dialog.BorderSizePixel        = 0
dialog.ZIndex                 = 50
dialog.Parent                 = sellScreen
addCorner(dialog, 12)
addStroke(dialog, BORDER, 1, 0.4)

-- Header: title text directly on the panel + a solid red close button, matching
-- the reference card exactly (no accent bar, no title-bar fill block).
local titleLabel               = Instance.new("TextLabel")
titleLabel.Size                = UDim2.new(1, -56, 0, 24)
titleLabel.Position            = UDim2.new(0, 16, 0, 14)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3          = GOLD
titleLabel.Font                = Enum.Font.GothamBold
titleLabel.TextSize            = 16
titleLabel.TextXAlignment       = Enum.TextXAlignment.Left
titleLabel.Text                 = "ATLAS ORE EXCHANGE"
titleLabel.ZIndex               = 51
titleLabel.Parent               = dialog

local closeBtn                 = Instance.new("TextButton")
closeBtn.Size                  = UDim2.new(0, 26, 0, 26)
closeBtn.Position              = UDim2.new(1, -40, 0, 14)
closeBtn.BackgroundColor3      = RED
closeBtn.BorderSizePixel       = 0
closeBtn.TextColor3            = Color3.fromRGB(255, 255, 255)
closeBtn.Font                  = Enum.Font.GothamBold
closeBtn.TextSize              = 14
closeBtn.Text                  = "X"
closeBtn.ZIndex                = 51
closeBtn.Parent                = dialog
addCorner(closeBtn, 6)

local subheader                = Instance.new("TextLabel")
subheader.Size                 = UDim2.new(1, -32, 0, 16)
subheader.Position             = UDim2.new(0, 16, 0, 46)
subheader.BackgroundTransparency = 1
subheader.TextColor3           = LIGHT
subheader.Font                 = Enum.Font.GothamBold
subheader.TextSize             = 11
subheader.TextXAlignment       = Enum.TextXAlignment.Left
subheader.Text                 = "TODAY'S PRICES"
subheader.ZIndex               = 51
subheader.Parent               = dialog

local CONTENT_Y = 70

-- Content
local content                 = Instance.new("Frame")
content.Size                  = UDim2.new(1, -32, 0, 0)
content.Position              = UDim2.new(0, 16, 0, CONTENT_Y)
content.BackgroundTransparency = 1
content.ZIndex                = 51
content.Parent                = dialog

local oreRows                 = Instance.new("Frame")
oreRows.Size                  = UDim2.new(1, 0, 0, 0)
oreRows.BackgroundTransparency = 1
oreRows.ZIndex                = 51
oreRows.Parent                = content

local rowLayout               = Instance.new("UIListLayout")
rowLayout.SortOrder           = Enum.SortOrder.LayoutOrder
rowLayout.Padding             = UDim.new(0, ROW_GAP)
rowLayout.Parent              = oreRows

local divider                 = Instance.new("Frame")
divider.Size                  = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3      = BORDER
divider.BorderSizePixel       = 0
divider.ZIndex                = 51
divider.Parent                = content

-- Footer: "TOTAL" caption + big amount stacked on the left, SELL ALL pinned right
local totalCaption             = Instance.new("TextLabel")
totalCaption.Size               = UDim2.new(0, 160, 0, 14)
totalCaption.BackgroundTransparency = 1
totalCaption.TextColor3         = LIGHT
totalCaption.Font               = Enum.Font.GothamBold
totalCaption.TextSize           = 10
totalCaption.TextXAlignment     = Enum.TextXAlignment.Left
totalCaption.Text               = "TOTAL"
totalCaption.ZIndex             = 51
totalCaption.Parent             = content

local totalLabel              = Instance.new("TextLabel")
totalLabel.Size               = UDim2.new(0, 160, 0, 26)
totalLabel.BackgroundTransparency = 1
totalLabel.TextColor3         = GOLD
totalLabel.Font               = Enum.Font.GothamBold
totalLabel.TextSize           = 20
totalLabel.TextXAlignment     = Enum.TextXAlignment.Left
totalLabel.Text               = "₡0"
totalLabel.ZIndex             = 51
totalLabel.Parent             = content

local sellAllBtn              = Instance.new("TextButton")
sellAllBtn.Size               = UDim2.new(0, 132, 0, 38)
sellAllBtn.BackgroundColor3   = GREEN
sellAllBtn.BorderSizePixel    = 0
sellAllBtn.TextColor3         = Color3.fromRGB(255, 255, 255)
sellAllBtn.Font               = Enum.Font.GothamBold
sellAllBtn.TextSize           = 14
sellAllBtn.Text               = "SELL ALL"
sellAllBtn.ZIndex             = 51
sellAllBtn.Parent             = content
addCorner(sellAllBtn, 8)

-- ── Sell sound ─────────────────────────────────────────────────────────────

local sellSound               = Instance.new("Sound")
sellSound.SoundId             = "rbxassetid://9125616843"
sellSound.Volume              = 0.85
sellSound.Parent              = sellScreen

-- ── Quantity picker (sub-modal, appears over dialog) ────────────────────────
-- Not part of the reference board (its mockup sells a whole stack in one click),
-- but this game supports partial sells, so the picker stays -- just restyled to
-- match the same panel/palette as the rest of the dialog.
-- A second dimmer behind the picker blocks clicks on the dialog underneath.

local pickerDim               = Instance.new("Frame")
pickerDim.Size                = UDim2.new(1, 0, 1, 0)
pickerDim.BackgroundColor3    = Color3.fromRGB(0, 0, 0)
pickerDim.BackgroundTransparency = 0.5
pickerDim.BorderSizePixel     = 0
pickerDim.ZIndex              = 65
pickerDim.Visible             = false
pickerDim.Parent              = sellScreen

local picker                  = Instance.new("Frame")
picker.Name                   = "QtyPicker"
picker.Size                   = UDim2.new(0, 310, 0, 238)
picker.AnchorPoint            = Vector2.new(0.5, 0.5)
picker.Position               = UDim2.new(0.5, 0, 0.5, 0)
picker.BackgroundColor3       = PANEL_2
picker.BorderSizePixel        = 0
picker.ZIndex                 = 70
picker.Visible                = false
picker.Parent                 = sellScreen
addCorner(picker, 12)
addStroke(picker, BORDER, 1, 0.4)

local pickerTitle             = Instance.new("TextLabel")
pickerTitle.Size              = UDim2.new(1, -24, 0, 24)
pickerTitle.Position          = UDim2.new(0, 12, 0, 14)
pickerTitle.BackgroundTransparency = 1
pickerTitle.TextColor3        = GOLD
pickerTitle.Font              = Enum.Font.GothamBold
pickerTitle.TextSize          = 15
pickerTitle.TextXAlignment    = Enum.TextXAlignment.Left
pickerTitle.Text              = "Sell Ore"
pickerTitle.ZIndex            = 71
pickerTitle.Parent            = picker

-- "You have: N  •  ₡N each"
local pickerInfo              = Instance.new("TextLabel")
pickerInfo.Size               = UDim2.new(1, -24, 0, 22)
pickerInfo.Position           = UDim2.new(0, 12, 0, 46)
pickerInfo.BackgroundTransparency = 1
pickerInfo.TextColor3         = LIGHT
pickerInfo.Font               = Enum.Font.Gotham
pickerInfo.TextSize           = 12
pickerInfo.TextXAlignment     = Enum.TextXAlignment.Left
pickerInfo.Text               = ""
pickerInfo.ZIndex             = 71
pickerInfo.Parent             = picker

-- Quick-fill buttons
local halfBtn                 = Instance.new("TextButton")
halfBtn.Size                  = UDim2.new(0, 128, 0, 28)
halfBtn.Position              = UDim2.new(0.5, -134, 0, 74)
halfBtn.BackgroundColor3      = BLUE
halfBtn.BorderSizePixel       = 0
halfBtn.TextColor3            = Color3.fromRGB(255, 255, 255)
halfBtn.Font                  = Enum.Font.GothamBold
halfBtn.TextSize              = 13
halfBtn.Text                  = "Half"
halfBtn.ZIndex                = 71
halfBtn.Parent                = picker
addCorner(halfBtn, 6)

local allBtn                  = Instance.new("TextButton")
allBtn.Size                   = UDim2.new(0, 128, 0, 28)
allBtn.Position               = UDim2.new(0.5, 6, 0, 74)
allBtn.BackgroundColor3       = BLUE
allBtn.BorderSizePixel        = 0
allBtn.TextColor3             = Color3.fromRGB(255, 255, 255)
allBtn.Font                   = Enum.Font.GothamBold
allBtn.TextSize               = 13
allBtn.Text                   = "Select All"
allBtn.ZIndex                 = 71
allBtn.Parent                 = picker
addCorner(allBtn, 6)

-- Quantity text box
local qtyBox                  = Instance.new("TextBox")
qtyBox.Size                   = UDim2.new(1, -24, 0, 50)
qtyBox.Position               = UDim2.new(0, 12, 0, 110)
qtyBox.BackgroundColor3       = PANEL
qtyBox.BorderSizePixel        = 0
qtyBox.TextColor3             = Color3.fromRGB(255, 255, 255)
qtyBox.Font                   = Enum.Font.GothamBold
qtyBox.TextSize               = 26
qtyBox.Text                   = "1"
qtyBox.PlaceholderText        = "Quantity..."
qtyBox.PlaceholderColor3      = Color3.fromRGB(90, 90, 90)
qtyBox.ClearTextOnFocus       = true
qtyBox.ZIndex                 = 71
qtyBox.Parent                 = picker
addCorner(qtyBox, 6)

-- Live total preview
local pickerTotal             = Instance.new("TextLabel")
pickerTotal.Size              = UDim2.new(1, -24, 0, 22)
pickerTotal.Position          = UDim2.new(0, 12, 0, 168)
pickerTotal.BackgroundTransparency = 1
pickerTotal.TextColor3        = GOLD
pickerTotal.Font              = Enum.Font.GothamBold
pickerTotal.TextSize          = 14
pickerTotal.TextXAlignment    = Enum.TextXAlignment.Right
pickerTotal.Text              = "Total:  ₡0"
pickerTotal.ZIndex            = 71
pickerTotal.Parent            = picker

-- Cancel / Confirm buttons
local pickerCancelBtn         = Instance.new("TextButton")
pickerCancelBtn.Size          = UDim2.new(0, 115, 0, 36)
pickerCancelBtn.Position      = UDim2.new(0.5, -123, 0, 196)
pickerCancelBtn.BackgroundColor3 = RED
pickerCancelBtn.BorderSizePixel = 0
pickerCancelBtn.TextColor3    = Color3.fromRGB(255, 255, 255)
pickerCancelBtn.Font          = Enum.Font.GothamBold
pickerCancelBtn.TextSize      = 13
pickerCancelBtn.Text          = "Cancel"
pickerCancelBtn.ZIndex        = 71
pickerCancelBtn.Parent        = picker
addCorner(pickerCancelBtn, 8)

local pickerConfirmBtn        = Instance.new("TextButton")
pickerConfirmBtn.Size         = UDim2.new(0, 115, 0, 36)
pickerConfirmBtn.Position     = UDim2.new(0.5, 8, 0, 196)
pickerConfirmBtn.BackgroundColor3 = GREEN
pickerConfirmBtn.BorderSizePixel = 0
pickerConfirmBtn.TextColor3   = Color3.fromRGB(255, 255, 255)
pickerConfirmBtn.Font         = Enum.Font.GothamBold
pickerConfirmBtn.TextSize     = 13
pickerConfirmBtn.Text         = "SELL 0"
pickerConfirmBtn.ZIndex       = 71
pickerConfirmBtn.Parent       = picker
addCorner(pickerConfirmBtn, 8)

-- ── Picker state ────────────────────────────────────────────────────────────

local pickerOreType = nil
local pickerMaxQty  = 0

local function getParsedQty()
	local n = tonumber((qtyBox.Text:gsub("[^%d]", ""))) or 0
	return math.min(math.max(0, n), pickerMaxQty)
end

local function refreshPickerPreview()
	local qty    = getParsedQty()
	local config = pickerOreType and OreConfig[pickerOreType]
	local total  = config and (config.BaseValue * qty) or 0

	pickerTotal.Text = string.format("Total:  ₡%d", total)

	if qty > 0 then
		pickerConfirmBtn.Text             = string.format("SELL %d", qty)
		pickerConfirmBtn.BackgroundColor3 = GREEN
	else
		pickerConfirmBtn.Text             = "SELL"
		pickerConfirmBtn.BackgroundColor3 = BORDER
	end
end

local function openPicker(oreType)
	pickerOreType = oreType
	pickerMaxQty  = cachedItems[oreType] or 0

	local config = OreConfig[oreType]
	local name   = oreType:sub(1,1):upper() .. oreType:sub(2)

	pickerTitle.Text = "Sell " .. name
	pickerInfo.Text  = string.format("You have: %d  •  ₡%d each", pickerMaxQty, config.BaseValue)
	qtyBox.Text      = tostring(pickerMaxQty)   -- default: all of that type

	refreshPickerPreview()
	pickerDim.Visible = true
	picker.Visible    = true
end

local function closePicker()
	picker.Visible    = false
	pickerDim.Visible = false
	pickerOreType     = nil
end

qtyBox:GetPropertyChangedSignal("Text"):Connect(refreshPickerPreview)

halfBtn.MouseButton1Click:Connect(function()
	local half = math.max(1, math.floor(pickerMaxQty / 2))
	qtyBox.Text = tostring(half)
end)

allBtn.MouseButton1Click:Connect(function()
	qtyBox.Text = tostring(pickerMaxQty)
end)

pickerCancelBtn.MouseButton1Click:Connect(closePicker)

pickerConfirmBtn.MouseButton1Click:Connect(function()
	local qty = getParsedQty()
	if qty <= 0 or not pickerOreType then return end
	SellOre:FireServer(pickerOreType, qty)
	sellSound:Play()
	closePicker()
end)

-- ── Main dialog: build ore rows ─────────────────────────────────────────────

local currentTotal = 0

local function buildContent(items)
	for _, child in ipairs(oreRows:GetChildren()) do
		if not child:IsA("UIListLayout") then child:Destroy() end
	end

	local rowCount = 0
	local total    = 0

	for order, oreType in ipairs(ORE_ORDER) do
		local qty = items[oreType] or 0
		if qty > 0 then
			rowCount += 1
			local cfg       = OreConfig[oreType]
			local lineTotal = cfg.BaseValue * qty
			total          += lineTotal
			local name      = oreType:sub(1,1):upper() .. oreType:sub(2)

			local row               = Instance.new("Frame")
			row.Size                = UDim2.new(1, 0, 0, ROW_H)
			row.BackgroundTransparency = 1
			row.LayoutOrder         = order
			row.ZIndex              = 52
			row.Parent              = oreRows

			-- Ore icon chip
			local icon               = Instance.new("Frame")
			icon.Size                = UDim2.new(0, 24, 0, 24)
			icon.Position            = UDim2.new(0, 0, 0.5, -12)
			icon.BackgroundColor3    = ORE_COLOR[oreType] or Color3.new(1, 1, 1)
			icon.BorderSizePixel     = 0
			icon.ZIndex              = 53
			icon.Parent              = row
			addCorner(icon, 6)

			-- Ore name + quantity
			local col1              = Instance.new("TextLabel")
			col1.Size               = UDim2.new(0, 112, 1, 0)
			col1.Position           = UDim2.new(0, 34, 0, 0)
			col1.BackgroundTransparency = 1
			col1.TextColor3         = Color3.fromRGB(240, 240, 240)
			col1.Font               = Enum.Font.GothamBold
			col1.TextSize           = 14
			col1.TextXAlignment     = Enum.TextXAlignment.Left
			col1.Text               = string.format("%s  ×%d", name, qty)
			col1.ZIndex             = 53
			col1.Parent             = row

			-- Line total (per unit price would clutter a 380px card -- this game
			-- shows the full line value here, same field the reference calls "price")
			local col2              = Instance.new("TextLabel")
			col2.Size               = UDim2.new(0, 70, 1, 0)
			col2.Position           = UDim2.new(1, -140, 0, 0)
			col2.BackgroundTransparency = 1
			col2.TextColor3         = GOLD
			col2.Font               = Enum.Font.GothamBold
			col2.TextSize           = 14
			col2.TextXAlignment     = Enum.TextXAlignment.Right
			col2.Text               = string.format("₡%d", lineTotal)
			col2.ZIndex             = 53
			col2.Parent             = row

			-- Individual sell button (opens qty picker)
			local sellRowBtn        = Instance.new("TextButton")
			sellRowBtn.Size         = UDim2.new(0, 60, 0, 26)
			sellRowBtn.Position     = UDim2.new(1, -60, 0.5, -13)
			sellRowBtn.BackgroundColor3 = BLUE
			sellRowBtn.BorderSizePixel = 0
			sellRowBtn.TextColor3   = Color3.fromRGB(255, 255, 255)
			sellRowBtn.Font         = Enum.Font.GothamBold
			sellRowBtn.TextSize     = 12
			sellRowBtn.Text         = "Sell"
			sellRowBtn.ZIndex       = 53
			sellRowBtn.Parent       = row
			addCorner(sellRowBtn, 6)

			local capturedType = oreType
			sellRowBtn.MouseButton1Click:Connect(function()
				openPicker(capturedType)
			end)
		end
	end

	local oreH   = rowCount > 0 and (rowCount * ROW_H + (rowCount - 1) * ROW_GAP) or 0
	oreRows.Size = UDim2.new(1, 0, 0, oreH)

	local divY  = oreH + 12
	local footY = divY + 14

	divider.Position       = UDim2.new(0, 0, 0, divY)
	totalCaption.Position  = UDim2.new(0, 0, 0, footY)
	totalLabel.Position    = UDim2.new(0, 0, 0, footY + 14)
	totalLabel.Text        = string.format("₡%d", total)
	sellAllBtn.Position    = UDim2.new(1, -132, 0, footY - 2)

	local contentH  = footY + 40 + 8
	content.Size    = UDim2.new(1, -32, 0, contentH)
	dialog.Size     = UDim2.new(0, 380, 0, CONTENT_Y + contentH + 16)

	currentTotal = total
	return rowCount
end

-- ── Show / hide main dialog ─────────────────────────────────────────────────

local function showNoOresHint()
	local old = playerGui:FindFirstChild("NoOresHint")
	if old then old:Destroy() end

	local gui               = Instance.new("ScreenGui")
	gui.Name                = "NoOresHint"
	gui.ResetOnSpawn        = false
	gui.ZIndexBehavior      = Enum.ZIndexBehavior.Sibling
	gui.Parent              = playerGui

	local frame             = Instance.new("Frame")
	frame.Size              = UDim2.new(0, 300, 0, 42)
	frame.Position          = UDim2.new(0.5, -150, 0.5, -80)
	frame.BackgroundColor3  = Color3.fromRGB(60, 40, 20)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel   = 0
	frame.ZIndex            = 80
	frame.Parent            = gui
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = frame

	local label             = Instance.new("TextLabel")
	label.Size              = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3        = Color3.fromRGB(255, 210, 120)
	label.Font              = Enum.Font.GothamBold
	label.TextSize          = 14
	label.Text              = "You have no ores to sell"
	label.TextTransparency  = 1
	label.ZIndex            = 81
	label.Parent            = frame

	TweenService:Create(frame, TweenInfo.new(0.15), { BackgroundTransparency = 0.2 }):Play()
	TweenService:Create(label, TweenInfo.new(0.15), { TextTransparency = 0 }):Play()

	task.delay(2, function()
		if not frame.Parent then return end
		TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		local out = TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 1 })
		out:Play()
		out.Completed:Connect(function() if gui.Parent then gui:Destroy() end end)
	end)
end

local function openSellUI()
	local rowCount = buildContent(cachedItems)
	if rowCount == 0 then
		showNoOresHint()
		return
	end
	sellScreen.Enabled = true
end

local function closeSellUI()
	closePicker()
	sellScreen.Enabled = false
end

closeBtn.MouseButton1Click:Connect(closeSellUI)

sellAllBtn.MouseButton1Click:Connect(function()
	if currentTotal <= 0 then return end
	SellOre:FireServer()   -- no args → sell all
	sellSound:Play()
	closeSellUI()
end)

-- ── Inventory sync ──────────────────────────────────────────────────────────

Inv_Update.OnClientEvent:Connect(function(items)
	cachedItems = items
	-- Rebuild if the dialog is open so rows and totals stay in sync after a partial sell
	if sellScreen.Enabled and not picker.Visible then
		buildContent(cachedItems)
	end
end)

-- ── Wire up ProximityPrompt ─────────────────────────────────────────────────

task.spawn(function()
	local exchange = workspace:WaitForChild("AtlasOreExchange", 30)
	if not exchange then
		warn("[SellController] AtlasOreExchange not found in Workspace")
		return
	end
	local prompt = exchange:WaitForChild("ExchangePrompt", 10)
	if not prompt then
		warn("[SellController] ExchangePrompt not found on kiosk")
		return
	end
	prompt.Triggered:Connect(openSellUI)
end)

print("[SellController] Loaded")
