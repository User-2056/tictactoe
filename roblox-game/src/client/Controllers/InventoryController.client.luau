-- InventoryController: Builds the inventory panel in the HUD and keeps it live.
-- Listens for Inv_Update (server snapshot) and Inv_Full (bag-full notification).
-- Never sends inventory data to the server — read-only on the client.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local Inv_Update        = Remotes:WaitForChild("Inv_Update")
local Inv_Full          = Remotes:WaitForChild("Inv_Full")
local Eco_CreditsUpdate = Remotes:WaitForChild("Eco_CreditsUpdate")

local hud = playerGui:WaitForChild("HUD")

-- ── Credits display (top-left) ──────────────────────────────────────────────

local creditsLabel              = Instance.new("TextLabel")
creditsLabel.Name               = "CreditsLabel"
creditsLabel.Size               = UDim2.new(0, 150, 0, 36)
creditsLabel.Position           = UDim2.new(0, 12, 0, 12)
creditsLabel.BackgroundColor3   = Color3.fromRGB(15, 15, 15)
creditsLabel.BackgroundTransparency = 0.35
creditsLabel.BorderSizePixel    = 0
creditsLabel.TextColor3         = Color3.fromRGB(215, 175, 30)
creditsLabel.Font               = Enum.Font.GothamBold
creditsLabel.TextSize           = 18
creditsLabel.Text               = "₡ 0"
creditsLabel.ZIndex             = 5
creditsLabel.Parent             = hud

local creditsCorner             = Instance.new("UICorner")
creditsCorner.CornerRadius      = UDim.new(0, 7)
creditsCorner.Parent            = creditsLabel

Eco_CreditsUpdate.OnClientEvent:Connect(function(balance)
	creditsLabel.Text = string.format("₡ %d", math.floor(balance))
end)

-- Display order and colours for the ore list
local ORE_ORDER = { "stone", "coal", "iron", "gold" }
local ORE_COLOR = {
	stone = Color3.fromRGB(180, 178, 180),
	coal  = Color3.fromRGB(130, 130, 130),
	iron  = Color3.fromRGB(180, 130, 100),
	gold  = Color3.fromRGB(215, 175, 30),
}

-- ── Build the panel once ────────────────────────────────────────────────────

local panel = Instance.new("Frame")
panel.Name                   = "InventoryPanel"
panel.Size                   = UDim2.new(0, 175, 0, 62)  -- grows downward as ore is added
panel.Position               = UDim2.new(0, 12, 1, -12)
panel.AnchorPoint            = Vector2.new(0, 1)
panel.BackgroundColor3       = Color3.fromRGB(15, 15, 15)
panel.BackgroundTransparency = 0.38
panel.BorderSizePixel        = 0
panel.Parent                 = hud

local panelCorner            = Instance.new("UICorner")
panelCorner.CornerRadius     = UDim.new(0, 7)
panelCorner.Parent           = panel

-- "BAG" header
local header                 = Instance.new("TextLabel")
header.Name                  = "Header"
header.Size                  = UDim2.new(1, -20, 0, 14)
header.Position              = UDim2.new(0, 10, 0, 8)
header.BackgroundTransparency = 1
header.TextColor3            = Color3.fromRGB(200, 200, 200)
header.Font                  = Enum.Font.GothamBold
header.TextSize              = 11
header.TextXAlignment        = Enum.TextXAlignment.Left
header.Text                  = "BAG"
header.Parent                = panel

-- "0 / 100 kg" label
local weightLabel            = Instance.new("TextLabel")
weightLabel.Name             = "WeightLabel"
weightLabel.Size             = UDim2.new(1, -20, 0, 14)
weightLabel.Position         = UDim2.new(0, 10, 0, 24)
weightLabel.BackgroundTransparency = 1
weightLabel.TextColor3       = Color3.fromRGB(220, 220, 220)
weightLabel.Font             = Enum.Font.Gotham
weightLabel.TextSize         = 11
weightLabel.TextXAlignment   = Enum.TextXAlignment.Left
weightLabel.Text             = "0 / 100 kg"
weightLabel.Parent           = panel

-- Progress bar track
local barBg                  = Instance.new("Frame")
barBg.Name                   = "BarBg"
barBg.Size                   = UDim2.new(1, -20, 0, 6)
barBg.Position               = UDim2.new(0, 10, 0, 40)
barBg.BackgroundColor3       = Color3.fromRGB(50, 50, 50)
barBg.BorderSizePixel        = 0
barBg.Parent                 = panel

local barBgCorner            = Instance.new("UICorner")
barBgCorner.CornerRadius     = UDim.new(0, 3)
barBgCorner.Parent           = barBg

-- Progress bar fill (starts at 0 width)
local barFill                = Instance.new("Frame")
barFill.Name                 = "BarFill"
barFill.Size                 = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3     = Color3.fromRGB(80, 200, 80)
barFill.BorderSizePixel      = 0
barFill.Parent               = barBg

local fillCorner             = Instance.new("UICorner")
fillCorner.CornerRadius      = UDim.new(0, 3)
fillCorner.Parent            = barFill

-- Ore list container (height updated dynamically)
local oreList                = Instance.new("Frame")
oreList.Name                 = "OreList"
oreList.Size                 = UDim2.new(1, -20, 0, 0)
oreList.Position             = UDim2.new(0, 10, 0, 54)
oreList.BackgroundTransparency = 1
oreList.ClipsDescendants     = false
oreList.Parent               = panel

local listLayout             = Instance.new("UIListLayout")
listLayout.SortOrder         = Enum.SortOrder.LayoutOrder
listLayout.Padding           = UDim.new(0, 2)
listLayout.Parent            = oreList

-- ── Update HUD from server snapshot ────────────────────────────────────────

local COLOR_NORMAL = Color3.fromRGB(80, 200, 80)
local COLOR_FULL   = Color3.fromRGB(220, 50,  50)
local ROW_H        = 14
local ROW_GAP      = 2

local function updateHUD(items, currentWeight, maxWeight)
	-- Weight label
	weightLabel.Text = string.format("%d / %d kg", math.floor(currentWeight), maxWeight)

	-- Progress bar (tween for smooth fill)
	local pct   = currentWeight / maxWeight
	local color = pct >= 1 and COLOR_FULL or COLOR_NORMAL
	TweenService:Create(barFill, TweenInfo.new(0.18), {
		Size             = UDim2.new(math.min(1, pct), 0, 1, 0),
		BackgroundColor3 = color,
	}):Play()

	-- Rebuild ore rows (only show ores with qty > 0)
	for _, child in ipairs(oreList:GetChildren()) do
		if child:IsA("TextLabel") then child:Destroy() end
	end

	local rowCount = 0
	for order, oreType in ipairs(ORE_ORDER) do
		local qty = items[oreType] or 0
		if qty > 0 then
			rowCount += 1
			local name = oreType:sub(1,1):upper() .. oreType:sub(2)

			local row                    = Instance.new("TextLabel")
			row.Size                     = UDim2.new(1, 0, 0, ROW_H)
			row.BackgroundTransparency   = 1
			row.TextColor3               = ORE_COLOR[oreType] or Color3.new(1,1,1)
			row.Font                     = Enum.Font.Gotham
			row.TextSize                 = 11
			row.TextXAlignment           = Enum.TextXAlignment.Left
			row.Text                     = string.format("%s  ×%d", name, qty)
			row.LayoutOrder              = order
			row.Parent                   = oreList
		end
	end

	-- Resize oreList and panel to fit content
	local oreH = rowCount > 0 and (rowCount * ROW_H + (rowCount - 1) * ROW_GAP) or 0
	oreList.Size  = UDim2.new(1, -20, 0, oreH)
	panel.Size    = UDim2.new(0, 175, 0, 62 + oreH + (oreH > 0 and 8 or 0))
end

Inv_Update.OnClientEvent:Connect(updateHUD)

-- ── Inventory-full toast ────────────────────────────────────────────────────

Inv_Full.OnClientEvent:Connect(function()
	-- Destroy any existing toast so the timer resets
	local old = hud:FindFirstChild("InvFullToast")
	if old then old:Destroy() end

	local toast                    = Instance.new("Frame")
	toast.Name                     = "InvFullToast"
	toast.Size                     = UDim2.new(0, 340, 0, 38)
	toast.Position                 = UDim2.new(0.5, -170, 0, 56)
	toast.BackgroundColor3         = Color3.fromRGB(175, 40, 40)
	toast.BackgroundTransparency   = 1
	toast.BorderSizePixel          = 0
	toast.ZIndex                   = 20
	toast.Parent                   = hud

	local toastCorner              = Instance.new("UICorner")
	toastCorner.CornerRadius       = UDim.new(0, 7)
	toastCorner.Parent             = toast

	local toastLabel               = Instance.new("TextLabel")
	toastLabel.Size                = UDim2.new(1, 0, 1, 0)
	toastLabel.BackgroundTransparency = 1
	toastLabel.TextColor3          = Color3.fromRGB(255, 255, 255)
	toastLabel.Font                = Enum.Font.GothamBold
	toastLabel.TextSize            = 13
	toastLabel.Text                = "Inventory Full — return to camp to sell or store resources"
	toastLabel.TextXAlignment      = Enum.TextXAlignment.Center
	toastLabel.TextTransparency    = 1
	toastLabel.ZIndex              = 21
	toastLabel.Parent              = toast

	-- Fade in
	TweenService:Create(toast,      TweenInfo.new(0.2), { BackgroundTransparency = 0.15 }):Play()
	TweenService:Create(toastLabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()

	-- Fade out after 2.8 s
	task.delay(2.8, function()
		if not toast.Parent then return end
		TweenService:Create(toast,      TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
		local fadeText = TweenService:Create(toastLabel, TweenInfo.new(0.4), { TextTransparency = 1 })
		fadeText:Play()
		fadeText.Completed:Connect(function()
			if toast.Parent then toast:Destroy() end
		end)
	end)
end)

print("[InventoryController] Loaded")
