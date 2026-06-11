-- "gamemodes\\mafiarp\\plugins\\charutil\\cl_plugin.lua"


local PLUGIN = PLUGIN

net.Receive( "Charutil.CharData", function()
    local target = net.ReadString()
    local sendData = net.ReadTable()

    local fr = vgui.Create( "DFrame" )
    fr:SetTitle( "Character List for " .. ( target or "N/A" ) )
    local ScrW, ScrH = ScrW(), ScrH()
    fr:SetSize( ScrW * 0.9, ScrH * 0.9 )
    fr:Center()
    fr:MakePopup()
    
    local listView = vgui.Create( "DListView", fr )
    listView:Dock( FILL )
    local columns = { "ID", "Name", "Desc", "Model", "Attributes", "Money", "Faction", "Character Values", "Created At", "Last Joined", "Is PK'd", "By", "Rank", "Languages" }
    for _, col in ipairs( columns ) do
        listView:AddColumn( col )
    end
    
    for _, v in pairs( sendData or {} ) do
        local Line = listView:AddLine( v.ID, v.Name, v.Desc, v.Model, "Edit to View", v.Money, v.Faction, "Edit to View", v.CreateTime, v.LastJoinTime, v.Banned, v.BannedInfoName, v.BannedInfoRank, v.Languages )
        if ( v.Banned == "Yes" ) then
            Line.DoPaint = Line.Paint
            Line.Paint = function( pnl, w, h )
                surface.SetDrawColor( 200, 100, 100 )
                surface.DrawRect( 0, 0, w, h )
                pnl:DoPaint( w, h )
            end
        end
        Line.OnRightClick = function()
            local menu = DermaMenu()
            
            menu:AddOption( "Copy SteamID", function() 
                SetClipboardText( target ) 
                chat.AddText( Color( 255, 255, 255 ), "Copied ID to clipboard!" )
            end ):SetIcon( "icon16/page_copy.png" )

            menu:AddOption( "Copy ID", function() 
                SetClipboardText( v.ID ) 
                chat.AddText( Color( 255, 255, 255 ), "Copied ID to clipboard!" )
            end ):SetIcon( "icon16/page_copy.png" )

			menu:AddSpacer()
            
            menu:AddOption( "Ban Offline", function() 
                LocalPlayer():ConCommand( [[say "/charbanoffline ]] .. v.ID .. [["]] ) 
                Line.Paint = function( pnl, w, h )
                    surface.SetDrawColor( 200, 100, 100 )
                    surface.DrawRect( 0, 0, w, h )
                    Line:SetValue( 11, "Yes" ) Line:SetValue( 12, LocalPlayer():Name() ) Line:SetValue( 13, LocalPlayer():GetUserGroup() )
                end
            end ):SetIcon( "icon16/user_delete.png" )
            
            menu:AddOption( "Unban Offline", function() 
                LocalPlayer():ConCommand( [[say "/charunbanoffline ]] .. v.ID .. [["]] )
                Line.Paint = Line.DoPaint
                Line:SetValue( 11, "No" ) Line:SetValue( 12, "N/A" ) Line:SetValue( 13, "N/A" )
            end ):SetIcon( "icon16/user_add.png" )     
            
            menu:AddSpacer()
            
            menu:AddOption( "Edit Name", function() 
                Derma_StringRequest( "Edit Name", "Enter a new name for this character.", Line:GetValue( 2 ), function( text )
                    if not tostring( text ) then return end

                    net.Start( "Charutil.EditData" )
                        net.WriteString( "name" )
                        net.WriteUInt( v.ID, 32 )
                        net.WriteString( text )
                    net.SendToServer()
                    Line:SetValue( 2, text )
                end )
            end ):SetIcon( "icon16/page_edit.png" )    

            menu:AddOption( "Edit Description", function() 
                Derma_StringRequest( "Edit Description", "Enter a new description for this character.", Line:GetValue( 3 ), function( text )
                    if not tostring( text ) then return end

                    net.Start( "Charutil.EditData" )
                        net.WriteString( "description" )
                        net.WriteUInt( v.ID, 32 )
                        net.WriteString( text )
                    net.SendToServer()
                    Line:SetValue( 3, text )
                end )
            end ):SetIcon( "icon16/page_edit.png" )   

            local setFaction, parentMenu = menu:AddSubMenu("Set Faction")
            parentMenu:SetIcon("icon16/chart_organisation.png")

            for index,faction in next, nut.faction.teams do
                setFaction:AddOption(faction.name, function()
                    net.Start( "Charutil.EditData" )
                        net.WriteString( "faction" )
                        net.WriteUInt( v.ID, 32 )
                        net.WriteUInt( faction.index, 32 )
                        net.WriteString( faction.uniqueID )
                    net.SendToServer()
                    Line:SetValue( 7, faction.name )
                end)
            end
			
			menu:AddSpacer()

            menu:AddOption( "Edit Character Values", function() 
                PLUGIN:EditDescription( v.ID, v.DescGenerator )
            end ):SetIcon( "icon16/page_edit.png" )            
            
            menu:AddOption( "Edit Attributes", function() 
                PLUGIN:EditAttributes( v.ID, v.Attribs )
            end ):SetIcon( "icon16/page_edit.png" )            
            
            menu:AddOption( "Edit Money", function() 
                Derma_StringRequest( "Edit Money", "Enter the amount of money you want to set for this character.", Line:GetValue( 6 ), function( text )
                    text = tonumber( text )
                    net.Start( "Charutil.EditData" )
                        net.WriteString( "money" )
                        net.WriteUInt( v.ID, 32 )
                        net.WriteUInt( text, 32 )
                    net.SendToServer()
                    Line:SetValue( 6, text )
                end )
            end ):SetIcon( "icon16/page_edit.png" )

            menu:AddSpacer()
            
            menu:Open()
        end
    
    end
end )

net.Receive( "Charutil.FacData", function(len)
    local faction = net.ReadString()
	local data = net.ReadData(len)
	local decompressed_data = util.Decompress(data)
    local sendData = util.JSONToTable(decompressed_data)

    local fr = vgui.Create( "DFrame" )
    fr:SetTitle( faction )
    local ScrW, ScrH = ScrW(), ScrH()
    fr:SetSize( ScrW * 0.9, ScrH * 0.9 )
    fr:Center()
    fr:MakePopup()
    
    local listView = vgui.Create( "DListView", fr )
    listView:Dock( FILL )
    local columns = { "Name", "Last Joined", "Faction", "ID", "SteamID"}
    for _, col in ipairs( columns ) do
        listView:AddColumn( col )
    end
    
    for _, v in pairs( sendData or {} ) do
        local newSteamID = util.SteamIDFrom64( v.SteamID )
        local Line = listView:AddLine( v.Name, v.LastJoinTime, v.Faction, v.ID, newSteamID )
        Line.OnRightClick = function()
            local menu = DermaMenu()
            
            menu:AddOption( "Copy ID", function() 
                SetClipboardText( v.ID ) 
                chat.AddText( Color( 255, 255, 255 ), "Copied ID to clipboard!" )
            end ):SetIcon( "icon16/page_copy.png" )

            menu:AddOption( "Copy SteamID", function() 
                SetClipboardText( newSteamID ) 
                chat.AddText( Color( 255, 255, 255 ), "Copied SteamID to clipboard!" )
            end ):SetIcon( "icon16/page_copy.png" )

            menu:AddSpacer()

            menu:AddOption( "View Charlist for " .. newSteamID, function() 
                LocalPlayer():ConCommand([[say "/charlist ]] .. newSteamID .. [["]]) 
            end ):SetIcon( "icon16/page_copy.png" )

            menu:AddSpacer()

            menu:AddOption( "Transfer Out", function() 
                local selectedRows = listView:GetSelected()
                local i = 0
                for _, row in pairs(selectedRows) do
                    local id = row:GetValue(4)
                    if not tonumber( id ) then return end
                    timer.Simple( i * 0.1, function()
                        net.Start( "Charutil.EditData" )
                            net.WriteString( "faction" )
                            net.WriteUInt( id, 32 )
                            net.WriteUInt( FACTION_CITIZEN, 32 )
                            net.WriteString( "citizen" )
                        net.SendToServer()
                        row:SetValue( 3, "citizen" )
                    end )
                    i = i + 1
                end
            end ):SetIcon( "icon16/page_edit.png" )
            
            menu:Open()
        end
    
    end
end )

net.Receive( "Charutil.FacActivityData", function()
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 800, 600 )
	frame:Center()
	frame:MakePopup()
	
	local listView = vgui.Create( "DListView", frame)
	listView:Dock( FILL )
	listView:AddColumn( "Faction Name" )
	listView:AddColumn( "Members Connected" )
	
	local SendInfo = {}
	local FactionTable = net.ReadTable()
    local date = net.ReadString()

    frame:SetTitle( "Faction Activity - From " .. date .. ":" )
    
	for k,v in ipairs( FactionTable ) do
        for i,fac in pairs( nut.faction.teams ) do
            if v._name == fac.uniqueID then
                v._name = fac.name
                listView:AddLine( v._name or "N/A", v._amount or "N/A" )
            end
        end
	end

	listView:SortByColumn( 2, true )

	listView.OnRowSelected = function( _, rowIndex, row )
		local menu = DermaMenu()
        menu:AddOption( "Manage Faction", function() RunConsoleCommand( 'say', '/managefaction ' .. tostring( row:GetValue( 1 ) ) ) end )
		menu:Open()
	end
end )

function PLUGIN:EditDescription( id, descgenerator )
    descgenerator = util.JSONToTable( descgenerator )
    local panel = vgui.Create( "DFrame" )
    panel:SetTitle( "Character Values" )
    panel:SetSize( ScrW() * 0.3, ScrH() * 0.31 )
    panel:Center()
    panel:MakePopup()
    panel:SetSkin( "nutscript" )
    
    local i = 1
    for k, v in ipairs( nut.plugin.list.modified_charcreation.character_customization ) do
        local container = panel:Add( "DPanel" )
        container:Dock( TOP )
        container:DockMargin (0, 0, 0, 4 )
        container:SetZPos( i )
        container.Paint = function() end

        local label = container:Add( "DLabel" )
        label:SetFont( "nutGenericFont" )
        label:SetText( L( v.Name ) )
        label:SetZPos(1)
        label:Dock( LEFT )
        label:DockMargin( 0, 0, 10, 0 )
        label:InvalidateLayout( true )

        label:SizeToContents()

        if v.Type == "Dropdown" then
            local combo = container:Add( "DComboBox" )
            combo:SetFont( "nutGenericFont" )
            combo:Dock( FILL )
            combo:SetZPos( 2 )
            combo.OnSelect = function( _, index, value, data )
                descgenerator[v.Name] = value
            end

            local selected
            for k2, v2 in pairs( v.Options ) do
                local result = combo:AddChoice( v2 )

                if v2 == descgenerator[v.Name] then
                    selected = result
                end
            end

            combo:ChooseOptionID( selected or 1 )
        elseif v.Type == "Text" then
            local entry = container:Add( "DTextEntry" )
            entry:SetFont( "nutGenericFont" )
            entry:Dock( FILL )
            entry:SetZPos( 2 )
            entry:SetText( descgenerator[v.Name] )
            entry.OnValueChange = function( _, value )
                descgenerator[v.Name] = string.Trim( value )
            end
        elseif v.Type == "NumberWang" then
            local wang = container:Add( "DNumberWang" )
            wang.OnValueChanged = function( wang, value )
                value = tonumber( value )
                if value > wang:GetMax() then
                    wang:SetValue( v.Maximum )
                    wang:SetValue( v.Maximum )
                end
                if wang:GetMin() > value then
                    wang:SetText( v.Minimum )
                    wang:SetValue( v.Minimum )
                end

                descgenerator[v.Name] = wang:GetValue()
            end
            wang:SetFont( "nutGenericFont" )
            wang:SetTextColor( Color( 200, 200, 200 ) )
            wang:SetZPos( 2 )
            wang:Dock( FILL )
            wang:SetMinMax( v.Minimum or 0, v.Maximum or 100 )
            wang:SetValue( descgenerator[v.Name] )

            if ( v.Minimum ) then
                wang:SetMin( v.Minimum )
            end

            if ( v.Maximum ) then
                wang:SetMax( v.Maximum )
            end
        end

        i = i + 1
    end

    panel.done = panel:Add( "DButton" )
    panel.done:SetZPos( i )
    panel.done:Dock( BOTTOM )
    panel.done:SetText( "Edit" )
    function panel.done:DoClick()
        net.Start( "Charutil.EditData" )
            net.WriteString( "descgenerator")
            net.WriteUInt( id, 32 )
            net.WriteTable( descgenerator )
        net.SendToServer()

        panel:Close()
    end
end

function PLUGIN:EditAttributes( id, values )
    values = util.JSONToTable( values )
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 300, 200 )
    frame:Center()
    frame:SetTitle( "Attribute Selection" )
    frame:SetDraggable( false )
    
    local enduranceSlider = vgui.Create( "DNumSlider", frame )
    enduranceSlider:SetPos( 50, 50 )
    enduranceSlider:SetSize( 200, 20 )
    enduranceSlider:SetText( "Endurance" )
    enduranceSlider:SetMin( 0 )
    enduranceSlider:SetMax( 1000 )
    enduranceSlider:SetDecimals( 0 )
    enduranceSlider:SetValue( values["end"] or 0 )
    
    local staminaSlider = vgui.Create( "DNumSlider", frame )
    staminaSlider:SetPos( 50, 80 )
    staminaSlider:SetSize( 200, 20 )
    staminaSlider:SetText( "Stamina" )
    staminaSlider:SetMin( 0 )    
    staminaSlider:SetMax( 1000 )
    staminaSlider:SetDecimals( 0 )
    staminaSlider:SetValue( values.stm or 0 )
    
    local strengthSlider = vgui.Create( "DNumSlider", frame )
    strengthSlider:SetPos( 50, 110 )
    strengthSlider:SetSize( 200, 20 )
    strengthSlider:SetText( "Strength" )
    strengthSlider:SetMin( 0 )
    strengthSlider:SetMax( 1000 )
    strengthSlider:SetDecimals( 0 )
    strengthSlider:SetValue( values.str or 0 )
    
    local submitButton = vgui.Create( "DButton", frame )
    submitButton:SetPos( 100, 150 )
    submitButton:SetSize( 100, 30 )
    submitButton:SetText( "Submit" )
    submitButton.DoClick = function()
        local endurancePoints = math.floor( enduranceSlider:GetValue() )
        local staminaPoints = math.floor( staminaSlider:GetValue() )
        local strengthPoints = math.floor( strengthSlider:GetValue() )

        local attributes = {
            endurance = endurancePoints,
            stamina = staminaPoints,
            strength = strengthPoints
        }
        
        net.Start( "Charutil.EditData" )
            net.WriteString( "attributes" )
            net.WriteUInt( id, 32 )
            net.WriteTable( attributes )
        net.SendToServer()
        frame:Close()
    end
    
    frame:MakePopup()
end