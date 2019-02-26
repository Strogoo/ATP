local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Checkbox = import('/lua/maui/checkbox.lua').Checkbox
local Button = import('/lua/maui/button.lua').Button
local Prefs = import('/lua/user/prefs.lua')
local Dragger = import('/lua/maui/dragger.lua').Dragger
local ItemList = import('/lua/maui/itemlist.lua').ItemList
local Combo = import('/lua/ui/controls/combo.lua').Combo
local Edit = import('/lua/maui/edit.lua').Edit

local getPrioritySettingsPrefs = import('/lua/ui/game/orders.lua').GetPrioritySettingsPrefs
local getPrioritySettings = import('/lua/ui/game/orders.lua').GetPrioritySettings
local createSeparateWindow = import('/lua/ui/game/orders.lua').CreateSeparateWindow
local destroySeparateWindow = import('/lua/ui/game/orders.lua').DestroySeparateWindow
local updatePriorityPrefs = import('/lua/ui/game/orders.lua').UpdatePriorityPrefs

local settingsWindow
local prioritySettingsPrefs 
local prioritySettings

function CreateSettingsWindow()
    if not prioritySettingsPrefs then
        prioritySettingsPrefs = getPrioritySettingsPrefs()
    end
    
    if not prioritySettings then
        prioritySettings = getPrioritySettings()
    end    

    if settingsWindow then
        settingsWindow:Destroy()
        settingsWindow = nil
    end    
    
    local width = 500
    local height = 400
    
    settingsWindow = Bitmap(GetFrame(0), UIUtil.UIFile('/mods/Advanced target priorities/textures/back.dds'))
    settingsWindow.Depth:Set(100)
    settingsWindow.Width:Set(width)
    settingsWindow.Height:Set(height)
    settingsWindow:SetAlpha(0.8)
    LayoutHelpers.AtCenterIn(settingsWindow, GetFrame(0))    

    settingsWindow.HandleEvent = function(self, event)
        if event.Type == 'ButtonPress' then
            local drag = Dragger()
            local offX = event.MouseX - self.Left()
            local offY = event.MouseY - self.Top()
            
            drag.OnMove = function(dragself, x, y)
                self.Left:Set(x - offX)
                self.Top:Set(y - offY)
                GetCursor():SetTexture(UIUtil.GetCursor('MOVE_WINDOW'))
            end

            drag.OnRelease = function(dragself)
                GetCursor():Reset()
                drag:Destroy()
            end
            
            PostDragger(self:GetRootFrame(), event.KeyCode, drag)
        end
    end
    
    ---Close button---
    settingsWindow.closeButton =  Button(settingsWindow, 
        UIUtil.UIFile('/mods/Advanced target priorities/textures/close1.dds'),
        UIUtil.UIFile('/mods/Advanced target priorities/textures/close1.dds'),
        UIUtil.UIFile('/mods/Advanced target priorities/textures/close2.dds'),
        UIUtil.UIFile('/mods/Advanced target priorities/textures/close2.dds'))
        
    LayoutHelpers.AtRightTopIn(settingsWindow.closeButton, settingsWindow, 5, 5) 
        
    settingsWindow.closeButton.OnClick = function(self, event)
        settingsWindow:Destroy()
        settingsWindow = nil
    end
    
    --CheckBoxWindowOn
    
    settingsWindow.CheckBoxShowWindow = UIUtil.CreateCheckbox(settingsWindow, '/CHECKBOX/')
    settingsWindow.CheckBoxShowWindow.Height:Set(18)
    settingsWindow.CheckBoxShowWindow.Width:Set(18)
  
    if prioritySettingsPrefs.showSeparateWindow == true then
        settingsWindow.CheckBoxShowWindow:SetCheck(true, true)
    else
        settingsWindow.CheckBoxShowWindow:SetCheck(false, true)
    end
	
    settingsWindow.CheckBoxShowWindow.OnClick = function(self)
        if(settingsWindow.CheckBoxShowWindow:IsChecked()) then
            prioritySettingsPrefs.showSeparateWindow = false
            settingsWindow.CheckBoxShowWindow:SetCheck(false, true)
            destroySeparateWindow()
        else
            prioritySettingsPrefs.showSeparateWindow = true
            settingsWindow.CheckBoxShowWindow:SetCheck(true, true)
            
            CalculateSize()
            createSeparateWindow()
        end
        
        updatePriorityPrefs()
    end
    
    LayoutHelpers.AtLeftTopIn(settingsWindow.CheckBoxShowWindow, settingsWindow, 20, 20)
    
    settingsWindow.CheckBoxShowWindow.text = UIUtil.CreateText(settingsWindow, "Separate window", 18, UIUtil.bodyFont)
    
    LayoutHelpers.AtLeftTopIn(settingsWindow.CheckBoxShowWindow.text, settingsWindow.CheckBoxShowWindow, 20, -2)
    
    
    
    --CheckBoxLockPosition
    
    settingsWindow.CheckBoxLockWindow = UIUtil.CreateCheckbox(settingsWindow, '/CHECKBOX/')
    settingsWindow.CheckBoxLockWindow.Height:Set(14)
    settingsWindow.CheckBoxLockWindow.Width:Set(14)
  
    if prioritySettingsPrefs.lockSeparateWindow == true then
        settingsWindow.CheckBoxLockWindow:SetCheck(true, true)
    else
        settingsWindow.CheckBoxLockWindow:SetCheck(false, true)
    end
	
    settingsWindow.CheckBoxLockWindow.OnClick = function(self)
        if(settingsWindow.CheckBoxLockWindow:IsChecked()) then
            prioritySettingsPrefs.lockSeparateWindow = false
            settingsWindow.CheckBoxLockWindow:SetCheck(false, true)
        else
            prioritySettingsPrefs.lockSeparateWindow = true
            settingsWindow.CheckBoxLockWindow:SetCheck(true, true)
        end
        
        updatePriorityPrefs()
    end
    
    LayoutHelpers.AtLeftTopIn(settingsWindow.CheckBoxLockWindow, settingsWindow.CheckBoxShowWindow, 20, 20)
    
    settingsWindow.CheckBoxLockWindow.text = UIUtil.CreateText(settingsWindow, "Lock window position", 14, UIUtil.bodyFont)
    
    LayoutHelpers.AtLeftTopIn(settingsWindow.CheckBoxLockWindow.text, settingsWindow.CheckBoxLockWindow, 20, -2)
    
    
    
    --First column dropdowns---
    ---------------------------
    local i = 1
    local sortedPresets = {}
    for name, set in prioritySettings.priorityTables do
        table.insert(sortedPresets, name)
    end
    table.sort(sortedPresets)

    
    settingsWindow.dropdowns1 = {}
    
    while i < 7 do
        settingsWindow.dropdowns1[i] = Combo(settingsWindow, 14, 10, nil, nil)
        settingsWindow.dropdowns1[i].Width:Set(130)
        LayoutHelpers.AtLeftTopIn(settingsWindow.dropdowns1[i], settingsWindow.CheckBoxLockWindow, 0, 150 - i * 20)
        
        settingsWindow.dropdowns1[i].Number = i 
        
        settingsWindow.dropdowns1[i].OnClick = function(self, index, text, skipUpdate)
            if index == 1 then
                prioritySettingsPrefs.buttonLayoutSeparate[1][self.Number] = nil
            else
                prioritySettingsPrefs.buttonLayoutSeparate[1][self.Number] = settingsWindow.dropdowns1[1].itemArray[index]
            end
            
            CalculateSize()
            createSeparateWindow()
            updatePriorityPrefs()
        end
        
        if i == 1 then
            local index = 2
            
            settingsWindow.dropdowns1[1]:ClearItems()
            settingsWindow.dropdowns1[1].itemArray = {}
            settingsWindow.dropdowns1[1].ID = {}
            settingsWindow.dropdowns1[1].itemArray[1] = "-"
            
            for k, name in sortedPresets do
                settingsWindow.dropdowns1[1].itemArray[index] = name
                settingsWindow.dropdowns1[1].ID[name] = index
                index = index + 1
            end 
            
            settingsWindow.dropdowns1[1]:AddItems(settingsWindow.dropdowns1[1].itemArray, 1)
            
            if prioritySettingsPrefs.buttonLayoutSeparate[1][1] then
                settingsWindow.dropdowns1[1]:SetItem(settingsWindow.dropdowns1[1].ID[prioritySettingsPrefs.buttonLayoutSeparate[1][1]])
            end 
        
        else          
            settingsWindow.dropdowns1[i]:AddItems(settingsWindow.dropdowns1[1].itemArray, 1)
            
            if prioritySettingsPrefs.buttonLayoutSeparate[1][i] then
                settingsWindow.dropdowns1[i]:SetItem(settingsWindow.dropdowns1[1].ID[prioritySettingsPrefs.buttonLayoutSeparate[1][i]])
            end 
        end    
         
        i = i + 1      
    end
    
    
     ----Second column dropdowns----
     -------------------------------
    i = 1
    settingsWindow.dropdowns2 = {}
    
    while i < 7 do
        settingsWindow.dropdowns2[i] = Combo(settingsWindow, 14, 10, nil, nil)
        settingsWindow.dropdowns2[i].Width:Set(130)
        LayoutHelpers.AtLeftTopIn(settingsWindow.dropdowns2[i], settingsWindow.dropdowns1[1], 150, 20 - i * 20)
        
        settingsWindow.dropdowns2[i].Number = i 
        
        settingsWindow.dropdowns2[i].OnClick = function(self, index, text, skipUpdate)
            if index == 1 then
                prioritySettingsPrefs.buttonLayoutSeparate[2][self.Number] = nil
            else
                prioritySettingsPrefs.buttonLayoutSeparate[2][self.Number] = settingsWindow.dropdowns1[1].itemArray[index]
            end

            CalculateSize()
            createSeparateWindow()
            updatePriorityPrefs()
        end
                
        settingsWindow.dropdowns2[i]:AddItems(settingsWindow.dropdowns1[1].itemArray, 1)
        
        if prioritySettingsPrefs.buttonLayoutSeparate[2][i] then
            settingsWindow.dropdowns2[i]:SetItem(settingsWindow.dropdowns1[1].ID[prioritySettingsPrefs.buttonLayoutSeparate[2][i]])
        end 
        
        i = i + 1      
    end
    
    ----Third column dropdowns----
    -------------------------------
    
    i = 1
    settingsWindow.dropdowns3 = {}
    
    while i < 7 do
        settingsWindow.dropdowns3[i] = Combo(settingsWindow, 14, 10, nil, nil)
        settingsWindow.dropdowns3[i].Width:Set(130)
        LayoutHelpers.AtLeftTopIn(settingsWindow.dropdowns3[i], settingsWindow.dropdowns2[1], 150, 20 - i * 20)
        
        settingsWindow.dropdowns3[i].Number = i 
        
        settingsWindow.dropdowns3[i].OnClick = function(self, index, text, skipUpdate)
            if index == 1 then
                prioritySettingsPrefs.buttonLayoutSeparate[3][self.Number] = nil
            else
                prioritySettingsPrefs.buttonLayoutSeparate[3][self.Number] = settingsWindow.dropdowns1[1].itemArray[index]
            end

            CalculateSize()
            createSeparateWindow()
            updatePriorityPrefs()
        end
                
        settingsWindow.dropdowns3[i]:AddItems(settingsWindow.dropdowns1[1].itemArray, 1)
        
        if prioritySettingsPrefs.buttonLayoutSeparate[3][i] then
            settingsWindow.dropdowns3[i]:SetItem(settingsWindow.dropdowns1[1].ID[prioritySettingsPrefs.buttonLayoutSeparate[3][i]])
        end 
        
        i = i + 1      
    end
    
    ---Hide abilities---
    settingsWindow.CheckBoxHideAbilities = UIUtil.CreateCheckbox(settingsWindow, '/CHECKBOX/')
    settingsWindow.CheckBoxHideAbilities.Height:Set(18)
    settingsWindow.CheckBoxHideAbilities.Width:Set(18)
  
    if prioritySettingsPrefs.hideAbilities == true then
        settingsWindow.CheckBoxHideAbilities:SetCheck(true, true)
    else
        settingsWindow.CheckBoxHideAbilities:SetCheck(false, true)
    end
	
    settingsWindow.CheckBoxHideAbilities.OnClick = function(self)
        if(settingsWindow.CheckBoxHideAbilities:IsChecked()) then
            prioritySettingsPrefs.hideAbilities = false
            settingsWindow.CheckBoxHideAbilities:SetCheck(false, true)
        else
            prioritySettingsPrefs.hideAbilities = true
            settingsWindow.CheckBoxHideAbilities:SetCheck(true, true)
        end
        
        updatePriorityPrefs()
    end
    
    LayoutHelpers.AtLeftTopIn(settingsWindow.CheckBoxHideAbilities, settingsWindow.CheckBoxShowWindow, 0, 200)
    
    settingsWindow.CheckBoxHideAbilities.text = UIUtil.CreateText(settingsWindow, "Hide abilities", 18, UIUtil.bodyFont)
    
    LayoutHelpers.AtLeftTopIn(settingsWindow.CheckBoxHideAbilities.text, settingsWindow.CheckBoxHideAbilities, 20, -2)
    
    ---abilities.dds---
    settingsWindow.AbilitiesTexture = Bitmap(settingsWindow, UIUtil.UIFile('/mods/Advanced target priorities/textures/Abilities.dds'))
    settingsWindow.AbilitiesTexture:SetAlpha(0.3)
    settingsWindow.AbilitiesTexture:DisableHitTest()
    LayoutHelpers.AtLeftTopIn(settingsWindow.AbilitiesTexture, settingsWindow.CheckBoxHideAbilities, 0, 30)  
    
end

function CalculateSize()
    local i = 0
    local additionalColumn = 0
    
    for k,tbl in prioritySettingsPrefs.buttonLayoutSeparate do
        for k,v in tbl or {} do
            if k > i then i = k end
        end
    end
    
    for k,v in prioritySettingsPrefs.buttonLayoutSeparate[3] or {} do
        additionalColumn = 1
        break
    end

    prioritySettingsPrefs.windowWidth = 120 + additionalColumn * 70
    prioritySettingsPrefs.windowHeight = 20 + i * 20   
end