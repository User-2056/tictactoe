--!strict
-- UpgradeConfig.luau
-- capacity = max total ore items (sum of all quantities).
-- Tier 1 is the default; players start here at no cost.

return {
    Tiers = {
        [1] = { capacity = 50,   cost = 0      },
        [2] = { capacity = 100,  cost = 5000   },
        [3] = { capacity = 250,  cost = 20000  },
        [4] = { capacity = 500,  cost = 75000  },
        [5] = { capacity = 1000, cost = 200000 },
    },
    MaxTier = 5,
}
