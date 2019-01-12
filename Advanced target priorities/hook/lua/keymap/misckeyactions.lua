local originalSetWeaponPriorities = SetWeaponPriorities
local updatePrioState
local KeyMapper = import('/lua/keymap/keymapper.lua')

function SetWeaponPriorities(prioritiesString, name, exclusive)
    originalSetWeaponPriorities(prioritiesString, name, exclusive)
    
    if updatePrioState then
        ForkThread(function() WaitSeconds(0.1) updatePrioState() WaitSeconds(0.1) updatePrioState() end)
    else
        updatePrioState = import('/lua/ui/game/orders.lua').UpdatePrioState
        ForkThread(function() WaitSeconds(0.1) updatePrioState() WaitSeconds(0.1) updatePrioState() end)
    end
end

local PrioritySettings = {
    priorityTables = {
        ACU = "{categories.COMMAND}",
        Power = "{categories.ENERGYPRODUCTION * categories.STRUCTURE}",
        PD = "{categories.DEFENSE * categories.DIRECTFIRE * categories.STRUCTURE}",
        Units = "{categories.MOBILE - categories.COMMAND - categories.EXPERIMENTAL}",
        Shields = "{categories.SHIELD}",
        EXP = "{categories.EXPERIMENTAL}",
        Engies = "{categories.ENGINEER * categories.RECLAIMABLE}",
        Arty = "{categories.ARTILLERY}",
        Fighters = "{categories.AIR * categories.ANTIAIR - categories.EXPERIMENTAL}",
        SMD = "{categories.TECH3 * categories.STRUCTURE * categories.ANTIMISSILE}",
        Gunship = "{categories.AIR * categories.GROUNDATTACK}",
        Mex = "{categories.MASSEXTRACTION}",
        Snipe = "{categories.COMMAND, categories.STRATEGIC, categories.ANTIMISSILE * categories.TECH3, "..
            "categories.MASSEXTRACTION * categories.STRUCTURE * categories.TECH3, categories.MASSEXTRACTION * categories.STRUCTURE * categories.TECH2, "..
            "categories.ENERGYPRODUCTION * categories.STRUCTURE * categories.TECH3, categories.ENERGYPRODUCTION * categories.STRUCTURE * categories.TECH2, ".. 
            "categories.MASSFABRICATION * categories.STRUCTURE, categories.SHIELD,}",
    },
    exclusive = {ACU = false, Power = false, PD = false, Units = false, Shields = false, EXP = false, Engies = false,
                 Arty = false, Fighters = false, SMD = false, Gunship = false, Mex = false, Snipe = false},
}

function SetWeaponPrioritiesHotkey(name)
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