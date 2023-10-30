-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local mining = false

CreateThread(function()
    for i=1, #cfg_mining.miningAreas, 1 do
        CreateBlip(cfg_mining.miningAreas[i], 85, 5, Strings.mining_blips, 0.75)
    end
end)

CreateThread(function()
    local textUI = {}
    while true do
        local sleep = 1500
        local pos = GetEntityCoords(cache.ped)
        for i=1, #cfg_mining.miningAreas, 1 do
            local dist = #(pos - cfg_mining.miningAreas[i])	
            if dist <= 2.0 and not mining then
                sleep = 0
                if not textUI[i] then
                    lib.showTextUI(Strings.mine_rock)
                    textUI[i] = true
                end
                if IsControlJustReleased(0, 47) and dist <= 2.0 then
                    lib.hideTextUI()
                    local output = lib.callback.await('RW:checkPick', 100, 'pickaxe')
                    if output then
                        mining = true
                        local model = cfg_mining.axe.prop
                        lib.requestModel(model, 100)
                        local axe = CreateObject(model, GetEntityCoords(cache.ped), true, false, false)
                        AttachEntityToEntity(axe, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                        while mining do
                            Wait()
                            local unarmed = `WEAPON_UNARMED`
                            SetCurrentPedWeapon(cache.ped, unarmed)
                            lib.showTextUI(Strings.intro_instruction)
                            --showHelp(Strings.intro_instruction)
                            --DisableControlAction(0, 24, true)
                            if IsControlJustReleased(0, 38) then
                                lib.hideTextUI()
                                lib.requestAnimDict('melee@hatchet@streamed_core', 100)
                                TaskPlayAnim(cache.ped, 'melee@hatchet@streamed_core', 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                --local rockData = lib.callback.await('RW:getRockData', 100)
                                if lib.skillCheck({'easy'}, {'e'}) then
                                    ClearPedTasks(cache.ped)
                                    TriggerServerEvent('rw:stone')
                                else
                                    local breakChance = math.random(1, 100)
                                    if breakChance < cfg_mining.axe.breakChance then
                                        TriggerServerEvent('RW:axeBroke')
                                        exports['klrp_notify']:SendAlert('inform', 'PickAxe Kamu Pecah!')
                                        TriggerEvent('rw:fixpropradio')
                                        --TriggerEvent('wasabi_mining:notify', Strings.axe_broke, Strings.axe_broke_desc, 'error')
                                        ClearPedTasks(cache.ped)
                                        textUI[i] = nil
                                        break
                                    end
                                    --TriggerEvent('rw:fixpropradio')
                                    ClearPedTasks(PlayerPedId())
                                    exports['klrp_notify']:SendAlert('inform', 'Kamu Kurang AHLI nih!')
                                    --TriggerEvent('wasabi_mining:notify', Strings.failed_mine, Strings.failed_mine_desc, 'error')
                                end
                            elseif IsControlJustReleased(0, 194) then
                                textUI[i] = nil
                                break
                            elseif #(GetEntityCoords(cache.ped) - cfg_mining.miningAreas[i]) > 2.0 then
                                textUI[i] = nil
                                break
                            end
                        end
                        mining = false
                        textUI[i] = nil
                        TriggerEvent('rw:fixpropradio')
                        DeleteObject(axe)
                        SetModelAsNoLongerNeeded(model)
                        RemoveAnimDict('melee@hatchet@streamed_core')
                    elseif not output then
                        exports['klrp_notify']:SendAlert('inform', 'Kamu Tidak memiliki PickAxe')
                        --TriggerEvent('wasabi_mining:notify', Strings.no_pickaxe, Strings.no_pickaxe_desc, 'error')
                    end
                end	
            elseif dist >= 2.1 then
                if textUI[i] then
                    lib.hideTextUI()
                    textUI[i] = nil
                end
            end
        end
        Wait(sleep)
     end
 end)

 CreateThread(function()
    local textUI = {}
    while true do
        local sleep = 1500
        local pos = GetEntityCoords(cache.ped)
        for i=1, #cfg_mining.miningAreas, 1 do
            local dist = #(pos - cfg_mining.miningAreas[i])	
            if dist <= 2.0 and not mining then
                sleep = 0
                if not textUI[i] then
                    lib.showTextUI(Strings.mine_rock)
                    textUI[i] = true
                end
                if IsControlJustReleased(0, 47) and dist <= 2.0 then
                    lib.hideTextUI()
                    local output = lib.callback.await('RW:checkPick', 100, 'pickaxe')
                    if output then
                        mining = true
                        local model = cfg_mining.axe.prop
                        lib.requestModel(model, 100)
                        local axe = CreateObject(model, GetEntityCoords(cache.ped), true, false, false)
                        AttachEntityToEntity(axe, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                        while mining do
                            Wait()
                            local unarmed = `WEAPON_UNARMED`
                            SetCurrentPedWeapon(cache.ped, unarmed)
                            lib.showTextUI(Strings.intro_instruction)
                            --showHelp(Strings.intro_instruction)
                            --DisableControlAction(0, 24, true)
                            if IsControlJustReleased(0, 38) then
                                lib.hideTextUI()
                                lib.requestAnimDict('melee@hatchet@streamed_core', 100)
                                TaskPlayAnim(cache.ped, 'melee@hatchet@streamed_core', 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                local rockData = lib.callback.await('RW:getRockData', 100)
                                if lib.skillCheck(rockData.difficulty) then
                                    ClearPedTasks(cache.ped)
                                    TriggerServerEvent('rw:stone')
                                else
                                    local breakChance = math.random(1, 100)
                                    if breakChance < cfg_mining.axe.breakChance then                                        TriggerServerEvent('RW:axeBroke')
                                        TriggerEvent('rw:fixpropradio')
                                        TriggerEvent('wasabi_mining:notify', Strings.axe_broke, Strings.axe_broke_desc, 'error')
                                        ClearPedTasks(cache.ped)
                                        textUI[i] = nil
                                        break
                                    end
                                    TriggerEvent('rw:fixpropradio')
                                    ClearPedTasks(PlayerPedId())
                                    TriggerEvent('wasabi_mining:notify', Strings.failed_mine, Strings.failed_mine_desc, 'error')
                                end
                            elseif IsControlJustReleased(0, 194) then
                                textUI[i] = nil
                                break
                            elseif #(GetEntityCoords(cache.ped) - cfg_mining.miningAreas[i]) > 2.0 then
                                textUI[i] = nil
                                break
                            end
                        end
                        mining = false
                        textUI[i] = nil
                        DeleteObject(axe)
                        TriggerEvent('rw:fixpropradio')
                        SetModelAsNoLongerNeeded(model)
                        RemoveAnimDict('melee@hatchet@streamed_core')
                    elseif not output then
                        exports['klrp_notify']:SendAlert('inform', 'Kamu Tidak memiliki PickAxe')
                    end
                end	
            elseif dist >= 2.1 then
                if textUI[i] then
                    lib.hideTextUI()
                    textUI[i] = nil
                end
            end
        end
        Wait(sleep)
     end
 end)


 --[[if cfg_mining.sellShop.enabled then
    CreateThread(function()
        --CreateBlip(Config.sellShop.coords, 207, 5, Strings.sell_shop_blip, 0.80)
        local ped, pedSpawned
        local textUI
        while true do
            local sleep = 1500
            local playerPed = cache.ped
            local coords = GetEntityCoords(playerPed)
            local dist = #(coords - cfg_mining.sellShop.coords)
            if dist <= 30 and not pedSpawned then
                lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                lib.requestModel(cfg_mining.sellShop.ped, 100)
                ped = CreatePed(28, cfg_mining.sellShop.ped, cfg_mining.sellShop.coords.x, cfg_mining.sellShop.coords.y, cfg_mining.sellShop.coords.z, cfg_mining.sellShop.heading, false, false)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskPlayAnim(ped, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                pedSpawned = true
            elseif dist <= 1.8 and pedSpawned then
                sleep = 0
                if not textUI then
                    lib.showTextUI(Strings.sell_material)
                    textUI = true
                end
                if IsControlJustReleased(0, 38) then
                    miningSellItems()
                end
            elseif dist >= 1.9 and textUI then
                sleep = 0
                lib.hideTextUI()
                textUI = nil
            elseif dist >= 31 and pedSpawned then
                local model = GetEntityModel(ped)
                SetModelAsNoLongerNeeded(model)
                DeletePed(ped)
                SetPedAsNoLongerNeeded(ped)
                RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                pedSpawned = nil
            end
            Wait(sleep)
        end
    end)
end]]

RegisterNetEvent('rw:jsbahantambgn')
AddEventHandler('rw:jsbahantambgn', function()
    miningSellItems()
end)

RegisterNetEvent('wasabi_mining:alertStaff')
AddEventHandler('wasabi_mining:alertStaff', function()
    TriggerEvent('wasabi_mining:notify', Strings.possible_cheater, Strings.possible_cheater_desc, 'error')
end)
