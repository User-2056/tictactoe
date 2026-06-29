--!strict
-- PickaxeConfig.luau
-- swingCooldown = BASE_SWING_COOLDOWN / speed
-- Upgrades must be purchased sequentially (tier + 1 only).

return {
    Tiers = {
        Starter = { displayName = "Starter Pickaxe", cost = 0,     power = 1, speed = 1.0, tier = 1 },
        Iron    = { displayName = "Iron Pickaxe",    cost = 2500,  power = 2, speed = 1.5, tier = 2 },
        Steel   = { displayName = "Steel Pickaxe",   cost = 15000, power = 4, speed = 2.0, tier = 3 },
        Gold    = { displayName = "Gold Pickaxe",    cost = 75000, power = 7, speed = 2.8, tier = 4 },
    },
    Order = { "Starter", "Iron", "Steel", "Gold" },
}
