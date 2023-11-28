ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterServerEvent('duty:onoff')
AddEventHandler('duty:onoff', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    
    if job == 'police' or job == 'ambulance' or job == 'mcg' or job == 'pedagang' or job == 'mechanic' or job == 'taxi' then
        xPlayer.setJob('off' ..job, grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('offduty'), length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        --TriggerClientEvent('esx:showNotification', _source, _U('offduty'))
    elseif job == 'offpolice' then
        xPlayer.setJob('police', grade)
        TriggerEvent("mystoria-polisi:updateBlip")
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  _U('onduty'), length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
       -- TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offambulance' then
        xPlayer.setJob('ambulance', grade)
        TriggerEvent("mystoria-polisi:updateBlip")
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  _U('onduty'), length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        --TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offmcg' then
        xPlayer.setJob('mcg', grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  _U('onduty'), length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        --TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offpedagang' then
        xPlayer.setJob('pedagang', grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  _U('onduty'), length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
       -- TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offmechanic' then
        xPlayer.setJob('mechanic', grade)
        TriggerEvent("mystoria-polisi:updateBlip")
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  _U('onduty'), length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        --TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    elseif job == 'offtaxi' then
        xPlayer.setJob('taxi', grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  _U('onduty'), length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        --TriggerClientEvent('esx:showNotification', _source, _U('onduty'))
    end

end)