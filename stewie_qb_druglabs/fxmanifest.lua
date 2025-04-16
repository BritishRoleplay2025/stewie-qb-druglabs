server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Stewie' -- Replace with your name or alias
description '[QB] Drug Labs' -- Replace with a brief description
version '1.0.0' -- Version of your resource



shared_scripts {
    '@ox_lib/init.lua',

}

-- Client scripts
client_scripts {
    'client/client.lua',
    'client/drug_settings.lua',  -- Path to your client script
    'config.lua'         -- Path to your config file (if needed)
}

-- Server scripts
server_scripts {
    'server/server.lua', -- Path to your server script
    'config.lua'         -- Path to your config file (if needed)
}

escrow_ignore {
    'config.lua',
    'client/drug_settings.lua'
}

dependency {
    'ox_lib',
    'ps-dispatch'


}