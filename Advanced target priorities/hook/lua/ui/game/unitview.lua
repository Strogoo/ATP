local oldUpdateWindow = UpdateWindow
local hideAbilities = Prefs.GetFromCurrentProfile("AdvancedPriotities").hideAbilities or false

function UpdateWindow(info)
    oldUpdateWindow(info)
    if hideAbilities then
        controls.abilities:Hide()
    end
end

function UpdateAbilitiesSettings()
    hideAbilities = Prefs.GetFromCurrentProfile("AdvancedPriotities").hideAbilities or false
end