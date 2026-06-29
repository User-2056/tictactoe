--!strict
-- MiningService.luau
-- Scans Workspace for Parts with OreType attribute (set in Studio).
-- Attaches ProximityPrompts, tracks health, awards ore on depletion,
-- schedules respawn, and fires the onOreAwarded callback for ContractService.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)
local RE            = require(Shared.RemoteEvents)
local OreConfig     = require(Shared.Config.OreConfig)
local PickaxeConfig = require(Shared.Config.PickaxeConfig)
local UpgradeConfig = require(Shared.Config.UpgradeConfig)

local MiningService = {}

type NodeState = {
    oreType    : string,
    health     : number,
    maxHealth  : number,
    isDestroyed: boolean,
    region     : string,
    prompt     : ProximityPrompt,
}

type ServiceConfig = {
    onOreAwarded: (player: Player, oreType: string, amount: number) -> (),
}

local nodeStates:    { [BasePart]: NodeState } = {}
local swingTimes:    { [number]: { [BasePart]: number } } = {}
local oreAwardedCb:  (Player, string, number) -> ()
local DataService:   any

-- Visual constants
local STONE_COLOR    = Color3.fromRGB(130, 130, 130)
local STONE_MATERIAL = Enum.Material.Slate
local CHUNK_TAG      = "OreChunk"
local CHUNK_COUNT    = 9

-- Helpers ------------------------------------------------------------------
local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

local function inventoryTotal(inv: { [string]: number }): number
    local n = 0
    for _, q in pairs(inv) do n += q end
    return n
end

local function clearChunks(part: BasePart)
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BasePart") and child:GetAttribute(CHUNK_TAG) then
            child:Destroy()
        end
    end
end

local function buildChunks(basePart: BasePart, chunkColor: Color3)
    local s  = basePart.Size
    local hx = s.X * 0.5
    local hy = s.Y * 0.5
    local hz = s.Z * 0.5

    local faces = {
        { n=Vector3.new(0, 1,0), a1=Vector3.new(1,0,0), a2=Vector3.new(0,0,1), fd=hy, s1=hx, s2=hz },
        { n=Vector3.new(0,-1,0), a1=Vector3.new(1,0,0), a2=Vector3.new(0,0,1), fd=hy, s1=hx, s2=hz },
        { n=Vector3.new( 1,0,0), a1=Vector3.new(0,1,0), a2=Vector3.new(0,0,1), fd=hx, s1=hy, s2=hz },
        { n=Vector3.new(-1,0,0), a1=Vector3.new(0,1,0), a2=Vector3.new(0,0,1), fd=hx, s1=hy, s2=hz },
        { n=Vector3.new(0,0, 1), a1=Vector3.new(1,0,0), a2=Vector3.new(0,1,0), fd=hz, s1=hx, s2=hy },
        { n=Vector3.new(0,0,-1), a1=Vector3.new(1,0,0), a2=Vector3.new(0,1,0), fd=hz, s1=hx, s2=hy },
    }

    for i = 1, CHUNK_COUNT do
        local face = faces[((i - 1) % #faces) + 1]

        local u          = (math.random() * 2 - 1) * face.s1 * 0.55
        local v          = (math.random() * 2 - 1) * face.s2 * 0.55
        local protrusion = face.fd + 0.12 + math.random() * 0.18

        local chunkSize = Vector3.new(
            0.55 + math.random() * 0.45,
            0.45 + math.random() * 0.40,
            0.55 + math.random() * 0.45
        )

        local localPos = face.n * protrusion + face.a1 * u + face.a2 * v

        local chunk = Instance.new("Part")
        chunk.Name        = "OreChunk"
        chunk.Size        = chunkSize
        chunk.Color       = chunkColor
        chunk.Material    = Enum.Material.SmoothPlastic
        chunk.Anchored    = false
        chunk.CanCollide  = false
        chunk.CastShadow  = false
        chunk:SetAttribute(CHUNK_TAG, true)
        chunk.CFrame = basePart.CFrame
            * CFrame.new(localPos)
            * CFrame.Angles(
                (math.random() - 0.5) * 0.55,
                (math.random() - 0.5) * 0.55,
                (math.random() - 0.5) * 0.55
            )
        chunk.Parent = basePart

        local weld  = Instance.new("WeldConstraint")
        weld.Part0  = chunk
        weld.Part1  = basePart
        weld.Parent = chunk
    end
end

local function applyAppearance(part: BasePart, oreType: string)
    part.Color    = STONE_COLOR
    part.Material = STONE_MATERIAL

    clearChunks(part)
    local data: any = OreConfig.Ores[oreType]
    if data.chunkColor then
        buildChunks(part, data.chunkColor :: Color3)
    end
end

local function setNodeVisible(part: BasePart, visible: boolean)
    local t = if visible then 0 else 1
    part.Transparency = t
    part.CanCollide   = visible
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BasePart") and child:GetAttribute(CHUNK_TAG) then
            (child :: BasePart).Transparency = t
        end
    end
end

local function attachPrompt(part: BasePart, state: NodeState)
    local p = Instance.new("ProximityPrompt")
    p.ActionText            = "Mine"
    p.ObjectText            = (OreConfig.Ores[state.oreType] :: any).displayName
    p.MaxActivationDistance = 8
    p.HoldDuration          = 0
    p.Parent                = part
    state.prompt            = p

    p.Triggered:Connect(function(player: Player)
        MiningService.handleSwing(player, part)
    end)
end

local function respawnNode(part: BasePart)
    local state = nodeStates[part]
    if not state then return end

    local newType = OreConfig.rollOreType(state.region)
    local oreData: any = OreConfig.Ores[newType]

    state.oreType     = newType
    state.health      = oreData.nodeHealth
    state.maxHealth   = oreData.nodeHealth
    state.isDestroyed = false

    applyAppearance(part, newType)
    setNodeVisible(part, true)
    state.prompt.ObjectText = oreData.displayName
    state.prompt.Enabled    = true

    getRemote(RE.MINING_NODE_RESPAWNED):FireAllClients({
        nodeId  = part.Name,
        oreType = newType,
    })
end

-- Swing handler ------------------------------------------------------------
function MiningService.handleSwing(player: Player, part: BasePart)
    local state = nodeStates[part]
    if not state or state.isDestroyed then return end

    local data: any = DataService.getPlayerData(player)
    if not data then return end

    -- Rate limit by pickaxe speed
    local pickaxe = PickaxeConfig.Tiers[data.pickaxeTier]
    local cooldown = GameConstants.BASE_SWING_COOLDOWN / pickaxe.speed
    local uid = player.UserId
    swingTimes[uid] = swingTimes[uid] or {}

    if os.clock() - (swingTimes[uid][part] or 0) < cooldown then return end
    swingTimes[uid][part] = os.clock()

    -- Inventory capacity check
    local cap = UpgradeConfig.Tiers[data.capacityTier].capacity
    if inventoryTotal(data.inventory) >= cap then return end

    -- Apply damage
    state.health = math.max(0, state.health - pickaxe.power)

    getRemote(RE.MINING_NODE_DAMAGED):FireAllClients({
        nodeId          = part.Name,
        healthRemaining = state.health,
        maxHealth       = state.maxHealth,
    })

    if state.health <= 0 then
        state.isDestroyed    = true
        setNodeVisible(part, false)
        state.prompt.Enabled = false

        local oreType = state.oreType
        DataService.updatePlayerData(player, function(d: any)
            d.inventory[oreType] = (d.inventory[oreType] or 0) + 1
        end)

        oreAwardedCb(player, oreType, 1)

        task.delay(GameConstants.NODE_RESPAWN_DELAY, function()
            respawnNode(part)
        end)
    end
end

-- Init ---------------------------------------------------------------------
function MiningService.init(config: ServiceConfig)
    DataService  = require(script.Parent.DataService)
    oreAwardedCb = config.onOreAwarded

    local function registerPart(part: BasePart)
        if nodeStates[part] then return end  -- already registered (dedup guard)
        local oreType = part:GetAttribute(GameConstants.ORE_NODE_ATTRIBUTE) :: string?
        if not oreType or not OreConfig.Ores[oreType] then return end

        local region: string = (part:GetAttribute(GameConstants.ORE_REGION_ATTRIBUTE) :: string?) or "StarterMine"
        local oreData: any = OreConfig.Ores[oreType]

        local state: NodeState = {
            oreType     = oreType,
            health      = oreData.nodeHealth,
            maxHealth   = oreData.nodeHealth,
            isDestroyed = false,
            region      = region,
            prompt      = nil :: any,
        }

        nodeStates[part] = state
        applyAppearance(part, oreType)
        attachPrompt(part, state)
    end

    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") and d:GetAttribute(GameConstants.ORE_NODE_ATTRIBUTE) then
            registerPart(d :: BasePart)
        end
    end

    workspace.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") and d:GetAttribute(GameConstants.ORE_NODE_ATTRIBUTE) then
            registerPart(d :: BasePart)
        end
    end)

    local count = 0
    for _ in pairs(nodeStates) do count += 1 end
    print("[MiningService] Registered", count, "ore nodes.")
end

return MiningService
