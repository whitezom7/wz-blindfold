lib.locale()


function ApplyBlindfold(data)
 if QBX.PlayerData.metadata.isDead then
    lib.notify({
        title = "Blindfold",
        description = locale('CannotApplyDead'),
        type = "error",
        position = "top"
    }) return
end
if QBX.PlayerData.metadata.ishandcuffed then
    lib.notify({
        title = "Blindfold",
        description = locale('CantApplyHandcuffed'),
        type = "error",
        position = "top"
    }) return
end

    if lib.progressCircle({
            duration = Config.ApplyDuration,
            label = locale('toggleBlindfold'),
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
        local success = lib.callback.await('blindfold:applyBlindfold', false,
            GetPlayerServerId(NetworkGetEntityOwner(data.entity)))
        if success then
            lib.notify({
                title = "Blindfold",
                description = locale('SuccessfulBlindfold'),
                type = "success",
                position = "top"
            })
        else -- Should never really hit this case since the item check is done in the server callback, but just in case
            lib.notify({
                title = "Blindfold",
                description = locale('NoBlindfold'),
                type = "error",
                position = "top"
            })
        end
    else
        lib.notify({
            title = "Blindfold",
            description = locale('ActionCancelled'),
            type = "error",
            position = "top"
        })
    end
end

function RemoveBlindfold(data)
 if QBX.PlayerData.metadata.isDead then
    lib.notify({
        title = "Blindfold",
        description = locale('CannotRemoveDead'),
        type = "error",
        position = "top"
    }) return
end
if QBX.PlayerData.metadata.ishandcuffed then
    lib.notify({
        title = "Blindfold",
        description = locale('CantRemoveHandcuffed'),
        type = "error",
        position = "top"
    }) return
end
    if lib.progressCircle({
            duration = Config.RemoveDuration,
            label = locale('RemoveBlindfold'),
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
            lib.notify({
                title = "Blindfold",
                description = locale('SuccessfulRemove'),
                type = "success",
                position = "top"
            })
        end
    else
        lib.notify({
            title = "Blindfold",
            description = locale('ActionCancelled'),
            type = "error",
            position = "top"
        })
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