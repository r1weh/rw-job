RegisterNetEvent("rw1:catch")
AddEventHandler("rw1:catch", function()
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
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer",
            flags = 49,
        },
    }, function(cancel)
        if not cancel then
            TriggerServerEvent('rw:Catch')
        end
    end)
end)

RegisterNetEvent("rw1:hasil2")
AddEventHandler("rw1:hasil2", function()
    local success = lib.skillCheck({'easy'}, {'e', 'e', 'e', 'e'})
	if not success then
		isActive = false
		exports['klrp_notify']:SendAlert('erorr', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
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
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer",
            flags = 49,
        },
    }, function(cancel)
        if not cancel then
            TriggerServerEvent('rw:tabung1')
        end
    end)
end
end)

RegisterNetEvent("rw1:hasil1")
AddEventHandler("rw1:hasil1", function()
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
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer",
            flags = 49,
        },
    }, function(cancel)
        if not cancel then
            TriggerServerEvent('rw:Process2')
        end
    end)
end)

RegisterNetEvent("rw1:hasil")
AddEventHandler("rw1:hasil", function()
local finished = exports["klrp_misc"]:taskBar(2000)
if not finished then
    isActive = false
    exports['klrp_notify']:SendAlert('erorr', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
    --TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
else
    local finished2 = exports["klrp_misc"]:taskBar(2000)
    if not finished2 then
        isActive = false
        exports['klrp_notify']:SendAlert('erorr', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
        --TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
    else
                    ClearPedSecondaryTask(playerPed)
                    isActive = false
                    TriggerEvent('rw1:hasil1')
                end
            end
end)

--- Target ---
local gentong = {
 -1738103333,
}

exports.ox_target:addBoxZone({
    coords = vec3(581.33, 2930.39, 40.92),
    size = vec3(5, 5, 5),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'rw1:catch',
            event = 'rw1:catch',
            icon = 'fa-solid fa-cube',
            label = 'Ambil Bahan Oil',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(544.84, 2883.56, 42.97),
    size = vec3(3, 3, 3),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'mobilpolisi',
            event = 'rw1:hasil2',
            icon = 'fa-solid fa-cube',
            label = 'Mengolah Bahan Oil',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(2675.64, 1482.86, 24.5),
    size = vec3(3, 3, 3),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'mobilpolisi2',
            event = 'rw1:hasil',
            icon = 'fa-solid fa-cube',
            label = 'Mengolah Bahan Oli or Minyak',
        }
    }
})
