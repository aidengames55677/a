-- "gamemodes\\mafiarp\\plugins\\bonemerge\\cl_bonemerge.lua"


local PLUGIN = PLUGIN

function PLUGIN:GetItemMeta( itemClass )
    return nut.item.list[itemClass]
end

function PLUGIN:CreateNewBonemerge( ply, model, boneScale )
    if not model then return end

    local bonemerge = ClientsideModel( model, RENDERGROUP_OPAQUE )
    if not bonemerge then return end
    bonemerge:SetModel( model )
    bonemerge:InvalidateBoneCache()
    bonemerge:SetParent( ply )
    bonemerge:AddEffects( bit.bor( EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES ) )
    bonemerge:SetupBones()

    if boneScale then
        for i = 0, bonemerge:GetBoneCount() - 1 do
            bonemerge:ManipulateBoneScale( i, Vector( boneScale, boneScale, boneScale ) )
        end
    end

    bonemerge.IsBonemergeEntity = true
    bonemerge.Player = ply

    return bonemerge
end

function PLUGIN:UpdateBonemergedEntities()
    for _, ent in pairs( ents.FindByClass( "class C_BaseFlex" ) ) do
        if not ent.IsBonemergeEntity then continue end

        local ply = ent.Player

        if not IsValid( ply ) then
            ent:Remove()
            continue
        end

        if ply:IsPlayer() then
            if ply:GetMoveType() == MOVETYPE_NOCLIP and ply:GetNoDraw() and not ent.bLastDrawState then
                ent:SetNoDraw( true )
            elseif not ply:GetNoDraw() and ent.bLastDrawState then
                ent:SetNoDraw( false )
            end

            if ply.pac_hide_entity then
                ent:SetNoDraw( true )
            end

            local parent = ent:GetParent()

            local ragdollEnt
            if not ply:Alive() and IsValid( ply:GetRagdollEntity() ) then
                ragdollEnt = ply:GetRagdollEntity()
            else
                local falloverRagdoll = ply:getNetVar( "ragdoll", 0 )

                if falloverRagdoll ~= 0 then
                    falloverRagdoll = Entity( falloverRagdoll )
                    if IsValid( falloverRagdoll ) then
                        ragdollEnt = falloverRagdoll
                    end
                end
            end

            if parent == ply and IsValid( ragdollEnt ) and parent ~= ragdollEnt then
                ent:SetParent( ragdollEnt )
            elseif parent ~= ply and not IsValid( ragdollEnt ) then
                ent:SetParent( ply )
            end
        end

        ent.bLastDrawState = ent:GetNoDraw()
    end
end

PLUGIN.CharacterData = PLUGIN.CharacterData or {}

function PLUGIN:EnsureItem( itemId, itemData )
    local charId = itemData.charId

    local charData = self.CharacterData[charId]
    if not charData then
        self.CharacterData[charId] = {
            items = {}
        }

        charData = self.CharacterData[charId]
    end

    if not charData.items then
        charData.items = {}
    end

    local parent = itemData.owner

    charData.items[itemId] = {
        parent = parent,
        class = itemData.class,
        equipped = itemData.equipped,
        charId = charId,
        itemId = itemId
    }

    PLUGIN:ManageEntities( parent, true, true )
end

function PLUGIN:RemoveItem( charId, itemId )
    local charData = self.CharacterData[charId]

    if not charData
    or not charData.items
    or not charData.items[itemId] then return end

    local itemData = charData.items[itemId]
    if not itemData then return end

    if istable( itemData.entities ) and #itemData.entities > 0 then
        for i = 1, #itemData.entities do
            local ent = itemData.entities[i]
            if IsValid( ent ) then
                SafeRemoveEntity( ent )
            end
        end
    end

    charData.items[itemId] = nil
end

local function getBodygroupIndex( ent, bodygroupName )
    for k, v in pairs( ent:GetBodyGroups() ) do
        if v.name == bodygroupName then
            return v.id
        end
    end
end

function PLUGIN:ManageTies( charId, tieBodygroup )
    if not tieBodygroup then
        return
    end

    for k, v in next, self.CharacterData[charId].items do
        if v.equipped then
            local itemMeta = self:GetItemMeta( v.class )

            if itemMeta.base ~= "base_bonemerge" then continue end

            for m in ipairs( itemMeta.Bonemerge ) do
                if not v.entities then continue end
                local ent = v.entities[m]
                if not IsValid( ent ) then continue end
                local entTiesBodygroupId = ent:FindBodygroupByName( "ties" )

                if entTiesBodygroupId and entTiesBodygroupId ~= -1 then
                    ent:SetBodygroup( entTiesBodygroupId, tieBodygroup )
                end
            end
        end
    end
end

function PLUGIN:CreateEntities( ply, itemClass, model )
    if not IsValid( ply ) then return end

    if not model then
        model = ply:GetModel()
    end

    local isMale = self:GetModelGender( model ) == "male"

    local itemMeta = self:GetItemMeta( itemClass )
    if itemMeta.Bonemerge and #itemMeta.Bonemerge > 0 then
        local bonemergeEnts = {}

        for i = 1, #itemMeta.Bonemerge do
            local bonemergeData = itemMeta.Bonemerge[i]
            local mdl = bonemergeData.Model

            local ent = PLUGIN:CreateNewBonemerge( ply, mdl )
            if not ent or not IsValid( ent ) then
                continue
            end

            local bodygroups = bonemergeData.Bodygroups
            if bodygroups then
                for _, bodygroup in next, bodygroups do
                    -- First key in bodygroup is bodygroup index
                    -- Second key in bodygroup is bodygroup value
                    local bodygroupId = getBodygroupIndex( ent, bodygroup[1] )

                    if bodygroupId then
                        ent:SetBodygroup( bodygroupId, bodygroup[2] )
                    end
                end
            end

            if bonemergeData.CalculateSkinTone and not isMale then
                for index, submaterial in next, ent:GetMaterials() do
                    local isCultistShared = submaterial:find( "fem_legs_w" )
                    local isGTAShared = submaterial:find( "legs_white" )

                    if isCultistShared or isGTAShared then
                        local isBlack = self.SkinTranslation[model] == 1
                        local whiteSubmaterial = isCultistShared and "models/cultist/clothing/shared/fem_legs_w" or "models/cultist/clothing/female/legs_white"
                        local blackSubmaterial = isCultistShared and "models/cultist/clothing/shared/fem_legs_b" or "models/cultist/clothing/female/legs_black"

                        ent:SetSubMaterial( index - 1, isBlack and blackSubmaterial or whiteSubmaterial )
                    end
                end
            end

            if bonemergeData.Skin then
                ent:SetSkin( bonemergeData.Skin )
            end

            table.insert( bonemergeEnts, ent )
        end

        if #bonemergeEnts > 0 then
            return bonemergeEnts
        end
    end
end

function PLUGIN:ManageEntities( ply, createEntities, removeEntities, newParent )
    if not IsValid( ply ) or not ply.getChar then return end
    local char = ply:getChar()
    if not char then return end
    local charId = char:getID()
    if not charId or charId == 0 then return end

    local charData = self.CharacterData[charId]
    if not charData then
        charData = {
            items = {}
        }

        self.CharacterData[charId] = charData
    end

    if not charData.items then
        charData.items = {}
    end

    local hiddenParts = {
        ["body"] = false,
        ["legs"] = false,
        ["shoes"] = false,
        ["hands"] = false
    }

    local canWearShoes = false

    local tieBodygroup
    local handsValue = 0

    for itemId, itemData in next, charData.items do
        local itemMeta = self:GetItemMeta( itemData.class )
        itemData.parent = ply

        if removeEntities and istable( itemData.entities ) and #itemData.entities > 0 then
            for i = 1, #itemData.entities do
                local ent = itemData.entities[i]
                if IsValid( ent ) then
                    ent:Remove()
                end
            end
        end

        if createEntities and self.ModelCheck[ply:GetModel()] and itemData.equipped then
            itemData.entities = self:CreateEntities( ply, itemData.class, char:getModel() )

            if itemMeta.RemoveBody and itemMeta.Hands then hiddenParts["body"] = true handsValue = itemMeta.Hands end
            if itemMeta.RemoveLegs then hiddenParts["legs"] = true end
            if itemMeta.RemoveHands then hiddenParts["hands"] = true end
            if itemMeta.slot == "shoes" then hiddenParts["shoes"] = true end
            if itemMeta.CanWearShoes then canWearShoes = true end
            if itemMeta.TieBodygroup then tieBodygroup = itemMeta.TieBodygroup end

            if self.CanAdjust[slot] and #itemData.entities == 1 then
                itemData.entities[1].LinkedItemAdjustables = itemId -- We want to cache the linked item for adjustable items, so we can live update in the F1 menu.
            end
        end

        if istable( itemData.entities ) and #itemData.entities > 0 then
            for i = 1, #itemData.entities do
                local ent = itemData.entities[i]
                if IsValid( ent ) then
                    if IsValid( newParent ) then
                        ent:SetParent( newParent )
                    end

                    ent.slot = itemMeta.slot
                end
            end
        end
    end

    self:ManageTies( charId, tieBodygroup )

    local isMale = self:GetModelGender( char:getModel() ) == "male"

    if not charData.parts then
        charData.parts = {
            ["body"] = {
                model = isMale and MALE_BODY or FEMALE_BODY
            },
            ["hands"] = {
                model = isMale and MALE_HANDS or FEMALE_HANDS
            },
            ["legs"] = {
                model = isMale and MALE_LEGS or FEMALE_LEGS
            },
            ["shoes"] = {
                model = isMale and MALE_SHOES or FEMALE_SHOES
            },
        }
    end

    for partType, partData in next, charData.parts do
        local entity = partData.entity

        if removeEntities and IsValid( entity ) then
            entity:Remove()
        end

        if createEntities and not hiddenParts[partType] and self.ModelCheck[char:getModel()] then
            if partType == "shoes" and not canWearShoes then continue end
            if not partData.model or #partData.model == 0 then continue end

            local ent = PLUGIN:CreateNewBonemerge( ply, partData.model )
            if not ent or not IsValid( ent ) then
                continue -- outside of pvs? creation failed.
            end

            if partType == "hands" then
                ent:SetSkin( self.SkinTranslation[char:getModel()], 0 )

                if not isMale and handsValue > 10 then
                    handsValue = 10
                end

                ent:SetBodygroup( 0, handsValue )
            end

            partData.entity = ent
        end

        if IsValid( newParent ) and IsValid( partData.entity ) then
            partData.entity:SetParent( newParent )
        end
    end

    for _, ent in next, ply:GetBonemergedChildren() do
        local foundEntity = false
        for _, itemData in next, charData.items do
            if istable( itemData.entities ) and #itemData.entities > 0 then
                for i = 1, #itemData.entities do
                    if ent == itemData.entities[i] then
                        foundEntity = true
                    end
                end
            end
        end

        for _, partData in next, charData.parts do
            if partData.entity == ent then
                foundEntity = true
            end
        end

        if not foundEntity then
            ent:Remove()
        end
    end

    -- Very fucking ugly workaround for live updating in the F1 menu.
    if ply == LocalPlayer() then
        for _, v in pairs( ents.FindByClass( "class C_BaseFlex" ) ) do
            if v.LinkedInfoPanel then
                timer.Simple( 0.05, function() -- I literally do not know why this has to be in a timer, but it doesn't work if it's not in one. Doesn't work in a 0 second timer either lmao.
                    if IsValid( v ) and v.LinkedInfoPanel then
                        self:OnCharInfoSetup( v.LinkedInfoPanel )
                    end
                end )
            end
        end
    end
end

function PLUGIN:Clear()
    for _, ent in ipairs( ents.FindByClass( "class C_BaseFlex" ) ) do
        if not ent.IsBonemergeEntity then continue end
        ent:Remove()
    end
end

function PLUGIN:FullUpdate()
    if self.InVendor then return end

    PLUGIN:Clear()

    for _, ply in ipairs( player.GetHumans() ) do
        if not IsValid( ply ) then continue end
        if ply:IsDormant() then continue end

        PLUGIN:ManageEntities( ply, true, true )
    end
end

function PLUGIN:ClearCharacterVars( charId )
    local charData = self.CharacterData[charId]
    if not charData then return end

    if charData.items then
        for itemId in next, charData.items do
            PLUGIN:RemoveItem( charId, itemId )
        end
    end

    self.CharacterData[charId] = nil
end

-- Hooks
hook.Add( "NotifyShouldTransmit", "Bonemerge.NotifyShouldTransmit", function( ent, transmit )
    if not ent:IsPlayer() then return end
    PLUGIN:ManageEntities( ent, transmit, true )
end )

hook.Add( "NetworkEntityCreated", "Bonemerge.NetworkEntityCreated", function( ent )
    if not ent:IsPlayer() then return end
    PLUGIN:ManageEntities( ent, true, true )
end )

hook.Add( "EntityRemoved", "Bonemerge.EntityRemoved", function( ent )
    if not ent:IsPlayer() then return end
    PLUGIN:ManageEntities( ent, nil, true )
end )

hook.Add( "OnReloaded", "Bonemerge.OnReloaded", function()
    PLUGIN:FullUpdate()
end )

function PLUGIN:CharacterLoaded()
    self:FullUpdate()
end

function PLUGIN:PlayerLoadedChar( ply, oldCharId )
    if oldCharId and oldCharId ~= 0 then
        self:ClearCharacterVars( oldCharId )
    end

    if ply ~= LocalPlayer() then
        self:ManageEntities( ply, true, true )
    end
end

gameevent.Listen( "player_spawn" )
hook.Add( "player_spawn", "Bonemerge.player_spawn", function( data )
    local ply = Player( data.userid )
    if not IsValid( ply ) then return end

    if not PLUGIN.ModelCheck[ply:GetModel()] then
        PLUGIN:ManageEntities( ply, nil, true )
        return
    end

    PLUGIN:ManageEntities( ply, true, true )

    if ply == LocalPlayer() then
        PLUGIN:FullUpdate()
    end
end )

gameevent.Listen( "entity_killed" )
hook.Add( "entity_killed", "Bonemerge.entity_killed", function( data )
    local ent = Entity( data.entindex_killed )
    if not ent:IsPlayer() then return end

    timer.Create( "BonemergeSwitchParent" .. data.entindex_killed, 0, 0, function()
        if not IsValid( ent ) then
            timer.Remove( "BonemergeSwitchParent" .. data.entindex_killed )
            return
        end

        local ragdoll = ent:GetRagdollEntity()
        if not IsValid( ragdoll ) then return end

        PLUGIN:ManageEntities( ent, nil, nil, ragdoll )
        timer.Remove( "BonemergeSwitchParent" .. data.entindex_killed )
    end )
end )

timer.Create( "Bonemerge.RefreshTimer", 60, 0, function()
    PLUGIN:FullUpdate()
end )

hook.Add( "Think", "Bonemerge.Think", function()
    PLUGIN:UpdateBonemergedEntities()
end )

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "Bonemerge.player_disconnect", function( data )
    local ply = Player( data.userid )
    if not IsValid( ply ) then return end

    local char = ply:getChar()
    if not char then return end
    local charId = char:getID()
    if not charId or charId == 0 then return end

    PLUGIN:ClearCharacterVars( charId )
end )

hook.Add( "PlayerModelChanged", "Bonemerge.PlayerModelChanged", function( ply )
    if not IsValid( ply ) then return end

    if not PLUGIN.ModelCheck[ply:GetModel()] then
        PLUGIN:ManageEntities( ply, nil, true )
        return
    end

    PLUGIN:ManageEntities( ply, true, true )
end )

local ACCESSOR_HOOKS = {
    RagdollIndex = function( ply, key, value )
        if value ~= -1 then
            timer.Create( "BonemergeSwitchParent" .. value, 0, 0, function()
                if not IsValid( ply ) then
                    timer.Remove( "BonemergeSwitchParent" .. value )
                    return
                end

                local ragdoll = ply:Ragdoll()
                if not IsValid( ragdoll ) then return end

                PLUGIN:ManageEntities( ply, nil, nil, ragdoll )
                timer.Remove( "BonemergeSwitchParent" .. value )
            end )
        else
            PLUGIN:ManageEntities( ply, true, true )
        end
    end,
    Body = function( ply, key, value )
        local char = ply:getChar()
        if not char then return end
        local charId = char:getID()
        if not charId or charId == 0 then return end

        local charData = PLUGIN.CharacterData[charId]
        if not charData then
            PLUGIN.CharacterData[charId] = {}
            charData = PLUGIN.CharacterData[charId]
        end

        local charParts = charData.parts
        if not charParts then
            charData.parts = {}
            charParts = charData.parts
        end

        charParts[string.lower( key )] = {
            model = value
        }

        PLUGIN:ManageEntities( ply, true, true )
    end,
    BodySubMat = function( ply, key, value )
        PLUGIN:ManageEntities( ply, true, true )
    end
}

hook.Add( "PlayerAccessorChanged", "Bonemerge.PlayerAccessorChanged", function( ply, key, value )
    local accessorHook = ACCESSOR_HOOKS[key]
    if not accessorHook then return end

    accessorHook( ply, key, value )
end )