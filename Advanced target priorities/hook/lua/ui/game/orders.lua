local textures = '/mods/Advanced target priorities/textures/'
local originalIsToggleMode = IsToggleMode
local originalUpdateToggleIcon = UpdateToggleIcon
local actualUnitList
local separateWindow = false

local currentPreset = "Default"

local PrioritySettings = {
    category = {},
    priorityTables = {
        ACU = "{categories.COMMAND}",
        Power = "{categories.ENERGYPRODUCTION * categories.STRUCTURE}",
        PD = "{categories.DEFENSE * categories.DIRECTFIRE * categories.STRUCTURE}",
        Units = "{categories.MOBILE - categories.COMMAND - categories.EXPERIMENTAL - categories.ENGINEER}",
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
        Naval = "{categories.MOBILE * categories.NAVAL * categories.TECH3, categories.MOBILE * categories.NAVAL * categories.TECH2, categories.MOBILE * categories.NAVAL * categories.TECH1}",
        Bships = "{categories.BATTLESHIP}",
        Destros = "{categories.DESTROYER}",
        Cruiser = "{categories.CRUISER}",
        SACU = "{categories.SUBCOMMANDER}",
        Factory = "{categories.TECH3 * categories.STRUCTURE * categories.FACTORY, categories.TECH2 * categories.STRUCTURE * categories.FACTORY, categories.TECH1 * categories.STRUCTURE * categories.FACTORY}",
    },
    exclusive = {ACU = false, Power = false, PD = false, Units = false, Shields = false, EXP = false, Engies = false,
                 Arty = false, Fighters = false, SMD = false, Gunship = false, Mex = false, Snipe = false},
    buttonLayout = {
        {"ACU", "Units", "PD", "Engies", "Shields", "EXP"}, --first column. bottom --> top
        {"Mex", "Power", "SMD", "Arty", "Gunship", "Fighters"}, --second column. bottom --> top
        {"Factory", "SACU", "Cruiser", "Destros", "Bships", "Naval"}, --third column. bottom --> top
        },
}

local prioStateTextures = {
    Default = textures..'default.dds',
    ACU = textures..'ACU.dds',
    Power = textures..'power.dds',
    PD = textures..'PD.dds',
    Units = textures..'units.dds',
    Shields = textures..'shields.dds',
    EXP = textures..'EXP.dds',
    Engies = textures..'engies.dds',
    Arty = textures..'arty.dds',
    Fighters = textures..'fighters.dds',
    SMD = textures..'SMD.dds',
    Gunship = textures..'gunship.dds',
    Mex = textures..'mex.dds',
    Snipe = textures..'snipe.dds',
    Mixed = textures..'mixed.dds',
    Empty = textures..'smallBlack.dds',
    Factory = textures..'Factory.dds',
    SACU = textures..'SACU.dds',
    Cruiser = textures..'Cruiser.dds',
    Destros = textures..'Destros.dds',
    Bships = textures..'Bships.dds',
    Naval = textures..'Naval.dds',
}

function UpdateToggleIcon(control)
    UpdatePrioState(control)
   
    originalUpdateToggleIcon(control)
end

function CheckForMixedPriorities(units)
    local name
    
    for key, unit in units do
        if not name then
            name = UnitData[unit:GetEntityId()].WepPriority or "Default"
        else
            local preset = UnitData[unit:GetEntityId()].WepPriority or "Default"
            
            if name ~= preset then
                return "Mixed"
            end    
        end
    end
    
    return name
end

function UpdatePrioState()
    local units = currentSelection
    local control = controls.bg   

    if not control.prioState then
        control.prioState = Bitmap(control, UIUtil.UIFile(textures..'smallBlack.dds'))
        LayoutHelpers.AtRightTopIn(control.prioState, control, 25, 15)
        control.prioState.Depth:Set(100)
        control.prioState:DisableHitTest()
    end
    
    if units[1] then
        local priority = CheckForMixedPriorities(units)
        currentPreset = priority
        
        if prioStateTextures[priority] then
            if control.prioState.textBitmap then
                control.prioState.textBitmap:Destroy()
                control.prioState.textBitmap = nil
            end    
                
            control.prioState:SetTexture(UIUtil.UIFile(prioStateTextures[priority]))
        else 
            --using CreateText for presets without texture
            control.prioState:SetTexture(UIUtil.UIFile(textures..'smallBlack.dds'))
            
            if control.prioState.textBitmap then
                control.prioState.textBitmap:Destroy()
                control.prioState.textBitmap = nil
            end
            
            control.prioState.textBitmap = Bitmap(control.prioState, UIUtil.UIFile(textures..'smallBlack.dds'))
            LayoutHelpers.AtRightTopIn(control.prioState.textBitmap, control.prioState, 0, 0)
            
            control.prioState.textBitmap.text = UIUtil.CreateText(control.prioState.textBitmap, priority, 10, 'Arial')
            control.prioState.textBitmap.text:SetColor("White")
            LayoutHelpers.AtCenterIn(control.prioState.textBitmap.text, control.prioState)
        end
    end
end

function CreatePrioBorder(parent)
    local prioBorder = {}
    
    prioBorder.topleft = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_ul.dds'))
    prioBorder.bottomleft = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_ll.dds'))
    prioBorder.topright = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_ur.dds'))
    prioBorder.bottomright = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_lr.dds'))
    
    prioBorder.topmid = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_horz_um.dds'))
    prioBorder.bottommid = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_lm.dds'))
    
    prioBorder.midleft = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_vert_l.dds'))
    prioBorder.midright = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_vert_r.dds'))
    
    prioBorder.back = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_m.dds'))
    
    
    local x = 56 --topleft relative coordinates
    local y = -18
    
    local width = 210
    local height = 155

    --corners
    LayoutHelpers.AtLeftTopIn(prioBorder.topleft, parent, x, y)
    LayoutHelpers.AtLeftTopIn(prioBorder.bottomleft, prioBorder.topleft, 0, height)
    
    LayoutHelpers.AtLeftTopIn(prioBorder.topright, prioBorder.topleft, width, 0)
    LayoutHelpers.AtLeftTopIn(prioBorder.bottomright, prioBorder.topleft, width, height)
    
    
    --mid
    LayoutHelpers.AtLeftTopIn(prioBorder.topmid, prioBorder.topleft, 18, 0)
    prioBorder.topmid.Width:Set(width - 18)
    
    LayoutHelpers.AtLeftTopIn(prioBorder.bottommid, prioBorder.topleft, 18, height)
    prioBorder.bottommid.Width:Set(width - 18)
    
    LayoutHelpers.AtLeftTopIn(prioBorder.midleft, prioBorder.topleft, 0, 18)
    prioBorder.midleft.Height:Set(height - 18)
    
    LayoutHelpers.AtLeftTopIn(prioBorder.midright, prioBorder.topleft, width, 18)
    prioBorder.midright.Height:Set(height - 18)
 
    --background
    LayoutHelpers.AtLeftTopIn(prioBorder.back, prioBorder.topleft, 18 , 18)
    prioBorder.back.Width:Set(width - 18)
    prioBorder.back.Height:Set(height - 18)
    
    return prioBorder
end

function CreatePrioButtons(parent)
    local buttons = {{},{},{}}
    local active = false
    
    local function CreateButton(prioTable, name, exclusive)
        local btn = Checkbox(parent)
      
        btn.Width:Set(70)
        btn.Height:Set(20)
    
        if not active and name == currentPreset then
            btn:SetNewTextures(
            UIUtil.UIFile(textures..'Button1active.dds'),
            UIUtil.UIFile(textures..'Button1active.dds'),
            UIUtil.UIFile(textures..'Button2.dds'),
            UIUtil.UIFile(textures..'Button2.dds')
            )
            
            active = true
        else
            btn:SetNewTextures(
            UIUtil.UIFile(textures..'Button1.dds'),
            UIUtil.UIFile(textures..'Button1.dds'),
            UIUtil.UIFile(textures..'Button2.dds'),
            UIUtil.UIFile(textures..'Button2.dds')
            )
        end
        
        if name then 
            btn.OnCheck = function(control, checked)
                SetWeaponPriorities(prioTable, name, exclusive)
            end
            
            LayoutHelpers.AtLeftTopIn(UIUtil.CreateText(parent, name, 14, UIUtil.bodyFont), btn, 10, 0)  
        else -- empty button
            btn:DisableHitTest()
        end   
        
        return btn
    end
    
    
    --"Default" button
    buttons.default = Checkbox(parent)
    
    buttons.default.Width:Set(70)
    buttons.default.Height:Set(30)
    
    if currentPreset == "Default" then
        buttons.default:SetNewTextures(
            UIUtil.UIFile(textures..'Button1active.dds'),
            UIUtil.UIFile(textures..'Button1active.dds'),
            UIUtil.UIFile(textures..'Button2big.dds'),
            UIUtil.UIFile(textures..'Button2big.dds')
        )
        
        active = true
    else
        buttons.default:SetNewTextures(
            UIUtil.UIFile(textures..'Button1.dds'),
            UIUtil.UIFile(textures..'Button1.dds'),
            UIUtil.UIFile(textures..'Button2big.dds'),
            UIUtil.UIFile(textures..'Button2big.dds')
        )
    end    
    
    LayoutHelpers.AtLeftTopIn(buttons.default, parent, 65, 117)
    buttons.default.OnCheck = function(control, checked)
        SetWeaponPriorities(0, "Default")
    end
    LayoutHelpers.AtCenterIn(UIUtil.CreateText(parent, "Default", 18, UIUtil.bodyFont), buttons.default)
    
    
    --"Snipe" button
    buttons.snipe = Checkbox(parent)
    
    buttons.snipe.Width:Set(70)
    buttons.snipe.Height:Set(30)
    
    if not active and currentPreset == "Snipe" then
        buttons.snipe:SetNewTextures(
            UIUtil.UIFile(textures..'Button1active.dds'),
            UIUtil.UIFile(textures..'Button1active.dds'),
            UIUtil.UIFile(textures..'Button2big.dds'),
            UIUtil.UIFile(textures..'Button2big.dds')
        )
        
        active = true
    else
        buttons.snipe:SetNewTextures(
            UIUtil.UIFile(textures..'Button1.dds'),
            UIUtil.UIFile(textures..'Button1.dds'),
            UIUtil.UIFile(textures..'Button2big.dds'),
            UIUtil.UIFile(textures..'Button2big.dds')
        )
    end
    
    LayoutHelpers.AtLeftTopIn(buttons.snipe, buttons.default, 70, 0)
    buttons.snipe.OnCheck = function(control, checked)
        SetWeaponPriorities(PrioritySettings.priorityTables.Snipe, "Snipe", false)
    end
    LayoutHelpers.AtCenterIn(UIUtil.CreateText(parent, "Snipe", 18, UIUtil.bodyFont), buttons.snipe)
    
    
  
    --first column
    for i, name in PrioritySettings.buttonLayout[1] or {} do
        
        local name = PrioritySettings.buttonLayout[1][i]
        
        buttons[1][i] = CreateButton(PrioritySettings.priorityTables[name], name, PrioritySettings.exclusive[name])
        
        if i == 1 then   
            LayoutHelpers.AtLeftTopIn(buttons[1][i], parent, 65, 95)
        else
            LayoutHelpers.Above(buttons[1][i], buttons[1][i-1])
        end
    end
    
    
    --second column
    for i, name in PrioritySettings.buttonLayout[2] or {} do
        
        local name = PrioritySettings.buttonLayout[2][i]
        
        buttons[2][i] = CreateButton(PrioritySettings.priorityTables[name], name, PrioritySettings.exclusive[name])
        
        if i == 1 then 
            LayoutHelpers.AtLeftTopIn(buttons[2][i], buttons[1][1], 70, 0)
        else
            LayoutHelpers.Above(buttons[2][i], buttons[2][i-1])
        end
    end
    
    --third column
    for i, name in PrioritySettings.buttonLayout[3] or {} do
        
        local name = PrioritySettings.buttonLayout[3][i]
        
        buttons[3][i] = CreateButton(PrioritySettings.priorityTables[name], name, PrioritySettings.exclusive[name])
        
        if i == 1 then 
            LayoutHelpers.AtLeftTopIn(buttons[3][i], buttons[2][1], 70, 0)
        else
            LayoutHelpers.Above(buttons[3][i], buttons[3][i-1])
        end
    end
    
    return buttons
end

function CreateFirestatePopup(parent, selected)
    local bg = Bitmap(parent, UIUtil.UIFile('/game/ability_brd/chat_brd_m.dds'))

    if not separateWindow then
        bg.border = CreateBorder(bg)
        bg.prioBorder = CreatePrioBorder(bg)
        
        bg:DisableHitTest(true)
        
        bg.prioButtons = CreatePrioButtons(bg)
    else
        bg.border = CreateBorder(bg)
        
        bg:DisableHitTest(true)
    end    
    
    
    local function CreateButton(index, info)
        local btn = Checkbox(bg, GetOrderBitmapNames(info.bitmap))
        btn.info = info
        btn.index = index
        btn.HandleEvent = function(control, event)
            if event.Type == 'MouseEnter' then
                CreateMouseoverDisplay(control, control.info.helpText, 1)
            elseif event.Type == 'MouseExit' then
                if controls.mouseoverDisplay then
                    controls.mouseoverDisplay:Destroy()
                    controls.mouseoverDisplay = false
                end
            end
            return Checkbox.HandleEvent(control, event)
        end
        btn.OnCheck = function(control, checked)
            parent:_OnFirestateSelection(control.index, control.info.id)
        end
        return btn
    end

    local i = 1
    bg.buttons = {}
    for index, state in retaliateStateInfo do
        if index ~= -1 then
            bg.buttons[i] = CreateButton(index, state)
            if i == 1 then
                LayoutHelpers.AtBottomIn(bg.buttons[i], bg)
                LayoutHelpers.AtLeftIn(bg.buttons[i], bg)
            else
                LayoutHelpers.Above(bg.buttons[i], bg.buttons[i-1])
            end
            i = i + 1
        end
    end

    bg.Height:Set(function() return table.getsize(bg.buttons) * bg.buttons[1].Height() end)
    bg.Width:Set(bg.buttons[1].Width)

    if UIUtil.currentLayout == 'left' then
        LayoutHelpers.RightOf(bg, parent, 40)
    else
        LayoutHelpers.Above(bg, parent, 20)
    end

    return bg
end

function ToggleMode()
    if currentPreset ~= "Snipe" then
        SetWeaponPriorities(PrioritySettings.priorityTables.Snipe, "Snipe", false)
    else
        SetWeaponPriorities(0, "Default")
    end
end

local KeyMapper = import('/lua/keymap/keymapper.lua')
KeyMapper.SetUserKeyAction('Toggle_snipe_default', {action = 'UI_Lua import("/lua/ui/game/orders.lua").ToggleMode()', category = 'Target priorities', order = 103})
KeyMapper.SetUserKeyAction('Shift_Toggle_snipe_default', {action = 'UI_Lua import("/lua/ui/game/orders.lua").ToggleMode()', category = 'Target priorities', order = 104})
