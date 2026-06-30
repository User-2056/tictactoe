-- SellController: Atlas Ore Exchange interaction and sell dialog.
-- Opens when the player triggers the ProximityPrompt on the kiosk.
-- Sends SellOre to the server with NO value payload — the server
-- recalculates the total from its own stored inventory independently.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local OreConfig = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("OreConfig"))

local Remotes    = ReplicatedStorage:WaitForChild("Remotes")
local SellOre    = Remotes:WaitForChild("SellOre")
local Inv_Update = Remotes:WaitForChild("Inv_Update")

-- Cached inventory snapshot kept in sync with Inv_Update
local cachedItems = {}

-- ── Build the sell ScreenGui (persists across respawns) ─────────────────────

local sellScreen              = Instance.new("ScreenGui")
sellScreen.Name               = "SellScreen"
sellScreen.ResetOnSpawn       = false   -- we create it once; don't let respawn wipe it
sellScreen.ZIndexBehavior     = Enum.ZIndexBehavior.Sibling
sellScreen.Enabled            = false
sellScreen.Parent             = playerGui

-- Backdrop (darkens the game while dialog is open)
local backdrop                = Instance.new("Frame")
backdrop.Name                 = "Backdrop"
backdrop.Size                 = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3     = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.55
backdrop.BorderSizePixel      = 0
backdrop.ZIndex               = 49
backdrop.Parent               = sellScreen

-- Main dialog
local dialog                  = Instance.new("Frame")
dialog.Name                   = "Dialog"
dialog.Size                   = UDim2.new(0, 380, 0, 60)   -- height set dynamically
dialog.AnchorPoint            = Vector2.new(0.5, 0.5)
dialog.Position               = UDim2.new(0.5, 0, 0.5, 0)
dialog.BackgroundColor3       = Color3.fromRGB(18, 18, 18)
dialog.BackgroundTransparency = 0.05
dialog.BorderSizePixel        = 0
dialog.ZIndex                 = 50
dialog.Parent                 = sellScreen

local dialogCorner            = Instance.new("UICorner")
dialogCorner.CornerRadius     = UDim.new(0, 10)
dialogCorner.Parent           = dialog

-- ── Title bar ───────────────────────────────────────────────────────────────

local titleBar                = Instance.new("Frame")
titleBar.Name                 = "TitleBar"
titleBar.Size                 = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3     = Color3.fromRGB(200, 145, 15)
titleBar.BorderSizePixel      = 0
titleBar.ZIndex               = 51
titleBar.Parent               = dialog

local titleCorner             = Instance.new("UICorner")
titleCorner.CornerRadius      = UDim.new(0, 10)
titleCorner.Parent            = titleBar

-- Cover the bottom rounded corners of the title bar so it meets dialog body flush
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

local closeBtnCorner          = Instance.new("UICorner")
closeBtnCorner.CornerRadius   = UDim.new(0, 6)
closeBtnCorner.Parent         = closeBtn

-- ── Content area ────────────────────────────────────────────────────────────

local content                 = Instance.new("Frame")
content.Name                  = "Content"
content.Size                  = UDim2.new(1, -32, 0, 0)   -- height set dynamically
content.Position              = UDim2.new(0, 16, 0, 52)
content.BackgroundTransparency = 1
content.ZIndex                = 51
content.Parent                = dialog

-- Ore rows (one row per ore type with qty > 0)
local oreRows                 = Instance.new("Frame")
oreRows.Name                  = "OreRows"
oreRows.Size                  = UDim2.new(1, 0, 0, 0)
oreRows.BackgroundTransparency = 1
oreRows.ZIndex                = 51
oreRows.Parent                = content

local rowLayout               = Instance.new("UIListLayout")
rowLayout.SortOrder           = Enum.SortOrder.LayoutOrder
rowLayout.Padding             = UDim.new(0, 6)
rowLayout.Parent              = oreRows

local divider                 = Instance.new("Frame")
divider.Name                  = "Divider"
divider.Size                  = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3      = Color3.fromRGB(55, 55, 55)
divider.BorderSizePixel       = 0
divider.ZIndex                = 51
divider.Parent                = content

local totalLabel              = Instance.new("TextLabel")
totalLabel.Name               = "TotalLabel"
totalLabel.Size               = UDim2.new(1, 0, 0, 24)
totalLabel.BackgroundTransparency = 1
totalLabel.TextColor3         = Color3.fromRGB(215, 175, 30)
totalLabel.Font               = Enum.Font.GothamBold
totalLabel.TextSize           = 15
totalLabel.TextXAlignment     = Enum.TextXAlignment.Right
totalLabel.Text               = "Total:  ₡0"
totalLabel.ZIndex             = 51
totalLabel.Parent             = content

local sellBtn                 = Instance.new("TextButton")
sellBtn.Name                  = "SellAllBtn"
sellBtn.Size                  = UDim2.new(0, 170, 0, 40)
sellBtn.AnchorPoint           = Vector2.new(0.5, 0)
sellBtn.Position              = UDim2.new(0.5, 0, 0, 0)   -- Y set dynamically
sellBtn.BackgroundColor3      = Color3.fromRGB(38, 155, 38)
sellBtn.BorderSizePixel       = 0
sellBtn.TextColor3            = Color3.fromRGB(255, 255, 255)
sellBtn.Font                  = Enum.Font.GothamBold
sellBtn.TextSize              = 15
sellBtn.Text                  = "SELL ALL"
sellBtn.ZIndex                = 51
sellBtn.Parent                = content

local sellBtnCorner           = Instance.new("UICorner")
sellBtnCorner.CornerRadius    = UDim.new(0, 8)
sellBtnCorner.Parent          = sellBtn

-- ── Sell confirmation sound ─────────────────────────────────────────────────

local sellSound               = Instance.new("Sound")
sellSound.Name                = "SellSound"
sellSound.SoundId             = "rbxassetid://9125616843"   -- metallic coin clinks, 0.9s
sellSound.Volume              = 0.85
sellSound.Parent              = sellScreen

-- ── Ore display constants ───────────────────────────────────────────────────

local ORE_ORDER = { "stone", "coal", "iron", "gold" }
local ORE_COLOR = {
	stone = Color3.fromRGB(180, 178, 180),
	coal  = Color3.fromRGB(140, 140, 140),
	iron  = Color3.fromRGB(180, 130, 100),
	gold  = Color3.fromRGB(215, 175, 30),
}
local ROW_H   = 22
local ROW_GAP = 6

-- ── Build and show/hide ─────────────────────────────────────────────────────

local currentTotal = 0

local function buildContent(items)
	-- Clear old rows
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

			local name = oreType:sub(1,1):upper() .. oreType:sub(2)

			local row               = Instance.new("Frame")
			row.Size                = UDim2.new(1, 0, 0, ROW_H)
			row.BackgroundTransparency = 1
			row.LayoutOrder         = order
			row.ZIndex              = 52
			row.Parent              = oreRows

			-- Ore name + quantity
			local col1              = Instance.new("TextLabel")
			col1.Size               = UDim2.new(0.42, 0, 1, 0)
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
			col2.Size               = UDim2.new(0.33, 0, 1, 0)
			col2.Position           = UDim2.new(0.42, 0, 0, 0)
			col2.BackgroundTransparency = 1
			col2.TextColor3         = Color3.fromRGB(160, 160, 160)
			col2.Font               = Enum.Font.Gotham
			col2.TextSize           = 12
			col2.TextXAlignment     = Enum.TextXAlignment.Left
			col2.Text               = string.format("₡%d each", cfg.BaseValue)
			col2.ZIndex             = 53
			col2.Parent             = row

			-- Line total (right-aligned)
			local col3              = Instance.new("TextLabel")
			col3.Size               = UDim2.new(0.25, 0, 1, 0)
			col3.Position           = UDim2.new(0.75, 0, 0, 0)
			col3.BackgroundTransparency = 1
			col3.TextColor3         = Color3.fromRGB(215, 175, 30)
			col3.Font               = Enum.Font.GothamBold
			col3.TextSize           = 13
			col3.TextXAlignment     = Enum.TextXAlignment.Right
			col3.Text               = string.format("₡%d", lineTotal)
			col3.ZIndex             = 53
			col3.Parent             = row
		end
	end

	-- Resize ore rows container
	local oreH = rowCount > 0 and (rowCount * ROW_H + (rowCount - 1) * ROW_GAP) or 0
	oreRows.Size = UDim2.new(1, 0, 0, oreH)

	-- Position divider, total, sell button below the rows
	local divY  = oreH + 10
	local totY  = divY + 9
	local btnY  = totY + 30

	divider.Position    = UDim2.new(0, 0, 0, divY)
	totalLabel.Position = UDim2.new(0, 0, 0, totY)
	totalLabel.Text     = string.format("Total:  ₡%d", total)
	sellBtn.Position    = UDim2.new(0.5, 0, 0, btnY)

	-- Resize dialog to fit all content
	local contentH  = btnY + 40 + 16    -- button height + bottom padding
	content.Size    = UDim2.new(1, -32, 0, contentH)
	dialog.Size     = UDim2.new(0, 380, 0, 52 + contentH + 16)

	currentTotal = total
	return rowCount
end

local function openSellUI()
	local rowCount = buildContent(cachedItems)
	if rowCount == 0 then return end   -- nothing to sell, stay closed
	sellScreen.Enabled = true
end

local function closeSellUI()
	sellScreen.Enabled = false
end

closeBtn.MouseButton1Click:Connect(closeSellUI)

sellBtn.MouseButton1Click:Connect(function()
	if currentTotal <= 0 then closeSellUI() return end
	-- Fire to server — NO value payload; server recalculates from its own data
	SellOre:FireServer()
	sellSound:Play()
	closeSellUI()
end)

-- ── Keep cached inventory in sync ──────────────────────────────────────────

Inv_Update.OnClientEvent:Connect(function(items)
	cachedItems = items
end)

-- ── Wire up the ProximityPrompt on the kiosk ───────────────────────────────

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
