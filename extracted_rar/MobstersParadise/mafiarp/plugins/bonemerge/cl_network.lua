-- "gamemodes\\mafiarp\\plugins\\bonemerge\\cl_network.lua"


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

net.Receive( "Bonemerge.PlayerLoadedChar", function()
    local ply = net.ReadEntity()
    local oldCharId = net.ReadUInt( 32 )
    PLUGIN:PlayerLoadedChar( ply, oldCharId ~= 0 and oldCharId or nil )
end )

net.Receive( "Bonemerge.StartAdjustingItem", function()
    vgui.Create( "Bonemerge.AdjustPanel" )
end )

net.Receive( "Bonemerge.OpenVendor", function()
    local ply = LocalPlayer()
    local vendor = net.ReadEntity()

    if not PLUGIN.ModelCheck[ply:GetModel()] then
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

net.Receive("Bonemerge.OneTimeModelChange", function()
    local panel = vgui.Create("DFrame")
    panel:SetTitle("Model Change")
    panel:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    panel:Center()
    panel:MakePopup()

    panel.scroll = panel:Add("DScrollPanel")
    panel.scroll:Dock(FILL)

    panel.models = panel.scroll:Add("DIconLayout")
    panel.models:Dock(FILL)
    panel.models:SetSpaceX(4)
    panel.models:SetSpaceY(4)
    panel.models:SetPaintBackground(false)
    panel.models:SetStretchWidth(true)
    panel.models:SetStretchHeight(true)
    panel.models:StretchToParent(0, 0, 0, 0)

    local faction = nut.faction.teams["citizen"]
    if (not faction) then return end

    local function isFemale(model)
        return model:find("female") ~= nil
    end

    for k, v in SortedPairs(faction.models) do
        if isFemale(LocalPlayer():GetModel()) != isFemale(v) then continue end
        if LocalPlayer():GetModel():find("models/tnb/techcom/brot/") and PLUGIN.SkinTranslation[LocalPlayer():GetModel()] != PLUGIN.SkinTranslation[v] then continue end

        local icon = panel.models:Add("SpawnIcon")
        icon:SetSize(64, 128)
        icon:InvalidateLayout(true)
        icon.DoClick = function(icon)
            Derma_Query(
                "Are you sure this is the model you wish to select?", 
                "Are you sure?", 
                "Yes", 
                function() 
                    net.Start("Bonemerge.OneTimeModelChange")
                        net.WriteString(icon.model)
                    net.SendToServer()
                    panel:Close()
                end, 
                "No"
            )
        end

        if (type(v) == "string") then
            icon:SetModel(v)
            icon.model = v
            icon.skin = 0
            icon.bodyGroups = {}
        else
            icon:SetModel(v[1], v[2] or 0, v[3])
            icon.model = v[1]
            icon.skin = v[2] or 0
            icon.bodyGroups = v[3]
        end
        icon.index = k
    end

    panel.models:Layout()
    panel.models:InvalidateLayout()
end)

net.Receive("Bonemerge.CustomHeadsChange", function()
    local panel = vgui.Create("DFrame")
    panel:SetTitle("Custom Model Change")
    panel:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    panel:Center()
    panel:MakePopup()

    panel.scroll = panel:Add("DScrollPanel")
    panel.scroll:Dock(FILL)

    panel.models = panel.scroll:Add("DIconLayout")
    panel.models:Dock(FILL)
    panel.models:SetSpaceX(4)
    panel.models:SetSpaceY(4)
    panel.models:SetPaintBackground(false)
    panel.models:SetStretchWidth(true)
    panel.models:SetStretchHeight(true)
    panel.models:StretchToParent(0, 0, 0, 0)
    
    local heads = {}
    local ply = LocalPlayer()
    for k, v in pairs( PLUGIN.CustomHeads ) do
        if v.Access[ply:SteamID()] and ply:GetGender() == v.Gender then
            table.insert(heads, k)
        end
    end

    if #heads == 0 then return end

    for k, v in SortedPairs(heads) do
        local icon = panel.models:Add("SpawnIcon")
        icon:SetSize(64, 128)
        icon:InvalidateLayout(true)
        icon.DoClick = function(icon)
            Derma_Query(
                "Are you sure this is the model you wish to select?", 
                "Are you sure?", 
                "Yes", 
                function() 
                    net.Start("Bonemerge.CustomHeadsChange")
                        net.WriteString(icon.model)
                    net.SendToServer()
                    panel:Close()
                end, 
                "No"
            )
        end

        if (type(v) == "string") then
            icon:SetModel(v)
            icon.model = v
            icon.skin = 0
            icon.bodyGroups = {}
        else
            icon:SetModel(v[1], v[2] or 0, v[3])
            icon.model = v[1]
            icon.skin = v[2] or 0
            icon.bodyGroups = v[3]
        end
        icon.index = k
    end

    panel.models:Layout()
    panel.models:InvalidateLayout()
end)