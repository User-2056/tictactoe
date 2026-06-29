--!strict
-- OreConfig.luau
-- All ore type definitions. Region field enables multi-region expansion later.

local OreConfig = {}

OreConfig.Ores = {
    stone = {
        displayName = "Stone",
        basePrice   = 1,
        spawnWeight = 45,
        nodeHealth  = 3,
        region      = "StarterMine",
        brickColor  = BrickColor.new("Medium stone grey"),
        material    = Enum.Material.SmoothPlastic,
    },
    coal = {
        displayName = "Coal",
        basePrice   = 10,
        spawnWeight = 35,
        nodeHealth  = 5,
        region      = "StarterMine",
        brickColor  = BrickColor.new("Really black"),
        material    = Enum.Material.SmoothPlastic,
    },
    iron = {
        displayName = "Iron",
        basePrice   = 35,
        spawnWeight = 17,
        nodeHealth  = 8,
        region      = "StarterMine",
        brickColor  = BrickColor.new("Light grey"),
        material    = Enum.Material.SmoothPlastic,
    },
    gold = {
        displayName = "Gold",
        basePrice   = 150,
        spawnWeight = 3,
        nodeHealth  = 12,
        region      = "StarterMine",
        brickColor  = BrickColor.new("Bright yellow"),
        material    = Enum.Material.SmoothPlastic,
    },
}

-- Weighted random roll for a region. Used by MiningService on node respawn.
function OreConfig.rollOreType(region: string): string
    local pool: { { key: string, weight: number } } = {}
    local totalWeight = 0

    for key, data in pairs(OreConfig.Ores) do
        if data.region == region then
            totalWeight += data.spawnWeight
            table.insert(pool, { key = key, weight = data.spawnWeight })
        end
    end

    local roll = math.random(1, totalWeight)
    local cumulative = 0
    for _, entry in ipairs(pool) do
        cumulative += entry.weight
        if roll <= cumulative then
            return entry.key
        end
    end

    return "stone"
end

return OreConfig
