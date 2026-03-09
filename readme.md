
# wz-blindfold
## A high-performance, modular blindfold system for Qbox

### wz-blindfold is a modern take on player restraint mechanics, built specifically for the Qbox ecosystem using OxLib for UI and state management. It features real-time visual overlays, movement restrictions, and seamless prop integration.

**Features**

- **Modular Design**: Cleanly separated logic for easy maintenance.

- **Immersive Visuals**: Customizable NUI overlay with timecycle blur effects.
- **State Bag Synchronization**: Efficiently tracks blindfold states across server and client.

- **Localization Ready**: Full support for multi-language servers via locales/*.json.

- **Admin Controls**: Dedicated commands for administrative oversight.

**Dependencies**
- qbx_core
- ox_lib
- ox_target
- ox_inventory


**Installation**
1. Ensure all dependencies are installed and started beforehand.
2. Add the blindfold item to your ``ox_inventory/data/items.lua``.
3. Add the blindfold.png photo to your ``ox_inventory/web/images``
4. Drop ``wz-blindfold`` into your resources folder.
5. Add ensure ``wz-blindfold`` to your ``server.cfg``.


### Usage Examples
* `ThirdEye:Blindfold` - Allows players to blind fold the target player as long as they have the blindfold item
* `ThirdEye:Remove Blindfold` ` Allows players to remove the blindfold from the target

* `/removeblindfold` - Allows players to remove their own blindfold as long as they're not dead or handcuffed
* `/forceblindfold 1` — Blindfolds the player with Server ID 1.
* `/forceunblindfold 1` — Removes the blindfold from player with Server ID 1.
* `/blindfoldstate 1` - Checks the blindfold state of the player with Server ID 1


**Configuration**
The script is configurable via ``config.lua``:

```lua
Config = {}

Config.MaxDistanceToBlindfold = 2.5           -- Max distance to apply/remove blindfold
Config.blindfoldColor = "#000000"             -- Hex color for blindfold overlay
Config.blindfoldOpacity = 0.85                -- 0.0 to 1.0
Config.fadeDuration = 1000                    -- in milliseconds

Config.RequireHandsUp = true -- Require players to have their hands up before they can be blindfolded

Config.ApplyDuration = 3000                   -- Time to apply (ms)
Config.RemoveDuration = 2000                  -- Time to remove (ms)

Config.blindfoldItem = 'blindfold'            -- Item name in ox_inventory
Config.BlurStrength = 1.0                     -- Timecycle blur intensity
Config.Clipset = "move_m@drunk@moderatedrunk" -- Movement style
Config.BlindfoldDrawableIndex = 69            -- Prop drawable ID
Config.BlindfoldTextureIndex = 0              -- Prop texture ID```
```


**Add this to ox_inventory/data/items.lua**

**Add the blindfold.png to ox_inventory/web/images**
```['blindfold'] = {
    label = 'Blindfold',
    weight = 100,
    stack = true,
    close = true,
    description = 'Old and worn bag that can be used to cover someone\'s eyes. Perfect for kidnappings, robberies, or just messing with your friends.',
    client = {
        image = 'blindfold.png',
    }
},
```


### Changes to 1.1
- Added the option for server owners to only let players blindfold players who have their hands up
- Fixed certain locales that were not working before
- Fixed state checks to stop players from adding blindfold multiple times

---
## ☕ Support My Work
If you find this script useful and would like to support my development journey, feel free to buy me a coffee!

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/whitezom)

---
