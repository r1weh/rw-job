RegisterNetEvent('rw:jualbahands')
AddEventHandler('rw:jualbahands', function()
    lib.registerContext({
        id = 'rw:jsbahan',
        title = 'Menu Shop #KOTALAMA',
		menu = 'rw:jsbahan',
        options = {
            {
				title = 'Jual Bahan [Tambang]',
				description = 'Kamu Bisa Jual Bahan Tambang Disini lo',
                icon = 'hand',
				event = 'rw:jsbahantambgn',
			},
            {
				title = 'Jual Bahan [Ayam]',
				description = 'Kamu Bisa Jual Bahan Ayam Disini lo',
				event = 'rw:ironc',
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
				event = 'rw:copperc',
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
	  lib.showContext('rw:jsbahan')
end)