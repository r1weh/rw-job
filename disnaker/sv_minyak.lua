local ox_inventory = exports.ox_inventory
local playersProcessingCannabis = {}
local outofbound = true
local alive = true

RegisterServerEvent('rw:Catch')
AddEventHandler('rw:Catch', function()
   -- math.randomseed(os.time())
    local xPlayer = ESX.GetPlayerFromId(source)
   -- local luck = math.random('minyak', 'oli')
        xPlayer.addInventoryItem('tabung' , 1)
end)

RegisterServerEvent('rw:tabung1')
AddEventHandler('rw:tabung1', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
    if xPlayer.canSwapItem('tabung', 2, 'jirigen', 1) then 
        xPlayer.addInventoryItem('jirigen', 1)
        xPlayer.removeInventoryItem('tabung', 2)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterServerEvent('rw:Process2')
AddEventHandler('rw:Process2', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ox_inventory = exports.ox_inventory
	local luck = math.random(1, 3)
    if xPlayer.canSwapItem('jirigen', 1, 'minyak', 1, 'oli', luck) then 
        xPlayer.addInventoryItem('minyak', 1)
        xPlayer.removeInventoryItem('jirigen', 1)
	if luck >= 2 and luck <= 3 then
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Yahh sayang nggk dapet berlian', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
	else
		xPlayer.addInventoryItem('oli', 1)
	end
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu Tidak Memiliki Bahan'})
    end  
end)

RegisterServerEvent('rw:Pack')
AddEventHandler('rw:Pack', function()
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