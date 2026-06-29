--!strict
-- ContractUI.luau
-- Toggle with C key. Shows 3 active contracts with progress bars.
-- Refresh button sends Contract_Refresh remote (server enforces cooldown).

local Players           = game:GetService("Players")
local UIS               = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared    = ReplicatedStorage:WaitForChild("Shared")
local RE        = require(Shared.RemoteEvents)
local OreConfig = require(Shared.Config.OreConfig)

local ContractUI = {}

local cards:      { Frame } = {}
local refreshBtn: TextButton
local gui:        ScreenGui

local function build(): ScreenGui
    local g = Instance.new("ScreenGui")
    g.Name         = "ContractUI"
    g.ResetOnSpawn = false
    g.Enabled      = false
    g.Parent       = Players.LocalPlayer:WaitForChild("PlayerGui")

    local fr = Instance.new("Frame")
    fr.Size     = UDim2.new(0, 295, 0, 295)
    fr.Position = UDim2.new(1, -305, 0.5, -148)
    fr.BackgroundColor3       = Color3.fromRGB(10, 10, 28)
    fr.BackgroundTransparency = 0.18
    fr.Parent = g
    Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel")
    title.Size               = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.TextColor3         = Color3.new(1, 1, 1)
    title.Font               = Enum.Font.GothamBold
    title.TextSize           = 15
    title.Text               = "Contracts  [C]"
    title.Parent             = fr

    for i = 1, 3 do
        local card = Instance.new("Frame")
        card.Size     = UDim2.new(1, -10, 0, 66)
        card.Position = UDim2.new(0, 5, 0, 28 + (i - 1) * 72)
        card.BackgroundColor3 = Color3.fromRGB(22, 22, 44)
        card.Parent   = fr
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
        cards[i] = card

        local desc = Instance.new("TextLabel")
        desc.Name              = "Desc"
        desc.Size              = UDim2.new(1, -8, 0, 22)
        desc.Position          = UDim2.new(0, 4, 0, 2)
        desc.BackgroundTransparency = 1
        desc.TextColor3        = Color3.fromRGB(210, 210, 210)
        desc.TextXAlignment    = Enum.TextXAlignment.Left
        desc.Font              = Enum.Font.Gotham
        desc.TextSize          = 12
        desc.Text              = "Loading..."
        desc.Parent            = card

        local bg = Instance.new("Frame")
        bg.Name     = "BarBG"
        bg.Size     = UDim2.new(1, -8, 0, 10)
        bg.Position = UDim2.new(0, 4, 0, 26)
        bg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        bg.Parent   = card
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)

        local fill = Instance.new("Frame")
        fill.Name   = "Fill"
        fill.Size   = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        fill.Parent = bg
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

        local reward = Instance.new("TextLabel")
        reward.Name              = "Reward"
        reward.Size              = UDim2.new(1, -8, 0, 20)
        reward.Position          = UDim2.new(0, 4, 0, 40)
        reward.BackgroundTransparency = 1
        reward.TextColor3        = Color3.fromRGB(80, 255, 120)
        reward.TextXAlignment    = Enum.TextXAlignment.Left
        reward.Font              = Enum.Font.GothamBold
        reward.TextSize          = 11
        reward.Text              = ""
        reward.Parent            = card
    end

    refreshBtn = Instance.new("TextButton")
    refreshBtn.Size     = UDim2.new(1, -10, 0, 26)
    refreshBtn.Position = UDim2.new(0, 5, 1, -31)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 190)
    refreshBtn.TextColor3       = Color3.new(1, 1, 1)
    refreshBtn.Font             = Enum.Font.GothamBold
    refreshBtn.TextSize         = 12
    refreshBtn.Text             = "Refresh Completed Contracts"
    refreshBtn.Parent           = fr
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

    return g
end

local function updateCards(contracts: { any })
    for i, card in ipairs(cards) do
        local c = contracts[i]
        local descLbl:   TextLabel = card:FindFirstChild("Desc") :: TextLabel
        local fill:      Frame     = (card:FindFirstChild("BarBG") :: Frame):FindFirstChild("Fill") :: Frame
        local rewardLbl: TextLabel = card:FindFirstChild("Reward") :: TextLabel

        if not c then
            descLbl.Text   = "No contract"
            rewardLbl.Text = ""
            fill.Size      = UDim2.new(0, 0, 1, 0)
            continue
        end

        local oreName = (OreConfig.Ores[c.oreType] :: any)
            and (OreConfig.Ores[c.oreType] :: any).displayName or c.oreType
        local pct = math.clamp(c.currentAmount / c.targetAmount, 0, 1)

        if c.completed then
            descLbl.Text       = "Done: " .. c.targetAmount .. "x " .. oreName
            descLbl.TextColor3 = Color3.fromRGB(80, 255, 120)
            fill.Size          = UDim2.new(1, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(50, 220, 80)
        else
            descLbl.Text       = string.format("Mine %d %s  (%d/%d)",
                c.targetAmount, oreName, c.currentAmount, c.targetAmount)
            descLbl.TextColor3 = Color3.fromRGB(210, 210, 210)
            fill.Size          = UDim2.new(pct, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        end

        rewardLbl.Text = string.format("Reward: %d coins", c.reward)
    end
end

function ContractUI.init(RemoteProxy: any)
    gui = build()

    refreshBtn.Activated:Connect(function()
        RemoteProxy.fire(RE.CONTRACT_REFRESH)
    end)

    UIS.InputBegan:Connect(function(input: InputObject, processed: boolean)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.C then
            gui.Enabled = not gui.Enabled
        end
    end)

    RemoteProxy.connect(RE.CONTRACT_UPDATED, function(contracts: any)
        updateCards(contracts)
    end)

    RemoteProxy.connect(RE.DATA_UPDATE, function(data: any)
        if data.contracts then updateCards(data.contracts) end
    end)
end

return ContractUI
