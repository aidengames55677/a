local PLUGIN = PLUGIN

net.Receive( "Bonemerge.ReceiveBonemergeItem", function()
    local id = net.ReadUInt( 32 )
    local owner = net.ReadEntity()
    local charId = net.ReadUInt( 32 )
    local class = net.ReadString()
    local equipped = net.ReadBool() or false

    PLUGIN:EnsureItem( id, {
        owner = owner,
        charId = charId,
        class = class,
        equipped = equipped,
    } )
end )

net.Receive( "Bonemerge.StartAdjustingItem", function()
    vgui.Create( "Bonemerge.AdjustPanel" )
end )

net.Receive( "Bonemerge.OpenVendor", function()
    local ply = LocalPlayer()
    local vendor = net.ReadEntity()

    if not ply:GetModel():find("models/tnb/techcom/brot/") then
        Derma_Query(
            "Your model does not support bonemerge clothing. Do you wish to have it converted automatically? (This action is irreversible without staff!)", 
            "Unsupported Model",
            "Yes",
            function()
                net.Start("Bonemerge.ConvertModel")
                net.SendToServer()
            end, 
            "No"
        )
        return
    end

    if not PLUGIN.InVendor then
        GetConVar( "nut_tp_enabled" ):SetString( "0" )
        ply:SelectWeapon( "nut_keys" )
        PLUGIN:OpenVendor( vendor )
    end
end )