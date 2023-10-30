RegisterNetEvent('rw:washed')
AddEventHandler('rw:washed', function()
	local success = lib.skillCheck({'easy'}, {'e'})
	if not success then
		isActive = false
		exports['klrp_notify']:SendAlert('inform', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
		isActive = false
        if lib.progressCircle({
            duration = 2000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                --clip = 'loop_bottle'
            },
        }) then TriggerServerEvent('rw:washed_stone') 
        else 
         end
	end
end)

RegisterNetEvent('rw:ironc')
AddEventHandler('rw:ironc', function()
    local output = lib.callback.await('RW:checkPick', 100, 'iron_stone')
	if output then
	local success = lib.skillCheck({'easy'}, {'e'})
	if not success then
		isActive = false
		exports['klrp_notify']:SendAlert('inform', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
		isActive = false
        if lib.progressCircle({
            duration = 2000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                --clip = 'loop_bottle'
            },
        }) then TriggerServerEvent('rw:iron_stone') 
        else 
         end
	end
elseif not output then
    exports['klrp_notify']:SendAlert('inform', 'Kamu tidak memiliki bahan')
    Wait(100)
    exports['klrp_notify']:SendAlert('inform', 'Kamu Harus memiliki Bahan Min 2x!')
 end
end)

RegisterNetEvent('rw:goldc')
AddEventHandler('rw:goldc', function()
    local output = lib.callback.await('RW:checkPick', 100, 'gold_stone')
	if output then
	local success = lib.skillCheck({'easy'}, {'e'})
	if not success then
		isActive = false
		exports['klrp_notify']:SendAlert('inform', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
		isActive = false
        if lib.progressCircle({
            duration = 2000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                --clip = 'loop_bottle'
            },
        }) then TriggerServerEvent('rw:gold_stone') 
        else
            end
        end
        elseif not output then
            exports['klrp_notify']:SendAlert('inform', 'Kamu tidak memiliki bahan')
            Wait(100)
            exports['klrp_notify']:SendAlert('inform', 'Kamu Harus memiliki Bahan Min 2x!')
         end
end)

RegisterNetEvent('rw:copperc')
AddEventHandler('rw:copperc', function()
    local output = lib.callback.await('RW:checkPick', 100, 'copper_stone')
	if output then
	local success = lib.skillCheck({'easy'}, {'e'})
	if not success then
		isActive = false
		exports['klrp_notify']:SendAlert('inform', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
		isActive = false
        if lib.progressCircle({
            duration = 2000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                --clip = 'loop_bottle'
            },
        }) then TriggerServerEvent('rw:copper_stone') 
        else 
         end
	end
elseif not output then
    exports['klrp_notify']:SendAlert('inform', 'Kamu tidak memiliki bahan')
    Wait(100)
    exports['klrp_notify']:SendAlert('inform', 'Kamu Harus memiliki Bahan Min 2x!')
 end
end)

RegisterNetEvent('rw:diamondc')
AddEventHandler('rw:diamondc', function()
    local output = lib.callback.await('RW:checkPick', 100, 'diamond_stone')
	if output then
	local success = lib.skillCheck({'easy'}, {'e'})
	if not success then
		isActive = false
		exports['klrp_notify']:SendAlert('inform', 'Yah payah kamu gagal', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
		--TriggerEvent("rri-notify:Icon","Yah payah kamu gagal","top-right",2500,"blue-10","white",true,"mdi-alert-box")
	else
		isActive = false
        if lib.progressCircle({
            duration = 2000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                --clip = 'loop_bottle'
            },
        }) then TriggerServerEvent('rw:diamond_stone') 
        else 
         end
	end
elseif not output then
    exports['klrp_notify']:SendAlert('inform', 'Kamu tidak memiliki bahan')
    Wait(100)
    exports['klrp_notify']:SendAlert('inform', 'Kamu Harus memiliki Bahan Min 2x!')
 end
end)
