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
    local cid = player.PlayerData.citizenid
    local currentTime = os.time()
    if vehiclelist[cid] then
        if currentTime < vehiclelist[cid].expires then
            TriggerClientEvent('fz-rental:notify', source, locale('error.vehicle_already_rented'), 'error')
            return
        else
            vehiclelist[cid] = nil
        end
    end
    local balance = player.Functions.GetMoney(config.moneytype)
    local total_price = price * rentalduration
    if balance < total_price then
        if config.moneytype == 'cash' then
            TriggerClientEvent('fz-rental:notify', source, locale('error.not_enough_cash'), 'error')
        elseif config.moneytype == 'bank' then
            TriggerClientEvent('fz-rental:notify', source, locale('error.not_enough_money'), 'error')
        else
            TriggerClientEvent('fz-rental:notify', source, locale('error.invalid_money_type'), 'error')
        end
        return
    end
    player.Functions.RemoveMoney(config.moneytype, total_price, locale('info.remove_money') .. name)
    TriggerClientEvent('fz-rental:spawnVehicle', source, id, name, model, rentalduration)
end)

RegisterNetEvent('fz-rental:giveKeys', function(plate)
    local source = source
    TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
end)

RegisterNetEvent('fz-rental:recoverVehicle', function(id)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    local cid = player.PlayerData.citizenid
    if not vehiclelist[cid] then
        TriggerClientEvent('fz-rental:notify', source, locale('error.vehicle_not_found'), 'error')
        return
    end
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