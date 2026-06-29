--!strict
-- MiningClient.luau
-- Purely reactive: listens to server mining events and plays visual feedback.
-- Floating text on hit, colour changes on destroy. HP bar on active ore nodes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local RE     = require(Shared.RemoteEvents)

local MiningClient = {}

-- ── Helpers ──────────────────────────────────────────────────────────────────

local function findNode(nodeId: string): BasePart?
    for _, d in ipairs(workspace:GetDescendants()) do
        if d.Name == nodeId and d:IsA("BasePart") then
            return d :: BasePart
        end
    end
    return nil
end

local function floatText(part: BasePart, text: string, color: Color3)
    local bb = Instance.new("BillboardGui")
    bb.Size         = UDim2.new(0, 80, 0, 28)
    bb.StudsOffset  = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop  = false
    bb.Parent       = part

    local lbl = Instance.new("TextLabel")
    lbl.Size                    = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency  = 1
    lbl.TextColor3              = color
    lbl.Font                    = Enum.Font.GothamBold
    lbl.TextSize                = 16
    lbl.Text                    = text
    lbl.Parent                  = bb

    task.spawn(function()
        for i = 1, 20 do
            task.wait(0.05)
            bb.StudsOffset       = Vector3.new(0, 3 + i * 0.12, 0)
            lbl.TextTransparency = i / 20
        end
        bb:Destroy()
    end)
end

-- ── HP Bar ───────────────────────────────────────────────────────────────────

local HP_BAR_NAME = "OreHpBar"

local function createHpBar(part: BasePart): Frame
    local bb = Instance.new("BillboardGui")
    bb.Name         = HP_BAR_NAME
    bb.Size         = UDim2.new(0, 110, 0, 16)
    bb.StudsOffset  = Vector3.new(0, 5, 0)
    bb.AlwaysOnTop  = false
    bb.Parent       = part

    local bg = Instance.new("Frame")
    bg.Name                     = "BG"
    bg.Size                     = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3         = Color3.fromRGB(20, 20, 20)
    bg.BackgroundTransparency   = 0.35
    bg.BorderSizePixel          = 0
    bg.Parent                   = bb

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent       = bg

    local fill = Instance.new("Frame")
    fill.Name               = "Fill"
    fill.AnchorPoint        = Vector2.new(0, 0.5)
    fill.Position           = UDim2.new(0, 0, 0.5, 0)
    fill.Size               = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3   = Color3.fromRGB(60, 220, 80)
    fill.BorderSizePixel    = 0
    fill.Parent             = bg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent       = fill

    return fill
end

local function getHpFill(part: BasePart): Frame?
    local bb = part:FindFirstChild(HP_BAR_NAME) :: BillboardGui?
    if not bb then return nil end
    local bg = bb:FindFirstChild("BG") :: Frame?
    if not bg then return nil end
    return bg:FindFirstChild("Fill") :: Frame?
end

local function updateHpBar(part: BasePart, health: number, maxHealth: number)
    local fill = getHpFill(part) or createHpBar(part)
    local pct  = math.max(0, health / maxHealth)

    fill.Size = UDim2.new(pct, 0, 1, 0)

    if pct >= 0.6 then
        fill.BackgroundColor3 = Color3.fromRGB(60, 220, 80)
    elseif pct >= 0.3 then
        fill.BackgroundColor3 = Color3.fromRGB(220, 200, 40)
    else
        fill.BackgroundColor3 = Color3.fromRGB(220, 60, 40)
    end

    fill.Visible = pct > 0
end

local function removeHpBar(part: BasePart)
    local bb = part:FindFirstChild(HP_BAR_NAME)
    if bb then bb:Destroy() end
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function MiningClient.init(RemoteProxy: any)
    RemoteProxy.connect(RE.MINING_NODE_DAMAGED, function(payload: any)
        local part = findNode(payload.nodeId)
        if not part then return end

        updateHpBar(part, payload.healthRemaining, payload.maxHealth)

        local destroyed = payload.healthRemaining <= 0
        local color = if destroyed then Color3.fromRGB(255, 100, 50) else Color3.fromRGB(255, 255, 80)
        local text  = if destroyed then "Mined!" else string.format("-%d HP", payload.healthRemaining)
        floatText(part, text, color)

        if destroyed then
            task.delay(0.4, function()
                if part and part.Parent then
                    removeHpBar(part)
                end
            end)
        end
    end)

    RemoteProxy.connect(RE.MINING_NODE_RESPAWNED, function(payload: any)
        local part = findNode(payload.nodeId)
        if part then removeHpBar(part) end
    end)
end

return MiningClient
