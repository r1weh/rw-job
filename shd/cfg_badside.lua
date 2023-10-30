RW                           	  = {}

RW.DrawDistance                   = 3.5
RW.MarkerType                     = 20
RW.MarkerSize                 	  = { x = 1.0, y = 1.0, z = 0.5 }
RW.MarkerColor                	  = { r = 50, g = 50, b = 204 }
RW.Marker = {
    color = {r = 0, g = 0, b = 255},
    size = {x = 0.5, y = 0.5, z = 0.5},
    type = 2
}

RW.EnablePlayerManagement     	  = true
RW.EnableermonytelManagement      = true
RW.EnablerolymafiaManagement      = true
RW.EnableArmoryManagement     	  = true
RW.EnablealmolygengManagement     = true
RW.EnableESXIdentity          	  = true -- enable if you're using esx_identity
RW.EnableNonFreemodePeds      	  = false -- turn this on if you want custom peds
RW.EnableSocietyOwnedVehicles 	  = false
RW.EnableLicenses             	  = false -- enable if you're using esx_license

RW.EnableHandcuffTimer        	  = true -- enable handcuff timer? will unrestrain player after the time ends
RW.HandcuffTimer              	  = 10 * 60000 -- 10 mins

RW.EnableJobBlip              	  = false -- enable blips for colleagues, requires esx_society

RW.MaxInService               	  = -1
RW.Locale = 'br'

RW.Blip = {
    Blip = {
      Pos     = { x = -572.38, y = 286.89, z = 79.18 },
      Sprite  = 303,
      Display = 4,
      Scale   = 0.8,
      Colour  = 2 
	  
   }
}

RW.bikerstations = {

  LSPD1 = {

    AuthorizedWeapons = {
	},

	Authorizedkendaraanbkr = {
	},

    Cloakrooms = {
    },

    Armories = {
    },

    kendaraanbkr = {
		{
			Spawner    = { x = 1365.9, y = -2105.09, z = 52.01 },
			tempatspawnbkr =  { x = 1363.85, y = -2096.88, z = 52.28 },
			Heading    = 40.0,
		}
},

    Helicopters = {
    },

    ngapusbiker = {
    },

    BossActions = {
    }
  }
}

RW.cartelStations = {

	LSPD1 = {
  
	  Blip = {
	  },
  
	  AuthorizedWeapons = {
	  },
  
	   Authorizedmotorcartel = {
		},
  
	  Cloakrooms = {
	  },
  
	  brangtel = {
	  },
  
	  motorcartel = {
		{
		}
	  },
  
	  Helicopters = {
		{
		}
	  },

	  apusmotor = {
  
	  },
  
	  BossActions = {
	  },
  
	},
  
}


RW.gangStations = {

	LSPD1 = {
  
	  Blip = {
	  },
  
	  AuthorizedWeapons = {

  
	  },
  
	  Authorizedmobilgang = {
	  },
  
	  Cloakrooms = {
	  },
  
	  gengarmor = {
	  },
  
	  mobilgang = {
		{
	  }
  },
  
	  Helicopters = {
		{
		}
	  },
  
	  hapuskengang = {
	  },
  
	  BossActions = {
	  }
	}
}

RW.familiesStations = {

	LSPD1 = {
  
	  Blip = {
	  },
  
	  AuthorizedWeapons = {

  
	  },
  
	  Authorizedmobilfamilies = {
	  },
  
	  Cloakrooms = {
	  },
  
	  familiesarmor = {
	  },
  
	  mobilfamilies = {
		{
	  }
  },
  
	  Helicopters = {
		{
		}
	  },
  
	  hapuskenfamilies = {
	  },
  
	  BossActions = {
	  }
	}
}

RW.dallasStations = {

	LSPD1 = {
  
	  Blip = {
	  },
  
	  AuthorizedWeapons = {

  
	  },
  
	  Authorizedmobildallas = {
	  },
  
	  Cloakrooms = {
	  },
  
	  dallasarmor = {
	  },
  
	  mobildallas = {
		{
	  }
  },
  
	  Helicopters = {
		{
		}
	  },
  
	  hapuskendallas = {
	  },
  
	  BossActions = {
	  }
	}
}

RW.mafiaStations = {

	LSPD1 = {
  
	  Blip = {
	  },
  
	  AuthorizedWeapons = {
	  },
  
	  AuthorizedVehicles = {
		vector3(89.34, -1967.25, 20.75)
	  },
  
	  Cloakrooms = {
	  },
  
	  kasmafia = {
	  },

	  Vehicles = {
		{
	  }
  },
  
	  Helicopters = {
		{
		}
	  },
  
	  VehicleDeleters = {
	  },
  
	  BossActions = {
	  }
	}
}

-- YAKUZA

RW.yakuzaanjing = {

	LSPD1 = {
  
	  Blip = {
	  },
  
	  AuthorizedWeapons = {
	  },
  
	  kendaraanyakuza = {
	  },
  
	  Cloakrooms = {
	  },
  
	  kasyakuza = {
	  },

	  asukendaraan = {
		{
	  	}
  		},
  
	  Helicopters = {
		{
		}
	  },
  
	  VehicleDeleters = {
	  },
  
	  BossActions = {
	  }
	}
}
-- https://wiki.rage.mp/index.php?title=Vehicles
--[[RW.AuthorizedVehicles = {

    Shared = {
		{ name = 'cognoscenti2',  label = 'Véhicule Blindé' },
		  { name = 'Manchez',    label = 'Moto' },
		  { name = 'Contender',   label = '4X4' },
		  { name = 'felon',      label = 'Véhicule Civil' }

	}
}]]


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

RW.Uniforms = {
}