RegisterNetEvent('rw:addwool1')
AddEventHandler('rw:addwool1', function()
    if not playersProcessingCannabis[source] then
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xCannabis = xPlayer.getInventoryItem('wool')
		local can = true
		outofbound = false
    if xCannabis.count >= 1 then
				if playersProcessingCannabis[source] == nil then
					playersProcessingCannabis[source] = ESX.SetTimeout(1 , function()
            if xCannabis.count >= 1 then
              if xPlayer.canSwapItem('wool', 1, 'bulu', 1) then
                xPlayer.removeInventoryItem('bulu', 1)
                xPlayer.addInventoryItem('wool', 1)
							else
								can = false
								TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Tas Kamu Penuh Boss","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
								TriggerEvent('esx_drugs:cancelProcessing')
							end
						else						
							can = false
                            TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Tas Kamu Penuh Boss","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
							TriggerEvent('esx_drugs:cancelProcessing')
						end

						playersProcessingCannabis[source] = nil
					end)
				else
					Wait(5000)
				end	
		else
            TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Anda Tidak Memiliki Batu","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
			TriggerEvent('esx_drugs:cancelProcessing')
		end	
			
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)