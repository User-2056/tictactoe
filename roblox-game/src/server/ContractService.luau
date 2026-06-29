--!strict
-- ContractService.luau
-- Generates "mine X of Y ore" contracts on player join.
-- Tracks progress via onOreAwarded callback from MiningService.
-- Awards bonus money on completion.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared         = ReplicatedStorage:WaitForChild("Shared")
local GameConstants  = require(Shared.GameConstants)
local RE             = require(Shared.RemoteEvents)
local OreConfig      = require(Shared.Config.OreConfig)
local ContractConfig = require(Shared.Config.ContractConfig)

local ContractService = {}

local DataService: any

local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

local function newId(): string
    return tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
end

local function generateContract(): any
    local keys: { string } = {}
    for k in pairs(ContractConfig.Templates) do table.insert(keys, k) end

    local oreType  = keys[math.random(1, #keys)]
    local tmpl: any = ContractConfig.Templates[oreType]
    local amount   = math.random(tmpl.minAmount, tmpl.maxAmount)
    local reward   = math.round((OreConfig.Ores[oreType] :: any).basePrice * amount * tmpl.rewardMult)

    return {
        id            = newId(),
        oreType       = oreType,
        targetAmount  = amount,
        currentAmount = 0,
        reward        = reward,
        completed     = false,
    }
end

function ContractService.init()
    DataService = require(script.Parent.DataService)
    print("[ContractService] Initialised.")
end

function ContractService.ensureContracts(player: Player)
    local data: any = DataService.getPlayerData(player)
    if not data then return end

    local changed = false
    while #data.contracts < GameConstants.NUM_ACTIVE_CONTRACTS do
        table.insert(data.contracts, generateContract())
        changed = true
    end

    if changed then
        getRemote(RE.CONTRACT_UPDATED):FireClient(player, data.contracts)
    end
end

function ContractService.onOreAwarded(player: Player, oreType: string, amount: number)
    local data: any = DataService.getPlayerData(player)
    if not data then return end

    local changed = false
    for _, c: any in ipairs(data.contracts) do
        if not c.completed and c.oreType == oreType then
            c.currentAmount = math.min(c.currentAmount + amount, c.targetAmount)
            if c.currentAmount >= c.targetAmount then
                c.completed = true
                DataService.updatePlayerData(player, function(d: any)
                    d.money += c.reward
                end)
                print(string.format("[ContractService] %s completed: %d %s. Rewarded %d",
                    player.Name, c.targetAmount, c.oreType, c.reward))
            end
            changed = true
        end
    end

    if changed then
        getRemote(RE.CONTRACT_UPDATED):FireClient(player, data.contracts)
    end
end

function ContractService.refreshContracts(player: Player)
    local data: any = DataService.getPlayerData(player)
    if not data then return end

    local now = os.time()
    if now - data.contractsLastRefresh < GameConstants.CONTRACT_REFRESH_COOLDOWN then
        getRemote(RE.CONTRACT_UPDATED):FireClient(player, data.contracts)
        return
    end

    for i, c: any in ipairs(data.contracts) do
        if c.completed then
            data.contracts[i] = generateContract()
        end
    end

    data.contractsLastRefresh = now
    getRemote(RE.CONTRACT_UPDATED):FireClient(player, data.contracts)
end

return ContractService
