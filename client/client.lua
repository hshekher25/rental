local config = Config or {}

local spawnedPeds = {}
local spawnedBlips = {}

exports.ox_inventory:displayMetadata({
    name = 'Vehicle',
    plate = 'Plate',
    owner = 'Renter'
})

local function registerRentalMenu()
    lib.registerContext({
        id = 'rentalmenu',
        title = 'Rental Service',
        options = {
          {
            title = 'Vehicles for Rent',
            description = 'Browse available vehicles for rent',
            menu = 'rentalvehicles',
            arrow = true,
            icon = 'car'
          },
          {
            title = 'Information',
            description = 'Hover over to view',
            metadata = {
                {label = 'Information', value = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas cursus sem in massa hendrerit gravida. Aliquam feugiat, lorem id imperdiet. '},
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
            description = vehicle.description .. ' ($' .. vehicle.price .. ')',
            icon = vehicle.icon,
            onSelect = function()
                TriggerServerEvent('fz-rental:rentVehicle', vehicle.name, vehicle.model, vehicle.price)
            end,
        })
    end

    lib.registerContext({
        id = 'rentalvehicles',
        title = 'Available Vehicles',
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

RegisterNetEvent('fz-rental:spawnVehicle', function(name, model)
    local playerPed = PlayerPedId()
    local coords = config.peds[1].spawncoords
    local modelHash = GetHashKey(model)
    if not IsModelValid(modelHash) then
        lib.print.error('Invalid vehicle model: ' .. model)
        return
    end
    lib.RequestModel(modelHash)
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
    TriggerServerEvent('fz-rental:giveRentalPapers', name, model, plate)
end)

local function spawnPeds()
    for i, current in ipairs(config.peds) do
        lib.RequestModel(current.model)
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
                label = 'Open Rental Service',
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
                        lib.showTextUI('Press E to open Rental Service')
                    end,
                    onExit = function()
                        lib.hideTextUI()
                    end,
                    inside = function()
                        if IsControlJustPressed(0, 38) then
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
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deletePeds()
    deleteBlips()
end)