lib.locale()



function ApplyBlindfold(data)
    if lib.progressCircle({
            duration = Config.ApplyDuration,
            label = locale('toggleBlindfold'),
            useWhileDead = false,
            useWhileCuffed = false,
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
    if lib.progressCircle({
            duration = Config.RemoveDuration,
            label = locale('RemoveBlindfold'),
            useWhileDead = false,
            useWhileCuffed = false,
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
