RegisterNetEvent("rw1:wool")
AddEventHandler("rw1:wool", function()
local success = lib.skillCheck({'easy'}, {'e'})
	if not success then
		isActive = false
		exports['klrp_notify']:SendAlert('erorr', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
    exports.ox_inventory:Progress({
        duration = 1500,
        label = "Mengambil Wool",
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
            TriggerServerEvent('rw:addwool')
        end
    end)
end
end)

--[[RegisterNetEvent("rw1:hasil22")
AddEventHandler("rw1:hasil22", function()
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
end)]]

RegisterNetEvent("rw:penjahit")
AddEventHandler("rw:penjahit", function()
    local success = lib.skillCheck({'easy'}, {'e'})
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
            TriggerServerEvent('rw:Penjahit2')
        end
    end)
end
end)

RegisterNetEvent("rw:pakain1")
AddEventHandler("rw:pakain1", function()
    local success = lib.skillCheck({'easy'}, {'e'})
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
            TriggerServerEvent('rw:Pack1')
        end
    end)
end
end)

--- Target ---
local gentong = {
 -1738103333,
}

exports.ox_target:addBoxZone({
    coords = vec3(2122.56, 4784.33, 40.97),
    size = vec3(5, 5, 5),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'mobilpolisi1',
            event = 'rw1:wool',
            icon = 'fa-solid fa-cube',
            label = 'Ambil Bahan Wool',
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vec3(717.67, -960.02, 30.4),
    size = vec3(4, 4, 4),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'mobilpolisi',
            event = 'rw:menupenjahit',
            icon = 'fa-solid fa-cube',
            label = 'Mengolah Kain',
        }
    }
})

RegisterNetEvent('rw:menupenjahit')
AddEventHandler('rw:menupenjahit', function()
    lib.registerContext({
        id = 'menupenjahit',
        title = 'Mengolah Bahan Kain',
		menu = 'menupenjahit1',
        options = {
            {
				title = 'Mengolah Kain',
				description = 'Anda Akan Dapat Mengolah Kain Dari Wool, 2x Wool = 1x Kain',
				event = 'rw:penjahit',
                icon = 'hand',
                image = 'https://media.discordapp.net/attachments/1167569624133541898/1167569765540298844/kain.png',
			},
			{
				title = 'Mengolah Pakain',
				description = 'Anda Akan Dapat Mengolah Pakain Dari Kain, 2x Kain = 1x Pakaian',
				event = 'rw:pakain1',
                icon = 'hand',
                image = 'https://media.discordapp.net/attachments/1167569624133541898/1167569766806995034/clothe.png',
			}
        }
    })
    lib.showContext('menupenjahit')
end)