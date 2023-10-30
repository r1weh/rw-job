local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsHandcuffed            = false
local HandcuffTimer           = {}
local DragStatus              = {}
DragStatus.IsDragged          = false
local hasAlreadyJoined        = false
local blipsCops               = {}
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false

ESX                           = nil
local ox_inventory = exports.ox_inventory

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function OpenMafiaInventoryMenu()
	TriggerEvent("rri-notify:Icon","Membuka Lemari!","top-right",2500,"green-20","white",true,"mdi-compass")
	--exports.ox_inventory:openInventory('stash', {id = 'society_mafia', owner = nil})
	ox_inventory:openInventory('stash', 'society_mafia')
end

function OpenBodySearchMenu(player)
	exports.ox_inventory:openInventory('player', GetPlayerServerId(player))
end


RegisterNetEvent('glsd')
AddEventHandler('glsd', function(data2, menu2)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerEvent("rri-notify:Icon",GetPlayerServerId(closestPlayer),_U('being_searched'),"top-right",2500,"negative","white",true,"mdi-tooltip-remove-outline")
		TriggerServerEvent('marskuy-mafia:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
		OpenBodySearchMenu(closestPlayer)
end
end)

RegisterNetEvent('mbol')
AddEventHandler('mbol', function(data2, menu2)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	TriggerServerEvent('marskuy-mafia:putInVehicle', GetPlayerServerId(closestPlayer))
end
end)

RegisterNetEvent('klr')
AddEventHandler('klr', function(data2, menu2)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	TriggerServerEvent('marskuy-mafia:OutVehicle', GetPlayerServerId(closestPlayer))
end
end)

RegisterNetEvent('sertt')
AddEventHandler('sertt', function(data2, menu2)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	TriggerServerEvent('marskuy-mafia:drag', GetPlayerServerId(closestPlayer))
end
end)

--- [Menu Vehicle] ---
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(playerPed)
        local letSleep = true
        
        if ESX.PlayerData.job and ESX.PlayerData.job.name == "mafia" then
            for k,v in pairs(RW.mafiaStations.LSPD1.AuthorizedVehicles) do
                local dist = #(pedCoords - v)
                if dist < 25.0 then
                    lib.hideTextUI()
                    letSleep = false
                    DrawMarker(RW.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, RW.Marker.size.x, RW.Marker.size.y, RW.Marker.size.z, RW.Marker.color.r, RW.Marker.color.g, RW.Marker.color.b, 100, false, false, 2, false, nil, nil, false)

                    if dist < 2.5 then
                        lib.showTextUI('[E] - Open Garage')
                       -- DisplayHelpText(Language['open_menu_help'])
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('rw:carbd')
                        end
                    end
                end
            end
		end
    end
end)
--- [Menu Vehicle] ---

RegisterNetEvent('bdcar')
AddEventHandler('bdcar', function(vehicle)
	local playerPed = PlayerPedId()
	ESX.Game.SpawnVehicle('sanchez',
		{x = 89.34, y = -1967.25, z = 20.75} , 314.76, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
		SetVehicleMaxMods(vehicle)
	  end)
end)

RegisterNetEvent('bdcarmbl')
AddEventHandler('bdcarmbl', function(vehicle)
	local playerPed = PlayerPedId()
	ESX.Game.SpawnVehicle('nissantitan17', 
	{x = 89.34, y = -1967.25, z = 20.75} , 314.76, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
		SetVehicleMaxMods(vehicle)
	  end)
end)


RegisterNetEvent('rw:carbd')
AddEventHandler('rw:carbd', function()
    lib.registerContext({
        id = 'car_bd',
        title = 'Menu Ganti Baju',
		menu = 'car_bd',
        options = {
            {
				title = 'Motor',
				description = 'Motor Fraksi co!',
				event = 'bdcar',
			},
			{
				title = 'Mobil',
				description = 'Motor Fraksi co!',
				event = 'bdcarmbl',
			},
			{
				title = 'Save Vehicle',
				description = 'Masukin kendaraan anda',
				event = 'bdcarsave',
			},
        }
    })
    lib.showContext('car_bd')
end)

function Svabd(vehicle)
    local smuaKendaraan = GetGamePool('CVehicle')
    for i = 1, #smuaKendaraan do
        local kendaraan = smuaKendaraan[i]
        if DoesEntityExist(kendaraan) then
            DeleteVehicle(kendaraan)
        end
    end
end

RegisterNetEvent('bdcarsave')
AddEventHandler('bdcarsave', function(vehicle)
	Svabd(vehicle)
end)

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('marskuy-mafia:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('marskuy-mafia:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

RegisterNetEvent('rw:cuff')
AddEventHandler('rw:cuff', function()
	local target, distance = ESX.Game.GetClosestPlayer()
	playerheading = GetEntityHeading(PlayerPedId())
	playerlocation = GetEntityForwardVector(PlayerPedId())
	playerCoords = GetEntityCoords(PlayerPedId())
	local target_id = GetPlayerServerId(target)
	if distance <= 2.0 then
		TriggerServerEvent('marskuy-mafia:requestarrest', target_id, playerheading, playerCoords, playerlocation)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'handcuff', 0.5)
	else
		ESX.ShowNotification('Not Close Enough to Cuff.')
	end
end)

RegisterNetEvent('rw:uncuff')
AddEventHandler('rw:uncuff', function()
	local target, distance = ESX.Game.GetClosestPlayer()
	playerheading = GetEntityHeading(PlayerPedId())
	playerlocation = GetEntityForwardVector(PlayerPedId())
	playerCoords = GetEntityCoords(PlayerPedId())
	local target_id = GetPlayerServerId(target)
	if distance <= 2.0 then
		TriggerServerEvent('marskuy-mafia:requestrelease', target_id, playerheading, playerCoords, playerlocation)
	else
		ESX.ShowNotification('Not Close Enough to Uncuff.')
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    --CreateBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	--CreateBlip()
	
	Citizen.Wait(5000)
	TriggerServerEvent('marskuy-mafia:forceBlip')
end)

-- don't show dispatches if the player iIERP't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'mafia' and PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if RW.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('marskuy-mafia:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('marskuy-mafia:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'mafia' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('marskuy-mafia:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('marskuy-mafia:unrestrain')
AddEventHandler('marskuy-mafia:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if RW.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

RegisterNetEvent('marskuy-mafia:drag')
AddEventHandler('marskuy-mafia:drag', function(copID)
	if not IsHandcuffed then
		return
	end

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('marskuy-mafia:putInVehicle')
AddEventHandler('marskuy-mafia:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				DragStatus.IsDragged = false
			end
		end
	end
end)

RegisterNetEvent('marskuy-mafia:OutVehicle')
AddEventHandler('marskuy-mafia:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

RegisterNetEvent('marskuy-mafia:getarrested')
AddEventHandler('marskuy-mafia:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	TriggerEvent('marskuy-mafia:handcuff')
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('marskuy-mafia:doarrested')
AddEventHandler('marskuy-mafia:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)

end) 

RegisterNetEvent('marskuy-mafia:douncuffing')
AddEventHandler('marskuy-mafia:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('marskuy-mafia:getuncuffed')
AddEventHandler('marskuy-mafia:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	TriggerEvent('marskuy-mafia:handcuff')
	ClearPedTasks(PlayerPedId())
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, Keys['W'], true) -- W
			--DisableControlAction(0, Keys['A'], true) -- A
			--DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			--DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			--DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['V'], true) -- Disable changing view
			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('rw:mafia')
AddEventHandler('rw:mafia', function()
	if PlayerData.job ~= nil and PlayerData.job.name == 'mafia' then
		OpenMafiaInventoryMenu()
	else
        TriggerEvent("rri-notify:Icon", "Kamu Tidak Memilik Akses", "right", 1500, "grey-1", "green", true, "mdi-check-decagram")
    end
end)

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)
		
		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('marskuy-mafia:updateBlip')
AddEventHandler('marskuy-mafia:updateBlip', function()
	
	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end
	
	-- Clean the blip table
	blipsCops = {}

	-- Enable blip?
	if RW.MaxInService ~= -1 and not playerInService then
		return
	end

	if not RW.EnableJobBlip then
		return
	end
	
	-- Is the player a cop? In that case show all the blips for other cops
	if PlayerData.job ~= nil and PlayerData.job.name == 'mafia' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'mafia' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id)
					end
				end
			end
		end)
	end

end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('marskuy-mafia:unrestrain')
	
	if not hasAlreadyJoined then
		TriggerServerEvent('marskuy-mafia:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('marskuy-mafia:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'mafia')

		if RW.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'mafia')
		end

		if RW.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if RW.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(RW.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('marskuy-mafia:unrestrain')
		HandcuffTimer.Active = false
	end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle) 
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end

RegisterCommand('job', function()
	riwehjob = ESX.GetPlayerData().job.label.. " - "..ESX.GetPlayerData().job.grade_label
	TriggerEvent("rri-notify:Icon","Job Kamu : " .. riwehjob,"top-right",2500,"blue-10","white",true,"mdi-bank")
 end)

 RegisterCommand('id', function()
	riwehjob = GetPlayerServerId(PlayerId())
	TriggerEvent("rri-notify:Icon","ID Kamu : " .. riwehjob,"top-right",2500,"blue-10","white",true,"mdi-bank")
 end)
