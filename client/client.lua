lib.locale()


function ApplyBlindfold(data)
    -- 1. Pre-checks
    if QBX.PlayerData.metadata.isDead then
        return Notify('Blindfold', 'cant_apply_dead', 'error')
    end

    if QBX.PlayerData.metadata.ishandcuffed then
        return Notify('Blindfold', 'cant_apply_handcuffed', 'error')
    end

    -- 2. Progress Bar
    local completed = lib.progressCircle({
        duration = Config.ApplyDuration,
        label = locale('applying_blindfold'),
        useWhileDead = false,
        allowCuffed = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
    })

    if completed then
        -- 3. Server Validation
        local targetId = GetPlayerServerId(NetworkGetEntityOwner(data.entity))
        local success = lib.callback.await('blindfold:applyBlindfold', false, targetId)

        if success then
            Notify('Blindfold', 'player_blindfold_success', 'success')
        else
            Notify('Blindfold', 'no_blindfold_item', 'info')
        end
    else
        -- 4. User Cancelled
        Notify('Blindfold', 'action_cancelled', 'info')
    end
end

function RemoveBlindfold(data)
 if QBX.PlayerData.metadata.isDead then
    return Notify('Blindfold', 'cant_remove_dead', 'info')
end

if QBX.PlayerData.metadata.ishandcuffed then
    return Notify('Blindfold', 'cant_remove_handcuffed', 'info')
end
    if lib.progressCircle({
            duration = Config.RemoveDuration,
            label = locale('removing_blindfold'),
            useWhileDead = false,
            allowCuffed = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
        })
    then
        local success = lib.callback.await('blindfold:removeBlindfold', false,
            GetPlayerServerId(NetworkGetEntityOwner(data.entity)))
        if success then
            Notify('Blindfold', 'player_blindfold_removed_success', 'success')
        end
    else
        Notify('Blindfold', 'action_cancelled', 'info')
    end
end





AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    local ped = PlayerPedId()

    -- 1. Reset Visuals
    ClearTimecycleModifier() 
    TriggerScreenblurFadeOut(0) -- Ensures blur is gone instantly

    -- 2. Reset Movement
    ResetPedMovementClipset(ped, 0)
    SetPedIsDrunk(ped, false)

    -- 3. Reset Appearance
    SetPedComponentVariation(ped, 1, 0, 0, 2) 

    -- 4. Hide NUI
    SendNUIMessage({ action = 'hide' })
    
    lib.print.warn("Blindfold effects cleaned up due to resource stop.")
end)