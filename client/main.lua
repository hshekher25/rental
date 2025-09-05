local config = Config or {}

local spawnedPeds = {}
local spawnedBlips = {}

exports.ox_inventory:displayMetadata({
    name = locale('item_metadata.vehicle_name'),
    plate = locale('item_metadata.plate_number'),
    owner = locale('item_metadata.owner'),
    expires = locale('item_metadata.expires')
})

local function openVehicleMenu(id)
    local vehicleOptions = {}
    local vehicles = config.vehicles[id] or {}
    for _, vehicle in ipairs(vehicles) do
        table.insert(vehicleOptions, {
            title = vehicle.name,
            description = vehicle.description .. locale('currency.symbol') .. vehicle.price .. locale('vehicle_menu.per_hour'),
            icon = vehicle.icon,
            image = vehicle.image,
            onSelect = function()
                local input = lib.inputDialog(locale('rental_time_menu.title'), {
                    {
                        type = 'slider',
                        label = locale('rental_time_menu.label'),
                        default = 1,
                        min = config.minRentTime,
                        max = config.maxRentTime,
                    }
                })
                if not input then return end
                local rentalDuration = tonumber(input[1])
                TriggerServerEvent('rental:rentVehicle', id, vehicle.name, vehicle.model, vehicle.price, rentalDuration)
            end,
        })
    end

    lib.registerContext({
        id = 'rentalvehicles' .. id,
        title = locale('vehicle_menu.title'),
        options = vehicleOptions,
    })
    lib.showContext('rentalvehicles' .. id)
end

local function openRentalMenu(id)
    lib.registerContext({
        id = 'rentalmenu' .. id,
        title = locale('rental_menu.title'),
        options = {
          {
            title = locale('rental_menu.subtitle_vehicles_for_rent'),
            description = locale('rental_menu.description_vehicles_for_rent'),
            arrow = true,
            icon = 'car',
            onSelect = function()
                openVehicleMenu(id)
            end,
          },
          {
            title = locale('rental_menu.subtitle_recover_vehicle'),
            description = locale('rental_menu.description_recover_vehicle'),
            icon = 'car',
            onSelect = function()
                TriggerServerEvent('rental:recoverVehicle', id)
            end,
          },
          {
            title = locale('rental_menu.subtitle_information'),
            description = locale('rental_menu.description_information'),
            metadata = {
                {label = locale('rental_menu.information_label'), value = locale('rental_menu.information')},
            },
            icon = 'book'
          },
        }
    })
    lib.showContext('rentalmenu' .. id)
end


RegisterNetEvent('rental:notify', function(message, type)
    lib.notify({
        description = message,
        type = type,
        duration = 5000
    })
end)

local function setFuelFull(vehicle)
    if not DoesEntityExist(vehicle) then
        lib.print.error('Vehicle does not exist')
        return
    end
 if Config.fuelSystem == 'ox_fuel' then
        Entity(vehicle).state.fuel = 100.0
    elseif Config.fuelSystem == 'LegacyFuel' then
        exports["LegacyFuel"]:SetFuel(vehicle, 100)
    elseif Config.fuelSystem == 'cdn-fuel' then
        -- cdn-fuel usually uses SetFuel(vehicle, value)
        exports['cdn-fuel']:SetFuel(vehicle, 100.0)
    else
        lib.print.error('Invalid fuel system, supports only ox_fuel, LegacyFuel, or cdn-fuel')
        return
    end
end

RegisterNetEvent('rental:spawnVehicle', function(id, name, model, rentalduration)
    local pedId = config.peds[id]
    local playerPed = PlayerPedId()
    local coords = pedId.spawncoords
    local modelHash = GetHashKey(model)
    if not IsModelValid(modelHash) then
        lib.print.error('Invalid vehicle model: ' .. model)
        return
    end
    RequestModel(modelHash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() > timeout then
            lib.print.error('Failed to load vehicle model')
            return
        end
        Wait(50)
    end
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w, true, false)
    setFuelFull(vehicle)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    local plate = GetVehicleNumberPlateText(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    while not NetworkDoesEntityExistWithNetworkId(netId) do
        if GetGameTimer() > timeout then
            lib.print.error('Vehicle failed to register with server')
            return
        end
        Wait(50)
    end
    TriggerServerEvent('rental:giveKeys', plate)
    TriggerServerEvent('rental:giveRentalPapers', netId, name, model, plate, rentalduration)
end)

RegisterNetEvent('rental:spawnRecoveredVehicle', function(id, name, model, plate, rentalduration)
    local pedId = config.peds[id]
    local playerPed = PlayerPedId()
    local coords = pedId.spawncoords
    local modelHash = GetHashKey(model)
    if not IsModelValid(modelHash) then
        lib.print.error('Invalid vehicle model: ' .. model)
        return
    end
    RequestModel(modelHash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() > timeout then
            lib.print.error('Failed to load vehicle model')
            return
        end
        Wait(50)
    end
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w, true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleNumberPlateText(vehicle, plate)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    while not NetworkDoesEntityExistWithNetworkId(netId) do
        if GetGameTimer() > timeout then
            lib.print.error('Vehicle failed to register with server')
            return
        end
        Wait(50)
    end
    TriggerServerEvent('rental:giveKeys', plate)
    TriggerEvent('rental:notify', locale('success.vehicle_recovered'), 'success')
end)


local function spawnPeds()
    for id, current in pairs(Config.peds) do
        local pedModel   = current.model   or Config.defaults.pedModel
        local scenario   = current.scenario or Config.defaults.scenario
        local blipData   = current.blip    or Config.defaults.blip
        local zoneOptions= current.zoneOptions or Config.defaults.zoneOptions

        local modelHash = GetHashKey(pedModel)
        if not IsModelValid(modelHash) then
            lib.print.error('Invalid ped model: ' .. tostring(pedModel))
            goto continue
        end

        RequestModel(modelHash)
        local timeout = GetGameTimer() + 5000
        while not HasModelLoaded(modelHash) do
            if GetGameTimer() > timeout then
                lib.print.error('Failed to load ped model: ' .. pedModel)
                goto continue
            end
            Wait(50)
        end

        local ped = CreatePed(0, modelHash, current.coords.x, current.coords.y, current.coords.z, current.coords.w, false, false)
        SetModelAsNoLongerNeeded(modelHash)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, scenario, 0, true)
        table.insert(spawnedPeds, ped)

        -- ox_target or zone interaction
        if Config.useTarget then
            exports.ox_target:addLocalEntity(ped, {{
                name = 'open_rental' .. id,
                icon = 'fa-solid fa-car',
                label = locale('info.open_rental_target'),
                distance = 1.5,
                debug = false,
                onSelect = function()
                    openRentalMenu(id)
                end
            }})
        elseif zoneOptions then
            lib.zones.box({
                name = 'rental_zone_' .. id,
                coords = current.coords.xyz,
                size = vec3(zoneOptions.length, zoneOptions.width, 3),
                rotation = current.coords.w,
                debug = zoneOptions.debugPoly,
                onEnter = function()
                    lib.showTextUI(locale('info.open_rental_textui'))
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                inside = function()
                    if IsControlJustPressed(0, Config.keybind) then
                        openRentalMenu(id)
                        lib.hideTextUI()
                    end
                end,
            })
        end

        ::continue::
    end
end

local function spawnBlips()
    if Config.useBlips then
        for _, pedData in pairs(Config.peds) do
            local blipData = pedData.blip or Config.defaults.blip
            local blip = AddBlipForCoord(pedData.coords.x, pedData.coords.y, pedData.coords.z)
            SetBlipSprite(blip, blipData.sprite)
            SetBlipDisplay(blip, blipData.display or 4)
            SetBlipScale(blip, blipData.scale)
            SetBlipColour(blip, blipData.colour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipData.label)
            EndTextCommandSetBlipName(blip)
            table.insert(spawnedBlips, blip)
        end
    end
end


-- local function spawnPeds()
--     for id, current in pairs(config.peds) do
--         RequestModel(current.model)
--         local timeout = GetGameTimer() + 5000
--         while not HasModelLoaded(current.model) do
--             if GetGameTimer() > timeout then
--                 lib.print.error('Failed to load ped model')
--                 return
--             end
--             Wait(50)
--         end
--         local ped = CreatePed(0, current.model, current.coords.x, current.coords.y, current.coords.z, current.coords.w, false, false)
--         SetModelAsNoLongerNeeded(current.model)
--         FreezeEntityPosition(ped, true)
--         SetEntityInvincible(ped, true)
--         SetBlockingOfNonTemporaryEvents(ped, true)
--         TaskStartScenarioInPlace(ped, current.scenario, 0, true)
--         table.insert(spawnedPeds, ped)
--         if config.useTarget then
--             exports.ox_target:addLocalEntity(ped, {{
--                 name = 'open_rental' .. id,
--                 icon = 'fa-solid fa-car',
--                 label = locale('info.open_rental_target'),
--                 distance = 1.5,
--                 debug = false,
--                 onSelect = function()
--                     openRentalMenu(id)
--                 end
--             }})
--         else
--             local options = current.zoneOptions
--             if options then
--                 lib.zones.box({
--                     name = 'rental_zone_' .. id,
--                     coords = current.coords.xyz,
--                     size = vec3(2, 2, 3),
--                     rotation = current.coords.w,
--                     debug = options.debugPoly,
--                     onEnter = function()
--                         lib.showTextUI(locale('info.open_rental_textui'))
--                     end,
--                     onExit = function()
--                         lib.hideTextUI()
--                     end,
--                     inside = function()
--                         if IsControlJustPressed(0, config.keybind) then
--                             openRentalMenu(id)
--                             lib.hideTextUI()
--                         end
--                     end,
--                 })
--             end
--         end
--     end
-- end

local function deletePeds()
    for _, ped in ipairs(spawnedPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end

-- local function spawnBlips()
--     if config.useBlips then
--         for _, pedData in pairs(config.peds) do
--             local blip = AddBlipForCoord(pedData.coords.x, pedData.coords.y, pedData.coords.z)
--             SetBlipSprite(blip, pedData.blip and pedData.blip.sprite or 1)
--             SetBlipDisplay(blip, pedData.blip and pedData.blip.display or 4)
--             SetBlipScale(blip, pedData.blip and pedData.blip.scale or 1.0)
--             SetBlipColour(blip, pedData.blip and pedData.blip.colour or 1)
--             SetBlipAsShortRange(blip, true)
--             BeginTextCommandSetBlipName('STRING')
--             AddTextComponentString(pedData.blip.label)
--             EndTextCommandSetBlipName(blip)
--             table.insert(spawnedBlips, blip)
--         end
--     end
-- end

local function deleteBlips()
    for _, blip in ipairs(spawnedBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    spawnPeds()
    spawnBlips()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    spawnPeds()
    spawnBlips()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    deleteBlips()
    deletePeds()
    lib.closeInputDialog()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deletePeds()
    deleteBlips()
    lib.closeInputDialog()
end)