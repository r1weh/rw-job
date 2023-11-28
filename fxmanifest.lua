fx_version 'adamant'
game 'gta5'
author "Rnr"
description 'Disnaker - Badside'
lua54 'yes'
version '0.0.2'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'@ox_lib/init.lua',
	'shd/cfg_mining.lua',
	'shd/strings.lua',
	'locales/*.lua',
}
server_scripts {
	'@es_extended/imports.lua',
	'@oxmysql/lib/MySQL.lua',
	'bridge/**/server.lua',
	'sv/*.lua',
	'shd/*.lua',
	'sv/disnaker/*.lua',
	'sv/badside/*.lua'
}

client_scripts {
	'@es_extended/imports.lua',
	'bridge/**/client.lua',
	'cl/*.lua',
	'shd/*.lua',
	'cl/disnaker/*.lua',
	'cl/badside/*.lua',
}

dependency {
	'es_extended',
	'ox_lib'
}
