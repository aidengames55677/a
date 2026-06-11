-- "gamemodes\\mafiarp\\plugins\\serialnumbers\\cl_plugin.lua"


local weaponsFrame

net.Receive( "SerialNumbers.InitiateSerialScratch", function()
    local validItems = net.ReadTable()

    if weaponsFrame then
        weaponsFrame:Remove()
    end

    weaponsFrame = vgui.Create( "DFrame" )
    weaponsFrame:MakePopup()
    weaponsFrame:SetSize( 350, 300 )
    weaponsFrame:SetDrawOnTop( true )
    weaponsFrame:DoModal()
    weaponsFrame:SetDraggable( false )
    weaponsFrame:ShowCloseButton( false )
    weaponsFrame:Center()
    weaponsFrame:SetTitle( "Choose a weapon" )

    weaponsFrame.ListView = vgui.Create( "DListView", weaponsFrame )
    weaponsFrame.ListView:Dock( FILL )
    weaponsFrame.ListView:AddColumn( "Weapon" )
    weaponsFrame.ListView:AddColumn( "ID" )

    for k, v in ipairs( validItems ) do
        local itemTable = nut.item.instances[v]
        weaponsFrame.ListView:AddLine( itemTable.name, v )
    end

    weaponsFrame.ListView.OnRowSelected = function( _, _, row )
        net.Start( "SerialNumbers.FinishSerialScratch" )
        net.WriteBit( true )
        net.WriteUInt( tonumber( row:GetValue( 2 ) ), 32 )
        net.SendToServer()

        weaponsFrame:Close()
    end

    weaponsFrame.ListView:SortByColumn( 1 )

    weaponsFrame.CancelButton = vgui.Create( "DButton", weaponsFrame )
    weaponsFrame.CancelButton:Dock( BOTTOM )
    weaponsFrame.CancelButton:SetText( "Cancel" )
    weaponsFrame.CancelButton:SetTall( 30 )
    weaponsFrame.CancelButton:DockMargin( 5, 5, 5, 5 )
    weaponsFrame.CancelButton.DoClick = function()
        net.Start( "SerialNumbers.FinishSerialScratch" )
        net.WriteBool( false )
        net.SendToServer()
        weaponsFrame:Close()
    end

    weaponsFrame.Paint = function( _, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 45, 45 ) )
    end
end )