-- "gamemodes\\mafiarp\\plugins\\bonemerge\\derma\\cl_creation.lua"


local PLUGIN = PLUGIN

hook.Add( "InitializedPlugins", "Bonemerge.DetourCharacterCreation", function()
    local PANEL = vgui.GetControlTable( "nutCharacterCreation" )

    function PANEL:updateModel()
        local faction = nut.faction.indices[self.context.faction]
        assert( faction, "invalid faction when updating model" )
        local modelInfo = faction.models[self.context.model or 1]
        assert( modelInfo, "faction " .. faction.name .. " has no models!" )

        local model, skin, groups
        if istable( modelInfo ) then
            model, skin, groups = unpack( modelInfo )
        else
            model, skin, groups = modelInfo, 0, {}
        end

        self.model:SetModel( model )
        local entity = self.model:GetEntity()
        if not IsValid( entity ) then return end
        entity:SetSkin( skin )
        if istable( groups ) then
            for group, value in pairs( groups ) do
                entity:SetBodygroup( group, value )
            end
        elseif isstring( groups ) then
            entity:SetBodyGroups( groups )
        end

        if self.context.skin then
            entity:SetSkin( self.context.skin )
        end

        if self.context.groups then
            for group, value in pairs( self.context.groups or {} ) do
                entity:SetBodygroup( group, value )
            end
        end

        if faction.material then
            entity:SetMaterial( faction.material )
        end

        /*
            frankly just god awful code but i only got 24 hours left
        */

        if entity.Bonemerge and #entity.Bonemerge > 0 then
            for _, ent in ipairs( entity.Bonemerge ) do
                ent:Remove()
                ent.Bonemerge[_] = nil
            end
        end

        entity.Bonemerge = {}

        local isFemale = PLUGIN:GetModelGender( model ) == "female"
        local hands = isFemale and FEMALE_HANDS or MALE_HANDS
        local body = isFemale and FEMALE_BODY or MALE_BODY
        local legs = isFemale and FEMALE_LEGS or MALE_LEGS

        local handsEntity = ClientsideModel( hands, RENDERGROUP_BOTH )
        if not IsValid( handsEntity ) then return end

        handsEntity:SetParent( entity )
        handsEntity:AddEffects( EF_BONEMERGE )
        handsEntity:SetNoDraw( true )
        handsEntity:SetSkin( PLUGIN.SkinTranslation[model] or 0 )

        entity.Bonemerge[#entity.Bonemerge + 1] = handsEntity

        local bodyEntity = ClientsideModel( body, RENDERGROUP_BOTH )
        if not IsValid( bodyEntity ) then return end

        bodyEntity:SetParent( entity )
        bodyEntity:AddEffects( EF_BONEMERGE )
        bodyEntity:SetNoDraw( true )

        entity.Bonemerge[#entity.Bonemerge + 1] = bodyEntity

        local legsEntity = ClientsideModel( legs, RENDERGROUP_BOTH )
        if not IsValid( legsEntity ) then return end

        legsEntity:SetParent( entity )
        legsEntity:AddEffects( EF_BONEMERGE )
        legsEntity:SetNoDraw( true )

        entity.Bonemerge[#entity.Bonemerge + 1] = legsEntity
    end

    vgui.Register( "nutCharacterCreation", PANEL, "EditablePanel" )
end )