-- "gamemodes\\mafiarp\\plugins\\bonemerge\\cl_vendor.lua"


local PLUGIN = PLUGIN

-- Vendor Opening/Closing
PLUGIN.VendorOrigin = Vector( 34, 281, -83 )
PLUGIN.DefaultBone = "ValveBiped.Bip01_Pelvis"
if game.GetMap() == "rp_southside" or game.GetMap() == "rp_southside_day" then
    PLUGIN.VendorOrigin = Vector( -2030.003540, 10390.573242, 132.031250 )
end

function PLUGIN:CreateVendorModel( ply )
    if not ply:getChar() then return end

    local charData = self.CharacterData[ply:getChar():getID()]
    if not charData then return end

    local modelAngles = ply:GetAngles()
    modelAngles.p = 0

    local ent = ClientsideModel( ply:GetModel() )
    ent:SetPos( self.VendorOrigin )
    ent:SetAngles( modelAngles )
    ent:Spawn()
    ent:SetSequence( "idle_all_01" )
    ent.Bonemerge = {}

    return ent
end

-- I know I'm not fucking following the DRY principle because of the repetition here and in PLUGIN:ManageEntities(), but give me a break I'm sick of this shit.
function PLUGIN:UpdateVendorModel( items )
    local ent = self.VendorModel
    if not IsValid( ent ) then return end

    for k, v in pairs( ent.Bonemerge ) do
        SafeRemoveEntity( v )
    end

    ent.Bonemerge = {}

    local isMale = ent:IsMale()

    local hiddenParts = {
        ["body"] = false,
        ["legs"] = false,
        ["shoes"] = false,
        ["hands"] = false
    }

    local canWearShoes = false

    local tieBodygroup
    local handsValue = 0

    if istable( items ) then
        for class in pairs( items ) do
            local itemMeta = self:GetItemMeta( class )

            local itemEnts = self:CreateEntities( ent, class )

            if itemMeta.RemoveBody and itemMeta.Hands then hiddenParts["body"] = true handsValue = itemMeta.Hands end
            if itemMeta.RemoveLegs then hiddenParts["legs"] = true end
            if itemMeta.RemoveHands then hiddenParts["hands"] = true end
            if itemMeta.slot == "shoes" then hiddenParts["shoes"] = true end
            if itemMeta.CanWearShoes then canWearShoes = true end
            if itemMeta.TieBodygroup then tieBodygroup = itemMeta.TieBodygroup end

            if istable( itemEnts ) and #itemEnts > 0 then
                for i = 1, #itemEnts do
                    local itemEnt = itemEnts[i]
                    if IsValid( itemEnt ) then
                        itemEnt:SetParent( ent )
                        table.insert( ent.Bonemerge, itemEnt )
                    end
                end
            end
        end

        -- We have to do a second loop for tie functionality.
        if tieBodygroup then
            for k, v in pairs( ent.Bonemerge ) do
                local entTiesBodygroupId = v:FindBodygroupByName( "ties" )

                if entTiesBodygroupId and entTiesBodygroupId ~= -1 then
                    v:SetBodygroup( entTiesBodygroupId, tieBodygroup )
                end
            end
        end
    end

    local bodyParts = {
        ["body"] = isMale and MALE_BODY or FEMALE_BODY,
        ["hands"] = isMale and MALE_HANDS or FEMALE_HANDS,
        ["legs"] = isMale and MALE_LEGS or FEMALE_LEGS,
        ["shoes"] = isMale and MALE_SHOES or FEMALE_SHOES
    }

    for partType, model in next, bodyParts do
        if not hiddenParts[partType] and self.ModelCheck[ent:GetModel()] then
            if partType == "shoes" and not canWearShoes then continue end
            if not model or #model == 0 then continue end

            local bonemerge = PLUGIN:CreateNewBonemerge( ent, model )
            if not bonemerge or not IsValid( bonemerge ) then
                continue -- outside of pvs? creation failed.
            end

            if partType == "hands" then
                bonemerge:SetSkin( self.SkinTranslation[ent:GetModel()], 0 )

                if ent:IsFemale() and handsValue > 10 then
                    handsValue = 10
                end

                bonemerge:SetBodygroup( 0, handsValue )
            end

            bonemerge:SetParent( ent )

            table.insert( ent.Bonemerge, bonemerge )
        end
    end
end

function PLUGIN:GetEquippedItemClasses( ply )
    local itemClasses = {}
    local charId = ply:getChar():getID()

    for k, v in next, self.CharacterData[charId].items do
        if v.equipped then
            itemClasses[v.class] = true
        end
    end

    return itemClasses
end

function PLUGIN:OpenVendor( vendor )
    local ply = LocalPlayer()
    ply:SetNoDraw( true )

    for _, v in ipairs( ply:GetBonemergedChildren() ) do
        v:SetNoDraw( true )
    end

    self.InVendor = true
    self.SelectedBone = self.DefaultBone
    self.BonePos = self.VendorOrigin + WorldToLocal( ply:GetBonePosition( ply:LookupBone( self.DefaultBone ) ), ply:GetAngles(), ply:GetPos(), Angle( 0, 0, 0 ) )

    self.VendorModel = self:CreateVendorModel( ply )

    self.VendorPanel = vgui.Create( "nsClothingVendor" )
    self.VendorPanel:SetInfo( vendor, self.VendorModel )
end

function PLUGIN:CloseVendor()
    local ply = LocalPlayer()
    ply:SetNoDraw( false )

    for _, v in ipairs( ply:GetBonemergedChildren() ) do
        v:SetNoDraw( false )
    end

    self.InVendor = nil
    self.SelectedBone = nil
    self.BonePos = nil
    SafeRemoveEntity( self.VendorModel )

    if self.VendorPanel then
        self.VendorPanel:Remove()
    end

    self:FullUpdate()
end

-- Rendering
function PLUGIN:CalcView( ply, origin, angles, fov, znear, zfar )
    if self.InVendor then
        local bonePos = self.BonePos
        local modifiedOrigin = bonePos + ( Angle( 0, angles[2], 0 ):Forward() * 50 ) + ( angles:Right() * 10 )

        local view = {
            origin = modifiedOrigin,
            angles = ( bonePos - modifiedOrigin ):Angle(),
            fov = self.CameraFOV or fov,
            drawviewer = true,
        }

        return view
    end
end

function PLUGIN:PostDrawOpaqueRenderables( depth, skybox )
    if skybox then return end
    if not self.InVendor or not IsValid( self.VendorModel ) then return end

    local ent = self.VendorModel

    if ent.Bonemerge then
        for _, model in pairs( ent.Bonemerge ) do
            model:DrawModel()
        end
    end
end
