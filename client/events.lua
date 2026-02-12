local IsBlindfolded = false


-- Net Events --

RegisterNetEvent('wz-blindfold:applyBlindfold', function()
    IsBlindfolded = true
    local ped = PlayerPedId()

    -- 1. Visuals
    SendNUIMessage({
        action  = 'show',
        color   = Config.blindfoldColor,
        opacity = Config.blindfoldOpacity,
        fade    = Config.fadeDuration
    })

    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)

    -- 2. Movement
    LoadClipSet(Config.Clipset)
    SetPedMovementClipset(ped, Config.Clipset, 1.0)

    -- 3. Prop (mask)
    SetBlindfoldMask(ped)
    lib.disableControls:Add({
        -- don't include 'move' so they can still walk/stumble
        combat = true,
        mouse = false,
        vehicle = true,
        disable = {
            44,                -- INPUT_COVER (Q)
            157, 158, 159, 160 -- Weapon Hotkeys 1-4
        }
    }, function()
        return IsBlindfolded -- The controls stay disabled as long as this is true
    end)
end)

RegisterNetEvent('wz-blindfold:removeBlindfold', function()
    IsBlindfolded = false
    local ped = PlayerPedId()

    -- 1. Visuals
    SendNUIMessage({ action = 'hide' })
    ClearTimecycleModifier()

    -- 2. Movement
    ResetPedMovementClipset(ped, 0)

    -- 3. Prop (mask)
    RestoreOriginalMask(ped)
end)


RegisterNetEvent('wz-blindfold:removeOwnBlindfold', function()
    if QBX.PlayerData.metadata.isDead then
        lib.notify({
            title = "Blindfold",
            description = locale('CantRemoveInLastStand'),
            type = "error",
            position = "top"
        })
        return
    end
    if QBX.PlayerData.metadata.ishandcuffed then
        lib.notify({
            title = "Blindfold",
            description = locale('CantRemoveHandcuffed'),
            type = "error",
            position = "top"
        })
        return
    end
    local success = lib.progressCircle({
        duration = 2000,
        label = locale('RemoveBlindfold'),
        useWhileDead = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
    })
    if success then
        lib.callback.await('blindfold:removeOwnBlindfold', false)
    else
        lib.notify({
            title = "Blindfold",
            description = locale('ActionCancelled'),
            type = "error",
            position = "top"
        })
    end
end)
