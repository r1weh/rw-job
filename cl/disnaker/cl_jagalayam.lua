local spawnedChickenAlive = 0
local Chickens = {}

RegisterNetEvent('rw:spawnayam')
AddEventHandler('rw:spawnayam', function()
	SpawnChickens()
end)

CreateThread(function()
	while true do
		inRange = false
		local coords = GetEntityCoords(cache.ped)
		local distance = #(coords - Config.ChickenField)

		if distance < 50 then
			SpawnChickens()
			Wait(500)
			inRange = true
		end

		if not inRange then 
			Wait(1000)
		end
		Wait(500)
	end
end)


RegisterNetEvent("ttyy_butcher:catch")
AddEventHandler("ttyy_butcher:catch", function()
	local dead = false
	local plyCoords = GetEntityCoords(PlayerPedId())
	local closestAnimal, closestDistance = ESX.Game.GetClosestPed(plyCoords)
	local nearbyObject, nearbyID

	for i=1, #Chickens, 1 do
		if closestAnimal ~= -1 and closestDistance <= 2.0 then
			nearbyObject, nearbyID = Chickens[i], i
		end
	end
	if closestAnimal ~= -1 and closestDistance <= 2.0 then
		if GetPedType(closestAnimal) == 28 and GetEntityHealth(closestAnimal) == 0 and GetPedSourceOfDeath(closestAnimal) == PlayerPedId() then
			dead = true
			local attempt = 0
			while not NetworkHasControlOfEntity(closestAnimal) and attempt < 10 and DoesEntityExist(closestAnimal) do -- Network handling contributed via thelindat
				Wait(100)
				NetworkRequestControlOfEntity(closestAnimal)
				attempt = attempt + 1
			end
			local netid = NetworkGetNetworkIdFromEntity(closestAnimal)
			--if GetSelectedPedWeapon(PlayerPedId()) == `WEAPON_KNIFE` then
				if DoesEntityExist(closestAnimal) and NetworkHasControlOfNetworkId(netid) then
					local ent = Entity(NetworkGetEntityFromNetworkId(netid))

					exports.ox_inventory:Progress({
						duration = 1500,
						label = "Pick up",
						useWhileDead = false,
						canCancel = false,
						disable = {
							move = true,
							car = true,
							combat = false,
						},
						anim = {
							dict = "random@domestic",
							clip = "pickup_low",
							flags = 49,
						},
					}, function(cancel)
						if not cancel then
							ClearPedTasksImmediately(PlayerPedId())
							
							isButchering = false
							TriggerServerEvent('ttyy_butcher:Catch', 'alive_chicken', 1)
							Wait(150)
							SetEntityAsMissionEntity(closestAnimal, true, true)
							SetEntityAsNoLongerNeeded(closestAnimal)
							DeleteEntity(closestAnimal)

							table.remove(Chickens, nearbyID)
							spawnedChickenAlive = spawnedChickenAlive - 1
							--print('sisa di ladang' .. spawnedChickenAlive)
						end
					end)
				--end
			 --else
			 	--ESX.ShowNotification('You need knife to butcher', 'error')
			 end
		elseif dead == false or netid == nil then
			ESX.ShowNotification('This chicken is not dead', 'error')
			dead = false
		end
	end
end)

function SpawnChickens()
	while spawnedChickenAlive < 15 do
		Wait(0)
		local rwch = 'a_c_hen'
		local chickenCoords = GenerateChickenAliveCoords()

		ESX.Streaming.RequestModel(rwch, function()
			local Animal = CreatePed(5, rwch, chickenCoords, 0.0, true, false)
			PlaceObjectOnGroundProperly(Animal)
			--FreezeEntityPosition(Animal, true)

			table.insert(Chickens, animal)
			spawnedChickenAlive = spawnedChickenAlive + 1
		end)
	end
end

function ValidateChickenAliveCoord(chickenCoord)
	if spawnedChickenAlive > 0 then
		local validate = true

		for k, v in pairs(Chickens) do
			if GetDistanceBetweenCoords(chickenCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(chickenCoord, Config.ChickenField, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

function GenerateChickenAliveCoords()
	while true do
		Wait(1)

		local chickenCordX, chickenCordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-5, 5)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-5, 5)

		chickenCordX = Config.ChickenField.x + modX
		chickenCordY = Config.ChickenField.y + modY

		local coordZ = GetCoordZChicken(chickenCordX, chickenCordY)
		local coord = vector3(chickenCordX, chickenCordY, coordZ)

		if ValidateChickenAliveCoord(coord) then
			return coord
		end
	end
end

function GetCoordZChicken(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end
	return 53.85
end

--target system
local ox_target = exports.ox_target
local drawZones = true

local chicken = {
	'a_c_hen',
}

exports.ox_target:addModel(chicken, {
    {
		name = 'ayam',
		event = "ttyy_butcher:catch",
		icon = "far fas fa-laptop-medical",
		label = "Take",
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(-95.0819, 6207.5879, 31.0259),
    size = vec3(2, 2, 2),
    rotation = 45,
    --debug = drawZones,
    options = {
        {
            event = "ttyy_butcher:Process",
			icon = "fas fa-steak",
			label = "Cut Chicken",
			item = 'WEAPON_KNIFE',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(-99.9406, 6201.8672, 31.0685),
    size = vec3(2, 2, 2),
    rotation = 45,
    --debug = drawZones,
    options = {
        {
			event = "ttyy_butcher:Process2",
			icon = "fas fa-steak",
			label = "Cut Chicken",
			item = 'WEAPON_KNIFE',
        }
    }
})

-- processing handler
RegisterNetEvent('ttyy_butcher:Process')
AddEventHandler('ttyy_butcher:Process', function()
	ProsesChicken(1)
end)

RegisterNetEvent('ttyy_butcher:Process2')
AddEventHandler('ttyy_butcher:Process2', function()
	ProsesChicken(2)
end)

ProsesChicken = function(position)
	local ox_inventory = exports.ox_inventory
	local alivechicken = ox_inventory:Search(2, 'alive_chicken')

	if alivechicken >= 1 then
		local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'

		ESX.Streaming.RequestAnimDict(dict, function()
			local plyCoords = GetEntityCoords(cache.ped)

			TaskPlayAnim(cache.ped, dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 10, 0, 0, 0, 0 )
			
			prop = CreateObject('prop_knife',plyCoords.x, plyCoords.y,plyCoords.z, true, true, true)
			AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
			
			if position == 1 then
				SetEntityHeading(cache.ped, 314.9000)
				chicken = CreateObject('prop_int_cf_chick_01', -94.87, 6207.008, 30.08, true, true, true)

				SetEntityRotation(chicken, 90.0, 0.0, 45.0, 1,true)
				exports.ox_inventory:Progress({
					duration = 10000,
					label = 'Cutting Chicken',
					useWhileDead = false,
					canCancel = true,
					disable = {
						move = true,
						car = true,
						combat = true
					},
				}, function(cancel)
					if not cancel then
						DeleteEntity(chicken)
						DeleteEntity(prop)
						ClearPedTasks(cache.ped)
		
						TriggerServerEvent('ttyy_butcher:Process')
					else
						DeleteEntity(chicken)
						DeleteEntity(prop)
						ClearPedTasks(cache.ped)
					end
				end)

			elseif position == 2 then
				SetEntityHeading(cache.ped, 227.2153)
				chicken = CreateObject('prop_int_cf_chick_01', -99.91, 6201.3272, 30.0685, true, true, true)
				
				SetEntityRotation(chicken, 90.0, 0.0, 20.0, 1,true)

				exports.ox_inventory:Progress({
					duration = 15000,
					label = 'Cutting Chicken',
					useWhileDead = false,
					canCancel = true,
					disable = {
						move = true,
						car = true,
						combat = true
					},
				}, function(cancel)
					if not cancel then
						DeleteEntity(chicken)
						DeleteEntity(prop)
						ClearPedTasks(cache.ped)
		
						TriggerServerEvent('ttyy_butcher:Process')
					else
						DeleteEntity(chicken)
						DeleteEntity(prop)
						ClearPedTasks(cache.ped)
					end
				end)
			end
		end)
	else
		ESX.ShowNotification('There is no alive chicken left', 'error')
	end
end


-- packing handler
exports['qtarget']:AddBoxZone("ttyy_butcher:Pack", vector3(-103.8782, 6208.5313, 30.9089), 12.0, 1.70, {
	name="ttyy_butcher:Pack",
	heading=136.2,
	--debugPoly=true,
	minZ=29.67834,
	maxZ=31.67834,
	}, {
	options = {
		{
			event = "ttyy_butcher:Pack",
			icon = "fas fa-steak",
			label = "Pack Chicken",
			--job = "slaughterer",
		},
	},
	distance = 3.5
})

RegisterNetEvent('ttyy_butcher:Pack')
AddEventHandler('ttyy_butcher:Pack', function()
	PackChicken()
end)

PackChicken = function()
	local ox_inventory = exports.ox_inventory
	local slaughtered = ox_inventory:Search(2, 'slaughtered_chicken')

	if slaughtered >= 1 then
		local PedCoords = GetEntityCoords(cache.ped)
		local dict = 'anim@heists@ornate_bank@grab_cash_heels'

		ESX.Streaming.RequestAnimDict(dict, function()
			TaskPlayAnim(cache.ped, "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
			
			meat = CreateObject('prop_cs_steak', PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(meat, cache.ped, GetPedBoneIndex(cache.ped, 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			
			carton = CreateObject('prop_cs_clothes_box',PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(carton, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)

			SetEntityHeading(cache.ped, 40.2)

			exports.ox_inventory:Progress({
				duration = 15000,
				label = 'Packing Chicken',
				useWhileDead = false,
				canCancel = true,
				disable = {
					move = true,
					car = true,
					combat = true
				},
			}, function(cancel)
				if not cancel then
					ClearPedTasks(cache.ped)
					DeleteEntity(carton)
					DeleteEntity(meat)
					TriggerServerEvent('ttyy_butcher:Pack')
				else
					ClearPedTasks(cache.ped)
					DeleteEntity(carton)
					DeleteEntity(meat)
				end
			end)
		end)
	else
		ESX.ShowNotification('There is no slaughtered chicken left', 'error')
	end
end
