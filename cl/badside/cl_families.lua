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
          Citizen.Wait(500)
      end
  
      while ESX.GetPlayerData().job == nil do
          Citizen.Wait(10)
      end
  
      PlayerData = ESX.GetPlayerData()
  end)
  
  function OpenalmolygengMenu(station)
  
      if RW.EnablealmolygengManagement then
  
          local elements = {
              {label = 'Inventory',  value = 'Inventory'}	
              
          }
  
          if PlayerData.job.grade_name == 'boss' then
              --table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
          end
  
          ESX.UI.Menu.CloseAll()
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'almolygeng',
          {
              title    = _U('almolygeng'),
              align    = 'top-left',
              elements = elements
          }, function(data, menu)
  
              if data.current.value == 'get_weapon' then
                  OpenGetWeaponMenu()
              elseif data.current.value == 'put_weapon' then
                  OpenPutWeaponMenu()
              elseif data.current.value == 'buy_weapons' then
                  OpenBuyWeaponsMenu(station)
              elseif data.current.value == 'put_stock' then
                  OpenPutStocksMenu()
              elseif data.current.value == 'Inventory' then
                  OpenfamiliesInventoryMenu()
                  menu.close()
              elseif data.current.value == 'get_stock' then
                  OpenGetStocksMenu()
              end
  
          end, function(data, menu)
              menu.close()
  
              CurrentAction     = 'menu_almolygeng'
              CurrentActionMsg  = _U('open_almolygeng')
              CurrentActionData = {station = station}
          end)
  
      else
  
          local elements = {}
  
          for i=1, #RW.familiesStations[station].AuthorizedWeapons, 1 do
              local weapon = RW.familiesStations[station].AuthorizedWeapons[i]
              table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
          end
  
          ESX.UI.Menu.CloseAll()
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'almolygeng',
          {
              title    = _U('almolygeng'),
              align    = 'top-left',
              elements = elements
          }, function(data, menu)
              local weapon = data.current.value
              TriggerServerEvent('marskuy-ballas:giveWeapon', weapon, 1000)
          end, function(data, menu)
              menu.close()
  
              CurrentAction     = 'menu_almolygeng'
              CurrentActionMsg  = _U('open_almolygeng')
              CurrentActionData = {station = station}
          end)
  
      end
  
  end

  function OpenfamiliesInventoryMenu()
    exports['rri-prosess']:Progress({

		name = "locker",

		duration = 1000,

		label = 'Membuka Brangkas',

		useWhileDead = true,

		canCancel = false,

		controlDisables = {

			disableMovement = true,

			disableCarMovement = true,

			disableMouse = false,

			disableCombat = true,

		},

		animation = {

			animDict = "anim@heists@keycard@",

			anim = "exit",

			flags = 49,

		},

		prop = {



		},

		propTwo = {



		},

	})
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'open_door', 0.05)
	TriggerEvent("rri-notify:Icon","Membuka Lemari!","top-right",2500,"green-20","white",true,"mdi-compass")
	Wait(100)
    exports.ox_inventory:openInventory('stash', {id='society_thefamilies', owner=property.owner})
  end
  
  function GetAvailablemobilfamiliespawnPoints(station, partNum)
      local SpawnPointss = RW.familiesStations[station].mobilfamilies[partNum].SpawnPointss
      local found, foundSpawnPoints = false, nil
  
      for i=1, #SpawnPointss, 1 do
          if ESX.Game.IsSpawnPointsClear(SpawnPointss[i], SpawnPointss[i].radius) then
              found, foundSpawnPoints = true, SpawnPointss[i]
              break
          end
      end
  
      if found then
          return true, foundSpawnPoints
      else
          ESX.ShowNotification(_U('vehicle_blocked'))
          return false
      end
  end
  
  function OpenfamiliesActionsMenu()
      ESX.UI.Menu.CloseAll()
  
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'families_actions',
      {
          title    = 'The Families',
          align    = 'top-left',
          elements = {
              {label = _U('citizen_interaction'),	value = 'citizen_interaction'}
  --			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
  --			{label = _U('object_spawner'),		value = 'object_spawner'}
          }
      }, function(data, menu)
  
          if data.current.value == 'citizen_interaction' then
              local elements = {
  --				{label = _U('id_card'),			value = 'identity_card'},
                  {label = _U('search'),			value = 'body_search'},
                  --{label = _U('handcuff'), value = 'handcuff'},
                  --{label = _U('uncuff'), value = 'uncuff'},
                  --{label = _U('drag'),			value = 'drag'},
                  --{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
                  {label = _U('out_the_vehicle'),	value = 'out_the_vehicle'}
  --				{label = _U('fine'),			value = 'fine'},
  --				{label = _U('unpaid_bills'),	value = 'unpaid_bills'},
  --				{label = _U('jail_menu'),		value = 'jail_menu'}
              }
          
              if RW.EnableLicenses then
                  table.insert(elements, { label = _U('license_check'), value = 'license' })
              end
          
              ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'citizen_interaction',
              {
                  title    = _U('citizen_interaction'),
                  align    = 'top-left',
                  elements = elements
              }, function(data2, menu2)
                  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                  if closestPlayer ~= -1 and closestDistance <= 3.0 then
                      local action = data2.current.value
  
                      if action == 'identity_card' then
                          OpenIdentityCardMenu(closestPlayer)
                      elseif action == 'body_search' then
                            TriggerEvent("rri-notify:Icon",GetPlayerServerId(closestPlayer),_U('being_searched'),"top-right",2500,"negative","white",true,"mdi-tooltip-remove-outline")
                          TriggerServerEvent('marskuy-ballas:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
                          OpenBodySearchMenu(closestPlayer)
                      elseif action == 'handcuff' then
                          local target, distance = ESX.Game.GetClosestPlayer()
                          playerheading = GetEntityHeading(PlayerPedId())
                          playerlocation = GetEntityForwardVector(PlayerPedId())
                          playerCoords = GetEntityCoords(PlayerPedId())
                          local target_id = GetPlayerServerId(target)
                          if distance <= 2.0 then
                              TriggerServerEvent('marskuy-ballas:requestarrest', target_id, playerheading, playerCoords, playerlocation)
                              TriggerServerEvent('InteractSound_SV:PlayOnSource', 'handcuff', 0.5)
                          else
                              ESX.ShowNotification('Not Close Enough to Cuff.')
                          end
                      elseif action == 'uncuff' then
                          local target, distance = ESX.Game.GetClosestPlayer()
                          playerheading = GetEntityHeading(PlayerPedId())
                          playerlocation = GetEntityForwardVector(PlayerPedId())
                          playerCoords = GetEntityCoords(PlayerPedId())
                          local target_id = GetPlayerServerId(target)
                          if distance <= 2.0 then
                              TriggerServerEvent('marskuy-ballas:requestrelease', target_id, playerheading, playerCoords, playerlocation)
                          else
                              ESX.ShowNotification('Not Close Enough to Uncuff.')
                          end
                      elseif action == 'drag' then
                          TriggerServerEvent('marskuy-ballas:drag', GetPlayerServerId(closestPlayer))
                      elseif action == 'put_in_vehicle' then
                          TriggerServerEvent('marskuy-ballas:putInVehicle', GetPlayerServerId(closestPlayer))
                      elseif action == 'out_the_vehicle' then
                          TriggerServerEvent('marskuy-ballas:OutVehicle', GetPlayerServerId(closestPlayer))
                      elseif action == 'fine' then
                          OpenFineMenu(closestPlayer)
                      elseif action == 'license' then
                          ShowPlayerLicense(closestPlayer)
                      elseif action == 'unpaid_bills' then
                          OpenUnpaidBillsMenu(closestPlayer)
                      elseif action == 'jail_menu' then
                          TriggerEvent("esx-qalle-jail:openJailMenu")
                      end	
  
                  else
                      ESX.ShowNotification(_U('no_players_nearby'))
                  end
              end, function(data2, menu2)
                  menu2.close()
              end)
          elseif data.current.value == 'vehicle_interaction' then
              local elements  = {}
              local playerPed = PlayerPedId()
              local coords    = GetEntityCoords(playerPed)
              local vehicle   = ESX.Game.GetVehicleInDirection()
              
              table.insert(elements, {label = _U('search_database'), value = 'search_database'})
  
              ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'vehicle_interaction',
              {
                  title    = _U('vehicle_interaction'),
                  align    = 'top-left',
                  elements = elements
              }, function(data2, menu2)
                  coords  = GetEntityCoords(playerPed)
                  vehicle = ESX.Game.GetVehicleInDirection()
                  action  = data2.current.value
                  
                  if action == 'search_database' then
                  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
                      LookupVehicle()
                  elseif DoesEntityExist(vehicle) then
                      local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                      if action == 'vehicle_infos' then
                          OpenVehicleInfosMenu(vehicleData)
                          
                      elseif action == 'hijack_vehicle' then
                          if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
                              TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                              Citizen.Wait(20000)
                              ClearPedTasksImmediately(playerPed)
  
                              SetVehicleDoorsLocked(vehicle, 1)
                              SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                              ESX.ShowNotification(_U('vehicle_unlocked'))
                          end
                      elseif action == 'impound' then
                      
                          -- is the script busy?
                          if CurrentTask.Busy then
                              return
                          end
  
                          ESX.ShowHelpNotification(_U('impound_prompt'))
                          
                          TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                          
                          CurrentTask.Busy = true
                          CurrentTask.Task = ESX.SetTimeout(10000, function()
                              ClearPedTasks(playerPed)
                              ImpoundVehicle(vehicle)
                              Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
                          end)
                          
                          -- keep track of that vehicle!
                          Citizen.CreateThread(function()
                              while CurrentTask.Busy do
                                  Citizen.Wait(1000)
                              
                                  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                  if not DoesEntityExist(vehicle) and CurrentTask.Busy then
                                      ESX.ShowNotification(_U('impound_canceled_moved'))
                                      ESX.ClearTimeout(CurrentTask.Task)
                                      ClearPedTasks(playerPed)
                                      CurrentTask.Busy = false
                                      break
                                  end
                              end
                          end)
                      end
                  else
                      ESX.ShowNotification(_U('no_mobilfamilies_nearby'))
                  end
  
              end, function(data2, menu2)
                  menu2.close()
              end)
  
          elseif data.current.value == 'object_spawner' then
              ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'citizen_interaction',
              {
                  title    = _U('traffic_interaction'),
                  align    = 'top-left',
                  elements = {
                      {label = _U('cone'),		value = 'prop_roadcone02a'},
                      {label = _U('barrier'),		value = 'prop_barrier_work05'},
                      {label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
                      {label = _U('box'),			value = 'prop_boxpile_07d'},
                      {label = _U('cash'),		value = 'hei_prop_cash_crate_half_full'}
                  }
              }, function(data2, menu2)
                  local model     = data2.current.value
                  local playerPed = PlayerPedId()
                  local coords    = GetEntityCoords(playerPed)
                  local forward   = GetEntityForwardVector(playerPed)
                  local x, y, z   = table.unpack(coords + forward * 1.0)
  
                  if model == 'prop_roadcone02a' then
                      z = z - 2.0
                  end
  
                  ESX.Game.SpawnObject(model, {
                      x = x,
                      y = y,
                      z = z
                  }, function(obj)
                      SetEntityHeading(obj, GetEntityHeading(playerPed))
                      PlaceObjectOnGroundProperly(obj)
                  end)
  
              end, function(data2, menu2)
                  menu2.close()
              end)
          end
  
      end, function(data, menu)
          menu.close()
      end)
  end
  
  function OpenIdentityCardMenu(player)
  
      ESX.TriggerServerCallback('marskuy-ballas:getOtherPlayerData', function(data)
  
          local elements    = {}
          local nameLabel   = _U('name', data.name)
          local jobLabel    = nil
          local sexLabel    = nil
          local dobLabel    = nil
          local heightLabel = nil
          local idLabel     = nil
      
          if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
              jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
          else
              jobLabel = _U('job', data.job.label)
          end
      
          if RW.EnableESXIdentity then
      
              nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)
      
              if data.sex ~= nil then
                  if string.lower(data.sex) == 'm' then
                      sexLabel = _U('sex', _U('male'))
                  else
                      sexLabel = _U('sex', _U('female'))
                  end
              else
                  sexLabel = _U('sex', _U('unknown'))
              end
      
              if data.dob ~= nil then
                  dobLabel = _U('dob', data.dob)
              else
                  dobLabel = _U('dob', _U('unknown'))
              end
      
              if data.height ~= nil then
                  heightLabel = _U('height', data.height)
              else
                  heightLabel = _U('height', _U('unknown'))
              end
      
              if data.name ~= nil then
                  idLabel = _U('id', data.name)
              else
                  idLabel = _U('id', _U('unknown'))
              end
      
          end
      
          local elements = {
              {label = nameLabel, value = nil},
              {label = jobLabel,  value = nil},
          }
      
          if RW.EnableESXIdentity then
              table.insert(elements, {label = sexLabel, value = nil})
              table.insert(elements, {label = dobLabel, value = nil})
              table.insert(elements, {label = heightLabel, value = nil})
              table.insert(elements, {label = idLabel, value = nil})
          end
      
          if data.drunk ~= nil then
              table.insert(elements, {label = _U('bac', data.drunk), value = nil})
          end
      
          if data.licenses ~= nil then
      
              table.insert(elements, {label = _U('license_label'), value = nil})
      
              for i=1, #data.licenses, 1 do
                  table.insert(elements, {label = data.licenses[i].label, value = nil})
              end
      
          end
      
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
          {
              title    = _U('citizen_interaction'),
              align    = 'top-left',
              elements = elements,
          }, function(data, menu)
      
          end, function(data, menu)
              menu.close()
          end)
      
      end, GetPlayerServerId(player))
  
  end
  
function OpenBodySearchMenu(player)
	RequestAnimDict("mp_missheist_countrybank@nervous")
	while not HasAnimDictLoaded("mp_missheist_countrybank@nervous") do
	Citizen.Wait(100)
	end
	ExecuteCommand("me Menggeledah")
	TaskPlayAnim(GetPlayerPed(-1), "mp_missheist_countrybank@nervous", "nervous_idle", 8.0, -8.0, 5500, 33, 0, false, false, false)
    Citizen.Wait(2000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	exports.ox_inventory:openInventory('player', GetPlayerServerId(player))
end
  
  function OpenFineMenu(player)
  
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine',
      {
          title    = _U('fine'),
          align    = 'top-left',
          elements = {
              {label = _U('traffic_offense'), value = 0},
              {label = _U('minor_offense'),   value = 1},
              {label = _U('average_offense'), value = 2},
              {label = _U('major_offense'),   value = 3}
          }
      }, function(data, menu)
          OpenFineCategoryMenu(player, data.current.value)
      end, function(data, menu)
          menu.close()
      end)
  
  end
  
  function OpenFineCategoryMenu(player, category)
  
      ESX.TriggerServerCallback('marskuy-ballas:getFineList', function(fines)
  
          local elements = {}
  
          for i=1, #fines, 1 do
              table.insert(elements, {
                  label     = fines[i].label .. ' <span style="color: green;">Rp.' .. fines[i].amount .. '</span>',
                  value     = fines[i].id,
                  amount    = fines[i].amount,
                  fineLabel = fines[i].label
              })
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
          {
              title    = _U('fine'),
              align    = 'top-left',
              elements = elements,
          }, function(data, menu)
  
              local label  = data.current.fineLabel
              local amount = data.current.amount
  
              menu.close()
  
              if RW.EnablePlayerManagement then
                  TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_thefamilies', _U('fine_total', label), amount)
              else
                  TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', label), amount)
              end
  
              ESX.SetTimeout(300, function()
                  OpenFineCategoryMenu(player, category)
              end)
  
          end, function(data, menu)
              menu.close()
          end)
  
      end, category)
  
  end
  
  function LookupVehicle()
      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
      {
          title = _U('search_database_title'),
      }, function(data, menu)
          local length = string.len(data.value)
          if data.value == nil or length < 2 or length > 13 then
              ESX.ShowNotification(_U('search_database_error_invalid'))
          else
              ESX.TriggerServerCallback('marskuy-ballas:getVehicleFromPlate', function(owner, found)
                  if found then
                      ESX.ShowNotification(_U('search_database_found', owner))
                  else
                      ESX.ShowNotification(_U('search_database_error_not_found'))
                  end
              end, data.value)
              menu.close()
          end
      end, function(data, menu)
          menu.close()
      end)
  end
  
  function ShowPlayerLicense(player)
      local elements = {}
      local targetName
      ESX.TriggerServerCallback('marskuy-ballas:getOtherPlayerData', function(data)
          if data.licenses ~= nil then
              for i=1, #data.licenses, 1 do
                  if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
                      table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
                  end
              end
          end
          
          if RW.EnableESXIdentity then
              targetName = data.firstname .. ' ' .. data.lastname
          else
              targetName = data.name
          end
          
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
          {
              title    = _U('license_revoke'),
              align    = 'top-left',
              elements = elements,
          }, function(data, menu)
              ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
              TriggerServerEvent('marskuy-ballas:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
              
              TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
              
              ESX.SetTimeout(300, function()
                  ShowPlayerLicense(player)
              end)
          end, function(data, menu)
              menu.close()
          end)
  
      end, GetPlayerServerId(player))
  end
  
  function OpenUnpaidBillsMenu(player)
      local elements = {}
  
      ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
          for i=1, #bills, 1 do
              table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">Rp.' .. bills[i].amount .. '</span>', value = bills[i].id})
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
          {
              title    = _U('unpaid_bills'),
              align    = 'top-left',
              elements = elements
          }, function(data, menu)
      
          end, function(data, menu)
              menu.close()
          end)
      end, GetPlayerServerId(player))
  end
  
  function OpenVehicleInfosMenu(vehicleData)
  
      ESX.TriggerServerCallback('marskuy-ballas:getVehicleInfos', function(retrivedInfo)
  
          local elements = {}
  
          table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})
  
          if retrivedInfo.owner == nil then
              table.insert(elements, {label = _U('owner_unknown'), value = nil})
          else
              table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
          {
              title    = _U('vehicle_info'),
              align    = 'top-left',
              elements = elements
          }, nil, function(data, menu)
              menu.close()
          end)
  
      end, vehicleData.plate)
  
  end
  
  function OpenGetWeaponMenu()
  
      ESX.TriggerServerCallback('marskuy-ballas:getalmolygengWeapons', function(weapons)
          local elements = {}
  
          for i=1, #weapons, 1 do
              if weapons[i].count > 0 then
                  table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
              end
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'almolygeng_get_weapon',
          {
              title    = _U('get_weapon_menu'),
              align    = 'top-left',
              elements = elements
          }, function(data, menu)
  
              menu.close()
  
              ESX.TriggerServerCallback('marskuy-ballas:removealmolygengWeapon', function()
                  OpenGetWeaponMenu()
              end, data.current.value)
  
          end, function(data, menu)
              menu.close()
          end)
      end)
  
  end
  
  function OpenPutWeaponMenu()
      local elements   = {}
      local playerPed  = PlayerPedId()
      local weaponList = ESX.GetWeaponList()
  
      for i=1, #weaponList, 1 do
          local weaponHash = GetHashKey(weaponList[i].name)
  
          if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
              table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
          end
      end
  
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'almolygeng_put_weapon',
      {
          title    = _U('put_weapon_menu'),
          align    = 'top-left',
          elements = elements
      }, function(data, menu)
  
          menu.close()
  
          ESX.TriggerServerCallback('marskuy-ballas:addalmolygengWeapon', function()
              OpenPutWeaponMenu()
          end, data.current.value, true)
  
      end, function(data, menu)
          menu.close()
      end)
  end
  
  function OpenBuyWeaponsMenu(station)
  
      ESX.TriggerServerCallback('marskuy-ballas:getalmolygengWeapons', function(weapons)
  
          local elements = {}
  
          for i=1, #RW.familiesStations[station].AuthorizedWeapons, 1 do
              local weapon = RW.familiesStations[station].AuthorizedWeapons[i]
              local count  = 0
  
              for i=1, #weapons, 1 do
                  if weapons[i].name == weapon.name then
                      count = weapons[i].count
                      break
                  end
              end
  
              table.insert(elements, {
                  label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' Rp.' .. weapon.price,
                  value = weapon.name,
                  price = weapon.price
              })
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'almolygeng_buy_weapons',
          {
              title    = _U('buy_weapon_menu'),
              align    = 'top-left',
              elements = elements,
          }, function(data, menu)
  
              ESX.TriggerServerCallback('marskuy-ballas:buy', function(hasEnoughMoney)
                  if hasEnoughMoney then
                      ESX.TriggerServerCallback('marskuy-ballas:addalmolygengWeapon', function()
                          OpenBuyWeaponsMenu(station)
                      end, data.current.value, false)
                  else
                      ESX.ShowNotification(_U('not_enough_money'))
                  end
              end, data.current.price)
  
          end, function(data, menu)
              menu.close()
          end)
  
      end)
  
  end
  
  function OpenGetStocksMenu()
  
      ESX.TriggerServerCallback('marskuy-ballas:getStockItems', function(items)
  
  
          local elements = {}
  
          for i=1, #items, 1 do
              table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
          {
              title    = _U('dallas_stock'),
              align    = 'top-left',
              elements = elements
          }, function(data, menu)
  
              local itemName = data.current.value
  
              ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                  title = _U('quantity')
              }, function(data2, menu2)
  
                  local count = tonumber(data2.value)
  
                  if count == nil then
                      ESX.ShowNotification(_U('quantity_invalid'))
                  else
                      menu2.close()
                      menu.close()
                      TriggerServerEvent('marskuy-ballas:getStockItem', itemName, count)
  
                      Citizen.Wait(300)
                      OpenGetStocksMenu()
                  end
  
              end, function(data2, menu2)
                  menu2.close()
              end)
  
          end, function(data, menu)
              menu.close()
          end)
  
      end)
  
  end
  
  function OpenPutStocksMenu()
  
      ESX.TriggerServerCallback('marskuy-ballas:getPlayerInventory', function(inventory)
  
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
                      TriggerServerEvent('marskuy-ballas:putStockItems', itemName, count)
  
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
      TriggerServerEvent('marskuy-ballas:forceBlip')
  end)
  
  RegisterNetEvent('esx_phone:loaded')
  AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
      local specialContact = {
          name       = _U('phone_families'),
          number     = 'thefamilies',
          base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
      }
  
      TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
  end)
  
  -- don't show dispatches if the player iIERP't in service
  AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
      if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'thefamilies' and PlayerData.job.name == dispatchNumber then
          -- if esx_service is enabled
          if RW.MaxInService ~= -1 and not playerInService then
              CancelEvent()
          end
      end
  end)
  
  
  AddEventHandler('marskuy-ballas:hasEnteredMarker', function(station, part, partNum)
  
      if part == 'Cloakroom' then
          CurrentAction     = 'menu_cloakroom'
          CurrentActionMsg  = _U('open_cloackroom')
          CurrentActionData = {}
  
      elseif part == 'almolygeng' then
  
          CurrentAction     = 'menu_almolygeng'
          CurrentActionMsg  = _U('open_almolygeng')
          CurrentActionData = {station = station}
  
      elseif part == 'mobilfamiliespawner' then
  
          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}
  
      elseif part == 'HelicopterSpawner' then
  
          local helicopters = RW.familiesStations[station].Helicopters
  
          if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoints.x, helicopters[partNum].SpawnPoints.y, helicopters[partNum].SpawnPoints.z,  3.0) then
              ESX.Game.SpawnVehicle('as350', helicopters[partNum].SpawnPoints, helicopters[partNum].Heading, function(vehicle)
                  SetVehicleModKit(vehicle, 0)
                  SetVehicleLivery(vehicle, 0)
              end)
          end
  
      elseif part == 'VehicleDeleter' then
  
          local playerPed = PlayerPedId()
          local coords    = GetEntityCoords(playerPed)
  
          if IsPedInAnyVehicle(playerPed,  false) then
  
              local vehicle = GetVehiclePedIsIn(playerPed, false)
  
              if DoesEntityExist(vehicle) then
                  CurrentAction     = 'delete_vehicle'
                  CurrentActionMsg  = _U('store_vehicle')
                  CurrentActionData = {vehicle = vehicle}
              end
  
          end
  
      elseif part == 'BossActions' then
  
          CurrentAction     = 'menu_boss_actions'
          CurrentActionMsg  = _U('open_bossmenu')
          CurrentActionData = {}
  
      end
  
  end)
  
  AddEventHandler('marskuy-ballas:hasExitedMarker', function(station, part, partNum)
      ESX.UI.Menu.CloseAll()
      CurrentAction = nil
  end)
  
  AddEventHandler('marskuy-ballas:hasEnteredEntityZone', function(entity)
      local playerPed = PlayerPedId()
  
      if PlayerData.job ~= nil and PlayerData.job.name == 'thefamilies' and IsPedOnFoot(playerPed) then
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
  
  AddEventHandler('marskuy-ballas:hasExitedEntityZone', function(entity)
      if CurrentAction == 'remove_entity' then
          CurrentAction = nil
      end
  end)
  
  RegisterNetEvent('marskuy-ballas:unrestrain')
  AddEventHandler('marskuy-ballas:unrestrain', function()
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
  
  RegisterNetEvent('marskuy-ballas:drag')
  AddEventHandler('marskuy-ballas:drag', function(copID)
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
  
  RegisterNetEvent('marskuy-ballas:putInVehicle')
  AddEventHandler('marskuy-ballas:putInVehicle', function()
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
                  if IsmobilfamilieseatFree(vehicle, i) then
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
  
  RegisterNetEvent('marskuy-ballas:OutVehicle')
  AddEventHandler('marskuy-ballas:OutVehicle', function()
      local playerPed = PlayerPedId()
  
      if not IsPedSittingInAnyVehicle(playerPed) then
          return
      end
  
      local vehicle = GetVehiclePedIsIn(playerPed, false)
      TaskLeaveVehicle(playerPed, vehicle, 16)
  end)
  
  RegisterNetEvent('marskuy-ballas:getarrested')
  AddEventHandler('marskuy-ballas:getarrested', function(playerheading, playercoords, playerlocation)
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
      TriggerEvent('marskuy-ballas:handcuff')
      loadanimdict('mp_arresting')
      TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
  end)
  
  RegisterNetEvent('marskuy-ballas:doarrested')
  AddEventHandler('marskuy-ballas:doarrested', function()
      Citizen.Wait(250)
      loadanimdict('mp_arrest_paired')
      TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
      Citizen.Wait(3000)
  
  end) 
  
  RegisterNetEvent('marskuy-ballas:douncuffing')
  AddEventHandler('marskuy-ballas:douncuffing', function()
      Citizen.Wait(250)
      loadanimdict('mp_arresting')
      TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
      Citizen.Wait(5500)
      ClearPedTasks(PlayerPedId())
  end)
  
  RegisterNetEvent('marskuy-ballas:getuncuffed')
  AddEventHandler('marskuy-ballas:getuncuffed', function(playerheading, playercoords, playerlocation)
      local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
      SetEntityCoords(PlayerPedId(), x, y, z)
      SetEntityHeading(PlayerPedId(), playerheading)
      Citizen.Wait(250)
      loadanimdict('mp_arresting')
      TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
      Citizen.Wait(5500)
      IsHandcuffed = false
      TriggerEvent('marskuy-ballas:handcuff')
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
  
  -- Display markers
  Citizen.CreateThread(function()
      while true do
  
          local sleep = 2000
  
          if PlayerData.job ~= nil and PlayerData.job.name == 'thefamilies' then
  
              local playerPed = PlayerPedId()
              local coords    = GetEntityCoords(playerPed)
  
              for k,v in pairs(RW.familiesStations) do
  
                  for i=1, #v.Cloakrooms, 1 do
                      if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < RW.DrawDistance then
                          sleep = 5
                      end
                      if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < RW.DrawDistance then
                          DrawMarker(RW.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, RW.MarkerSize.x, RW.MarkerSize.y, RW.MarkerSize.z, RW.MarkerColor.r, RW.MarkerColor.g, RW.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                      end
                  end
  
                  for i=1, #v.familiesarmor, 1 do
                      if GetDistanceBetweenCoords(coords, v.familiesarmor[i].x, v.familiesarmor[i].y, v.familiesarmor[i].z, true) < RW.DrawDistance then
                          sleep = 5
                      end
                      if GetDistanceBetweenCoords(coords, v.familiesarmor[i].x, v.familiesarmor[i].y, v.familiesarmor[i].z, true) < RW.DrawDistance then
                          DrawMarker(RW.MarkerType, v.familiesarmor[i].x, v.familiesarmor[i].y, v.familiesarmor[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, RW.MarkerSize.x, RW.MarkerSize.y, RW.MarkerSize.z, RW.MarkerColor.r, RW.MarkerColor.g, RW.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                      end
                  end
  
                  for i=1, #v.mobilfamilies, 1 do
                      if GetDistanceBetweenCoords(coords, v.mobilfamilies[i].Spawner.x, v.mobilfamilies[i].Spawner.y, v.mobilfamilies[i].Spawner.z, true) < RW.DrawDistance then
                          sleep = 5
                      end
                      if GetDistanceBetweenCoords(coords, v.mobilfamilies[i].Spawner.x, v.mobilfamilies[i].Spawner.y, v.mobilfamilies[i].Spawner.z, true) < RW.DrawDistance then
                          DrawMarker(RW.MarkerType, v.mobilfamilies[i].Spawner.x, v.mobilfamilies[i].Spawner.y, v.mobilfamilies[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, RW.MarkerSize.x, RW.MarkerSize.y, RW.MarkerSize.z, RW.MarkerColor.r, RW.MarkerColor.g, RW.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                      end
                  end
  
                  for i=1, #v.hapuskenfamilies, 1 do
                      if GetDistanceBetweenCoords(coords, v.hapuskenfamilies[i].x, v.hapuskenfamilies[i].y, v.hapuskenfamilies[i].z, true) < RW.DrawDistance then
                          sleep = 5
                      end
                      if GetDistanceBetweenCoords(coords, v.hapuskenfamilies[i].x, v.hapuskenfamilies[i].y, v.hapuskenfamilies[i].z, true) < RW.DrawDistance then
                          DrawMarker(RW.MarkerType, v.hapuskenfamilies[i].x, v.hapuskenfamilies[i].y, v.hapuskenfamilies[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, RW.MarkerSize.x, RW.MarkerSize.y, RW.MarkerSize.z, RW.MarkerColor.r, RW.MarkerColor.g, RW.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                      end
                  end
  
                  if RW.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
                      for i=1, #v.BossActions, 1 do
                          if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < RW.DrawDistance then
                              sleep = 5
                          end
                          if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < RW.DrawDistance then
                              DrawMarker(RW.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, RW.MarkerSize.x, RW.MarkerSize.y, RW.MarkerSize.z, RW.MarkerColor.r, RW.MarkerColor.g, RW.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                          end
                      end
                  end
  
              end
  
          else
              Citizen.Wait(500)
          end
          Wait(sleep)
      end
  end)
  
  -- Enter / Exit marker events
  Citizen.CreateThread(function()
  
      while true do
  
          Citizen.Wait(10)
  
          if PlayerData.job ~= nil and PlayerData.job.name == 'thefamilies' then
  
              local playerPed      = PlayerPedId()
              local coords         = GetEntityCoords(playerPed)
              local isInMarker     = false
              local currentStation = nil
              local currentPart    = nil
              local currentPartNum = nil
  
              for k,v in pairs(RW.familiesStations) do
  
                  for i=1, #v.Cloakrooms, 1 do
                      if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < RW.MarkerSize.x then
                          isInMarker     = true
                          currentStation = k
                          currentPart    = 'Cloakroom'
                          currentPartNum = i
                      end
                  end
  
                  for i=1, #v.familiesarmor, 1 do
                      if GetDistanceBetweenCoords(coords, v.familiesarmor[i].x, v.familiesarmor[i].y, v.familiesarmor[i].z, true) < RW.MarkerSize.x then
                          isInMarker     = true
                          currentStation = k
                          currentPart    = 'almolygeng'
                          currentPartNum = i
                      end
                  end
  
                  for i=1, #v.mobilfamilies, 1 do
                      if GetDistanceBetweenCoords(coords, v.mobilfamilies[i].Spawner.x, v.mobilfamilies[i].Spawner.y, v.mobilfamilies[i].Spawner.z, true) < RW.MarkerSize.x then
                          isInMarker     = true
                          currentStation = k
                          currentPart    = 'mobilfamiliespawner'
                          currentPartNum = i
                      end
                  end
  
                  for i=1, #v.Helicopters, 1 do
                      if GetDistanceBetweenCoords(coords, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, true) < RW.MarkerSize.x then
                          isInMarker     = true
                          currentStation = k
                          currentPart    = 'HelicopterSpawner'
                          currentPartNum = i
                      end
                  end
  
                  for i=1, #v.hapuskenfamilies, 1 do
                      if GetDistanceBetweenCoords(coords, v.hapuskenfamilies[i].x, v.hapuskenfamilies[i].y, v.hapuskenfamilies[i].z, true) < RW.MarkerSize.x then
                          isInMarker     = true
                          currentStation = k
                          currentPart    = 'VehicleDeleter'
                          currentPartNum = i
                      end
                  end
  
                  if RW.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
                      for i=1, #v.BossActions, 1 do
                          if GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < RW.MarkerSize.x then
                              isInMarker     = true
                              currentStation = k
                              currentPart    = 'BossActions'
                              currentPartNum = i
                          end
                      end
                  end
  
              end
  
              local hasExited = false
  
              if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
  
                  if
                      (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
                      (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
                  then
                      TriggerEvent('marskuy-ballas:hasExitedMarker', LastStation, LastPart, LastPartNum)
                      hasExited = true
                  end
  
                  HasAlreadyEnteredMarker = true
                  LastStation             = currentStation
                  LastPart                = currentPart
                  LastPartNum             = currentPartNum
  
                  TriggerEvent('marskuy-ballas:hasEnteredMarker', currentStation, currentPart, currentPartNum)
              end
  
              if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                  HasAlreadyEnteredMarker = false
                  TriggerEvent('marskuy-ballas:hasExitedMarker', LastStation, LastPart, LastPartNum)
              end
  
          else
              Citizen.Wait(500)
          end
  
      end
  end)
  
  -- Enter / Exit entity zone events
  Citizen.CreateThread(function()
      local trackedEntities = {
          'prop_roadcone02a',
          'prop_barrier_work05',
          'p_ld_stinger_s',
          'prop_boxpile_07d',
          'hei_prop_cash_crate_half_full'
      }
  
      while true do
          Citizen.Wait(500)
  
          local playerPed = PlayerPedId()
          local coords    = GetEntityCoords(playerPed)
  
          local closestDistance = -1
          local closestEntity   = nil
  
          for i=1, #trackedEntities, 1 do
              local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)
  
              if DoesEntityExist(object) then
                  local objCoords = GetEntityCoords(object)
                  local distance  = GetDistanceBetweenCoords(coords, objCoords, true)
  
                  if closestDistance == -1 or closestDistance > distance then
                      closestDistance = distance
                      closestEntity   = object
                  end
              end
          end
  
          if closestDistance ~= -1 and closestDistance <= 3.0 then
              if LastEntity ~= closestEntity then
                  TriggerEvent('marskuy-ballas:hasEnteredEntityZone', closestEntity)
                  LastEntity = closestEntity
              end
          else
              if LastEntity ~= nil then
                  TriggerEvent('marskuy-ballas:hasExitedEntityZone', LastEntity)
                  LastEntity = nil
              end
          end
      end
  end)
  
  -- Key Controls
  Citizen.CreateThread(function()
      while true do
  
          Citizen.Wait(10)
  
          if CurrentAction ~= nil then
              ESX.ShowHelpNotification(CurrentActionMsg)
  
              if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'thefamilies' then
  
                  if CurrentAction == 'menu_cloakroom' then
                      OpenCloakroomMenu()
                  elseif CurrentAction == 'menu_almolygeng' then
                      if RW.MaxInService == -1 then
                          OpenalmolygengMenu(CurrentActionData.station)
                      elseif playerInService then
                          OpenalmolygengMenu(CurrentActionData.station)
                      else
                          ESX.ShowNotification(_U('service_not'))
                      end
                  elseif CurrentAction == 'menu_vehicle_spawner' then
                      OpenmobilfamiliespawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
                  elseif CurrentAction == 'delete_vehicle' then
                      if RW.EnableSocietyOwnedmobilfamilies then
                          local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
                          TriggerServerEvent('esx_society:putVehicleInGarage', 'thefamilies', vehicleProps)
                      end
                      ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                  elseif CurrentAction == 'menu_boss_actions' then
                      ESX.UI.Menu.CloseAll()
                      TriggerEvent('esx_society:openBossMenu', 'thefamilies', function(data, menu)
                          menu.close()
                          CurrentAction     = 'menu_boss_actions'
                          CurrentActionMsg  = _U('open_bossmenu')
                          CurrentActionData = {}
                      end, { wash = false }) -- disable washing money
                  elseif CurrentAction == 'remove_entity' then
                      DeleteEntity(CurrentActionData.entity)
                  end
                  
                  CurrentAction = nil
              end
          end -- CurrentAction end
          
          --[[if IsControlJustReleased(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'thefamilies' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'families_actions') then
              if RW.MaxInService == -1 then
                  OpenfamiliesActionsMenu()
              elseif playerInService then
                  OpenfamiliesActionsMenu()
              else
                  ESX.ShowNotification(_U('service_not'))
              end
          end]]
          
          if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
              ESX.ShowNotification(_U('impound_canceled'))
              ESX.ClearTimeout(CurrentTask.Task)
              ClearPedTasks(PlayerPedId())
              
              CurrentTask.Busy = false
          end
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
  
  RegisterNetEvent('marskuy-ballas:updateBlip')
  AddEventHandler('marskuy-ballas:updateBlip', function()
      
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
      if PlayerData.job ~= nil and PlayerData.job.name == 'thefamilies' then
          ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
              for i=1, #players, 1 do
                  if players[i].job.name == 'thefamilies' then
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
      TriggerEvent('marskuy-ballas:unrestrain')
      
      if not hasAlreadyJoined then
          TriggerServerEvent('marskuy-ballas:spawned')
      end
      hasAlreadyJoined = true
  end)
  
  AddEventHandler('esx:onPlayerDeath', function(data)
      isDead = true
  end)
  
  AddEventHandler('onResourceStop', function(resource)
      if resource == GetCurrentResourceName() then
          TriggerEvent('marskuy-ballas:unrestrain')
          TriggerEvent('esx_phone:removeSpecialContact', 'thefamilies')
  
          if RW.MaxInService ~= -1 then
              TriggerServerEvent('esx_service:disableService', 'thefamilies')
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
          TriggerEvent('marskuy-ballas:unrestrain')
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