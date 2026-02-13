lib.locale()

local BlindfoldStates = {}                       -- Table to track blindfold states of players on server side
local item = Config.BlindfoldItem or 'blindfold' -- Item name from config

function ServerNotify(target, title, key, type)
    TriggerClientEvent('wz-blindfold:Notify', target, title, key, type)
end

local function isTargetTooFar(src, targetSrc, maxDistance)
    maxDistance = maxDistance or 2.5

    local srcPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetSrc)

    if not DoesEntityExist(srcPed) or not DoesEntityExist(targetPed) then
        return true
    end

    local srcCoords = GetEntityCoords(srcPed)
    local targetCoords = GetEntityCoords(targetPed)

    return #(srcCoords - targetCoords) > maxDistance
end



lib.callback.register('blindfold:applyBlindfold', function(source, targetId) -- callback to apply blindfold to a player
    if not targetId or targetId == source then
        return false
    end
    if BlindfoldStates[targetId] then
        return false -- Target is already blindfolded
    end
    if isTargetTooFar(source, targetId) then
        return false -- Target is too far away, cannot apply blindfold
    end
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

lib.callback.register('blindfold:removeBlindfold', function(source, targetId) -- Callback to remove blindfold from a player
    if not targetId or targetId == source then
        return false
    end

    if not BlindfoldStates[targetId] then
        return false -- Target is not blindfolded
    end
    if isTargetTooFar(source, targetId) then
        return false -- Target is too far away, cannot remove blindfold
    end
        if BlindfoldStates[targetId] then
            BlindfoldStates[targetId] = nil
            exports.ox_inventory:AddItem(source, item, 1)
            TriggerClientEvent('wz-blindfold:removeBlindfold', targetId)
            return true
        else
            return false
        end
    end)

lib.callback.register('blindfold:removeOwnBlindfold', function(source) -- Callback for a player to remove their own blindfold
        if BlindfoldStates[source] then
            BlindfoldStates[source] = nil
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
    help = locale('admin_force_blindfold'),
    params = {
        { name = 'target', help = locale('admin_force_blindfold_help'), type = 'playerId' }
    },
    restricted = 'group.admin'
}, function(source, args)
    local targetId = args.target
    if targetId then
        if BlindfoldStates[targetId] then
            return ServerNotify(source, 'Admin', 'player_already_blindfolded', 'info')
        end
        BlindfoldStates[targetId] = true
        TriggerClientEvent('wz-blindfold:applyBlindfold', targetId)
        ServerNotify(source, 'Admin', 'player_blindfold_success', 'success')
    else
        ServerNotify(source, 'Admin', 'player_not_found', 'info')
    end
end)

lib.addCommand('forceunblindfold', {
    help = locale('admin_remove_blindfold'),
    params = {
        { name = 'target', help = locale('admin_remove_blindfold_help'), type = 'playerId' }
    },
    restricted = 'group.admin'
}, function(source, args)
    local targetId = args.target
    if targetId then
        if not BlindfoldStates[targetId] then
            ServerNotify(source, 'Admin', 'player_not_blindfolded', 'info')
            return
        end
        BlindfoldStates[targetId] = nil
        TriggerClientEvent('wz-blindfold:removeBlindfold', targetId)
        ServerNotify(source, 'Admin', 'player_blindfold_removed_success', 'success')
    else
        ServerNotify(source, 'Admin', 'player_not_found', 'info')
    end
end)

lib.addCommand('blindfoldstate', {
    help = locale('admin_check_blindfold_state'),
    params = {
        { name = 'target', help = locale('admin_check_blindfold_state_help'), type = 'playerId' }
    },
    restricted = 'group.admin'
}, function(source, args)
    local targetId = args.target
    if targetId then
        local stateKey = BlindfoldStates[targetId] and "state_blindfolded" or "state_not_blindfolded"
        ServerNotify(source, 'Admin', stateKey, 'info')
    else
        ServerNotify(source, 'Admin', 'player_not_found', 'info')
    end
end)

lib.addCommand('removeblindfold', {
    help = locale('remove_blindfold_command'),
}, function(source)
    if BlindfoldStates[source] then
        TriggerClientEvent('wz-blindfold:removeOwnBlindfold', source)
    else
        ServerNotify(source, 'Blindfold', 'self_is_not_blindfolded', 'info')
    end
end)


AddEventHandler('onResourceStop', function(resourceName) -- Clean up blindfold states when the resource stops
    if GetCurrentResourceName() == resourceName then
        for playerId, _ in pairs(BlindfoldStates) do
            TriggerClientEvent('wz-blindfold:removeBlindfold', playerId)
        end
        BlindfoldStates = {} -- Clear all states on resource stop
    end
end)


