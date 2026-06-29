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

-- Helpers ------------------------------------------------------------------
local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

local function inventoryTotal(inv: { [string]: number }): number
    local n = 0
    for _, q in pairs(inv) do n += q end
    return n
end

local function applyAppearance(part: BasePart, oreType: string)
    local data: any = OreConfig.Ores[oreType]
    part.BrickColor = data.brickColor
    part.Material   = data.material
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
    part.Transparency       = 0
    part.CanCollide         = true
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
        part.Transparency    = 1
        part.CanCollide      = false
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
