local config = Config or {}

RegisterNetEvent('fz-rental:giveRentalPapers', function(name, model, plate)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    if exports.ox_inventory:CanCarryItem(source, 'rental_papers', 1) then
        exports.ox_inventory:AddItem(source, 'rental_papers', 1, {
            name = name,
            plate = plate,
            owner = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
        })
        TriggerClientEvent('fz-rental:notify', source, 'You have received rental papers for the ' .. name .. '.', 'success')
    else
        TriggerClientEvent('fz-rental:notify', source, 'You do not have enough space in your inventory for the rental papers.', 'error')
    end
end)

RegisterNetEvent('fz-rental:rentVehicle', function(name, model, price)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    if not player.Functions.RemoveMoney(config.moneytype, price, 'Vehicle Rental: ' .. name) then
        if config.moneytype == 'cash' then
            TriggerClientEvent('fz-rental:notify', source, 'You do not have enough cash to rent this vehicle.', 'error')
        else
            TriggerClientEvent('fz-rental:notify', source, 'You do not have enough money in your bank to rent this vehicle.', 'error')
        end
        return
    end
    TriggerClientEvent('fz-rental:spawnVehicle', source, name, model)
end)

RegisterNetEvent('fz-rental:giveKeys', function(netId)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        exports.qbx_vehiclekeys:GiveKeys(source, vehicle)
    end
end)


