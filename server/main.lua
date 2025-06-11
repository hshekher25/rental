local config = Config or {}

local vehiclelist = {}

RegisterNetEvent('fz-rental:giveRentalPapers', function(name, model, plate, rentalduration)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    local currentTime = os.time()
    local rentalTime = rentalduration * 3600
    local rentTimeEnd = currentTime + rentalTime
    vehiclelist[plate] = {
        duration = rentalduration,
        expires = rentTimeEnd
    }
    if exports.ox_inventory:CanCarryItem(source, 'rental_papers', 1) then
        exports.ox_inventory:AddItem(source, 'rental_papers', 1, {
            name = name,
            plate = plate,
            owner = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname,
            expires = os.date("%Y-%m-%d %H:%M:%S", rentTimeEnd)
        })
        TriggerClientEvent('fz-rental:notify', source, locale('success.item_recieved'), 'success')
    else
        TriggerClientEvent('fz-rental:notify', source, locale('error.not_enough_inventory_space'), 'error')
    end
end)


RegisterNetEvent('fz-rental:rentVehicle', function(name, model, price, rentalduration)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    local total_price = price * rentalduration
    if not player.Functions.RemoveMoney(config.moneytype, total_price, locale('info.remove_money') .. name) then
        if config.moneytype == 'cash' then
            TriggerClientEvent('fz-rental:notify', source, locale('error.not_enough_cash'), 'error')
        else
            TriggerClientEvent('fz-rental:notify', source, locale('error.not_enough_money'), 'error')
        end
        return
    end
    TriggerClientEvent('fz-rental:spawnVehicle', source, name, model, rentalduration)
end)

RegisterNetEvent('fz-rental:giveKeys', function(netId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        exports.qbx_vehiclekeys:GiveKeys(source, vehicle)
    end
end)