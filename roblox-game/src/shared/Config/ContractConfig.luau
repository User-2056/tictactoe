--!strict
-- ContractConfig.luau
-- Contract payout = basePrice * targetAmount * rewardMult
-- minAmount/maxAmount rolled randomly at generation time.

return {
    Templates = {
        stone = { minAmount = 50,  maxAmount = 200, rewardMult = 1.2 },
        coal  = { minAmount = 20,  maxAmount = 80,  rewardMult = 1.3 },
        iron  = { minAmount = 10,  maxAmount = 40,  rewardMult = 1.4 },
        gold  = { minAmount = 3,   maxAmount = 15,  rewardMult = 1.5 },
    },
}
