--!strict
-- DataService.luau
-- All DataStore access and in-memory player data cache.
-- Every other service reads/writes player data exclusively through this module.

local Players           = game:GetService("Players")
local DataStoreService  = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared        = ReplicatedStorage:WaitForChild("Shared")
local GameConstants = require(Shared.GameConstants)
local RE            = require(Shared.RemoteEvents)

local DataService = {}

-- Private state ------------------------------------------------------------
local store:     DataStore
local cache:     { [number]: any } = {}
local saveLocks: { [number]: boolean } = {}

local DEFAULT_DATA = {
    money                = 0,
    inventory            = { stone = 0, coal = 0, iron = 0, gold = 0 },
    pickaxeTier          = "Starter",
    capacityTier         = 1,
    contracts            = {},
    contractsLastRefresh = 0,
    version              = GameConstants.DATA_SCHEMA_VERSION,
}

-- Schema migrations (add future migrations here) ---------------------------
local migrations: { [number]: (d: any) -> () } = {
    -- [1] = function(d) ... end,
}

local function migrateData(data: any): any
    while data.version < GameConstants.DATA_SCHEMA_VERSION do
        local fn = migrations[data.version]
        if fn then fn(data) end
        data.version += 1
    end
    return data
end

-- Helpers ------------------------------------------------------------------
local function deepCopy(t: any): any
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = if type(v) == "table" then deepCopy(v) else v
    end
    return copy
end

local function mergeDefaults(data: any, defaults: any)
    for k, v in pairs(defaults) do
        if data[k] == nil then
            data[k] = if type(v) == "table" then deepCopy(v) else v
        elseif type(v) == "table" and type(data[k]) == "table" then
            mergeDefaults(data[k], v)
        end
    end
end

local function getRemote(name: string): RemoteEvent
    return Shared:WaitForChild(GameConstants.REMOTE_FOLDER_NAME):WaitForChild(name) :: RemoteEvent
end

-- Public API ---------------------------------------------------------------

function DataService.init()
    store = DataStoreService:GetDataStore(GameConstants.DATA_STORE_NAME)

    task.spawn(function()
        while true do
            task.wait(GameConstants.AUTOSAVE_INTERVAL)
            DataService.saveAllPlayers()
        end
    end)

    print("[DataService] Initialised. Autosave every", GameConstants.AUTOSAVE_INTERVAL, "s.")
end

function DataService.loadPlayer(player: Player)
    local userId = player.UserId
    local key    = "Player_" .. userId

    local ok, result = pcall(function()
        return store:GetAsync(key)
    end)

    local data: any
    if ok and result then
        data = result
        mergeDefaults(data, DEFAULT_DATA)
        migrateData(data)
    else
        if not ok then
            warn("[DataService] Load failed for", player.Name, ":", result)
        end
        data = deepCopy(DEFAULT_DATA)
    end

    cache[userId] = data

    task.spawn(function()
        task.wait(1.5)
        if player.Parent then
            getRemote(RE.DATA_UPDATE):FireClient(player, data)
        end
    end)

    print("[DataService] Loaded:", player.Name)
end

function DataService.savePlayer(player: Player)
    local userId = player.UserId
    if saveLocks[userId] then return end

    local data = cache[userId]
    if not data then return end

    saveLocks[userId] = true
    local ok, err = pcall(function()
        store:SetAsync("Player_" .. userId, data)
    end)
    saveLocks[userId] = false
    cache[userId] = nil

    if not ok then
        warn("[DataService] Save failed for", player.Name, ":", err)
    else
        print("[DataService] Saved:", player.Name)
    end
end

function DataService.saveAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(DataService.savePlayer, player)
    end
end

-- Returns live cache. Callers must NOT replace top-level keys.
function DataService.getPlayerData(player: Player): any
    return cache[player.UserId]
end

-- Mutates cache via updateFn then fires Data_Update to the client.
function DataService.updatePlayerData(player: Player, updateFn: (data: any) -> ())
    local data = cache[player.UserId]
    if not data then
        warn("[DataService] updatePlayerData: no cache for", player.Name)
        return
    end
    updateFn(data)
    if player.Parent then
        getRemote(RE.DATA_UPDATE):FireClient(player, data)
    end
end

return DataService
