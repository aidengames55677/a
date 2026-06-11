-- "gamemodes\\mafiarp\\plugins\\medals\\derma\\cl_medalsmanage_menu.lua"


local PLUGIN = PLUGIN

function PLUGIN:ManageMenu( medals, charId )
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 400, 450 )
    frame:Center()
    frame:SetTitle( "Medals Manage for: " .. charId )
    frame:MakePopup()

    local scroll = vgui.Create( "DScrollPanel", frame )
    scroll:Dock( FILL )

    local searchBar = vgui.Create( "DTextEntry", frame )
    searchBar:Dock( BOTTOM )
    searchBar:SetPlaceholderText( "Search by name" )
    searchBar:SetTall( 30 )

    local function populateList( searchQuery )
        local sortedMedals = {}
        for uniqueID, item in pairs( PLUGIN.AwardableMedals ) do
            if not searchQuery or string.find( string.lower( item.name ), string.lower( searchQuery ) ) then
                table.insert( sortedMedals, {uniqueID = uniqueID, item = item} )
            end
        end
        table.sort( sortedMedals, function( a, b ) return a.item.name < b.item.name end )

        scroll:Clear()
        for _, data in ipairs( sortedMedals ) do
            local uniqueID = data.uniqueID
            local item = data.item
            local line = scroll:Add( "DPanel" )
            line:Dock( TOP )
            line:SetTall( 64 )

            local icon = line:Add( "DImage" )
            icon:SetPos( 5, 5 )
            icon:SetSize( 64, 64 )
            icon:SetImage( item.icon )

            local checkbox = line:Add( "DCheckBox" )
            checkbox:SetPos( 74, 20 )
            checkbox:SetValue( medals[uniqueID] and true or false )
            checkbox.OnChange = function( _, val )
                medals[uniqueID] = val == true and true or nil
                net.Start( "Medals.UpdateManage" )
                    net.WriteUInt( charId, 32 )
                    net.WriteTable( medals )
                net.SendToServer()
                nut.util.notify( "You have set permission to manage medal \"" .. item.name .. "\" for CharID " .. charId .. " to " .. tostring( val )  )
            end

            local text = line:Add( "DLabel" )
            text:SetPos( 150, 20 )
            text:SetText( item.name )
            text:SizeToContents()
        end
    end

    searchBar.OnTextChanged = function( _ )
        populateList( searchBar:GetValue() )
    end

    populateList()
end

function PLUGIN:MedalsMenu()
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 400, 450 )
    frame:Center()
    frame:SetTitle( "Medals Spawning Menu" )
    frame:MakePopup()

    local scroll = vgui.Create( "DScrollPanel", frame )
    scroll:Dock( FILL )

    local searchBar = vgui.Create( "DTextEntry", frame )
    searchBar:Dock( BOTTOM )
    searchBar:SetPlaceholderText( "Search by name" )
    searchBar:SetTall( 30 )

    local function populateList( searchQuery )
        local sortedMedals = {}
        for uniqueID, item in pairs( PLUGIN.AwardableMedals ) do
            if not PLUGIN:CanManageMedal( LocalPlayer():getChar(), uniqueID ) then continue end
            if not searchQuery or string.find( string.lower( item.name ), string.lower( searchQuery ) ) then
                table.insert( sortedMedals, {uniqueID = uniqueID, item = item} )
            end
        end
        table.sort( sortedMedals, function( a, b ) return a.item.name < b.item.name end )

        scroll:Clear()
        for _, data in ipairs( sortedMedals ) do
            local uniqueID = data.uniqueID
            local item = data.item
            local line = scroll:Add( "DPanel" )
            line:Dock( TOP )
            line:SetTall( 64 )

            local icon = line:Add( "DImage" )
            icon:SetPos( 5, 5 )
            icon:SetSize( 64, 64 )
            icon:SetImage( item.icon )

            local button = line:Add( "DButton" )
            button:Dock(RIGHT)
            button:SetSize( 60, 30 )
            button:SetText( "Create" )
            button.DoClick = function()
                net.Start( "Medals.Spawn" )
                    net.WriteString( uniqueID )
                net.SendToServer()
            end

            local medalName = line:Add( "DLabel" )
            medalName:Dock( FILL )
            medalName:SetContentAlignment( 5 )
            medalName:SetText( item.name )
        end
    end

    searchBar.OnTextChanged = function( _ )
        populateList( searchBar:GetValue() )
    end

    populateList()
end