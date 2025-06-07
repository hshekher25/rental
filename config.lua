Config = {}
Config.useTarget = true -- Use ox_target for interaction.
Config.useBlips = true -- Show blips on the map.

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
        price = 500,
        icon = 'car',
    },
    {
        name = 'Obey Tailgater',
        description = 'A 4-door sedan.',
        model = 'tailgater',
        price = 300,
        icon = 'car',
    },
    {
        name = 'Brawler',
        description = 'A off-road vehicle.',
        model = 'brawler',
        price = 400,
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