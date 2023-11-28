local ox_inventory = exports.ox_inventory

RegisterServerEvent('ttyy_butcher:Catch')
AddEventHandler('ttyy_butcher:Catch', function(item, count)
    if ox_inventory:CanCarryItem(source, item, count) then 
        ox_inventory:AddItem(source, item, count)
        ox_inventory:AddItem(source, 'bulu', 1)
    else
        TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Inventory full".. salary,"top-right",2500,"red-10","white",true,"")
    end
end)

RegisterServerEvent('ttyy_butcher:Process')
AddEventHandler('ttyy_butcher:Process', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local slaughtered = xPlayer.canCarryItem('slaughtered_chicken', 1)

    if xPlayer.canCarryItem('slaughtered_chicken', 3) then
        xPlayer.addInventoryItem('slaughtered_chicken', 3)
        xPlayer.removeInventoryItem('alive_chicken', 1)
    else
        TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Inventory full".. salary,"top-right",2500,"red-10","white",true,"")
    end  
    end)

RegisterServerEvent('ttyy_butcher:Pack')
AddEventHandler('ttyy_butcher:Pack', function()
    math.randomseed(os.time())
	local xPlayer = ESX.GetPlayerFromId(source)
	local luck = math.random(1, 100)
	local grade = 0

    if xPlayer.canCarryItem('packaged_chicken', 1) then
		xPlayer.addInventoryItem('packaged_chicken', 1)
        xPlayer.removeInventoryItem('slaughtered_chicken', 3)
    else
        TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Inventory full".. salary,"top-right",2500,"red-10","white",true,"")
    end  
end)