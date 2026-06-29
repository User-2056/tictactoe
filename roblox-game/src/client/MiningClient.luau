--!strict
-- MiningClient.luau
-- Purely reactive: listens to server mining events and plays visual feedback.
-- Floating text on hit, colour changes on destroy. No remotes fired here.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local RE     = require(Shared.RemoteEvents)

local MiningClient = {}

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
    lbl.Size                 = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3           = color
    lbl.Font                 = Enum.Font.GothamBold
    lbl.TextSize             = 16
    lbl.Text                 = text
    lbl.Parent               = bb

    task.spawn(function()
        for i = 1, 20 do
            task.wait(0.05)
            bb.StudsOffset     = Vector3.new(0, 3 + i * 0.12, 0)
            lbl.TextTransparency = i / 20
        end
        bb:Destroy()
    end)
end

function MiningClient.init(RemoteProxy: any)
    RemoteProxy.connect(RE.MINING_NODE_DAMAGED, function(payload: any)
        local part = findNode(payload.nodeId)
        if not part then return end

        local destroyed = payload.healthRemaining <= 0
        local color = if destroyed then Color3.fromRGB(255, 100, 50) else Color3.fromRGB(255, 255, 80)
        local text  = if destroyed then "Mined!" else string.format("-%d HP", payload.healthRemaining)
        floatText(part, text, color)
    end)

    RemoteProxy.connect(RE.MINING_NODE_RESPAWNED, function(_payload: any)
        -- Server updates Part appearance. Add particle effect here in Milestone 2.
    end)
end

return MiningClient
