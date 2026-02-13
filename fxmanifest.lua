fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "wz-blindfold"
description "A script that allows players to blindfold other players"
author "Whitezom"
version "0.1.0"

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'shared/*.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/helpers.lua', -- Added 'client/' prefix
    'client/client.lua',  -- Added 'client/' prefix
    'client/events.lua',  -- Added 'client/' prefix
    'client/target.lua',
    --'client/*.lua'   -- Added 'client/' prefix
}

server_scripts {
    'server/main.lua'
}

dependency {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'qbx_core'
}

ui_page 'html/index.html'

files {
    'locales/*.json',
    'html/index.html',
    'html/style.css',
    'html/blindfold.png'
}

escrow_ignore {
  '**.lua',
  'html/**/*',
  'locales/*.json'
}