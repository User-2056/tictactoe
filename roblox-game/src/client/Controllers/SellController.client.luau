-- SellController: Atlas Ore Exchange sell dialog.
-- Main dialog: per-ore rows with individual [Sell] buttons + a SELL ALL button.
-- Qty picker: sub-modal with TextBox, Half, All shortcuts and live total preview.
-- Server recalculates all values from its own data — no client number is trusted.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
local ROW_H   = 22
local ROW_GAP = 6

-- ── Helper ──────────────────────────────────────────────────────────────────

local function addCorner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = inst
end

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
dialog.Size                   = UDim2.new(0, 410, 0, 60)
dialog.AnchorPoint            = Vector2.new(0.5, 0.5)
dialog.Position               = UDim2.new(0.5, 0, 0.5, 0)
dialog.BackgroundColor3       = Color3.fromRGB(18, 18, 18)
dialog.BackgroundTransparency = 0.05
dialog.BorderSizePixel        = 0
dialog.ZIndex                 = 50
dialog.Parent                 = sellScreen
addCorner(dialog, 10)

-- Title bar
local titleBar                = Instance.new("Frame")
titleBar.Size                 = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3     = Color3.fromRGB(200, 145, 15)
titleBar.BorderSizePixel      = 0
titleBar.ZIndex               = 51
titleBar.Parent               = dialog
addCorner(titleBar, 10)

local titleFill               = Instance.new("Frame")
titleFill.Size                = UDim2.new(1, 0, 0, 10)
titleFill.Position            = UDim2.new(0, 0, 1, -10)
titleFill.BackgroundColor3    = Color3.fromRGB(200, 145, 15)
titleFill.BorderSizePixel     = 0
titleFill.ZIndex              = 51
titleFill.Parent              = titleBar

local titleLabel              = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, -56, 1, 0)
titleLabel.Position           = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextSize           = 15
titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
titleLabel.Text               = "ATLAS ORE EXCHANGE"
titleLabel.ZIndex             = 52
titleLabel.Parent             = titleBar

local closeBtn                = Instance.new("TextButton")
closeBtn.Size                 = UDim2.new(0, 32, 0, 32)
closeBtn.Position             = UDim2.new(1, -40, 0.5, -16)
closeBtn.BackgroundColor3     = Color3.fromRGB(160, 35, 35)
closeBtn.BorderSizePixel      = 0
closeBtn.TextColor3           = Color3.fromRGB(255, 255, 255)
closeBtn.Font                 = Enum.Font.GothamBold
closeBtn.TextSize             = 16
closeBtn.Text                 = "✕"
closeBtn.ZIndex               = 53
closeBtn.Parent               = titleBar
addCorner(closeBtn, 6)

-- Content
local content                 = Instance.new("Frame")
content.Size                  = UDim2.new(1, -32, 0, 0)
content.Position              = UDim2.new(0, 16, 0, 52)
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
divider.BackgroundColor3      = Color3.fromRGB(55, 55, 55)
divider.BorderSizePixel       = 0
divider.ZIndex                = 51
divider.Parent                = content

local totalLabel              = Instance.new("TextLabel")
totalLabel.Size               = UDim2.new(1, 0, 0, 24)
totalLabel.BackgroundTransparency = 1
totalLabel.TextColor3         = Color3.fromRGB(215, 175, 30)
totalLabel.Font               = Enum.Font.GothamBold
totalLabel.TextSize           = 15
totalLabel.TextXAlignment     = Enum.TextXAlignment.Right
totalLabel.Text               = "Total:  ₡0"
totalLabel.ZIndex             = 51
totalLabel.Parent             = content

local sellAllBtn              = Instance.new("TextButton")
sellAllBtn.Size               = UDim2.new(0, 170, 0, 40)
sellAllBtn.AnchorPoint        = Vector2.new(0.5, 0)
sellAllBtn.Position           = UDim2.new(0.5, 0, 0, 0)
sellAllBtn.BackgroundColor3   = Color3.fromRGB(38, 155, 38)
sellAllBtn.BorderSizePixel    = 0
sellAllBtn.TextColor3         = Color3.fromRGB(255, 255, 255)
sellAllBtn.Font               = Enum.Font.GothamBold
sellAllBtn.TextSize           = 15
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
picker.BackgroundColor3       = Color3.fromRGB(22, 22, 22)
picker.BackgroundTransparency = 0
picker.BorderSizePixel        = 0
picker.ZIndex                 = 70
picker.Visible                = false
picker.Parent                 = sellScreen
addCorner(picker, 10)

-- Picker title bar
local pickerTitleBar          = Instance.new("Frame")
pickerTitleBar.Size           = UDim2.new(1, 0, 0, 40)
pickerTitleBar.BackgroundColor3 = Color3.fromRGB(200, 145, 15)
pickerTitleBar.BorderSizePixel = 0
pickerTitleBar.ZIndex         = 71
pickerTitleBar.Parent         = picker
addCorner(pickerTitleBar, 10)

local pickerTitleFill         = Instance.new("Frame")
pickerTitleFill.Size          = UDim2.new(1, 0, 0, 10)
pickerTitleFill.Position      = UDim2.new(0, 0, 1, -10)
pickerTitleFill.BackgroundColor3 = Color3.fromRGB(200, 145, 15)
pickerTitleFill.BorderSizePixel = 0
pickerTitleFill.ZIndex        = 71
pickerTitleFill.Parent        = pickerTitleBar

local pickerTitle             = Instance.new("TextLabel")
pickerTitle.Size              = UDim2.new(1, 0, 1, 0)
pickerTitle.BackgroundTransparency = 1
pickerTitle.TextColor3        = Color3.fromRGB(255, 255, 255)
pickerTitle.Font              = Enum.Font.GothamBold
pickerTitle.TextSize          = 15
pickerTitle.Text              = "Sell Ore"
pickerTitle.ZIndex            = 72
pickerTitle.Parent            = pickerTitleBar

-- "You have: N  •  ₡N each"
local pickerInfo              = Instance.new("TextLabel")
pickerInfo.Size               = UDim2.new(1, -24, 0, 22)
pickerInfo.Position           = UDim2.new(0, 12, 0, 46)
pickerInfo.BackgroundTransparency = 1
pickerInfo.TextColor3         = Color3.fromRGB(180, 180, 180)
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
halfBtn.BackgroundColor3      = Color3.fromRGB(55, 75, 115)
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
allBtn.BackgroundColor3       = Color3.fromRGB(55, 75, 115)
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
qtyBox.BackgroundColor3       = Color3.fromRGB(35, 35, 35)
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
pickerTotal.TextColor3        = Color3.fromRGB(215, 175, 30)
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
pickerCancelBtn.BackgroundColor3 = Color3.fromRGB(80, 28, 28)
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
pickerConfirmBtn.BackgroundColor3 = Color3.fromRGB(38, 155, 38)
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
	local n = tonumber(qtyBox.Text:gsub("[^%d]", "")) or 0
	return math.min(math.max(0, n), pickerMaxQty)
end

local function refreshPickerPreview()
	local qty    = getParsedQty()
	local config = pickerOreType and OreConfig[pickerOreType]
	local total  = config and (config.BaseValue * qty) or 0

	pickerTotal.Text = string.format("Total:  ₡%d", total)

	if qty > 0 then
		pickerConfirmBtn.Text             = string.format("SELL %d", qty)
		pickerConfirmBtn.BackgroundColor3 = Color3.fromRGB(38, 155, 38)
	else
		pickerConfirmBtn.Text             = "SELL"
		pickerConfirmBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
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

			-- Ore name + quantity
			local col1              = Instance.new("TextLabel")
			col1.Size               = UDim2.new(0, 136, 1, 0)
			col1.Position           = UDim2.new(0, 0, 0, 0)
			col1.BackgroundTransparency = 1
			col1.TextColor3         = ORE_COLOR[oreType] or Color3.new(1,1,1)
			col1.Font               = Enum.Font.GothamBold
			col1.TextSize           = 13
			col1.TextXAlignment     = Enum.TextXAlignment.Left
			col1.Text               = string.format("%s  ×%d", name, qty)
			col1.ZIndex             = 53
			col1.Parent             = row

			-- Price per unit
			local col2              = Instance.new("TextLabel")
			col2.Size               = UDim2.new(0, 90, 1, 0)
			col2.Position           = UDim2.new(0, 136, 0, 0)
			col2.BackgroundTransparency = 1
			col2.TextColor3         = Color3.fromRGB(155, 155, 155)
			col2.Font               = Enum.Font.Gotham
			col2.TextSize           = 12
			col2.TextXAlignment     = Enum.TextXAlignment.Left
			col2.Text               = string.format("₡%d each", cfg.BaseValue)
			col2.ZIndex             = 53
			col2.Parent             = row

			-- Line total
			local col3              = Instance.new("TextLabel")
			col3.Size               = UDim2.new(0, 68, 1, 0)
			col3.Position           = UDim2.new(0, 226, 0, 0)
			col3.BackgroundTransparency = 1
			col3.TextColor3         = Color3.fromRGB(215, 175, 30)
			col3.Font               = Enum.Font.GothamBold
			col3.TextSize           = 13
			col3.TextXAlignment     = Enum.TextXAlignment.Right
			col3.Text               = string.format("₡%d", lineTotal)
			col3.ZIndex             = 53
			col3.Parent             = row

			-- Individual sell button (opens qty picker)
			local sellRowBtn        = Instance.new("TextButton")
			sellRowBtn.Size         = UDim2.new(0, 54, 0, 18)
			sellRowBtn.Position     = UDim2.new(1, -54, 0.5, -9)
			sellRowBtn.BackgroundColor3 = Color3.fromRGB(45, 90, 155)
			sellRowBtn.BorderSizePixel = 0
			sellRowBtn.TextColor3   = Color3.fromRGB(255, 255, 255)
			sellRowBtn.Font         = Enum.Font.GothamBold
			sellRowBtn.TextSize     = 11
			sellRowBtn.Text         = "Sell"
			sellRowBtn.ZIndex       = 53
			sellRowBtn.Parent       = row
			addCorner(sellRowBtn, 4)

			local capturedType = oreType
			sellRowBtn.MouseButton1Click:Connect(function()
				openPicker(capturedType)
			end)
		end
	end

	local oreH   = rowCount > 0 and (rowCount * ROW_H + (rowCount - 1) * ROW_GAP) or 0
	oreRows.Size = UDim2.new(1, 0, 0, oreH)

	local divY  = oreH + 10
	local totY  = divY + 9
	local btnY  = totY + 30

	divider.Position      = UDim2.new(0, 0, 0, divY)
	totalLabel.Position   = UDim2.new(0, 0, 0, totY)
	totalLabel.Text       = string.format("Total:  ₡%d", total)
	sellAllBtn.Position   = UDim2.new(0.5, 0, 0, btnY)

	local contentH  = btnY + 40 + 16
	content.Size    = UDim2.new(1, -32, 0, contentH)
	dialog.Size     = UDim2.new(0, 410, 0, 52 + contentH + 16)

	currentTotal = total
	return rowCount
end

-- ── Show / hide main dialog ─────────────────────────────────────────────────

local function openSellUI()
	local rowCount = buildContent(cachedItems)
	if rowCount == 0 then return end
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
