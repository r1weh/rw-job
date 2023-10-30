local blips = {
	{title="Disnaker", colour=3, id=590, x = -429.44, y = 1110.46, z = 327.68},
	{title="Ayam", colour=3, id=268, x = 2375.11, y = 5056.28, z = 46.44},
	{title="Prosess Ayam", colour=3, id=268, x = -71.33, y = 6266.45, z = 31.14},
	{title="Minyak", colour=3, id=415, x = 582.25, y = 2930.24, z = 40.92},
	{title="Oleh Minyak", colour=3, id=415, x = 544.84, y = 2883.56, z = 42.97},
	{title="Minyak", colour=3, id=415, x = 2675.58, y = 1482.97, z = 24.5},
	{title="Bahan Wool", colour=3, id=366, x = 2122.73, y = 4782.37, z = 40.97},
	{title="Penjahit", colour=3, id=366, x = 717.96, y = -975.69, z = 24.91},
	{title="Area Cuci Batu", colour=5, id=318, x = 1882.2, y = 376.0, z = 161.53},
	{title="Area Boor Batu", colour=5, id=318, x = 1109.97, y = -2008.1, z = 31.06},
	{title="Jual Bahan Tambang", colour=5, id=318, x = -170.29, y = -2659.28, z = 6.0}
 }

Citizen.CreateThread(function()

   for _, info in pairs(blips) do
	 info.blip = AddBlipForCoord(info.x, info.y, info.z)
	 SetBlipSprite(info.blip, info.id)
	 SetBlipDisplay(info.blip, 4)
	 SetBlipScale(info.blip, 0.7)
	 SetBlipColour(info.blip, info.colour)
	 SetBlipAsShortRange(info.blip, true)
	 BeginTextCommandSetBlipName("STRING")
	 AddTextComponentString(info.title)
	 EndTextCommandSetBlipName(info.blip)
   end
end)