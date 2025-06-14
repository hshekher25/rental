Config = {}
Config.useBlips = true -- Show blips on the map.
Config.useTarget = true -- Use ox_target for interaction.
Config.keybind = 38 -- Control index for the TextUI. Default is 'E' (38) Change locals file for UI text. https://docs.fivem.net/docs/game-references/controls/#controls

Config.minRentTime = 1 -- Minimum rental time in hours.
Config.maxRentTime = 24 -- Maximum rental time in hours.

Config.moneytype = 'bank' -- Type of money used for transactions. Options: 'cash' or 'bank'.

Config.peds = {
    car_rental1 = {    -- Unique identifier.
        model = 'a_m_m_hasjew_01',  -- Model for the ped.
        coords = vec4(-1039.04, -2678.52, 12.83, 16.87),    -- Coordinates for the rental service ped.
        scenario = 'WORLD_HUMAN_CLIPBOARD', -- Animation scenario for the ped.
        spawncoords = vec4(-1044.4, -2674.19, 13.83, 318.26), -- Coords for spawning vehicles.
        blip = {
            sprite = 225, -- Icon for the blip. https://docs.fivem.net/docs/game-references/blips/
            scale = 1.0, -- Size of the blip.
            colour = 2, -- Color of the blip. https://docs.fivem.net/docs/game-references/blips/#blip-colors
            label = 'Rental Service',
        },
        zoneOptions = { -- Used when UseTarget is false.
            length = 3.0,
            width = 3.0,
            debugPoly = false,  -- Only used for debugging.
        },
    },
--[[car_rental2 = {    -- Unique identifier.
        model = 'a_m_m_hasjew_01',  -- Model for the ped.
        coords = vec4(-1029.1, -2661.23, 13.83, 127.25),    -- Coordinates for the rental service ped.
        scenario = 'WORLD_HUMAN_CLIPBOARD', -- Animation scenario for the ped.
        spawncoords = vec4(-1034.84, -2657.33, 13.83, 151.96), -- Coords for spawning vehicles.
        blip = {
            sprite = 225, -- Icon for the blip. https://docs.fivem.net/docs/game-references/blips/
            scale = 1.0, -- Size of the blip.
            colour = 2, -- Color of the blip. https://docs.fivem.net/docs/game-references/blips/#blip-colors
            label = 'Rental Service',
        },
        zoneOptions = { -- Used when UseTarget is false.
            length = 3.0,
            width = 3.0,
            debugPoly = false,  -- Only used for debugging.
        },
    }, ]]
}

Config.vehicles = {
    car_rental1 = {
        {
            name = 'Adder',
            description = 'A fast sports car.',
            model = 'adder',
            price = 150,
            icon = 'car',
        },
        {
            name = 'Sultan',
            description = 'A 4-door sedan.',
            model = 'sultan',
            price = 100,
            icon = 'car',
        },
        {
            name = 'Brawler',
            description = 'A off-road vehicle.',
            model = 'brawler',
            price = 125,
            icon = 'car',
        },
    },
--[[car_rental2 = {
        {
            name = 'Adder', -- Name of the vehicle displayed in the menu, notifications, rental papers, etc.
            description = 'A fast sports car.', -- Description of the vehicle displayed in the menu.
            model = 'brawler', -- Vehicle model/Spawn code.
            price = 400, -- Price to rent the vehicle.
            icon = 'car', -- Icon displayed in the ox_lib menu.
        },
        {
            name = 'Sultan', -- Name of the vehicle displayed in the menu, notifications, rental papers, etc.
            description = 'A 4-door sedan.', -- Description of the vehicle displayed in the menu.
            model = 'sultan', -- Vehicle model/Spawn code.
            price = 150, -- Price to rent the vehicle.
            icon = 'car', -- Icon displayed in the ox_lib menu.
        },
    } ]]
}