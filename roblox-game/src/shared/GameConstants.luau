--!strict
-- GameConstants.luau
-- Single source of truth for all tunable numbers.
-- Nothing in any logic script should contain a magic number.

return {
    -- DataStore
    DATA_STORE_NAME           = "MiningCorp_v1",
    DATA_SCHEMA_VERSION       = 1,

    -- Timing (seconds)
    AUTOSAVE_INTERVAL         = 60,
    NODE_RESPAWN_DELAY        = 30,
    BASE_SWING_COOLDOWN       = 1.5,
    CONTRACT_REFRESH_COOLDOWN = 600,

    -- Gameplay
    NUM_ACTIVE_CONTRACTS      = 3,

    -- Workspace attribute keys — must match what you set in Studio
    ORE_NODE_ATTRIBUTE        = "OreType",
    ORE_REGION_ATTRIBUTE      = "Region",
    SELL_ZONE_ATTRIBUTE       = "IsSellZone",
    SHOP_ATTRIBUTE            = "IsPickaxeShop",

    -- Remote events folder (server creates instances on startup)
    REMOTE_FOLDER_NAME        = "RemoteEvents",
}
