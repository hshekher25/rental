# fz-rental

![](https://img.shields.io/badge/FzStudio-Discord?logo=discord&logoColor=%23FFFFFF&labelColor=%235865F2&color=%23333333&link=https%3A%2F%2Fdiscord.gg%2Fyk5ean6rte)

fz-rental is a FiveM resource that allows players to rent vehicles in a smooth and sleek way.

## Features
- Easy installation.
- Easily add or remove available vehicles to rent.
- Changeble prices, names and descriptions of each vehicle.
- Rental papers item with metadata (name, plate, renter).
- Supports bank and cash payments.
- Supports ox_target and TextUI for interaction.

## Dependencies
- qbx_core
- qbx_vehiclekeys
- ox_inventory
- ox_lib

## Installation
1. Download the resource and place it in your `resources` directory.
2. Add `ensure fz-rental` to your `server.cfg` file.
3. Add the item into ox_inventory/data/items.lua

```lua
    ['rental_papers'] = {
        label = 'Rental Papers',
        weight = 50,
    },
```

4. Drag or copy the image in fz-rental/images/rental_papers.png to ox_inventory/web/images/
5. Done!

## Support
For any issues or suggestions join: [Discord](#fz-rental)