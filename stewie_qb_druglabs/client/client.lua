local QBCore = exports['qb-core']:GetCoreObject()
local isCollecting = false
local isProcessing = false
local isInProcessZone = false
local currentZone = nil
local alreadyInZone = false
local isSelling = false



Citizen.CreateThread(function()
    -- Add blips if enabled
    if Config.EnableBlips then
        for _, blip in pairs(Config.Blips) do
            local blipHandle = AddBlipForCoord(blip.coords)
            SetBlipSprite(blipHandle, blip.sprite)
            SetBlipDisplay(blipHandle, 4)
            SetBlipScale(blipHandle, blip.scale)
            SetBlipColour(blipHandle, blip.color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blip.name)
            EndTextCommandSetBlipName(blipHandle)
        end
    end

    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInZone = false
        local isInProcessZone = false
        local interactionMessageShown = false
        local alreadyInZone = false

        -- Handle collection zones
        for _, zone in pairs(Config.CircleZones) do
            local distance = Vdist(playerCoords, zone.coords)

            -- Draw marker for collection zone
            DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 1.5, 0, 0, 0, 0, 0, 0, zone.radius * 2, zone.radius * 2, 1.0, zone.color[1], zone.color[2], zone.color[3], 500, false, true, 2, false, false, false, false)

            if distance <= zone.radius then
                isInZone = true
                hintToDisplay('Press ~INPUT_CONTEXT~ to collect ' .. zone.name, true)

                if IsControlJustPressed(0, 38) then -- E key
                    if not isCollecting then
                        startCollecting(zone.itemName)
                    end
                end
            end
        end

        -- Handle processing zones
        for _, zone in pairs(Config.ProcessZones) do
            local distance = Vdist(playerCoords, zone.coords)

            -- Draw marker for processing zone
            DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 1.5, 0, 0, 0, 0, 0, 0, zone.radius * 2, zone.radius * 2, 1.0, zone.color[1], zone.color[2], zone.color[3], 500, false, true, 2, false, false, false, false)

            if distance <= zone.radius then
                isInProcessZone = true
                currentZone = zone

                if not alreadyInZone then
                    hintToDisplay('Press ~INPUT_CONTEXT~ to process ' .. zone.name, true)
                    alreadyInZone = true
                end

                if IsControlJustPressed(0, 38) then -- E key
                    if not isProcessing then
                        startProcessing(zone)
                    end
                end
            end
        end

        -- Handle teleportation zones
        for _, zone in pairs(Config.TeleportZones) do
            local distance = Vdist(playerCoords, zone.coords)

            -- Draw marker for teleportation zone
            DrawMarker(20, zone.coords.x, zone.coords.y, zone.coords.z + 0.2, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, zone.color[1], zone.color[2], zone.color[3], 100, false, true, 2, false, false, false, false)

            if distance <= zone.radius then
                hintToDisplay('Press ~INPUT_CONTEXT~ to teleport to '.. zone.name, true)


                if IsControlJustPressed(0, 38) then
                    SetEntityCoords(PlayerPedId(), zone.destination)
                 --   QBCore.Functions.Notify("You have teleported to " .. zone.destinationName)
                end
            end
        end

    end
end)


function hintToDisplay(text)
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentString(text)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)  -- The third parameter is set to 1 to display immediately

end


function getCurrentZone(itemName)
    for _, zone in pairs(Config.CircleZones) do
        if zone.itemName == itemName then
            return zone
        end
    end
    return nil
end

function startCollecting(itemName)
    isCollecting = true
    local settings = DrugSettings[itemName] or { collectTime = 20000, amount = 1 }  -- Default settings if not found

    -- Start the new emote/animation
    local playerPed = PlayerPedId()  -- Get the player's Ped ID
    RequestAnimDict("anim@scripted@heist@ig9_control_tower@male@")  -- Request the animation dictionary
    while not HasAnimDictLoaded("anim@scripted@heist@ig9_control_tower@male@") do  -- Wait until the animation dictionary is loaded
        Citizen.Wait(0)  -- Yield execution to prevent freezing
    end

    -- Start the animation in a loop
    TaskPlayAnim(playerPed, "anim@scripted@heist@ig9_control_tower@male@", "loop", 8.0, -8.0, -1, 49, 0, false, false, false)  -- Play the specified animation

    -- Change progress bar to use lib.progressBar
    local progress = lib.progressBar({
        duration = settings.collectTime,  -- Set the duration for the progress bar from the settings
        label = 'Collecting ' .. itemName,  -- Set the label to reflect the item being collected
        useWhileDead = false,  -- Adjust based on your requirements
        canCancel = true,  -- Allow cancellation
        disable = {
            move = false,
            car = true,
            mouse = false,
            combat = true,
        },
    })

    -- Check if the progress bar was canceled
    if progress then
        -- Immediately collect the item after the progress bar completes
        collectItem(itemName, settings.amount)  -- Pass the amount to collect
        
        -- Stop the animation after completing the collection
        ClearPedTasksImmediately(playerPed)

        -- Continue collecting based on the defined settings
        Citizen.SetTimeout(1000, function()  
            if isCollecting then
                startCollecting(itemName)  -- Call startCollecting recursively
            end
        end)
    else
        -- If canceled, stop the animation
        QBCore.Functions.Notify("Collection canceled.", "error")
        isCollecting = false
        ClearPedTasksImmediately(playerPed)  -- Stop the animation
    end
end


function collectItem(itemName, amount)
    print("Attempting to collect item:", itemName, "Amount:", amount)  -- Debug print
    TriggerServerEvent('processing:addItem', itemName, amount)  -- Trigger server event with the specified amount
end


function startProcessing(zone)
    isProcessing = true
    local settings = DrugSettings[zone.itemName] or { processTime = 20000, amount = 1 }  -- Default settings if not found
    local processMessage = "Processing " .. (zone.itemName or "unknown item") .. "..."
    print("Starting to process: ", processMessage)  -- Debugging output

    -- Start the emote/animation
    local playerPed = PlayerPedId()  -- Get the player's Ped ID
    RequestAnimDict("anim@amb@drug_processors@coke@female_a@idles")  -- Request the animation dictionary
    while not HasAnimDictLoaded("anim@amb@drug_processors@coke@female_a@idles") do  -- Wait until the animation dictionary is loaded
        Citizen.Wait(0)  -- Yield execution to prevent freezing
    end

    -- Play the idle animation (looping)
    TaskPlayAnim(playerPed, "anim@amb@drug_processors@coke@female_a@idles", "idle_b", 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Change progress bar to use lib.progressBar
    local progress = lib.progressBar({
        duration = settings.processTime,  -- Set the duration for the progress bar from the settings
        label = processMessage,  -- Set the label to the processing message
        useWhileDead = false,  -- Adjust based on your requirements
        canCancel = true,  -- Allow cancellation
        disable = {
            move = false,
            car = true,
            mouse = false,
            combat = true,
        },
    })

    -- Check if the progress bar was canceled
    if progress then
        -- Immediately process the item after the progress bar completes
        processItem(zone, settings.amount)  -- Call the function to process the item with the amount
    else
        -- If canceled, stop the processing
        QBCore.Functions.Notify("Processing canceled.", "error")
        isProcessing = false
        ClearPedTasksImmediately(playerPed)  -- Stop the animation
        return  -- Exit the function if canceled
    end

    -- If processing is successful, provide feedback
    QBCore.Functions.Notify("You have processed " .. settings.amount .. " " .. zone.itemName, "success")

    -- Continue processing if still in the zone after a brief delay
    Citizen.SetTimeout(1000, function()  
        if isProcessing and currentZone == zone then
            startProcessing(zone)  -- Call startProcessing recursively
        end
    end)
end


function processItem(zone, amount)
    print("Attempting to process item:", zone.itemName, "Required Amount:", zone.requiredAmount)  -- Debug print
    TriggerServerEvent('processing:processItem', zone.itemName, zone.requiredAmount, zone.resultItem)  -- Trigger server event with the specified amount
end









-- Function to draw text above the ped's head in 3D
local function drawTxtAbovePed(ped, text)
    local pedCoords = GetEntityCoords(ped)
    local onScreen, _x, _y = World3dToScreen2d(pedCoords.x, pedCoords.y, pedCoords.z + 1.0) -- Adjust Z to position above the head
    local distance = Vdist(GetGameplayCamCoords().x, GetGameplayCamCoords().y, GetGameplayCamCoords().z, pedCoords.x, pedCoords.y, pedCoords.z)

    local scale = (1.0 / distance) * 2  -- Scale the text based on distance
    if onScreen then
        SetTextFont(4)
        SetTextProportional(0)
        SetTextScale(scale, scale)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)  -- Draw the text on the screen
    end
end

-- Function to spawn a gang ped
local function spawnGangPed()
    local model = Config.GangPeds[math.random(#Config.GangPeds)]  -- Randomly select a gang ped model
    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(100)
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Create a ped at a random offset from the player's position
    local offset = math.random(5, 15)  -- Random distance from the player (between 5 and 15 units)
    local spawnCoords = vector3(
        playerCoords.x + offset * math.cos(math.random() * 2 * math.pi),
        playerCoords.y + offset * math.sin(math.random() * 2 * math.pi),
        playerCoords.z  -- Keep the same Z level
    )

    local ped = CreatePed(4, model, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", 0, true)

    return ped
end

-- Function for ped to do an emote and then walk away
local function makePedLeave(ped)
    -- Perform a selling emote
    TaskPlayAnim(ped, "mp_common", "givetake1_a", 8.0, -8.0, 1500, 0, 0, false, false, false)

    -- Wait for the emote to finish
    Wait(1500)  -- Adjust wait time as necessary for the emote duration

    local playerCoords = GetEntityCoords(PlayerPedId())

    -- Task the ped to walk away
    TaskGoToCoordAnyMeans(ped, playerCoords.x + 10, playerCoords.y + 10, playerCoords.z, 1.0, 0, 0, 0, 0)

    -- Wait for the ped to walk away
    Wait(5000)  -- Wait 5 seconds to give the ped time to walk away
    DeleteEntity(ped)  -- Delete the ped
end

-- Start selling
RegisterCommand('start-sell', function()
    if isSelling then
        QBCore.Functions.Notify('You are already selling!', 'error')
        return
    end

    isSelling = true
    QBCore.Functions.Notify('Started selling! Gang peds will arrive every 6 seconds.', 'success')

    Citizen.CreateThread(function()
        while isSelling do
            local ped = spawnGangPed()

            -- Move the ped closer to the player
            TaskGoToEntity(ped, PlayerPedId(), -1, 1.0, 1.0, 0, 0)

            -- Wait for the ped to get close
            while not IsPedInRange(ped, PlayerPedId(), 1.5) do
                Wait(100)
            end

            -- Loop to show "Press E to sell" above the ped's head
            local sellingInProgress = true
            while sellingInProgress do
                Wait(0)  -- Prevent freezing the game

                -- Draw text above the ped's head
                drawTxtAbovePed(ped, 'Press E to sell')

                -- Check for E key press (input 38 is E)
                if IsControlJustReleased(0, 38) then
                    sellingInProgress = false

                    -- Play the custom selling animation for the player
                    local playerPed = PlayerPedId()
                    RequestAnimDict("mp_common")  -- Request the animation dictionary
                    while not HasAnimDictLoaded("mp_common") do
                        Wait(100)
                    end
                    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, 1500, 0, 0, false, false, false)
                    Wait(1500)  -- Wait for the player's emote to finish

                    -- Interact with the player
                    TriggerServerEvent('qb-sell:buyItem')

-- Check if dispatch should be triggered
local chance = math.random(1, 100)
if chance <= Config.DispatchChance then
    -- Debugging line
    print("Dispatch triggered with chance: " .. chance)
    
    if Config.DispatchSystem == "ps-dispatch" then
        exports['ps-dispatch']:DrugSale()
    elseif Config.DispatchSystem == "qs-dispatch" then
        exports['qs-dispatch']:DrugSale()
    else
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = data.coords,
            title = '10-31 - Drug Sale',
            message = 'A '..data.sex..' was spotted selling drugs at '..data.street, 
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 51, 
                scale = 1.2, 
                colour = 2,
                flashes = false, 
                text = '10-31 - Drug Sale',
                time = 5,
                radius = 0,
            }
        })
    end
else
    print("Dispatch NOT triggered with chance: " .. chance)
end
                    -- Make the ped perform an emote and then walk away
                    makePedLeave(ped)
                end

                -- Exit loop if the player moves away
                if not IsPedInRange(ped, PlayerPedId(), 1.5) then
                    sellingInProgress = false
                end
            end

            -- Wait before spawning the next NPC
            Wait(6000)  -- Wait 6 seconds before spawning the next NPC
        end
    end)
end)

-- Stop selling
RegisterCommand('stop-sell', function()
    if isSelling then
        isSelling = false
        QBCore.Functions.Notify('Stopped selling.', 'success')
    else
        QBCore.Functions.Notify('You are not selling!', 'error')
    end
end)

-- Utility function to check distance
function IsPedInRange(ped, target, distance)
    local pedCoords = GetEntityCoords(ped)
    local targetCoords = GetEntityCoords(target)
    return #(pedCoords - targetCoords) < distance
end













local pedModel = 'a_m_y_business_01' -- You can change this to any ped model
local coords = vector4(1870.01, 2596.87, 44.67, 0.0)


local function sellDrugs(drugType)
    local input = lib.inputDialog('Sell Drugs', {
        {
            type = 'number',
            label = 'Amount to sell',
            description = 'How many ' .. drugType .. ' do you want to sell?',
            icon = 'hashtag',
            required = true,
            min = 1,
            max = 100
        }
    })

    if input then
        local amount = input[1]
        local success = lib.progressBar({
            duration = 7000,
            label = 'Making the deal...',
            useWhileDead = false,
            canCancel = true,
            disable = { car = true },
        })

        if success then
            TriggerServerEvent('drug_dealer:sellDrug', drugType, amount)
        end
    end
end

local function createDealerMenu(drugType)
    lib.registerContext({
        id = 'dealer_menu_'..drugType,
        title = 'Drug Dealer - ' .. drugType,
        options = {
            {
                title = 'Sell ' .. drugType,
                description = '$' .. Config.DrugPrices[drugType] .. ' per unit',
                icon = 'cannabis',
                onSelect = function()
                    sellDrugs(drugType)
                end
            }
        }
    })
end

local function playDealerAnimation()
    local playerPed = PlayerPedId()
    RequestAnimDict("anim@mp_player_intcelebrationfemale@face_palm")
    while not HasAnimDictLoaded("anim@mp_player_intcelebrationfemale@face_palm") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, "anim@mp_player_intcelebrationfemale@face_palm", "face_palm", 8.0, -8.0, 2000, 0, 0, false, false, false)
    
    local success = lib.progressBar({
        duration = 3000,
        label = 'Talking to dealer...',
        useWhileDead = false,
        canCancel = true,
        disable = { car = true },
    })

    return success
end

CreateThread(function()
    for k, dealer in pairs(Config.DealerLocations) do
        RequestModel(GetHashKey(dealer.model))
        while not HasModelLoaded(GetHashKey(dealer.model)) do
            Wait(1)
        end

        local ped = CreatePed(4, GetHashKey(dealer.model), dealer.coords.x, dealer.coords.y, dealer.coords.z, dealer.coords.w, false, true)
        
        SetEntityHeading(ped, dealer.coords.w)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetPedDefaultComponentVariation(ped)

        createDealerMenu(dealer.drug)

        if Config.UseOxTarget then
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'dealer_'..k,
                    icon = 'fas fa-user-secret',
                    label = 'Talk to ' .. k:gsub("^%l", string.upper) .. ' Dealer',
                    onSelect = function()
                        local success = playDealerAnimation()
                        if success then
                            lib.showContext('dealer_menu_'..dealer.drug)
                        end
                    end
                }
            })
        else
            exports['qb-target']:AddTargetEntity(ped, {
                options = {
                    {
                        type = "client",
                        icon = "fas fa-user-secret",
                        label = "Talk to " .. k:gsub("^%l", string.upper) .. " Dealer",
                        action = function()
                            local success = playDealerAnimation()
                            if success then
                                lib.showContext('dealer_menu_'..dealer.drug)
                            end
                        end
                    }
                },
                distance = 2.5,
            })
        end
    end
end)
