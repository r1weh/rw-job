cfg_mulung = {}

cfg_mulung.BottleRecieve = { 1, 6 } -- This is the math random ex. math.random(1, 6) this will give you 1 - 6 bottles when searching a bin.
cfg_mulung.BottleReward = { 1, 4 } -- This is the math random ex. math.random(1, 4) this will give a random payout between 1 - 4
cfg_mulung.Miningrk = { 0, 1 } -- This is the math random ex. math.random(1, 6) this will give you 1 - 6 bottles when searching a bin.
cfg_mulung.Miningrw = { 0, 1 }

-- Here you add all the bins you are going to search.
cfg_mulung.BinsAvailable = {
    "prop_bin_01a",
    "prop_bin_03a",
    "prop_bin_05a"
}

-- This is where you add the locations where you sell the bottles.
cfg_mulung.SellBottleLocations = {
    vector3(29.337753295898, -1770.3348388672, 29.607357025146),
    vector3(388.30194091797, -874.88238525391, 29.295169830322),
    vector3(26.877752304077, -1343.0764160156, 29.497024536133)
}