local config = Config or {}

local spawnedPeds = {}
local spawnedBlips = {}

exports.ox_inventory:displayMetadata({
    name = locale('item_metadata.vehicle_name'),
    plate = locale('item_metadata.plate_number'),
    owner = locale('item_metadata.owner'),
    expires = locale('item_metadata.expires')
})

local function registerRentalMenu()
    lib.registerContext({
        id = 'rentalmenu',
        title = locale('rental_menu.title'),
        options = {
          {
            title = locale('rental_menu.subtitle_vehicles_for_rent'),
            description = locale('rental_menu.description_vehicles_for_rent'),
            menu = 'rentalvehicles',
            arrow = true,
            icon = 'car'
          },
         {
            title = locale('rental_menu.subtitle_recover_vehicle'),
            description = locale('rental_menu.description_recover_vehicle'),
            icon = 'car',
            onSelect = function()
                TriggerServerEvent('fz-rental:recoverVehicle')
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
end

local function registerVehicleMenu()
    local vehicleOptions = {}
    for _, vehicle in ipairs(config.vehicles) do
        table.insert(vehicleOptions, {
            title = vehicle.name,
            description = vehicle.description .. locale('currency.symbol') .. vehicle.price .. locale('vehicle_menu.per_hour'),
            icon = vehicle.icon,
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
                TriggerServerEvent('fz-rental:rentVehicle', vehicle.name, vehicle.model, vehicle.price, rentalDuration)
            end,
        })
    end

    lib.registerContext({
        id = 'rentalvehicles',
        title = locale('vehicle_menu.title'),
        options = vehicleOptions,
    })
end

RegisterNetEvent('fz-rental:notify', function(message, type)
    lib.notify({
        description = message,
        type = type,
        duration = 5000
    })
end)

RegisterNetEvent('fz-rental:spawnVehicle', function(name, model, rentalduration)
    local playerPed = PlayerPedId()
    local coords = config.peds[1].spawncoords
    local modelHash = GetHashKey(model)
    if not IsModelValid(modelHash) then
        lib.print.error('Invalid vehicle model: ' .. model)
        return
    end
    RequestModel(modelHash)
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w, true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    local plate = GetVehicleNumberPlateText(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local timeout = GetGameTimer() + 5000
    while not NetworkDoesEntityExistWithNetworkId(netId) do
        if GetGameTimer() > timeout then
            lib.print.error('Vehicle failed to register with server')
            return
        end
        Wait(50)
    end
    TriggerServerEvent('fz-rental:giveKeys', netId)
    TriggerServerEvent('fz-rental:giveRentalPapers', netId, name, model, plate, rentalduration)
end)

RegisterNetEvent('fz-rental:spawnRecoveredVehicle', function(name, model, plate, rentalduration)
    local playerPed = PlayerPedId()
    local coords = config.peds[1].spawncoords
    local modelHash = GetHashKey(model)
    if not IsModelValid(modelHash) then
        lib.print.error('Invalid vehicle model: ' .. model)
        return
    end
    RequestModel(modelHash)
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w, true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleNumberPlateText(vehicle, plate)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local timeout = GetGameTimer() + 5000
    while not NetworkDoesEntityExistWithNetworkId(netId) do
        if GetGameTimer() > timeout then
            lib.print.error('Vehicle failed to register with server')
            return
        end
        Wait(50)
    end
    TriggerServerEvent('fz-rental:giveKeys', netId)
    TriggerEvent('fz-rental:notify', locale('success.vehicle_recovered'), 'success')
end)

local function spawnPeds()
    for i, current in ipairs(config.peds) do
        RequestModel(current.model)
        local ped = CreatePed(0, current.model, current.coords.x, current.coords.y, current.coords.z, current.coords.w, false, false)
        SetModelAsNoLongerNeeded(current.model)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, current.scenario, 0, true)
        table.insert(spawnedPeds, ped)
        if config.useTarget then
            exports.ox_target:addLocalEntity(ped, {{
                name = 'open_rental' .. i,
                icon = 'fa-solid fa-car',
                label = locale('info.open_rental_target'),
                distance = 1.5,
                debug = false,
                onSelect = function()
                    lib.showContext('rentalmenu')
                end
            }})
        else
            local options = current.zoneOptions
            if options then
                lib.zones.box({
                    name = 'rental_zone_' .. i,
                    coords = current.coords.xyz,
                    size = vec3(2, 2, 3),
                    rotation = current.coords.w,
                    debug = options.debugPoly,
                    onEnter = function()
                        lib.showTextUI(locale('info.open_rental_textui'))
                    end,
                    onExit = function()
                        lib.hideTextUI()
                    end,
                    inside = function()
                        if IsControlJustPressed(0, config.keybind) then
                            lib.showContext('rentalmenu')
                            lib.hideTextUI()
                        end
                    end,
                })
            end
        end
    end
end

local function deletePeds()
    for _, ped in ipairs(spawnedPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end

local function spawnBlips()
    if config.useBlips then
        for _, pedData in ipairs(config.peds) do
            local blip = AddBlipForCoord(pedData.coords.x, pedData.coords.y, pedData.coords.z)
            SetBlipSprite(blip, pedData.blip and pedData.blip.sprite or 1)
            SetBlipDisplay(blip, pedData.blip and pedData.blip.display or 4)
            SetBlipScale(blip, pedData.blip and pedData.blip.scale or 1.0)
            SetBlipColour(blip, pedData.blip and pedData.blip.colour or 1)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(pedData.blip.label)
            EndTextCommandSetBlipName(blip)
            table.insert(spawnedBlips, blip)
        end
    end
end

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
    registerRentalMenu()
    registerVehicleMenu()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    spawnPeds()
    spawnBlips()
    registerRentalMenu()
    registerVehicleMenu()
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