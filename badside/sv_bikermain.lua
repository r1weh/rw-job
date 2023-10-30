ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if RW.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'biker', RW.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'biker', _U('alert_biker'), true, true)
TriggerEvent('esx_society:registerSociety', 'biker', 'biker', 'society_biker', 'society_biker', 'society_biker', {type = 'public'})

RegisterServerEvent('marskuy-biker:giveWeapon')
AddEventHandler('marskuy-biker:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('marskuy-biker:confiscatePlayerItem')
AddEventHandler('marskuy-biker:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('marskuy-biker:handcuff')
AddEventHandler('marskuy-biker:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'biker' then
		TriggerClientEvent('marskuy-biker:handcuff', target)
	else
		print(('marskuy-biker: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('marskuy-biker:drag')
AddEventHandler('marskuy-biker:drag', function(target)
	TriggerClientEvent('marskuy-biker:drag', target, source)
end)

RegisterServerEvent('marskuy-biker:putInVehicle')
AddEventHandler('marskuy-biker:putInVehicle', function(target)
	TriggerClientEvent('marskuy-biker:putInVehicle', target)
end)

RegisterServerEvent('marskuy-biker:OutVehicle')
AddEventHandler('marskuy-biker:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'biker' then
		TriggerClientEvent('marskuy-biker:OutVehicle', target)
	else
		print(('marskuy-biker: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('marskuy-biker:getStockItem')
AddEventHandler('marskuy-biker:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_biker', function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('marskuy-biker:putStockItems')
AddEventHandler('marskuy-biker:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_biker', function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = _U('have_deposited', count, inventoryItem.label)})
			local _source = source
    		local name = GetPlayerName(source)
    		local ip = GetPlayerEndpoint(source)
    		local steamhex = GetPlayerIdentifier(source)
    		local communtiylogo = ""
    		local logs = "https://discord.com/api/webhooks/1018635056211841035/1C8ux5zr7bYrSXsPVH7sqdhecMPUjIsrQWbG9iXjiW1kcNNbLkopzRZxZMBWNS9GQCzp"
    		local money = xPlayer.getMoney()
    		local bank = xPlayer.getAccount('bank').money
    		local black = xPlayer.getAccount('black_money').money
    		local job = xPlayer.job.name
    		local armorypolicelog = {
				{
            		["color"] = "8663711",
           		 	["title"] = "LOG DEPOSIT ITEM TO ARMORY POLICE",
						["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Gelap : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..count.."x "..itemName.."**",
            		["footer"] = {
                		["text"] = "REPUBLIK RP",
                		["icon_url"] = communtiylogo,
            		},
        		}
    		}
    		PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG DEPOSIT ITEM TO ARMORY POLICE", embeds = armorypolicelog}), { ['Content-Type'] = 'application/json' })

		else
			--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('quantity_invalid')})
		end

	end)

end)

ESX.RegisterServerCallback('marskuy-biker:getOtherPlayerData', function(source, cb, target)

	if RW.EnableESXIdentity then

		local xPlayer = ESX.GetPlayerFromId(target)

		local identifier = GetPlayerIdentifiers(target)[1]

		local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
			['@identifier'] = identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if RW.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end

	else

		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)

	end

end)

ESX.RegisterServerCallback('marskuy-biker:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('marskuy-biker:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if RW.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('marskuy-biker:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if RW.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('marskuy-biker:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_biker', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('marskuy-biker:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_biker', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('marskuy-biker:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 0)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_biker', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)


ESX.RegisterServerCallback('marskuy-biker:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_biker', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('marskuy-biker:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_biker', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('marskuy-biker:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source
	
	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)
		
		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'biker' then
			Citizen.Wait(5000)
			TriggerClientEvent('marskuy-biker:updateBlip', -1)
		end
	end	
end)

RegisterServerEvent('marskuy-biker:spawned')
AddEventHandler('marskuy-biker:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'biker' then
		Citizen.Wait(5000)
		TriggerClientEvent('marskuy-biker:updateBlip', -1)
	end
end)

RegisterServerEvent('marskuy-biker:forceBlip')
AddEventHandler('marskuy-biker:forceBlip', function()
	TriggerClientEvent('marskuy-biker:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('marskuy-biker:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'biker')
	end
end)

RegisterServerEvent('marskuy-biker:message')
AddEventHandler('marskuy-biker:message', function(target, msg)
	--TriggerClientEvent('esx:showNotification', target, msg)
	TriggerClientEvent("rri-notify:Icon",target,msg,"top-right",2500,"negative","white",true,"mdi-tooltip-remove-outline")
end)

RegisterServerEvent('marskuy-biker:requestarrest')
AddEventHandler('marskuy-biker:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('marskuy-biker:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('marskuy-biker:doarrested', _source)
end)

RegisterServerEvent('marskuy-biker:requestrelease')
AddEventHandler('marskuy-biker:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('marskuy-biker:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('marskuy-biker:douncuffing', _source)
end)

function DiscordHook(hook,message,color)
    local hooke = 'https://discordapp.com/api/webhooks/754213910168731709/vfRyZET_lFCvtk4ue4ziH84-ez6G-pMD-Yg6VF3KkLtcQtk73ozyn2LGqOgWGO-PH45A'
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = "RP",
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(hooke, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function DiscordHookwkladanie(hook,message,color)
    local hooke = 'https://discordapp.com/api/webhooks/754213910168731709/vfRyZET_lFCvtk4ue4ziH84-ez6G-pMD-Yg6VF3KkLtcQtk73ozyn2LGqOgWGO-PH45A'
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = "RP",
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(hooke, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function DiscordHookwkladanie(hook,message,color)
    local hooke = 'https://discordapp.com/api/webhooks/754213910168731709/vfRyZET_lFCvtk4ue4ziH84-ez6G-pMD-Yg6VF3KkLtcQtk73ozyn2LGqOgWGO-PH45A'
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = "RP",
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(hooke, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
