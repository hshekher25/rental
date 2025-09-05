# rental

[![Discord](https://img.shields.io/badge/Discord-%237289DA.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/yk5ean6rte)
[![YouTube](https://img.shields.io/badge/YouTube-%23FF0000.svg?style=for-the-badge&logo=YouTube&logoColor=white)](https://www.youtube.com/@official-fzstudio)

rental is a FiveM resource that allows players to rent vehicles in a smooth and sleek way.

## Features
- Easy installation.
- Easily editable local files to change text.
- Secure server sided events.
- Supports ox_target and TextUI for interaction.
- Easily add or remove available vehicles to rent.
- Images for each car in the menu.
- Supports multiple locations.
- Rental paper item with metadata (name, plate, renter and expiration date).
- Changeble prices, names and descriptions of each vehicle.
- Supports bank and cash payments.
- Rental price per hour.
- Changeble minimum and maximum rental time.
- Recover vehicle.

## Dependencies
- qbx_core
- qbx_vehiclekeys
- ox_inventory
- ox_lib

## Installation
1. Download the resource and place it in your `resources` directory.
2. Add `ensure rental` to your `server.cfg` file.
3. Add the item into ox_inventory/data/items.lua

```lua
    ['rental_papers'] = {
        label = 'Rental Papers',
        weight = 50,
    },
```

4. Drag or copy the image in rental/web/images/rental_papers.png to ox_inventory/web/images/
5. Done!

## Support
For any issues or suggestions join: [Discord](#rental)
