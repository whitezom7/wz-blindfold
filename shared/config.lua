Config = {}

Config.MaxDistanceToBlindfold = 2.5           -- Max distance to apply/remove blindfold
Config.blindfoldColor = "#000000"             -- Hex color for blindfold overlay
Config.blindfoldOpacity = 0.85                -- 0.0 to 1.0
Config.fadeDuration = 1000 -- in milliseconds

Config.RequireHandsUp = true -- Require players to have their hands up before they can be blindfolded

Config.ApplyDuration = 3000                   -- Time to apply blindfold (ms)
Config.RemoveDuration = 2000                  -- Time to remove blindfold (ms)

Config.blindfoldItem = 'blindfold'                                   -- Name of the item in ox_inventory/ Change if you want to use a different item

Config.BlurStrength = 1.0                     -- timecycle blur
Config.Clipset = "move_m@drunk@moderatedrunk" -- movement clipset
Config.BlindfoldDrawableIndex = 69            -- Prop index for blindfold (https://docs.fivem.net/docs/game-references/ped-models/prop-index/)
Config.BlindfoldTextureIndex = 0              -- Texture index for blindfold prop
