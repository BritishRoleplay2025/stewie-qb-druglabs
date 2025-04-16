local QBCore = exports['qb-core']:GetCoreObject()  -- Get QBCore object

-- Event to add collected item to the player's inventory
RegisterServerEvent('processing:addItem')
AddEventHandler('processing:addItem', function(itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Add the item to the player's inventory
    if Player.Functions.AddItem(itemName, amount) then
        TriggerClientEvent('QBCore:Notify', src, "You collected " .. amount .. " " .. itemName, "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "You can't carry more items", "error")
    end
end)

-- Event to process the collected item into a new item
RegisterServerEvent('processing:processItem')
AddEventHandler('processing:processItem', function(itemName, requiredAmount, resultItem)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Check if the player has enough items to process
    local itemCount = Player.Functions.GetItemByName(itemName)
    
    if itemCount and itemCount.amount >= requiredAmount then
        -- Remove the required items from the player's inventory
        Player.Functions.RemoveItem(itemName, requiredAmount)

        -- Add the processed item to the player's inventory
        Player.Functions.AddItem(resultItem, 1)

        TriggerClientEvent('QBCore:Notify', src, "You processed " .. requiredAmount .. " " .. itemName .. " into " .. resultItem, "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough " .. itemName, "error")
    end
end)

-- Optional: Event to notify when an item is collected
RegisterServerEvent('processing:collectItem')
AddEventHandler('processing:collectItem', function(itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Here you can handle any logic after collecting items if needed
    -- For example, logging or broadcasting to other players
end)




--- SELLING 


-- Server event to handle item buying
RegisterNetEvent('qb-sell:buyItem', function()
    local player = QBCore.Functions.GetPlayer(source)

    if player then
        -- Randomly select a quantity between Config.MinItemsToSell and Config.MaxItemsToSell
        local quantity = math.random(Config.MinItemsToSell, Config.MaxItemsToSell)

        -- Try to find an item the player has in their inventory
        local soldItem = nil

        for i = 1, 10 do  -- Loop up to 10 times to find a valid item
            local item = Config.ItemsToSell[math.random(#Config.ItemsToSell)]
            local itemName = item.name
            local price = item.price
            
            -- Check if the player has the item
            local hasItem = player.Functions.GetItemByName(itemName)

            -- If the player has enough of the item, set soldItem and break the loop
            if hasItem and hasItem.amount >= quantity then
                soldItem = {name = itemName, price = price}
                break
            end
        end

        -- If a soldItem was found, process the sale
        if soldItem then
            player.Functions.RemoveItem(soldItem.name, quantity)  -- Remove the item from the player's inventory
            local totalPrice = soldItem.price * quantity  -- Calculate total price
            player.Functions.AddMoney('cash', totalPrice)  -- Give the player cash
            TriggerClientEvent('QBCore:Notify', source, 'You sold ' .. quantity .. ' ' .. soldItem.name .. ' for $' .. totalPrice, 'success')
        else
            -- If no items were found, notify the player
            TriggerClientEvent('QBCore:Notify', source, 'You have no items to sell!', 'error')
        end
    end
end)

-- Server event for DrugSale dispatch notification
RegisterNetEvent('ps-dispatch:DrugSale', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    -- Here you can add logic for notifying the police or creating a dispatch
    TriggerClientEvent('QBCore:Notify', src, 'Police have been notified of a drug sale!', 'error')
    
    -- Example logic for dispatch notification to the police
    TriggerEvent('dispatch:sendAlert', {
        title = 'Drug Sale in Progress',
        description = 'Possible drug sale reported.',
        coords = GetEntityCoords(GetPlayerPed(src)),
        sender = player.PlayerData.citizenid,
    })
end)


RegisterNetEvent('drug_dealer:sellDrug')
AddEventHandler('drug_dealer:sellDrug', function(drugType, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName(drugType)
    
    if item and item.amount >= amount then
        local price = Config.DrugPrices[drugType] * amount
        if Player.Functions.RemoveItem(drugType, amount) then
            Player.Functions.AddMoney('cash', price)
            TriggerClientEvent('QBCore:Notify', src, 'Sold ' .. amount .. ' ' .. drugType .. ' for $' .. price, 'success')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough " .. drugType .. " to sell!", 'error')
    end
end)