RegisterNetEvent('rw:jualayam1')
AddEventHandler('rw:jualayam1', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
    if xPlayer.canSwapItem('packaged_chicken', 10, 'money', 10000) then 
        xPlayer.addInventoryItem('money', 10000)
        xPlayer.removeInventoryItem('packaged_chicken', 10)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterNetEvent('rw:jualkain')
AddEventHandler('rw:jualkain', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local slaughtered = xPlayer.canCarryItem('clothe', 1)

    if xPlayer.canSwapItem('clothe', 10, 'money', 10000) then 
        xPlayer.addInventoryItem('money', 10000)
        xPlayer.removeInventoryItem('clothe', 10)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterNetEvent('rw:jualminyak')
AddEventHandler('rw:jualminyak', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local slaughtered = xPlayer.canCarryItem('minyak', 1)

    if xPlayer.canSwapItem('minyak', 10, 'money', 10000) then 
        xPlayer.addInventoryItem('money', 10000)
        xPlayer.removeInventoryItem('minyak', 10)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)