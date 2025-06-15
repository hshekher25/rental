# fz-rental

![](https://img.shields.io/badge/FzStudio-Discord?logo=discord&logoColor=%23FFFFFF&labelColor=%235865F2&color=%23333333&link=https%3A%2F%2Fdiscord.gg%2Fyk5ean6rte)
![](https://img.shields.io/badge/FzStudio-youtube?logo=youtube&logoColor=%23FFFFFF&labelColor=%23FF0000&color=grey&link=https%3A%2F%2Fwww.youtube.com%2Fchannel%2FUCRvcGXhc7HCiz7_6VJGjgkA)

fz-rental is a FiveM resource that allows players to rent vehicles in a smooth and sleek way.

## Features
- Easy installation.
- Easily editable local files to change text.
- Secure server sided events.
- Supports ox_target and TextUI for interaction.
- Easily add or remove available vehicles to rent.
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