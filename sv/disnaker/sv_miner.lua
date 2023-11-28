ESX = nil
local playersProcessingCannabis = {}
local outofbound = true
local alive = true

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("rw:stone")
AddEventHandler("rw:stone", function()
local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('stone', 1)
end)

RegisterNetEvent('rw:addMining')
AddEventHandler('rw:addMining', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
	local luck = math.random(1, 3)
    if xPlayer.canSwapItem('stone', 1, 'washed_stone', 1, 'iron_stone', 1, 'copper_stone', luck, 'gold_stone', luck, 'diamond_stone', luck) then 
        xPlayer.addInventoryItem('iron_stone', 1)
		xPlayer.addInventoryItem('copper_stone', 1)
		xPlayer.addInventoryItem('washed_stone', 1)
        xPlayer.removeInventoryItem('stone', 1)
	if luck >= 2 and luck <= 3 then
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Yahh sayang nggk dapet berlian', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
	else
		xPlayer.addInventoryItem('copper_stone', 1)
		xPlayer.addInventoryItem('gold_stone', 1)
		xPlayer.addInventoryItem('diamond_stone', 1)
	end
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterNetEvent('rw:washed_stone')
AddEventHandler('rw:washed_stone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
    if xPlayer.canSwapItem('washed_stone', 2, 'scrapmetal', 1) then 
        xPlayer.addInventoryItem('scrapmetal', 1)
        xPlayer.removeInventoryItem('washed_stone', 2)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterNetEvent('rw:iron_stone')
AddEventHandler('rw:iron_stone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
    if xPlayer.canSwapItem('iron_stone', 2, 'iron', 1) then 
        xPlayer.addInventoryItem('iron', 1)
        xPlayer.removeInventoryItem('iron_stone', 2)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterNetEvent('rw:gold_stone')
AddEventHandler('rw:gold_stone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
    if xPlayer.canSwapItem('gold_stone', 2, 'gold', 1) then 
        xPlayer.addInventoryItem('gold', 1)
        xPlayer.removeInventoryItem('gold_stone', 2)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterNetEvent('rw:copper_stone')
AddEventHandler('rw:copper_stone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
    if xPlayer.canSwapItem('copper_stone', 2, 'copper', 1) then 
        xPlayer.addInventoryItem('copper', 1)
        xPlayer.removeInventoryItem('copper_stone', 2)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterNetEvent('rw:diamond_stone')
AddEventHandler('rw:diamond_stone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
    if xPlayer.canSwapItem('diamond_stone', 2, 'diamond', 1) then 
        xPlayer.addInventoryItem('diamond', 1)
        xPlayer.removeInventoryItem('diamond_stone', 2)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterServerEvent("rw:berliannn")
AddEventHandler("rw:berliannn", function()
    local player = ESX.GetPlayerFromId(source)

    math.randomseed(os.time())
    local luck = math.random(0, 3)
    local randomBottle = math.random((cfg_mulung.BottleRecieve[1] or 1), (cfg_mulung.BottleRecieve[2] or 6))

    if luck >= 0 and luck <= 3 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Yahh Di Tong sampa ini tidak ada :(', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
        --TriggerClientEvent("esx:showNotification", source, "The bin had no bottles in it.")
    else
        player.addInventoryItem("bottle", randomBottle)
        --TriggerClientEvent("esx:showNotification", source, ("You found x%s bottles"):format(randomBottle))
    end
end)

RegisterNetEvent('rw:addJual1')
AddEventHandler('rw:addJual1', function()
    if not playersProcessingCannabis[source] then
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xCannabis = xPlayer.getInventoryItem('iron')
		local can = true
		outofbound = false
    if xCannabis.count >= 1 then
        while outofbound == false and can do
				if playersProcessingCannabis[source] == nil then
					playersProcessingCannabis[source] = ESX.SetTimeout(2000 , function()
            if xCannabis.count >= 1 then
              if xPlayer.canSwapItem('iron', 1, 'gold', 1, 'copper', 1) then
                xPlayer.removeInventoryItem('iron', 1)
                xPlayer.removeInventoryItem('gold', 1)
                xPlayer.removeInventoryItem('copper', 1)
                xPlayer.addAccountMoney('money', 500)
							else
								can = false
								TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Telah Meninggalkan area proses","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
								TriggerEvent('esx_drugs:cancelProcessing')
							end
						else						
							can = false
                            TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Telah Meninggalkan area proses","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
							TriggerEvent('esx_drugs:cancelProcessing')
						end

						playersProcessingCannabis[source] = nil
					end)
				else
					Wait(2000)
				end	
            end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'erorr', text = 'Anda Tidak Memiliki Bahan Tambang', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            --TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Anda Tidak Memiliki Bahan Tambang","top-right",2500,"green-10","white",true,"mdi-tooltip-remove-outline")
			TriggerEvent('esx_drugs:cancelProcessing')
		end	
			
	else
		print(('esx_drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

