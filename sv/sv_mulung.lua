local ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

RegisterServerEvent("esx-ecobottles:sellBottles")
AddEventHandler("esx-ecobottles:sellBottles", function()
    local player = ESX.GetPlayerFromId(source)

    local currentBottles = player.getInventoryItem("bottle")["count"]
    
    if currentBottles > 0 then
        math.randomseed(os.time())
        local randomMoney = math.random((cfg_mulung.BottleReward[1] or 1), (cfg_mulung.BottleReward[2] or 4))

        player.removeInventoryItem("bottle", currentBottles)
        player.addMoney(randomMoney * currentBottles)

        TriggerClientEvent("esx:showNotification", source, ("You gave the store %s bottles and got paid $%s."):format(currentBottles, currentBottles * randomMoney))
    else
        TriggerClientEvent("esx:showNotification", source, "You don't have any bottles to give the store.")
    end
end)

RegisterServerEvent("esx-ecobottles:retrieveBottle")
AddEventHandler("esx-ecobottles:retrieveBottle", function()
    local player = ESX.GetPlayerFromId(source)

    math.randomseed(os.time())
    local luck = math.random(0, 69)
    local randomBottle = math.random((cfg_mulung.BottleRecieve[1] or 1), (cfg_mulung.BottleRecieve[2] or 6))

    if luck >= 0 and luck <= 29 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Yahh Di Tong sampa ini tidak ada :(', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        --TriggerClientEvent("esx:showNotification", source, "The bin had no bottles in it.")
    else
        player.addInventoryItem("bottle", randomBottle)
        player.addInventoryItem("copper", randomBottle)
        player.addInventoryItem("scrapmetal", randomBottle)
        player.addInventoryItem("plasticrab", randomBottle)
        --TriggerClientEvent("esx:showNotification", source, ("You found x%s bottles"):format(randomBottle))
    end
end)
