local ox_inventory = exports.ox_inventory
local playersProcessingCannabis = {}
local outofbound = true
local alive = true

RegisterServerEvent('rw:addwool')
AddEventHandler('rw:addwool', function()
    local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem('wool', 3)
end)

RegisterNetEvent('rw:buatktp1')
AddEventHandler('rw:buatktp1', function()
    local rw = ESX.GetPlayerFromId(source)
	local rwt = source
    if rw.canCarryItem('money', 15000) then
        rw.removeInventoryItem('money', 15000)
        exports['um-idcard']:CreateMetaLicense(rwt, 'kotalama')
    end
end)


RegisterServerEvent('rw:Penjahit2')
AddEventHandler('rw:Penjahit2', function()
    if not playersProcessingCannabis[source] then
		math.randomseed(os.time())
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xCannabis = xPlayer.getInventoryItem('wool')
    	local luck = math.random(1, 3)
		--local randomBottle = math.random((cfg_mulung.Miningrk[0] or 1), (cfg_mulung.Miningrw[0] or 1))
		local can = true
		outofbound = false
    if xCannabis.count >= 1 then
				if playersProcessingCannabis[source] == nil then
					playersProcessingCannabis[source] = ESX.SetTimeout(0 , function()
            if xCannabis.count >= 1 then
              if xPlayer.canSwapItem('wool', 2, 'kain', 1) then
                xPlayer.removeInventoryItem('wool', 2)
                xPlayer.addInventoryItem('kain', 1)
							else
								can = false
								TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'erorr', text = 'Tas Kamu Penuh loo', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
								--TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Telah Meninggalkan area proses","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
								TriggerEvent('esx_drugs:cancelProcessing')
							end
						else						
							can = false
                            --TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Telah Meninggalkan area proses","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
							TriggerEvent('esx_drugs:cancelProcessing')
						end

						playersProcessingCannabis[source] = nil
					end)
				else
					Wait(2000)
				end	
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'erorr', text = 'Kamu Tidak Memiliki Wool', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            --TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Anda Tidak Memiliki Battu Bersih","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
			TriggerEvent('esx_drugs:cancelProcessing')
		end	
			
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
	--TriggerEvent('rw:berliannn')
end)

RegisterServerEvent('rw:Pack1')
AddEventHandler('rw:Pack1', function()
    if not playersProcessingCannabis[source] then
		math.randomseed(os.time())
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xCannabis = xPlayer.getInventoryItem('kain')
    	local luck = math.random(1, 3)
		--local randomBottle = math.random((cfg_mulung.Miningrk[0] or 1), (cfg_mulung.Miningrw[0] or 1))
		local can = true
		outofbound = false
    if xCannabis.count >= 1 then
				if playersProcessingCannabis[source] == nil then
					playersProcessingCannabis[source] = ESX.SetTimeout(0 , function()
            if xCannabis.count >= 1 then
              if xPlayer.canSwapItem('kain', 2, 'clothe', 1) then
                xPlayer.removeInventoryItem('kain', 2)
                xPlayer.addInventoryItem('clothe', 1)
							else
								can = false
								TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'erorr', text = 'Tas Kamu Penuh', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
								--TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Telah Meninggalkan area proses","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
								TriggerEvent('esx_drugs:cancelProcessing')
							end
						else						
							can = false
                            --TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Telah Meninggalkan area proses","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
							TriggerEvent('esx_drugs:cancelProcessing')
						end

						playersProcessingCannabis[source] = nil
					end)
				else
					Wait(2000)
				end	
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'erorr', text = 'Kamu Tidak Memiliki Kain', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            --TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Anda Tidak Memiliki Battu Bersih","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
			TriggerEvent('esx_drugs:cancelProcessing')
		end	
			
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
	--TriggerEvent('rw:berliannn')
end)