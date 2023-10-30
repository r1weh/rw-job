cfg_mining = {}

cfg_mining.miningAreas = {
    vec3(2977.45, 2741.62, 44.62), -- vec3 of locations for mining stones
    vec3(2982.64, 2750.89, 42.99),
    vec3(2994.92, 2750.43, 44.04),
    vec3(2958.21, 2725.44, 50.16),
    vec3(2946.3, 2725.36, 47.94),
    vec3(3004.01, 2763.27, 43.56),
    vec3(3001.79, 2791.01, 44.82)
}

cfg_mining.axe = {
    prop = `prop_tool_pickaxe`, --Default: `prop_tool_pickaxe`
    breakChance = 50 -- When failing to mine rock, this is the percentage of a chance that your pickaxe will 'break'
}

cfg_mining.rocks = {
    { item = 'washed_stone', label = 'Cuci Batu', price = {190, 220}, difficulty = {'easy'} },
    { item = 'diamond_stone', label = 'Diamond', price = {150, 180}, difficulty = {'easy'} },
    { item = 'copper_stone', label = 'Copper', price = {110, 140}, difficulty = {'easy'} },
    { item = 'gold_stone', label = 'Gold', price = {110, 140}, difficulty = {'easy'} },
    { item = 'iron_stone', label = 'Iron', price = {70, 100}, difficulty = {'easy'} },
}

cfg_mining.shop = {
    { item = 'diamond', label = 'Diamond', price = {150, 180}, difficulty = {'easy'} },
    { item = 'copper', label = 'Copper', price = {110, 140}, difficulty = {'easy'} },
    { item = 'gold', label = 'Gold', price = {110, 140}, difficulty = {'easy'} },
    { item = 'iron', label = 'Iron', price = {70, 100}, difficulty = {'easy'} },
}

cfg_mining.sellShop = {
    enabled = true, -- Enable spot to sell the things mined?
    coords = vec3(-170.3, -2659.21, 5.0), -- Location of buyer
    heading = 276.54, -- Heading of ped
    ped = 'cs_joeminuteman' -- Ped name here
}

RegisterNetEvent('klrp-job:notify')
AddEventHandler('klrp-job:notify', function(title, message, msgType)	
    -- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
    if not msgType then
        lib.notify({
            title = title,
            description = message,
            type = 'inform'
        })
    else
        lib.notify({
            title = title,
            description = message,
            type = msgType
        })
    end
end)