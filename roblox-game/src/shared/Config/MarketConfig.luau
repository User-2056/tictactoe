--!strict
-- MarketConfig.luau
-- Daily price multipliers seeded by math.floor(os.time() / 86400).
-- All servers on the same UTC day produce identical prices.

return {
    minMultiplier = 0.7,
    maxMultiplier = 1.5,
}
