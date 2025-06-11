Config = {}
Config.useBlips = true -- Show blips on the map.
Config.useTarget = true -- Use ox_target for interaction.
Config.keybind = 38 -- Control index for the TextUI. Default is 'E' (38) Change locals file for UI text. https://docs.fivem.net/docs/game-references/controls/#controls

Config.minRentTime = 1 -- Minimum rental time in hours.
Config.maxRentTime = 24 -- Maximum rental time in hours.

Config.moneytype = 'bank' -- Type of money used for transactions. Options: 'cash' or 'bank'.

Config.peds = {
    {
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
}

Config.vehicles = {
    {
        name = 'Adder',
        description = 'A fast sports car.',
        model = 'adder',
        price = 150,
        icon = 'car',
    },
    {
        name = 'Obey Tailgater',
        description = 'A 4-door sedan.',
        model = 'tailgater',
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
    -- {
    --     name = 'Adder', -- Name of the vehicle displayed in the menu, notifications, rental papers, etc.
    --     description = 'A rugged off-road vehicle.', -- Description of the vehicle displayed in the menu.
    --     model = 'brawler', -- Vehicle model/Spawn code.
    --     price = 400, -- Price to rent the vehicle.
    --     icon = 'car', -- Icon displayed in the ox_lib menu.
    -- },
}