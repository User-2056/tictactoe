--!strict
-- RemoteEvents.luau
-- String name constants for every RemoteEvent.
-- Server creates the actual RemoteEvent instances in ReplicatedStorage.Shared.
-- Mining and Selling use ProximityPrompt.Triggered (no client remote needed).

return {
    -- Server -> Client
    DATA_UPDATE           = "Data_Update",
    MINING_NODE_DAMAGED   = "Mining_NodeDamaged",
    MINING_NODE_RESPAWNED = "Mining_NodeRespawned",
    MARKET_PRICES_UPDATED = "Market_PricesUpdated",
    SELL_RESULT           = "Sell_Result",
    UPGRADE_RESULT        = "Upgrade_Result",
    CONTRACT_UPDATED      = "Contract_Updated",

    -- Client -> Server
    UPGRADE_PICKAXE       = "Upgrade_Pickaxe",
    UPGRADE_CAPACITY      = "Upgrade_Capacity",
    CONTRACT_REFRESH      = "Contract_Refresh",
}
