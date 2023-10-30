ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
	refreshBlips()
end)

RegisterNetEvent('esx:onPlayerLogout',function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('rw:ciek')
AddEventHandler('rw:ciek', function()
	local output = lib.callback.await('RW:checkPick', 100, 'stone')
	if output then
	local rockData = lib.callback.await('RW:getRockData', 100)                              
		if lib.skillCheck(rockData.difficulty) then
			exports.ox_inventory:Progress({
				duration = 2500,
				label = "Mencuci Batu",
				useWhileDead = false,
				canCancel = false,
				disable = {
					move = true,
					car = true,
					combat = true,
				},
				anim = {
					dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
					clip = "machinic_loop_mechandplayer",
					flags = 49,
				},
			}, function(cancel)
				if not cancel then
					ClearPedTasks(cache.ped)
					tryWashed(rockData, i)
				end
			end)
		else
			exports['klrp_notify']:SendAlert('inform', 'Gagal Kamu')
		end
		elseif not output then
			exports['klrp_notify']:SendAlert('inform', 'Kamu tidak memiliki bahan')
	end
end)

RegisterNetEvent('rw:ciek10')
AddEventHandler('rw:ciek10', function()
	TriggerEvent('rw:menutambang')
end)

RegisterNetEvent('rw:menutambang1')
AddEventHandler('rw:menutambang1', function()
end)

RegisterNetEvent('rw:menutambang')
AddEventHandler('rw:menutambang', function()
    lib.registerContext({
        id = 'rw:menutambang',
        title = 'Mengolah Bahan Tambang',
		menu = 'rw:menutambang1',
        options = {
            {
				title = 'Mengolah Washed Stone',
				description = 'Kamu Membutuhkan washed Stone 2x',
                icon = 'hand',
				image = 'https://media.discordapp.net/attachments/1167569624133541898/1167578431630872606/steel.png',
				event = 'rw:washed',
			},
            {
				title = 'Mengolah Iron Core',
				description = 'Kamu Membutuhkan Iron Core 2x',
				event = 'rw:ironc',
                icon = 'hand',
                image = 'https://media.discordapp.net/attachments/1167569624133541898/1167578432226463754/iron.png',
			},
			{
				title = 'Mengolah Gold Core',
				description = 'Kamu Membutuhkan Gold Core 2x',
				event = 'rw:goldc',
                icon = 'hand',
                image = 'https://media.discordapp.net/attachments/1167569624133541898/1167578431119163512/gold1.png',
			},
			{
				title = 'Mengolah Copper Core',
				description = 'Kamu Membutuhkan Copper Core 2x',
				event = 'rw:copperc',
                icon = 'hand',
                image = 'https://media.discordapp.net/attachments/1167569624133541898/1167578431387607130/copper.png',
			},
			{
				title = 'Mengolah Diamond Core',
				description = 'Kamu Membutuhkan Diamond Core 2x',
				event = 'rw:diamondc',
                icon = 'hand',
                image = 'https://media.discordapp.net/attachments/1167569624133541898/1167578431907692634/diamond.png',
			},
        }
    })
	  lib.showContext('rw:menutambang')
end)

RegisterNetEvent('rw:AddJual')
AddEventHandler('rw:AddJual', function()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "stone_farm",
		duration = 5000,
		label = 'Menjual Bahan Tambang',
		useWhileDead = true,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "missfam4",
			anim = "base",
			flags = 63
		},
		prop = {
			model = "p_amb_clipboard_01",
		}
	}, function(status)
		if not status then
			-- Do Something If Event Wasn't Cancelled
		end
	end)
TriggerServerEvent('rw:addJual1')
end)

RegisterNetEvent('Tambang')
AddEventHandler('Tambang', function(data)
    lib.registerContext({
        id = 'shop_tambang',
        title = 'Jual Bahan Tambang',
        options = {
            {
				title = 'Bahan Tambang',
				description = 'Iron, Copper, Gold',
				event = 'rw:AddJual',
			},
			{
				title = 'Bahan Tambang',
				description = 'Berlian',
				event = 'rw:AddJual',
			}
        }
    })
    lib.showContext('shop_tambang')
end)

exports.ox_target:addBoxZone({
		coords = vec3(1882.2, 376.0, 161.53),
		size = vec3(15, 15, 15),
		rotation = 45,
		--debug = drawZones,
		options = {
			{
				name = 'ciek',
				event = 'rw:ciek',
				icon = 'fa-solid fa-cube',
				label = 'Cuci Batu',
			}
		}
	})

    exports.ox_target:addBoxZone({
		coords = vec3(1110.44, -2008.17, 30.96),
		size = vec3(5, 5, 5),
		rotation = 55,
		--debug = drawZones,
		options = {
			{
				name = 'rw:ciek10',
				event = 'rw:ciek10',
				icon = 'fa-solid fa-cube',
				label = 'Ngebor Batu',
			}
		}
	})