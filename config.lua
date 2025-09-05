Config = {}

Config.useBlips = true
Config.useTarget = true
Config.fuelSystem = 'cdn-fuel' -- 'ox_fuel' or 'LegacyFuel'
Config.keybind = 38 -- Default 'E'

Config.minRentTime = 1
Config.maxRentTime = 24
Config.moneytype = 'bank'

-- Default ped/blip settings
Config.defaults = {
    pedModel   = 'a_m_m_hasjew_01',
    scenario   = 'WORLD_HUMAN_CLIPBOARD',
    blip       = { sprite = 225, scale = 1.0, colour = 2, label = 'Rental Service' },
    zoneOptions = { length = 3.0, width = 3.0, debugPoly = false },
}

-- Rental locations (only unique coords/spawncoords matter)
Config.peds = {
    car_rental1 = { coords = vec4(-1031.13, -2735.50, 19.23, 64.95), spawncoords = vec4(-1031.30, -2731.70, 19.94, 239.97) },
    car_rental2 = { coords = vec4(156.77, -3006.02, 6.03, 270.07),   spawncoords = vec4(163.12, -3006.13, 5.80, 269.84) },
    car_rental3 = { coords = vec4(1238.38, -3105.04, 5.02, 272.18), spawncoords = vec4(1240.69, -3100.49, 5.74, 270.18) },
    car_rental4 = { coords = vec4(1080.54, -1972.13, 30.01, 328.06), spawncoords = vec4(1080.41, -1964.24, 30.88, 54.93) },
    car_rental5 = { coords = vec4(101.89, -1072.19, 28.21, 337.23),  spawncoords = vec4(104.62, -1077.73, 29.06, 340.23) },
    car_rental6 = { coords = vec4(-1618.02, -1013.48, 12.14, 317.74), spawncoords = vec4(-1270.67, -251.01, 42.31, 35.87) },
    car_rental7 = { coords = vec4(-1266.18, -251.86, 41.44, 36.52),   spawncoords = vec4(-1220.21, -194.63, 39.04, 151.87) },
    car_rental8 = { coords = vec4(882.29, 7.81, 77.90, 237.68),       spawncoords = vec4(877.97, 5.06, 78.63, 147.49) },
    car_rental9 = { coords = vec4(242.46, 197.22, 104.21, 168.21),   spawncoords = vec4(249.53, 191.91, 104.80, 69.27) },
    car_rental10 = { coords = vec4(-1324.02, -678.75, 25.51, 42.66), spawncoords = vec4(-1330.41, -676.15, 26.20, 304.67) },
}

-- Vehicle catalog (shared by all unless overridden)
Config.defaultVehicles = {
    {
        name = 'Adder', description = 'A fast sports car.',
        model = 'adder', price = 150, icon = 'car',
        image = 'nui://rental/web/images/adder.png',
    },
    {
        name = 'Sultan', description = 'A 4-door sedan.',
        model = 'sultan', price = 100, icon = 'car',
        image = 'nui://rental/web/images/sultan.png',
    },
    {
        name = 'Brawler', description = 'An off-road vehicle.',
        model = 'brawler', price = 125, icon = 'car',
        image = 'nui://rental/web/images/brawler.png',
    },
}

-- Vehicle overrides (if some locations have unique lists)
Config.vehicles = {
    car_rental1 = Config.defaultVehicles,
    car_rental2 = Config.defaultVehicles,
    car_rental3 = Config.defaultVehicles,
    car_rental4 = Config.defaultVehicles,
    car_rental5 = Config.defaultVehicles,
    car_rental6 = Config.defaultVehicles,
    car_rental7 = Config.defaultVehicles,
    car_rental8 = Config.defaultVehicles,
    car_rental9 = Config.defaultVehicles,
    car_rental10 = Config.defaultVehicles,
}
