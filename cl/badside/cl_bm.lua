ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

exports.ox_target:addBoxZone({
    coords = vec3(1334.43, 4306.58, 38.23),
    size = vec3(2, 2, 2),
    rotation = 45,
    options = {
        {
            event = "rw:bm",
			icon = "fa fa-shopping-basket",
			label = "Open Black Market",
            groups = {
                ['mafia'] = 2,
                ['thefamilies'] = 2,
                ['gang'] = 2,
                ['cartel'] = 2,
                ['ballas'] = 2,
            },
        }
    }
})

RegisterNetEvent('rw:bm')
AddEventHandler('rw:bm', function()
    local success = lib.skillCheck({'easy', 'easy', 'medium'}, {'e', 'e', 'e', 'e'})
    if not success then
        isActive = false
        SetEntityHealth(PlayerPedId(), 150)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2, 'meledakk', 0.100) 
        exports['klrp_notify']:SendAlert('erorr', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
        --TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
    else
                ClearPedSecondaryTask()
                isActive = false
                OpenBM()
            end
end)

function OpenBM()
    exports.ox_inventory:openInventory('shop', { type = 'YouTool', id = 1 })
end