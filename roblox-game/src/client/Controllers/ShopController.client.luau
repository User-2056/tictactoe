-- ShopController: Frontier Mining Supplies shop — opened by ProximityPrompt on the kiosk.
-- Reads EquipmentConfig from ReplicatedStorage for display; fires PurchaseEquipment to server.
-- Refreshes buy-button states automatically when Eq_Update or Eco_CreditsUpdate arrive.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local PurchaseEquipment = Remotes:WaitForChild("PurchaseEquipment")
local Eq_Update         = Remotes:WaitForChild("Eq_Update")
local Eco_CreditsUpdate = Remotes:WaitForChild("Eco_CreditsUpdate")

local EquipmentConfig = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("EquipmentConfig"))

-- ── State ────────────────────────────────────────────────────────────────────

local cachedBalance      = 0
local equippedPickaxeId  = "starter_pickaxe"
local equippedBackpackId = "starter_backpack"
local pendingPurchaseId  = nil   -- set when purchase fires; cleared when Eq_Update confirms it
local isShopOpen         = false

-- ── Helpers ──────────────────────────────────────────────────────────────────

local function addCorner(inst, r)
	local c           = Instance.new("UICorner")
	c.CornerRadius    = UDim.new(0, r)
	c.Parent          = inst
end

local function fmtNum(n)
	local s = tostring(math.floor(n)):reverse()
	return (s:gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
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
dialog.Size                   = UDim2.new(0, 680, 0, 440)
dialog.Position               = UDim2.new(0.5, -340, 0.5, -220)
dialog.BackgroundColor3       = Color3.fromRGB(25, 25, 30)
dialog.BorderSizePixel        = 0
dialog.ZIndex                 = 51
dialog.Parent                 = shopScreen
addCorner(dialog, 10)

-- Title bar (gold)
local titleBar                = Instance.new("Frame")
titleBar.Name                 = "TitleBar"
titleBar.Size                 = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3     = Color3.fromRGB(180, 130, 15)
titleBar.BorderSizePixel      = 0
titleBar.ZIndex               = 52
titleBar.Parent               = dialog
addCorner(titleBar, 10)

-- Mask bottom two corners so only top is rounded
local titleMask               = Instance.new("Frame")
titleMask.Size                = UDim2.new(1, 0, 0.5, 0)
titleMask.Position            = UDim2.new(0, 0, 0.5, 0)
titleMask.BackgroundColor3    = Color3.fromRGB(180, 130, 15)
titleMask.BorderSizePixel     = 0
titleMask.ZIndex              = 52
titleMask.Parent              = titleBar

local titleLabel              = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, -56, 1, 0)
titleLabel.Position           = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextSize           = 17
titleLabel.Text               = "FRONTIER MINING SUPPLIES"
titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
titleLabel.ZIndex             = 53
titleLabel.Parent             = titleBar

local closeBtn                = Instance.new("TextButton")
closeBtn.Name                 = "CloseBtn"
closeBtn.Size                 = UDim2.new(0, 34, 0, 34)
closeBtn.Position             = UDim2.new(1, -42, 0.5, -17)
closeBtn.BackgroundColor3     = Color3.fromRGB(200, 60, 60)
closeBtn.Text                 = "✕"
closeBtn.TextColor3           = Color3.fromRGB(255, 255, 255)
closeBtn.Font                 = Enum.Font.GothamBold
closeBtn.TextSize             = 15
closeBtn.ZIndex               = 54
closeBtn.Parent               = titleBar
addCorner(closeBtn, 6)

-- Upgrade confirmation sound (short positive chime)
local upgradeSound            = Instance.new("Sound")
upgradeSound.SoundId          = "rbxassetid://9119745960"
upgradeSound.Volume           = 0.7
upgradeSound.Parent           = shopScreen

-- ── Two-column content area ───────────────────────────────────────────────────

local CONTENT_TOP = 56   -- pixels below top of dialog (below title bar + gap)
local COL_W       = 308
local ITEM_H      = 80
local ITEM_GAP    = 6
local SECTION_H   = 34
local COL_PAD     = 14

-- Left column — Pickaxes
local leftCol                 = Instance.new("Frame")
leftCol.Name                  = "PickaxeCol"
leftCol.Size                  = UDim2.new(0, COL_W, 1, -CONTENT_TOP - 12)
leftCol.Position              = UDim2.new(0, COL_PAD, 0, CONTENT_TOP)
leftCol.BackgroundTransparency = 1
leftCol.ZIndex                = 52
leftCol.Parent                = dialog

local pickaxeHeader           = Instance.new("TextLabel")
pickaxeHeader.Size            = UDim2.new(1, 0, 0, SECTION_H)
pickaxeHeader.BackgroundTransparency = 1
pickaxeHeader.TextColor3      = Color3.fromRGB(215, 175, 30)
pickaxeHeader.Font            = Enum.Font.GothamBold
pickaxeHeader.TextSize        = 13
pickaxeHeader.Text            = "PICKAXES"
pickaxeHeader.TextXAlignment  = Enum.TextXAlignment.Left
pickaxeHeader.ZIndex          = 52
pickaxeHeader.Parent          = leftCol

local pickaxeList             = Instance.new("Frame")
pickaxeList.Name              = "PickaxeList"
pickaxeList.Size              = UDim2.new(1, 0, 1, -SECTION_H)
pickaxeList.Position          = UDim2.new(0, 0, 0, SECTION_H)
pickaxeList.BackgroundTransparency = 1
pickaxeList.ZIndex            = 52
pickaxeList.Parent            = leftCol

local pickaxeLayout           = Instance.new("UIListLayout")
pickaxeLayout.SortOrder       = Enum.SortOrder.LayoutOrder
pickaxeLayout.Padding         = UDim.new(0, ITEM_GAP)
pickaxeLayout.Parent          = pickaxeList

-- Vertical divider
local divider                 = Instance.new("Frame")
divider.Name                  = "Divider"
divider.Size                  = UDim2.new(0, 2, 1, -CONTENT_TOP - 20)
divider.Position              = UDim2.new(0, COL_PAD + COL_W + 7, 0, CONTENT_TOP + 8)
divider.BackgroundColor3      = Color3.fromRGB(55, 55, 65)
divider.BorderSizePixel       = 0
divider.ZIndex                = 52
divider.Parent                = dialog

-- Right column — Backpacks
local rightCol                = Instance.new("Frame")
rightCol.Name                 = "BackpackCol"
rightCol.Size                 = UDim2.new(0, COL_W, 1, -CONTENT_TOP - 12)
rightCol.Position             = UDim2.new(0, COL_PAD + COL_W + 18, 0, CONTENT_TOP)
rightCol.BackgroundTransparency = 1
rightCol.ZIndex               = 52
rightCol.Parent               = dialog

local backpackHeader          = Instance.new("TextLabel")
backpackHeader.Size           = UDim2.new(1, 0, 0, SECTION_H)
backpackHeader.BackgroundTransparency = 1
backpackHeader.TextColor3     = Color3.fromRGB(215, 175, 30)
backpackHeader.Font           = Enum.Font.GothamBold
backpackHeader.TextSize       = 13
backpackHeader.Text           = "BACKPACKS"
backpackHeader.TextXAlignment = Enum.TextXAlignment.Left
backpackHeader.ZIndex         = 52
backpackHeader.Parent         = rightCol

local backpackList            = Instance.new("Frame")
backpackList.Name             = "BackpackList"
backpackList.Size             = UDim2.new(1, 0, 1, -SECTION_H)
backpackList.Position         = UDim2.new(0, 0, 0, SECTION_H)
backpackList.BackgroundTransparency = 1
backpackList.ZIndex           = 52
backpackList.Parent           = rightCol

local backpackLayout          = Instance.new("UIListLayout")
backpackLayout.SortOrder      = Enum.SortOrder.LayoutOrder
backpackLayout.Padding        = UDim.new(0, ITEM_GAP)
backpackLayout.Parent         = backpackList

-- ── Item card builder ─────────────────────────────────────────────────────────

local itemEntries = {}   -- { btn, itemType, item } for refreshButtons()

local function makeItemCard(parent, itemType, item, order)
	local card                    = Instance.new("Frame")
	card.Name                     = item.Id
	card.Size                     = UDim2.new(1, 0, 0, ITEM_H)
	card.BackgroundColor3         = Color3.fromRGB(36, 36, 46)
	card.BorderSizePixel          = 0
	card.LayoutOrder              = order
	card.ZIndex                   = 53
	card.Parent                   = parent
	addCorner(card, 7)

	-- Item name (top-left)
	local nameLabel               = Instance.new("TextLabel")
	nameLabel.Size                = UDim2.new(1, -104, 0, 22)
	nameLabel.Position            = UDim2.new(0, 12, 0, 10)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3          = Color3.fromRGB(240, 240, 240)
	nameLabel.Font                = Enum.Font.GothamBold
	nameLabel.TextSize            = 14
	nameLabel.Text                = item.Name
	nameLabel.TextXAlignment      = Enum.TextXAlignment.Left
	nameLabel.ZIndex              = 54
	nameLabel.Parent              = card

	-- Stat (bottom-left)
	local statLabel               = Instance.new("TextLabel")
	statLabel.Size                = UDim2.new(1, -104, 0, 18)
	statLabel.Position            = UDim2.new(0, 12, 0, 36)
	statLabel.BackgroundTransparency = 1
	statLabel.Font                = Enum.Font.Gotham
	statLabel.TextSize            = 12
	statLabel.TextXAlignment      = Enum.TextXAlignment.Left
	statLabel.ZIndex              = 54
	statLabel.Parent              = card

	if itemType == "pickaxe" then
		statLabel.TextColor3 = Color3.fromRGB(163, 162, 165)
		statLabel.Text = string.format("Mining Power  ×%d", item.MiningPower)
	else
		statLabel.TextColor3 = Color3.fromRGB(100, 180, 240)
		statLabel.Text = string.format("Capacity  %d kg", item.Capacity)
	end

	-- Price (top-right)
	local priceLabel              = Instance.new("TextLabel")
	priceLabel.Name               = "Price"
	priceLabel.Size               = UDim2.new(0, 90, 0, 22)
	priceLabel.Position           = UDim2.new(1, -102, 0, 10)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Font               = Enum.Font.GothamBold
	priceLabel.TextSize           = 13
	priceLabel.TextXAlignment     = Enum.TextXAlignment.Right
	priceLabel.ZIndex             = 54
	priceLabel.Parent             = card

	if item.Cost == 0 then
		priceLabel.TextColor3 = Color3.fromRGB(100, 210, 100)
		priceLabel.Text       = "Free"
	else
		priceLabel.TextColor3 = Color3.fromRGB(215, 175, 30)
		priceLabel.Text       = "₡" .. fmtNum(item.Cost)
	end

	-- Buy / Equipped button (bottom-right)
	local btn                     = Instance.new("TextButton")
	btn.Name                      = "BuyBtn"
	btn.Size                      = UDim2.new(0, 90, 0, 28)
	btn.Position                  = UDim2.new(1, -102, 0, 40)
	btn.BorderSizePixel           = 0
	btn.Font                      = Enum.Font.GothamBold
	btn.TextSize                  = 12
	btn.ZIndex                    = 54
	btn.Parent                    = card
	addCorner(btn, 6)

	local capturedType = itemType
	local capturedItem = item
	btn.MouseButton1Click:Connect(function()
		if capturedItem.Cost <= 0 then return end
		local isEquipped = (capturedType == "pickaxe"  and equippedPickaxeId  == capturedItem.Id)
		               or  (capturedType == "backpack" and equippedBackpackId == capturedItem.Id)
		if isEquipped then return end
		if cachedBalance < capturedItem.Cost then return end
		pendingPurchaseId = capturedItem.Id
		PurchaseEquipment:FireServer(capturedType, capturedItem.Id)
	end)

	table.insert(itemEntries, { btn = btn, itemType = itemType, item = item })
end

-- Build all cards
for i, p in ipairs(EquipmentConfig.Pickaxes)  do makeItemCard(pickaxeList,  "pickaxe",  p, i) end
for i, b in ipairs(EquipmentConfig.Backpacks) do makeItemCard(backpackList, "backpack", b, i) end

-- ── Button state refresh ──────────────────────────────────────────────────────

local function refreshButtons()
	for _, entry in ipairs(itemEntries) do
		local btn  = entry.btn
		local kind = entry.itemType
		local item = entry.item

		local isEquipped = (kind == "pickaxe"  and equippedPickaxeId  == item.Id)
		               or  (kind == "backpack" and equippedBackpackId == item.Id)
		local isFree     = item.Cost <= 0
		local canAfford  = cachedBalance >= item.Cost

		if isEquipped or isFree then
			btn.Text             = "Equipped"
			btn.BackgroundColor3 = Color3.fromRGB(45, 155, 75)
			btn.TextColor3       = Color3.fromRGB(255, 255, 255)
			btn.AutoButtonColor  = false
		elseif canAfford then
			btn.Text             = "Buy"
			btn.BackgroundColor3 = Color3.fromRGB(50, 110, 200)
			btn.TextColor3       = Color3.fromRGB(255, 255, 255)
			btn.AutoButtonColor  = true
		else
			btn.Text             = "₡" .. fmtNum(item.Cost)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
			btn.TextColor3       = Color3.fromRGB(130, 130, 145)
			btn.AutoButtonColor  = false
		end
	end
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
	refreshButtons()
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
	if isShopOpen then refreshButtons() end
end)

Eq_Update.OnClientEvent:Connect(function(pickaxeId, backpackId)
	local prevPickaxe  = equippedPickaxeId
	local prevBackpack = equippedBackpackId
	equippedPickaxeId  = pickaxeId
	equippedBackpackId = backpackId

	if isShopOpen then refreshButtons() end

	-- Show toast only when this Eq_Update is confirming a pending purchase
	if pendingPurchaseId then
		if pickaxeId ~= prevPickaxe then
			for _, p in ipairs(EquipmentConfig.Pickaxes) do
				if p.Id == pickaxeId then
					upgradeSound:Play()
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
		prompt.Triggered:Connect(function(triggeringPlayer)
			if triggeringPlayer == player then openShop() end
		end)
	else
		warn("[ShopController] ShopPrompt not found on PickaxeShop")
	end
else
	warn("[ShopController] PickaxeShop not found in Workspace")
end

print("[ShopController] Loaded")
