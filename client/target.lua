-- Uses Ox Target to add interaction options to players for applying/removing blindfolds. The server callbacks will check if the player has the item and update the blindfold state accordingly.
exports.ox_target:addGlobalPlayer({
    {
        label = locale('put_on_blindfold_target'),
        icon = "fa-solid fa-eye-slash",
        distance = Config.MaxDistanceToBlindfold,
        items = Config.BlindfoldItem,
        onSelect = function(data)
                ApplyBlindfold(data)
            end
    },
    {
        label = locale('remove_blindfold_target'),
        icon = "fa-solid fa-eye",
        distance = Config.MaxDistanceToBlindfold,
        onSelect = function(data)
                RemoveBlindfold(data)
            end
    }
})
