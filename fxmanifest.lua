fx_version 'cerulean'
game 'gta5'
ui_page 'html/index.html'
description 'don-cardealer'
version '1.0.0'

shared_script {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	'sdealer.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client.lua',
	'dealer.lua'
}

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
	'html/img/*.png',
}

escrow_ignore {
    'locales/*.lua',
    'config.lua', 
}

lua54 'yes'