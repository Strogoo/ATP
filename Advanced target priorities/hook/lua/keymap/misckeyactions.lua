local originalSetWeaponPriorities = SetWeaponPriorities
local updatePrioState
local KeyMapper = import('/lua/keymap/keymapper.lua')
local PrioritySettings

function SetWeaponPriorities(prioritiesString, name, exclusive)
    originalSetWeaponPriorities(prioritiesString, name, exclusive)
    
    if updatePrioState then
        ForkThread(function() WaitSeconds(0.1) updatePrioState() WaitSeconds(0.1) updatePrioState() WaitSeconds(0.2) updatePrioState() end)
    else
        updatePrioState = import('/lua/ui/game/orders.lua').UpdatePrioState
        ForkThread(function() WaitSeconds(0.1) updatePrioState() WaitSeconds(0.1) updatePrioState() WaitSeconds(0.2) updatePrioState() end)
    end
end

function SetWeaponPrioritiesHotkey(name)
    if not PrioritySettings then
        PrioritySettings = import('/lua/ui/game/orders.lua').GetPrioritySettings()
    end    
    SetWeaponPriorities(PrioritySettings.priorityTables[name], name, PrioritySettings.exclusive[name]) 
end


--------HOTKEYS-----------

--Default
KeyMapper.SetUserKeyAction('Default', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Default")', category = 'Target priorities', order = 75})
KeyMapper.SetUserKeyAction('Shift_Default', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Default")', category = 'Target priorities', order = 76})

--ACU
KeyMapper.SetUserKeyAction('ACU', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("ACU")', category = 'Target priorities', order = 77})
KeyMapper.SetUserKeyAction('Shift_ACU', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("ACU")', category = 'Target priorities', order = 78})

--Power
KeyMapper.SetUserKeyAction('Power', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Power")', category = 'Target priorities', order = 79})
KeyMapper.SetUserKeyAction('Shift_Power', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Power")', category = 'Target priorities', order = 80})

--PD
KeyMapper.SetUserKeyAction('PD', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("PD")', category = 'Target priorities', order = 81})
KeyMapper.SetUserKeyAction('Shift_PD', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("PD")', category = 'Target priorities', order = 82})

--Units
KeyMapper.SetUserKeyAction('Units', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Units")', category = 'Target priorities', order = 83})
KeyMapper.SetUserKeyAction('Shift_Units', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Units")', category = 'Target priorities', order = 84})

--Shields
KeyMapper.SetUserKeyAction('Shields', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Shields")', category = 'Target priorities', order = 85})
KeyMapper.SetUserKeyAction('Shift_Shields', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Shields")', category = 'Target priorities', order = 86})

--EXP
KeyMapper.SetUserKeyAction('EXP', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("EXP")', category = 'Target priorities', order = 87})
KeyMapper.SetUserKeyAction('Shift_EXP', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("EXP")', category = 'Target priorities', order = 88})

--Engies
KeyMapper.SetUserKeyAction('Engies', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Engies")', category = 'Target priorities', order = 89})
KeyMapper.SetUserKeyAction('Shift_Engies', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Engies")', category = 'Target priorities', order = 90})

--Arty
KeyMapper.SetUserKeyAction('Arty', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Arty")', category = 'Target priorities', order = 91})
KeyMapper.SetUserKeyAction('Shift_Arty', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Arty")', category = 'Target priorities', order = 92})

--Fighters
KeyMapper.SetUserKeyAction('Fighters', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Fighters")', category = 'Target priorities', order = 93})
KeyMapper.SetUserKeyAction('Shift_Fighters', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Fighters")', category = 'Target priorities', order = 94})

--SMD
KeyMapper.SetUserKeyAction('SMD', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("SMD")', category = 'Target priorities', order = 95})
KeyMapper.SetUserKeyAction('Shift_SMD', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("SMD")', category = 'Target priorities', order = 96})

--Gunship
KeyMapper.SetUserKeyAction('Gunship', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Gunship")', category = 'Target priorities', order = 97})
KeyMapper.SetUserKeyAction('Shift_Gunship', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Gunship")', category = 'Target priorities', order = 98})

--Mex
KeyMapper.SetUserKeyAction('Mex', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Mex")', category = 'Target priorities', order = 99})
KeyMapper.SetUserKeyAction('Shift_Mex', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Mex")', category = 'Target priorities', order = 100})

--Snipe
KeyMapper.SetUserKeyAction('Snipe', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Snipe")', category = 'Target priorities', order = 101})
KeyMapper.SetUserKeyAction('Shift_Snipe', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Snipe")', category = 'Target priorities', order = 102})

--Naval
KeyMapper.SetUserKeyAction('target_Naval', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Naval")', category = 'Target priorities', order = 103})
KeyMapper.SetUserKeyAction('Shift_target_Naval', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Naval")', category = 'Target priorities', order = 104})

--Bships
KeyMapper.SetUserKeyAction('target_Bships', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Bships")', category = 'Target priorities', order = 105})
KeyMapper.SetUserKeyAction('Shift_target_Bships', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Bships")', category = 'Target priorities', order = 106})

--Destros
KeyMapper.SetUserKeyAction('target_Destros', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Destros")', category = 'Target priorities', order = 107})
KeyMapper.SetUserKeyAction('Shift_target_Destros', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").SetWeaponPrioritiesHotkey("Destros")', category = 'Target priorities', order = 108})