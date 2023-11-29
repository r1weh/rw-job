RegisterNetEvent('rw:jualbahands')
AddEventHandler('rw:jualbahands', function()
    lib.registerContext({
        id = 'rw:jsbahan11',
        title = 'Menu #KOTALAMA',
		menu = 'rw:jsbahan',
        options = {
            {
				title = 'Menu Kerja',
				description = 'Menu Pekerjaan',
                		icon = 'hand',
				menu = 'joblist',
			},
            {
				title = 'Menu Shop #KOTALAMA',
				description = 'Jual Bahan',
				menu = 'jualbahan',
                		icon = 'hand',
			},
        }
    })
	lib.registerContext({
		id = 'jualbahan',
		title = 'Menu Shop #KOTALAMA',
		menu = 'rw:jsbahan1',
		onBack = function()
			lib.showContext('rw:jsbahan11')
		end,
		options = {
            {
				title = 'Jual Bahan [Tambang]',
				description = 'Kamu Bisa Jual Bahan Tambang Disini lo',
                		icon = 'hand',
				event = 'rw:jsbahantambgn',
			},
            {
				title = 'Jual Bahan [Ayam]',
				description = 'Kamu Harus memiliki 10 Bahan Ayam',
				event = 'rw:jualayam',
                		icon = 'hand',
			},
			{
				title = 'Jual Bahan [Kayu]',
				description = 'Kamu Bisa Jual Bahan Kayu Disini lo',
				event = 'rw:goldc',
                		icon = 'hand',
            },
			{
				title = 'Jual Bahan [Pakain]',
				description = 'Kamu Bisa Jual Bahan Pakain Disini lo',
				event = 'rw:jualkain1',
                		icon = 'hand',
			},
			{
				title = 'Jual Bahan [Minyak]',
				description = 'Kamu Bisa Jual Bahan Minyak Disini lo',
				event = 'rw:jualminyak1',
                		icon = 'hand',
			},
			{
				title = 'Jual Bahan [Tani]',
				description = 'COMMING SOON',
				event = 'rw:diamondc',
                		icon = 'hand',
			},
		}
	  })
	  lib.registerContext({
		id = 'joblist',
		title = 'Menu Pekerjaan',
		menu = 'rw:jsbahan1',
		onBack = function()
			lib.showContext('rw:jsbahan11')
		end,
		options = {
			{
				title = 'Aktif Kerja',
				description = 'Aktif Untuk Menjadi Masyrakat',
                		icon = 'hand',
				event = 'rw:jobblips',
			},
		}
	  })
	  lib.showContext('rw:jsbahan11')
end)

-- [Ped Target in Ox_target!] --
local jualdisnaker = {
    1657546978,
}

exports.ox_target:addModel(jualdisnaker, {
    {
        name = 'js',
        event = 'rw:jualbahands',
        icon = 'far fas fa-laptop-medical',
        label = 'Akses Menu Shop!',
    }
})
