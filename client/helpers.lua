SavedMask = nil

-- Helper functions --

function LoadClipSet(clipset)
    RequestClipSet(clipset)
    while not HasClipSetLoaded(clipset) do Wait(10) end
end

function SetBlindfoldMask(ped)
    SavedMask = {
        drawable = GetPedDrawableVariation(ped, 1),
        texture  = GetPedTextureVariation(ped, 1),
        palette  = GetPedPaletteVariation(ped, 1)
    }
    local blindfoldId = Config.BlindfoldDrawableIndex or 35
    local blindfoldTexture = Config.BlindfoldTextureIndex or 0
    SetPedComponentVariation(ped, 1, blindfoldId, blindfoldTexture, 0)
end

function RestoreOriginalMask(ped)
    if SavedMask then
        SetPedComponentVariation(ped, 1, SavedMask.drawable, SavedMask.texture, SavedMask.palette)
        SavedMask = nil
    else
        SetPedComponentVariation(ped, 1, 0, 0, 0)
    end
end
