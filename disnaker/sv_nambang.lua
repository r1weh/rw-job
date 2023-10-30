-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

lib.callback.register('RW:checkPick', function(source, itemname)
    local item = HasItem(source, itemname)
    if item >= 1 then
        return true
    else
        return false
    end
end)

lib.callback.register('RW:getRockData', function(source)
    local data = cfg_mining.rocks[math.random(#cfg_mining.rocks)]
    return data
end)

local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

RegisterServerEvent("rw:washedks")
AddEventHandler("rw:washedks", function(data, index)
local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canSwapItem('stone', 1, data.item, 2) then
            xPlayer.addInventoryItem(data.item, 2)
            xPlayer.removeInventoryItem('stone', 1)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end
end)

RegisterServerEvent("RW:mineRock")
AddEventHandler("RW:mineRock", function(data, index)
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - cfg_mining.miningAreas[index])
    if distance == nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 10 then
        KickPlayer(Strings.kicked)
        return
    end
    if Framework == 'esx' and not Config.oldESX then
        local player = GetPlayer(source)
        if player.canCarryItem('stone', 1) then
            AddItem(source, 'stone', 1)
            --TriggerClientEvent('wasabi_mining:notify', source, Strings.rewarded, Strings.rewarded_desc..' '..data.label, 'error')
        else
	   --TriggerClientEvent('wasabi_mining:notify', source, Strings.cantcarry, Strings.cantcarry_desc..' '..data.label, 'success')
        end
    else
        AddItem(source, 'stone', 1)
        --TriggerClientEvent('wasabi_mining:notify', source, Strings.rewarded, Strings.rewarded_desc..' '..data.label, 'success')
    end
end)

RegisterServerEvent('RW:sellRock')
AddEventHandler('RW:sellRock', function()
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - cfg_mining.sellShop.coords)
    for i=1, #cfg_mining.shop do
        if HasItem(source, cfg_mining.shop[i].item) >= 1 then
            local rewardAmount = 0
            for j=1, HasItem(source, cfg_mining.shop[i].item) do
                rewardAmount = rewardAmount + math.random(cfg_mining.shop[i].price[1], cfg_mining.shop[i].price[2])
            end
            if rewardAmount > 0 then
                AddMoney(source, 'money', rewardAmount)
                TriggerClientEvent('wasabi_mining:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(HasItem(source, cfg_mining.shop[i].item), cfg_mining.shop[i].label, addCommas(rewardAmount)), 'success')
                RemoveItem(source, cfg_mining.shop[i].item, HasItem(source, cfg_mining.shop[i].item))
            end
        end
    end
end)

RegisterServerEvent('RW:axeBroke')
AddEventHandler('RW:axeBroke', function()
    if HasItem(source, 'pickaxe') >= 1 then
        RemoveItem(source, 'pickaxe', 1)
    else
        Wait(2000)
        KickPlayer(source, Strings.kicked)
    end
end)
