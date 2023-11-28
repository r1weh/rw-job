ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getJobs()
	local jobs = ESX.GetJobs()
	local availableJobs = {}
	for k,v in pairs(jobs) do 
		if v.whitelisted == false then 
			availableJobs[k] = {label = v.label}
		end
	end
	return availableJobs
end

ESX.RegisterServerCallback('esx_joblisting:getJobsList', function(source, cb)
	local jobs = getJobs()
	cb(jobs)
end)

function IsNearCentre(player)
	local Ped = GetPlayerPed(player)
	local PedCoords = GetEntityCoords(Ped)
	local Zones = Config.Zones

	for i=1, #Config.Zones, 1 do
		local distance = #(PedCoords - Config.Zones[i])

		if distance < Config.DrawDistance then
			return true
		end
	end
end

RegisterServerEvent('esx_joblisting:setJob')
AddEventHandler('esx_joblisting:setJob', function(job)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local jobs = getJobs()

	if xPlayer and IsNearCentre(source) then
		if jobs[job] then
			xPlayer.setJob('', 0)
		end
	end
end)

RegisterNetEvent('rw:bus')
AddEventHandler('rw:bus', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setJob('bus', 0)
end)