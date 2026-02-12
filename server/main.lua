lib.locale()

local BlindfoldStates = {}                       -- Table to track blindfold states of players on server side
local item = Config.BlindfoldItem or 'blindfold' -- Item name from config


lib.callback.register('blindfold:applyBlindfold', function(source, targetId) -- callback to apply blindfold to a player
    
    local hasItem = exports.ox_inventory:Search(source, 'count', item) > 0
    if hasItem then
        exports.ox_inventory:RemoveItem(source, item, 1)
        BlindfoldStates[targetId] = true
        TriggerClientEvent('wz-blindfold:applyBlindfold', targetId)
        return true
    else
        return false
    end
end)

lib.callback.register('blindfold:removeBlindfold',
    function(source, targetId) -- Callback to remove blindfold from a player
        if BlindfoldStates[targetId] then
            BlindfoldStates[targetId] = false
            exports.ox_inventory:AddItem(source, item, 1)
            TriggerClientEvent('wz-blindfold:removeBlindfold', targetId)
            return true
        else
            return false
        end
    end)

lib.callback.register('blindfold:removeOwnBlindfold',
    function(source) -- Callback for a player to remove their own blindfold
        if BlindfoldStates[source] then
            BlindfoldStates[source] = false
            exports.ox_inventory:AddItem(source, item, 1)
            TriggerClientEvent('wz-blindfold:removeBlindfold', source)
            return true
        else
            return false
        end
    end)

AddEventHandler('playerDropped', function() -- Event handler to clean up blindfold state when a player leaves
    local src = source
    if BlindfoldStates[src] then
        BlindfoldStates[src] = nil -- Clean up state when a player leaves
    end
end)                               -- Can be used to reapply blindfolds if a player disconnects while blindfolded and then reconnects in the future

lib.callback.register('blindfold:getBlindfoldState',
    function(source, targetId) -- This callback can be used by the client to check if a player is blindfolded
        local id = targetId or source
        return BlindfoldStates[id] or false
    end)

-- Admin commands

lib.addCommand('forceblindfold', {
    help = locale('AdminForceBlindfold'),
    params = {
        { name = 'target', help = locale('AdminForceBlindFoldHelp'), type = 'playerId' }
    },
    restricted = 'group.admin'
}, function(source, args)
    local targetId = args.target
    if targetId then
        if BlindfoldStates[targetId] then
            lib.notify(source, {
                title = "Blindfold",
                description = locale('PlayerAlreadyBlindfolded'),
                type = "error",
                position = "top"
            })
            return
        end
        BlindfoldStates[targetId] = true
        TriggerClientEvent('wz-blindfold:applyBlindfold', targetId)
        lib.notify(source, {
            title = "Blindfold",
            description = locale('PlayerBlindfolded'),
            type = "success",
            position = "top"
        })
    else
        lib.notify(source, {
            title = "Blindfold",
            description = locale('PlayerNotFound'),
            type = "error",
            position = "top"
        })
    end
end)

lib.addCommand('forceunblindfold', {
    help = locale('AdminRemoveBlindfold'),
    params = {
        { name = 'target', help = locale('AdminRemoveBlindfoldHelp'), type = 'playerId' }
    },
    restricted = 'group.admin'
}, function(source, args)
    local targetId = args.target
    if targetId then
        if not BlindfoldStates[targetId] then
            lib.notify(source, {
                title = "Blindfold",
                description = locale('PlayerNotBlindfolded'),
                type = "error",
                position = "top"
            })
            return
        end
        BlindfoldStates[targetId] = false
        TriggerClientEvent('wz-blindfold:removeBlindfold', targetId)
        lib.notify(source, {
            title = "Blindfold",
            description = locale('PlayerBlindfoldRemoved'),
            type = "success",
            position = "top"
        })
    else
        lib.notify(source, {
            title = "Blindfold",
            description = locale('PlayerNotFound'),
            type = "error",
            position = "top"
        })
    end
end)

lib.addCommand('blindfoldstate', {
    help = locale('AdminCheckBlindfoldState'),
    params = {
        { name = 'target', help = locale('AdminCheckBlindfoldStateHelp'), type = 'playerId' }
    },
    restricted = 'group.admin'
}, function(source, args)
    local targetId = args.target
    if targetId then
        local state = BlindfoldStates[targetId] and "blindfolded" or "not blindfolded"
        lib.notify(source, {
            title = "Blindfold State",
            description = locale('PlayerState', state),
            type = "info",
            position = "top"
        })
    else
        lib.notify(source, {
            title = "Blindfold State",
            description = locale('PlayerNotFound'),
            type = "error",
            position = "top"
        })
    end
end)

lib.addCommand('removeblindfold', {
    help = 'Remove your own blindfold',
}, function(source)
    if BlindfoldStates[source] then
        TriggerClientEvent('wz-blindfold:removeOwnBlindfold', source)
    else
        lib.notify(source, {
            description = locale('NoSelfBlindfold'),
            type = "error"
        })
    end
end)
