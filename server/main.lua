local config = Config or {}

local vehiclelist = {}

RegisterNetEvent('fz-rental:giveRentalPapers', function(netid, name, model, plate, rentalduration)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    local currentTime = os.time()
    local rentalTime = rentalduration * 3600
    local rentTimeEnd = currentTime + rentalTime
    local cid = player.PlayerData.citizenid
    vehiclelist[cid] = {
        netid = netid,
        name = name,
        model = model,
        plate = plate,
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


RegisterNetEvent('fz-rental:rentVehicle', function(id, name, model, price, rentalduration)
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
    TriggerClientEvent('fz-rental:spawnVehicle', source, id, name, model, rentalduration)
end)

RegisterNetEvent('fz-rental:giveKeys', function(netId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        exports.qbx_vehiclekeys:GiveKeys(source, vehicle)
    end
end)

RegisterNetEvent('fz-rental:recoverVehicle', function(id)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    local cid = player.PlayerData.citizenid
    local vehicleEntity = NetworkGetEntityFromNetworkId(vehiclelist[cid].netid)
    if not DoesEntityExist(vehicleEntity) then
        if vehiclelist[cid] then
            local currentTime = os.time()
            if currentTime < vehiclelist[cid].expires then
                local vehicle = vehiclelist[cid]
                TriggerClientEvent('fz-rental:spawnRecoveredVehicle', source, id, vehicle.name, vehicle.model, vehicle.plate, vehicle.duration)
            else
                vehiclelist[cid] = nil
                TriggerClientEvent('fz-rental:notify', source, locale('error.rental_expired'), 'error')
            end
        end
    else
        TriggerClientEvent('fz-rental:notify', source, locale('error.vehicle_already_spawned'), 'error')
    end
end)