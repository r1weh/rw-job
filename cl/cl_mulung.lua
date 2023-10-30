local dumpster = {
	1143474856,
	684586828,
	577432224,
	-206690185,
	682791951,
	1511880420,
	218085040,
	-58485588,
	666561306,
	-1587184881,
	1329570871
}

exports.ox_target:addModel(dumpster, {
    {
		name = 'minya1k2',
		event = "rw:mulung",
		icon = "far fas fa-laptop-medical",
		label = "Mulung",
    }
})

RegisterNetEvent('rw:mulung')
AddEventHandler('rw:mulung', function()
	local success = lib.skillCheck({'easy'}, {'e'})
	if not success then
		exports['klrp_notify']:SendAlert('inform', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
        ClearPedSecondaryTask(playerPed)
        OpenTrashCan()
    end
end)

function OpenTrashCan()
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    exports.ox_inventory:Progress({
        duration = 10000,
        label = "Pick up",
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = false,
        },
        anim = {
           --dict = "PROP_HUMAN_BUM_BIN",
            --clip = "machinic_loop_mechandplayer",
           -- flags = 49,
        },
    }, function(cancel)
        if not cancel then
            TriggerServerEvent("esx-ecobottles:retrieveBottle")
            ClearPedTasks(PlayerPedId())
        end
    end)
end