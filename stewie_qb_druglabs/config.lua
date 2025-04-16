Config = {}
Config.UseOxTarget = true -- Set to true for ox_target, false for qb-target
Config.DispatchSystem = "qs-dispatch"  -- Choose which dispatch system to use: "ps-dispatch", "cd-dispatch", or "qs-dispatch"
Config.MinItemsToSell = 1  -- Minimum number of items
Config.MaxItemsToSell = 10  -- Maximum number of items
Config.DispatchChance = 100  -- Percentage chance of dispatch notification (0-100)
Config.EnableBlips = true  -- Set this to false to disable all blips
Config.Blips = {
    { name = "Spice Lab", coords = vector3(2431.03, 4963.06, 41.38), sprite = 496, color = 1, scale = 0.8 },
    { name = "Heroin Lab", coords = vector3(1394.54, 3601.74, 37.97), sprite = 501, color = 21, scale = 0.8 },
    { name = "Meth Lab", coords = vector3(244.61, 374.4, 104.77), sprite = 57, color = 45, scale = 0.8 },
    { name = "Coke Lab", coords = vector3(-55.15, 6392.58, 30.52), sprite = 497, color = 0, scale = 0.8 },
    { name = "Weed Lab", coords = vector3(116.75, -1990.18, 17.43), sprite = 496, color = 2, scale = 0.8 },
    { name = "X-Pills Lab", coords = vector3(3561.85, 3670.55, 27.15), sprite = 403, color = 5, scale = 0.8 },
    { name = "Lean Lab", coords = vector3(96.23, -1289.87, 29.27), sprite = 93, color = 27, scale = 0.8 },

}
--NPC SELLING , YOU CAN DO BY /start-sell and /stop-sell to finnish
Config.ItemsToSell = {
    {name = "spice_pooch", price = 20},
    {name = "weed_pooch", price = 50},
    {name = "meth_pooch", price = 100},
    {name = "heroin_shot", price = 150},
    {name = "coke_pooch", price = 200},
    {name = "xpills", price = 80},
    {name = "lean_bottle", price = 180}
}
--BULK SELLING 
Config.DrugPrices = {
    weed_pooch = 500,
    xpills = 750,
    lean_bottle = 1000,
    spice_pooch = 1250,
    coke_pooch = 1500,
    meth_pooch = 2000,
    heroin_shot = 2500
}

-- BULK SELLING LOCATIONS 
Config.DealerLocations = {
    weed = {
        model = 'g_m_y_salvaboss_01',
        coords = vector4(-1173.0, -1571.33, 3.66, 161.97), -- Grove Street area
        drug = 'weed_pooch'
    },
    xpills = {
        model = 'g_m_m_chemwork_01',
        coords = vector4(32.75, -627.84, 09.77, 197.89), -- Del Perro Beach
        drug = 'xpills'
    },
    lean = {
        model = 'g_m_y_mexgoon_01',
        coords = vector4(40.63, 3707.46, 38.74, 338.35), -- La Mesa
        drug = 'lean_bottle'
    },
    spice = {
        model = 'g_m_y_korlieut_01',
        coords = vector4(-1146.91, 4939.52, 221.27, 167.07), -- Morningwood
        drug = 'spice_pooch'
    },
    coke = {
        model = 'g_m_m_cartelguards_01',
        coords = vector4(349.37, 166.9, 102.11, 164.58), -- Sandy Shores
        drug = 'coke_pooch'
    },
    meth = {
        model = 'g_m_m_chemwork_01',
        coords = vector4(495.8, -1822.97, 27.87, 13.45), -- Grapeseed
        drug = 'meth_pooch'
    },
    heroin = {
        model = 'g_m_y_lost_01',
        coords = vector4(1219.56, 1847.41, 77.95, 220.11), -- North Coast
        drug = 'heroin_shot'
    }
}

Config.TeleportZones = {
    { name = "Weed Lab", coords = vector3(116.75, -1990.18, 18.41), radius = 1.0, destination = vector3(1065.1, -3183.89, -39.16), destinationName = "Weed Lab", color = {255, 0, 0} },
    { name = "Exit Weed Lab", coords = vector3(1065.99, -3183.64, -39.16), radius = 1.0, destination = vector3(116.75, -1990.18, 18.41), destinationName = "Outside", color = {255, 0, 0} },
    { name = "Meth Lab", coords = vector3(244.6, 374.4, 105.74), radius = 1.0, destination = vector3(997.14, -3200.7, -36.39), destinationName = "Meth Lab", color = {255, 0, 0} },
    { name = "Exit Meth Lab", coords = vector3(997.14, -3200.7, -36.39), radius = 1.0, destination = vector3(244.6, 374.4, 105.74), destinationName = "Outside", color = {255, 0, 0} },
    { name = "Coke Lab", coords = vector3(-55.7, 6392.87, 31.49), radius = 1.0, destination = vector3(1088.83, -3187.74, -38.99), destinationName = "Coke Lab", color = {255, 0, 0} },
    { name = "Exit Coke Lab", coords = vector3(1088.83, -3187.74, -38.99), radius = 1.0, destination = vector3(-55.7, 6392.87, 31.49), destinationName = "Outside", color = {255, 0, 0} },
}
---- *********FOR COLLECTING AND THE AMOUNT CAN BE EDITED IN client/drug_settings**********
Config.CircleZones = {
    
    { name = "Coke", coords = vector3(1100.84, -3198.77, -38.99), radius = 0.8, color = { 0, 0, 255 }, itemName = "cokebrick"},
    { name = "Heroin", coords = vector3(1394.44, 3601.81, 38.94), radius = 0.8, color = { 0, 0, 255 }, itemName = "heroin"},
    { name = "Meth", coords = vector3(1016.18, -3195.62, -38.99), radius = 0.8, color = { 0, 0, 255 }, itemName = "meth_raw" },
    { name = "Spice Leafs", coords = vector3(2431.14, 4963.17, 42.35), radius = 0.8, color = { 0, 0, 255 }, itemName = "spice_leaf" },
    --Chemicals 
    { name = "Chemicals", coords = vector3(3561.42, 3668.62, 28.12), radius = 0.8, color = { 0, 0, 255 }, itemName = "chemicals" },
    { name = "Chemicals", coords = vector3(3561.86, 3670.55, 28.12), radius = 0.8, color = { 0, 0, 255 }, itemName = "chemicals" },
    -- WEED 
    { name = "Weed", coords = vector3(1057.49, -3196.77, -39.16), radius = 0.8, color = { 0, 0, 255 }, itemName = "weed_leaf" },
    { name = "Weed", coords = vector3(1059.94, -3193.77, -39.16), radius = 0.8, color = { 0, 0, 255 }, itemName = "weed_leaf" },
    { name = "Weed", coords = vector3(1054.2, -3192.12, -39.16), radius = 0.8, color = { 0, 0, 255 }, itemName = "weed_leaf" },
    -- LEAN
    { name = "Lean", coords = vector3(93.39, -1291.53, 29.27), radius = 0.8, color = { 0, 0, 255 }, itemName = "raw_lean" },
}
Config.ProcessZones = { -- PROCESS TIME CAN EDITED IN client/drug_settings AND REQUIRED AMOUNT CAN BE EDITED HERE IN THE CONFIG
    { name = "Process Chemicals", coords = vector3(3559.67, 3674.47, 28.12), radius = 0.8, color = { 0, 255, 0 }, itemName = "chemicals", resultItem = "xpills", requiredAmount = 5 },
    { name = "Process Chemicals", coords = vector3(3559.47, 3672.35, 28.12), radius = 0.8, color = { 0, 255, 0 }, itemName = "chemicals", resultItem = "xpills", requiredAmount = 5 },

-- Process Weed 
    { name = "Process Weed", coords = vector3(1039.24, -3205.12, -38.17), radius = 0.8, color = { 0, 255, 0 }, itemName = "weed_leaf", resultItem = "weed_pooch", requiredAmount = 5 },
    { name = "Process Weed", coords = vector3(1037.5, -3205.36, -38.17), radius = 0.8, color = { 0, 255, 0 }, itemName = "weed_leaf", resultItem = "weed_pooch", requiredAmount = 5} ,
    { name = "Process Weed", coords = vector3(1034.66, -3205.59, -38.18), radius = 0.8, color = { 0, 255, 0 }, itemName = "weed_leaf", resultItem = "weed_pooch", requiredAmount = 5 },
    { name = "Process Weed", coords = vector3(1032.93, -3205.51, -38.18), radius = 0.8, color = { 0, 255, 0 }, itemName = "weed_leaf", resultItem = "weed_pooch", requiredAmount = 5 },

-- Porcess Coke 
    { name = "Porcess Coke", coords = vector3(1095.16, -3196.64, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "cokebrick", resultItem = "coke_pooch", requiredAmount = 1 },
    { name = "Porcess Coke", coords = vector3(1092.52, -3196.57, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "cokebrick", resultItem = "coke_pooch", requiredAmount = 1 },
    { name = "Porcess Coke", coords = vector3(1090.06, -3196.58, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "cokebrick", resultItem = "coke_pooch", requiredAmount = 1 },
    { name = "Porcess Coke", coords = vector3(1090.3, -3194.82, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "cokebrick", resultItem = "coke_pooch", requiredAmount = 1 },
    { name = "Porcess Coke", coords = vector3(1092.9, -3194.9, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "cokebrick", resultItem = "coke_pooch", requiredAmount = 1 },
    { name = "Porcess Coke", coords = vector3(1095.37, -3194.92, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "cokebrick", resultItem = "coke_pooch", requiredAmount = 1 },
-- HERION
    { name = "Process Heroin", coords = vector3(1389.78, 3608.77, 38.94), radius = 0.8, color = { 0, 255, 0 }, itemName = "heroin", resultItem = "heroin_shot", requiredAmount = 5 },
    { name = "Process Heroin", coords = vector3(1389.08, 3605.68, 38.94), radius = 0.8, color = { 0, 255, 0 }, itemName = "heroin", resultItem = "heroin_shot", requiredAmount = 5 },
    { name = "Process Heroin", coords = vector3(1389.75, 3603.58, 38.94), radius = 0.8, color = { 0, 255, 0 }, itemName = "heroin", resultItem = "heroin_shot", requiredAmount = 5 },
    { name = "Process Heroin", coords = vector3(1392.06, 3605.95, 38.94), radius = 0.8, color = { 0, 255, 0 }, itemName = "heroin", resultItem = "heroin_shot", requiredAmount = 5 },

-- Process Meth 
    { name = "Process Meth", coords = vector3(1011.37, -3194.86, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "meth_raw", resultItem = "meth_pooch", requiredAmount = 3 },
    { name = "Process Meth", coords = vector3(1006.74, -3194.86, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "meth_raw", resultItem = "meth_pooch", requiredAmount = 3 },
    { name = "Process Meth", coords = vector3(1003.84, -3194.88, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "meth_raw", resultItem = "meth_pooch", requiredAmount = 3 },
    { name = "Process Meth", coords = vector3(1014.17, -3194.89, -38.99), radius = 0.8, color = { 0, 255, 0 }, itemName = "meth_raw", resultItem = "meth_pooch", requiredAmount = 3 },

-- Process Spice Leafs 
    { name = "Process Spice Leafs", coords = vector3(2436.15, 4965.48, 42.35), radius = 0.8, color = { 0, 255, 0 }, itemName = "spice_leaf", resultItem = "spice_pooch", requiredAmount = 2 },
    { name = "Process Spice Leafs", coords = vector3(2434.31, 4963.85, 42.35), radius = 0.8, color = { 0, 255, 0 }, itemName = "spice_leaf", resultItem = "spice_pooch", requiredAmount = 2 },
    { name = "Process Spice Leafs", coords = vector3(2431.28, 4970.79, 42.35), radius = 0.8, color = { 0, 255, 0 }, itemName = "spice_leaf", resultItem = "spice_pooch", requiredAmount = 2 },
    { name = "Process Spice Leafs", coords = vector3(2431.94, 4967.59, 42.35), radius = 0.8, color = { 0, 255, 0 }, itemName = "spice_leaf", resultItem = "spice_pooch", requiredAmount = 2 },
    { name = "Process Spice Leafs", coords = vector3(2433.95, 4969.23, 42.35), radius = 0.8, color = { 0, 255, 0 }, itemName = "spice_leaf", resultItem = "spice_pooch", requiredAmount = 2 },
-- Lean 
    { name = "Lean Ingrediants", coords = vector3(94.52, -1294.1, 29.27), radius = 0.8, color = { 0, 255, 0 }, itemName = "raw_lean", resultItem = "lean_bottle", requiredAmount = 2 },
}
Config.GangPeds = {
    'a_m_m_skater_01',  -- Example ped model
    'a_m_y_genstreet_01', -- Add more ped models as needed
    's_f_y_stripper_01',  -- Example ped model
    's_m_y_marine_01',    -- Example ped model
    'a_m_y_business_01'   -- Example ped model
}





