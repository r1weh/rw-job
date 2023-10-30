exports.ox_target:addBoxZone({
    coords = vec3(-260.49, -2657.25, 6.44),
    size = vec3(2, 2, 2),
    rotation = 45,
    --debug = drawZones,
    options = {
        {
            event = "rw:jualaan",
			icon = "fas fa-steak",
			label = "Jual Bahan",
        }
    }
})

RegisterNetEvent('rw:jualaan')
AddEventHandler('rw:jualaan', function(args)
    lib.registerContext({
        id = 'bahaan',
        title = 'Menu Jual Bahan',
		menu = 'bahaan1',
        options = {
            {
				title = 'Baju Ambulance',
				description = 'Baju dinas brow',
				event = 'rw:jualayam',
			},
			{
				title = 'Baju Warga',
				description = 'Untuk Bagi yang off duty!',
				event = 'rw:warga',
			}
        }
    })
    lib.showContext('bahaan')
end)

RegisterNetEvent('rw:jualayam')
AddEventHandler('rw:jualayam', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local slaughtered = xPlayer.canCarryItem('slaughtered_chicken', 1)

    if xPlayer.canCarryItem('slaughtered_chicken', 3) then
        xPlayer.addInventoryItem('money', 300)
        xPlayer.removeInventoryItem('alive_chicken', 1)
    else
        TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Inventory full".. salary,"top-right",2500,"red-10","white",true,"")
    end  
end)