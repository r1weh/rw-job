
local ox_inventory = exports.ox_inventory
local playersProcessingCannabis = {}
local outofbound = true
local alive = true

RegisterServerEvent('rw:addKayu')
AddEventHandler('rw:addKayu', function()
   -- math.randomseed(os.time())
    local xPlayer = ESX.GetPlayerFromId(source)
   -- local luck = math.random('minyak', 'oli')
        xPlayer.addInventoryItem('wood' , 1)
end)

RegisterServerEvent('rw:addProsess')
AddEventHandler('rw:addProsess', function()
    if not playersProcessingCannabis[source] then
		--math.randomseed(os.time())
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xCannabis = xPlayer.getInventoryItem('wood')
    	--local luck = math.random(1, 3)
		--local randomBottle = math.random((cfg_mulung.Miningrk[0] or 1), (cfg_mulung.Miningrw[0] or 1))
		local can = true
		outofbound = false
    if xCannabis.count >= 2 then
				if playersProcessingCannabis[source] == nil then
					playersProcessingCannabis[source] = ESX.SetTimeout(0 , function()
            if xCannabis.count >= 2 then
              if xPlayer.canSwapItem('wood', 2, 'kayu_potong', 1) then
                xPlayer.removeInventoryItem('wood', 2)
                xPlayer.addInventoryItem('kayu_potong', 1)
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
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'erorr', text = 'Kamu Tidak Memiliki Kayu', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            --TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Anda Tidak Memiliki Battu Bersih","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
			TriggerEvent('esx_drugs:cancelProcessing')
		end	
			
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
	--TriggerEvent('rw:berliannn')
end)

RegisterServerEvent('rw:Processkayu2')
AddEventHandler('rw:Processkayu2', function()
    if not playersProcessingCannabis[source] then
		math.randomseed(os.time())
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xCannabis = xPlayer.getInventoryItem('kayu_potong')
    	local luck = math.random(1, 3)
		--local randomBottle = math.random((cfg_mulung.Miningrk[0] or 1), (cfg_mulung.Miningrw[0] or 1))
		local can = true
		outofbound = false
    if xCannabis.count >= 1 then
				if playersProcessingCannabis[source] == nil then
					playersProcessingCannabis[source] = ESX.SetTimeout(0 , function()
            if xCannabis.count >= 1 then
              if xPlayer.canSwapItem('kayu_potong', 1, 'packaged_plank', 1) then
                xPlayer.removeInventoryItem('kayu_potong', 1)
                xPlayer.addInventoryItem('packaged_plank', 1)
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
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'erorr', text = 'Kamu Tidak Memiliki Kayu', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            --TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Anda Tidak Memiliki Battu Bersih","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
			TriggerEvent('esx_drugs:cancelProcessing')
		end	
			
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
	--TriggerEvent('rw:berliannn')
end)

RegisterServerEvent('rw:Pack')
AddEventHandler('rw:Pack', function()
    math.randomseed(os.time())
	local xPlayer = ESX.GetPlayerFromId(source)
	local luck = math.random(1, 100)
	local grade = 0

    if xPlayer.canCarryItem('packaged_chicken', 1) then
		xPlayer.addInventoryItem('packaged_chicken', 1)
        xPlayer.removeInventoryItem('slaughtered_chicken', 3)
    else
        TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Inventory full".. salary,"top-right",2500,"red-10","white",true,"")
    end  
end)