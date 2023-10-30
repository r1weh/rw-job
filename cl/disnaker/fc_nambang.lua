-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
showHelp = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

CreateBlip = function(coords, sprite, colour, text, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
	AddTextEntry(text, text)
	BeginTextCommandSetBlipName(text)
	EndTextCommandSetBlipName(blip)
    return blip
end

tryWashed = function(data, index)
    TriggerServerEvent('rw:washedks', data, index)
end

tryborr = function(data, index)
    TriggerServerEvent('wasabi_mining:ngebor', data, index)
end

miningSellItems = function()
	TriggerServerEvent('RW:sellRock')
end
