-- "gamemodes\\mafiarp\\plugins\\bonemerge\\derma\\cl_information.lua"


local PLUGIN = PLUGIN

function PLUGIN:DrawNutModelView( panel, ent )
    if ent.Bonemerge then
        for _, model in pairs( ent.Bonemerge ) do
            model:DrawModel()
        end
    end
end

function PLUGIN:OnCharInfoSetup( infoPanel )
    if not IsValid( infoPanel.model ) then return end
    local mdl = infoPanel.model
    local ent = mdl.Entity
    local client = LocalPlayer()

    if not client:getChar() then return end

    local charData = self.CharacterData[client:getChar():getID()]
    if not charData then return end

    if ent.Bonemerge then
        for k, v in pairs( ent.Bonemerge ) do
            SafeRemoveEntity( v )
        end
    end

    ent.Bonemerge = {}

    for k, v in next, client:GetBonemergedChildren() do
        local foundEntity = false
        for _, itemData in next, charData.items do
            if istable( itemData.entities ) and #itemData.entities > 0 then
                for i = 1, #itemData.entities do
                    if v == itemData.entities[i] then
                        foundEntity = true
                    end
                end
            end
        end

        for _, partData in next, charData.parts do
            if partData.entity == v then
                foundEntity = true
            end
        end

        if foundEntity then
            local model = ClientsideModel( v:GetModel(), RENDERGROUP_BOTH )
            if not IsValid( model ) then return end

            model:SetParent( ent )
            model:AddEffects( EF_BONEMERGE )
            model:SetNoDraw( true )

            model:SetSkin( v:GetSkin() )

            for _, bg in pairs( v:GetBodyGroups() ) do
                model:SetBodygroup( bg.id, v:GetBodygroup( bg.id ) )
            end

            if v.LinkedItemAdjustables then
                model.LinkedItemAdjustables = v.LinkedItemAdjustables
            end

            ent.Bonemerge[k] = model
        end
    end

    ent.LinkedInfoPanel = infoPanel
end

local PANEL = vgui.GetControlTable( "nutCharInfo" )

function PANEL:OnRemove()
    if not IsValid( self.model ) then return end
    local mdl = self.model
    local ent = mdl.Entity
    if not ent.Bonemerge then return end

    for k, v in pairs( ent.Bonemerge ) do
        if not IsValid( v ) then continue end

        v:Remove()
        ent.Bonemerge[k] = nil
    end
end

vgui.Register( "nutCharInfo", PANEL, "EditablePanel" )