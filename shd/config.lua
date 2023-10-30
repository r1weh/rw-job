Config              = {}
Config.DrawDistance = 10.0
Config.Locale = 'en'
Config.Jobs         = {}
Config.oldESX = false

Config.MaxCaution = 10000 -- the max caution allowed
Config.RequestIPL = true
Config.DrawDistance  = 5.0
Config.MarkerType    = 2
Config.MarkerSize    = {x = 2.5, y = 2.5, z = 0.5}
Config.MarkerColor   = {r = 60, g = 179, b = 113, a = 255}
Config.ZoneSize     = {x = 1.0, y = 2.5, z = 1.0}
Config.UseOxInventory = true

Config.DistanceToInteract = 2.0
Config.TimeToRecolect = 5000 --- In miliseconds

Config.washedAreas = {
	vec3(1882.2, 376.0, 161.53)
}

Config.Zones = {
	vector3(-139.32, -632.2, 168.82)
}

Config.PublicZones = {

	EnterBuilding = {
		Pos   = vector3(-428.97, 1111.02, 327.69),
		Size  = {x = 1.0, y = 2.5, z = 1.0},
		Color = {r = 50, g = 200, b = 50},
		Marker= 2,
		Blip  = false,
		Name  = _U('reporter_name'),
		Type  = "teleport",
		Hint  = _U('public_enter'),
		Teleport = vector3(-140.57, -618.92, 168.82)
	},

	ExitBuilding = {
		Pos   = vector3(-140.57, -618.92, 168.82),
		Size  = {x = 1.0, y = 2.5, z = 1.0},
		Color = {r = 50, g = 200, b = 50},
		Marker= 2,
		Blip  = false,
		Name  = _U('reporter_name'),
		Type  = "teleport",
		Hint  = _U('public_leave'),
		Teleport = vector3(-429.39, 1109.81, 327.68),
	}

}

Config.ChickenField = vector3(2375.71, 5054.3, 46.44)
-- Busjob --
Config.Locale                     = 'en'
Config.BusHash                    = 'Coach'
Config.Price = 50000

Config.Ped = true

Config.BusJob = {
  {
    DutyPos = {
      {x=-1070.91, y=-2003.52, z=15.79},
    },  
    VehicleSpawn = {
      {x=-1070.38, y=-2012.15, z=13.16},
    },
    FinishPos = {
      {x=695.5, y=626.46, z=128.91}
    },
    FinalPos = {
      {x=-1065.24, y=-2034.47, z=13.04}
    },
    SpawnBus = {
      {x=-1062.2, y=-2009.21, h=134.62, z=13.99}, -- 4. Location •
      {x=-1058.45, y=-2012.96, h=134.62, z=13.99}, -- 3. Location x
      {x=-1051.18, y=-2020.21, h=134.63, z=13.99}, -- Secondary Location x
      {x=-1047.397, y=-2023.994, h=134.63, z=13.99}, -- First Location x
    },
  }
}

Config.Blip = {
	color   = 40,
	alpha   = 255,
	friend  = 1,
	short   = 1,
	scale   = 1.3,
	display = 2,
	sprite  = 513,
	name    = 'Bus Job'
  }
