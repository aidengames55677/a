local PLUGIN = PLUGIN

PLUGIN.name = "Le Bonemerge"
PLUGIN.author = "Logan"
PLUGIN.desc = "Honestly, Fuck This System."

function PLUGIN:GetModelGender( model )
    if ( string.lower( model ):find( "female", 1, true ) ) then
        return "female"
    end

    return "male"
end

local entMeta = FindMetaTable( "Entity" )
function entMeta:GetGender()
    return PLUGIN:GetModelGender( self:GetModel() )
end

function entMeta:IsMale()
    return self:GetGender() == "male"
end

function entMeta:IsFemale()
    return self:GetGender() == "female"
end

function entMeta:GetBonemergedChildren()
    local bonemergedChildren = {}

    for _, ent in next, self:GetChildren() do
        if ent:GetClass() == "class C_BaseFlex" and ent:IsEffectActive( EF_BONEMERGE ) then
            table.insert( bonemergedChildren, ent )
        end
    end

    return bonemergedChildren
end

if SERVER then
    util.AddNetworkString("Bonemerge.ReceiveBonemergeItem")
    util.AddNetworkString("Bonemerge.StartAdjustingItem")
    util.AddNetworkString("Bonemerge.OpenVendor")
end

function entMeta:GetBonemergedChildrenBySlot()
    local bonemergedChildren = {}

    for _, ent in next, self:GetChildren() do
        if ent:GetClass() == "class C_BaseFlex" and ent:IsEffectActive( EF_BONEMERGE ) and ent.slot then
            if not bonemergedChildren[ent.slot] then
                bonemergedChildren[ent.slot] = {}
            end

            table.insert( bonemergedChildren[ent.slot], ent )
        end
    end

    return bonemergedChildren
end

PLUGIN.SkinTranslation = {
    ["models/tnb/techcom/male_01.mdl"] = 1,
    ["models/tnb/techcom/male_02.mdl"] = 0,
    ["models/tnb/techcom/male_03.mdl"] = 1,
    ["models/tnb/techcom/male_04.mdl"] = 0,
    ["models/tnb/techcom/male_05.mdl"] = 0,
    ["models/tnb/techcom/male_06.mdl"] = 0,
    ["models/tnb/techcom/male_07.mdl"] = 0,
    ["models/tnb/techcom/male_08.mdl"] = 0,
    ["models/tnb/techcom/male_09.mdl"] = 0,
    ["models/tnb/techcom/male_10.mdl"] = 0,
    ["models/tnb/techcom/male_11.mdl"] = 0,
    ["models/tnb/techcom/male_12.mdl"] = 2,
    ["models/tnb/techcom/male_14.mdl"] = 0,
    ["models/tnb/techcom/male_15.mdl"] = 2,
    ["models/tnb/techcom/male_16.mdl"] = 0,
    ["models/tnb/techcom/male_17.mdl"] = 2,
    ["models/tnb/techcom/male_18.mdl"] = 2,
    ["models/tnb/techcom/male_19.mdl"] = 2,
    ["models/tnb/techcom/male_20.mdl"] = 0,
    ["models/tnb/techcom/male_21.mdl"] = 0,
    ["models/tnb/techcom/male_22.mdl"] = 2,
    ["models/tnb/techcom/male_23.mdl"] = 0,
    ["models/tnb/techcom/male_24.mdl"] = 0,
    ["models/tnb/techcom/male_25.mdl"] = 0,
    ["models/tnb/techcom/male_26.mdl"] = 0,
    ["models/tnb/techcom/male_27.mdl"] = 0,
    ["models/tnb/techcom/male_28.mdl"] = 2,
    ["models/tnb/techcom/male_29.mdl"] = 0,
    ["models/tnb/techcom/male_30.mdl"] = 0,
    ["models/tnb/techcom/male_31.mdl"] = 0,
    ["models/tnb/techcom/male_32.mdl"] = 1,
    ["models/tnb/techcom/male_33.mdl"] = 1,
    ["models/tnb/techcom/male_34.mdl"] = 0,
    ["models/tnb/techcom/male_35.mdl"] = 0,
    ["models/tnb/techcom/male_36.mdl"] = 0,
    ["models/tnb/techcom/male_37.mdl"] = 0,
    ["models/tnb/techcom/male_38.mdl"] = 0,
    ["models/tnb/techcom/male_39.mdl"] = 2,
    ["models/tnb/techcom/male_40.mdl"] = 0,
    ["models/tnb/techcom/male_41.mdl"] = 2,
    ["models/tnb/techcom/male_42.mdl"] = 0,
    ["models/tnb/techcom/male_43.mdl"] = 0,
    ["models/tnb/techcom/male_44.mdl"] = 0,
    ["models/tnb/techcom/male_45.mdl"] = 1,
    ["models/tnb/techcom/male_47.mdl"] = 0,
    ["models/tnb/techcom/male_48.mdl"] = 0,
    ["models/tnb/techcom/male_49.mdl"] = 1,
    ["models/tnb/techcom/male_50.mdl"] = 0,
    ["models/tnb/techcom/male_51.mdl"] = 0,
    ["models/tnb/techcom/male_52.mdl"] = 2,
    ["models/tnb/techcom/male_53.mdl"] = 0,
    ["models/tnb/techcom/male_54.mdl"] = 0,
    ["models/tnb/techcom/male_55.mdl"] = 0,
    ["models/tnb/techcom/male_56.mdl"] = 2,
    ["models/tnb/techcom/male_57.mdl"] = 2,
    ["models/tnb/techcom/male_58.mdl"] = 0,
    ["models/tnb/techcom/male_59.mdl"] = 0,
    ["models/tnb/techcom/male_60.mdl"] = 0,
    ["models/tnb/techcom/male_61.mdl"] = 0,
    ["models/tnb/techcom/male_62.mdl"] = 0,
    ["models/tnb/techcom/male_63.mdl"] = 0,
    ["models/tnb/techcom/male_64.mdl"] = 0,
    ["models/tnb/techcom/male_65.mdl"] = 2,
    ["models/tnb/techcom/male_66.mdl"] = 0,
    ["models/tnb/techcom/male_67.mdl"] = 0,
    ["models/tnb/techcom/male_68.mdl"] = 0,
    ["models/tnb/techcom/male_69.mdl"] = 1,
    ["models/tnb/techcom/male_70.mdl"] = 1,
    ["models/tnb/techcom/male_71.mdl"] = 1,
    ["models/tnb/techcom/male_72.mdl"] = 0,
    ["models/tnb/techcom/male_73.mdl"] = 0,
    ["models/tnb/techcom/male_74.mdl"] = 2,
    ["models/tnb/techcom/male_75.mdl"] = 2,
    ["models/tnb/techcom/male_76.mdl"] = 0,
    ["models/tnb/techcom/male_77.mdl"] = 1,
    ["models/tnb/techcom/male_78.mdl"] = 1,
    ["models/tnb/techcom/male_79.mdl"] = 0,
    ["models/tnb/techcom/male_80.mdl"] = 2,
    ["models/tnb/techcom/male_81.mdl"] = 0,
    ["models/tnb/techcom/male_82.mdl"] = 0,
    ["models/tnb/techcom/male_83.mdl"] = 0,
    ["models/tnb/techcom/male_84.mdl"] = 0,
    ["models/tnb/techcom/male_85.mdl"] = 2,
    ["models/tnb/techcom/male_86.mdl"] = 0,
    ["models/tnb/techcom/male_87.mdl"] = 0,
    ["models/tnb/techcom/male_88.mdl"] = 0,
    ["models/tnb/techcom/male_89.mdl"] = 2,
    ["models/tnb/techcom/male_90.mdl"] = 1,
    ["models/tnb/techcom/male_91.mdl"] = 0,
    ["models/tnb/techcom/male_92.mdl"] = 0,
    ["models/tnb/techcom/male_93.mdl"] = 0,
    ["models/tnb/techcom/male_94.mdl"] = 2,
    ["models/tnb/techcom/male_95.mdl"] = 0,
    ["models/tnb/techcom/male_96.mdl"] = 2,
    ["models/tnb/techcom/male_97.mdl"] = 0,
    ["models/tnb/techcom/male_98.mdl"] = 0,
    ["models/tnb/techcom/male_99.mdl"] = 2,
    ["models/tnb/techcom/male_100.mdl"] = 1,
    ["models/tnb/techcom/female_01.mdl"] = 0,
    ["models/tnb/techcom/female_02.mdl"] = 0,
    ["models/tnb/techcom/female_03.mdl"] = 1,
    ["models/tnb/techcom/female_04.mdl"] = 0,
    ["models/tnb/techcom/female_05.mdl"] = 0,
    ["models/tnb/techcom/female_06.mdl"] = 0,
    ["models/tnb/techcom/female_07.mdl"] = 0,
    ["models/tnb/techcom/female_08.mdl"] = 0,
    ["models/tnb/techcom/female_09.mdl"] = 0,
    ["models/tnb/techcom/female_10.mdl"] = 0,
    ["models/tnb/techcom/female_11.mdl"] = 0,
    ["models/tnb/techcom/female_12.mdl"] = 0,
    ["models/tnb/techcom/female_13.mdl"] = 0,
    ["models/tnb/techcom/female_14.mdl"] = 0,
    ["models/tnb/techcom/female_15.mdl"] = 0,
    ["models/tnb/techcom/female_16.mdl"] = 2,
    ["models/tnb/techcom/female_17.mdl"] = 0,
    ["models/tnb/techcom/female_18.mdl"] = 2,
    ["models/tnb/techcom/female_19.mdl"] = 0,
    ["models/tnb/techcom/female_20.mdl"] = 0,
    ["models/tnb/techcom/female_21.mdl"] = 0,
    ["models/tnb/techcom/female_23.mdl"] = 0,
    ["models/tnb/techcom/female_24.mdl"] = 0,
    ["models/tnb/techcom/female_25.mdl"] = 0,
    ["models/tnb/techcom/female_26.mdl"] = 0,
    ["models/tnb/techcom/female_27.mdl"] = 0,
    ["models/tnb/techcom/female_28.mdl"] = 0,
    ["models/tnb/techcom/female_29.mdl"] = 0,
    ["models/tnb/techcom/female_30.mdl"] = 2,
    ["models/tnb/techcom/female_31.mdl"] = 0,
    ["models/tnb/techcom/female_32.mdl"] = 0,
    ["models/tnb/techcom/female_33.mdl"] = 2,
    ["models/tnb/techcom/female_34.mdl"] = 0,
    ["models/tnb/techcom/female_35.mdl"] = 0,
    ["models/tnb/techcom/female_36.mdl"] = 2,
    ["models/tnb/techcom/female_37.mdl"] = 0,
    ["models/tnb/techcom/female_38.mdl"] = 2,
    ["models/tnb/techcom/female_39.mdl"] = 0,
    ["models/tnb/techcom/female_40.mdl"] = 0,
    ["models/tnb/techcom/female_41.mdl"] = 0,
    ["models/tnb/techcom/female_42.mdl"] = 0,
    ["models/tnb/techcom/female_43.mdl"] = 0,
    ["models/tnb/techcom/female_44.mdl"] = 0,
    ["models/tnb/techcom/female_45.mdl"] = 1,
    ["models/tnb/techcom/female_46.mdl"] = 0,
    ["models/tnb/techcom/female_47.mdl"] = 0,
    ["models/tnb/techcom/female_48.mdl"] = 0,
    ["models/tnb/techcom/female_49.mdl"] = 0,
    ["models/tnb/techcom/female_50.mdl"] = 0,
    ["models/tnb/techcom/female_51.mdl"] = 0,
    ["models/tnb/techcom/female_52.mdl"] = 1,
    ["models/tnb/techcom/female_53.mdl"] = 2,
    ["models/tnb/techcom/female_54.mdl"] = 0,
    ["models/tnb/techcom/female_55.mdl"] = 0,
    ["models/tnb/techcom/female_56.mdl"] = 0,
    ["models/tnb/techcom/female_57.mdl"] = 0,
    ["models/tnb/techcom/female_58.mdl"] = 0,
    ["models/tnb/techcom/female_60.mdl"] = 0,
    ["models/tnb/techcom/female_61.mdl"] = 0,
    ["models/tnb/techcom/female_62.mdl"] = 0,
    ["models/tnb/techcom/female_63.mdl"] = 2,
    ["models/tnb/techcom/female_64.mdl"] = 2,
    ["models/tnb/techcom/female_65.mdl"] = 0,
    ["models/tnb/techcom/female_66.mdl"] = 2,
    ["models/tnb/techcom/female_67.mdl"] = 0,
    ["models/tnb/techcom/female_68.mdl"] = 0,
    ["models/tnb/techcom/female_70.mdl"] = 1,
    ["models/tnb/techcom/female_71.mdl"] = 0,
    ["models/tnb/techcom/female_72.mdl"] = 0,
    ["models/tnb/techcom/female_73.mdl"] = 2,
    ["models/tnb/techcom/female_74.mdl"] = 0,
}

PLUGIN.ModelCheck = {
    ["models/cultist/heads/female_01.mdl"] = true,
    ["models/tnb/techcom/male_01.mdl"] = true,
    ["models/tnb/techcom/male_02.mdl"] = true,
    ["models/tnb/techcom/male_03.mdl"] = true,
    ["models/tnb/techcom/male_04.mdl"] = true,
    ["models/tnb/techcom/male_05.mdl"] = true,
    ["models/tnb/techcom/male_06.mdl"] = true,
    ["models/tnb/techcom/male_07.mdl"] = true,
    ["models/tnb/techcom/male_08.mdl"] = true,
    ["models/tnb/techcom/male_09.mdl"] = true,
    ["models/tnb/techcom/male_10.mdl"] = true,
    ["models/tnb/techcom/male_11.mdl"] = true,
    ["models/tnb/techcom/male_12.mdl"] = true,
    ["models/tnb/techcom/male_14.mdl"] = true,
    ["models/tnb/techcom/male_15.mdl"] = true,
    ["models/tnb/techcom/male_16.mdl"] = true,
    ["models/tnb/techcom/male_17.mdl"] = true,
    ["models/tnb/techcom/male_18.mdl"] = true,
    ["models/tnb/techcom/male_19.mdl"] = true,
    ["models/tnb/techcom/male_20.mdl"] = true,
    ["models/tnb/techcom/male_21.mdl"] = true,
    ["models/tnb/techcom/male_22.mdl"] = true,
    ["models/tnb/techcom/male_23.mdl"] = true,
    ["models/tnb/techcom/male_24.mdl"] = true,
    ["models/tnb/techcom/male_25.mdl"] = true,
    ["models/tnb/techcom/male_26.mdl"] = true,
    ["models/tnb/techcom/male_27.mdl"] = true,
    ["models/tnb/techcom/male_28.mdl"] = true,
    ["models/tnb/techcom/male_29.mdl"] = true,
    ["models/tnb/techcom/male_30.mdl"] = true,
    ["models/tnb/techcom/male_31.mdl"] = true,
    ["models/tnb/techcom/male_32.mdl"] = true,
    ["models/tnb/techcom/male_33.mdl"] = true,
    ["models/tnb/techcom/male_34.mdl"] = true,
    ["models/tnb/techcom/male_35.mdl"] = true,
    ["models/tnb/techcom/male_36.mdl"] = true,
    ["models/tnb/techcom/male_37.mdl"] = true,
    ["models/tnb/techcom/male_38.mdl"] = true,
    ["models/tnb/techcom/male_39.mdl"] = true,
    ["models/tnb/techcom/male_40.mdl"] = true,
    ["models/tnb/techcom/male_41.mdl"] = true,
    ["models/tnb/techcom/male_42.mdl"] = true,
    ["models/tnb/techcom/male_43.mdl"] = true,
    ["models/tnb/techcom/male_44.mdl"] = true,
    ["models/tnb/techcom/male_45.mdl"] = true,
    ["models/tnb/techcom/male_47.mdl"] = true,
    ["models/tnb/techcom/male_48.mdl"] = true,
    ["models/tnb/techcom/male_49.mdl"] = true,
    ["models/tnb/techcom/male_50.mdl"] = true,
    ["models/tnb/techcom/male_51.mdl"] = true,
    ["models/tnb/techcom/male_52.mdl"] = true,
    ["models/tnb/techcom/male_53.mdl"] = true,
    ["models/tnb/techcom/male_54.mdl"] = true,
    ["models/tnb/techcom/male_55.mdl"] = true,
    ["models/tnb/techcom/male_56.mdl"] = true,
    ["models/tnb/techcom/male_57.mdl"] = true,
    ["models/tnb/techcom/male_58.mdl"] = true,
    ["models/tnb/techcom/male_59.mdl"] = true,
    ["models/tnb/techcom/male_60.mdl"] = true,
    ["models/tnb/techcom/male_61.mdl"] = true,
    ["models/tnb/techcom/male_62.mdl"] = true,
    ["models/tnb/techcom/male_63.mdl"] = true,
    ["models/tnb/techcom/male_64.mdl"] = true,
    ["models/tnb/techcom/male_65.mdl"] = true,
    ["models/tnb/techcom/male_66.mdl"] = true,
    ["models/tnb/techcom/male_67.mdl"] = true,
    ["models/tnb/techcom/male_68.mdl"] = true,
    ["models/tnb/techcom/male_69.mdl"] = true,
    ["models/tnb/techcom/male_70.mdl"] = true,
    ["models/tnb/techcom/male_71.mdl"] = true,
    ["models/tnb/techcom/male_72.mdl"] = true,
    ["models/tnb/techcom/male_73.mdl"] = true,
    ["models/tnb/techcom/male_74.mdl"] = true,
    ["models/tnb/techcom/male_75.mdl"] = true,
    ["models/tnb/techcom/male_76.mdl"] = true,
    ["models/tnb/techcom/male_77.mdl"] = true,
    ["models/tnb/techcom/male_78.mdl"] = true,
    ["models/tnb/techcom/male_79.mdl"] = true,
    ["models/tnb/techcom/male_80.mdl"] = true,
    ["models/tnb/techcom/male_81.mdl"] = true,
    ["models/tnb/techcom/male_82.mdl"] = true,
    ["models/tnb/techcom/male_83.mdl"] = true,
    ["models/tnb/techcom/male_84.mdl"] = true,
    ["models/tnb/techcom/male_85.mdl"] = true,
    ["models/tnb/techcom/male_86.mdl"] = true,
    ["models/tnb/techcom/male_87.mdl"] = true,
    ["models/tnb/techcom/male_88.mdl"] = true,
    ["models/tnb/techcom/male_89.mdl"] = true,
    ["models/tnb/techcom/male_90.mdl"] = true,
    ["models/tnb/techcom/male_91.mdl"] = true,
    ["models/tnb/techcom/male_92.mdl"] = true,
    ["models/tnb/techcom/male_93.mdl"] = true,
    ["models/tnb/techcom/male_94.mdl"] = true,
    ["models/tnb/techcom/male_95.mdl"] = true,
    ["models/tnb/techcom/male_96.mdl"] = true,
    ["models/tnb/techcom/male_97.mdl"] = true,
    ["models/tnb/techcom/male_98.mdl"] = true,
    ["models/tnb/techcom/male_99.mdl"] = true,
    ["models/tnb/techcom/male_100.mdl"] = true,
    ["models/tnb/techcom/female_01.mdl"] = true,
    ["models/tnb/techcom/female_02.mdl"] = true,
    ["models/tnb/techcom/female_03.mdl"] = true,
    ["models/tnb/techcom/female_04.mdl"] = true,
    ["models/tnb/techcom/female_05.mdl"] = true,
    ["models/tnb/techcom/female_06.mdl"] = true,
    ["models/tnb/techcom/female_07.mdl"] = true,
    ["models/tnb/techcom/female_08.mdl"] = true,
    ["models/tnb/techcom/female_09.mdl"] = true,
    ["models/tnb/techcom/female_10.mdl"] = true,
    ["models/tnb/techcom/female_11.mdl"] = true,
    ["models/tnb/techcom/female_12.mdl"] = true,
    ["models/tnb/techcom/female_13.mdl"] = true,
    ["models/tnb/techcom/female_14.mdl"] = true,
    ["models/tnb/techcom/female_15.mdl"] = true,
    ["models/tnb/techcom/female_16.mdl"] = true,
    ["models/tnb/techcom/female_17.mdl"] = true,
    ["models/tnb/techcom/female_18.mdl"] = true,
    ["models/tnb/techcom/female_19.mdl"] = true,
    ["models/tnb/techcom/female_20.mdl"] = true,
    ["models/tnb/techcom/female_21.mdl"] = true,
    ["models/tnb/techcom/female_23.mdl"] = true,
    ["models/tnb/techcom/female_24.mdl"] = true,
    ["models/tnb/techcom/female_25.mdl"] = true,
    ["models/tnb/techcom/female_26.mdl"] = true,
    ["models/tnb/techcom/female_27.mdl"] = true,
    ["models/tnb/techcom/female_28.mdl"] = true,
    ["models/tnb/techcom/female_29.mdl"] = true,
    ["models/tnb/techcom/female_30.mdl"] = true,
    ["models/tnb/techcom/female_31.mdl"] = true,
    ["models/tnb/techcom/female_32.mdl"] = true,
    ["models/tnb/techcom/female_33.mdl"] = true,
    ["models/tnb/techcom/female_34.mdl"] = true,
    ["models/tnb/techcom/female_35.mdl"] = true,
    ["models/tnb/techcom/female_36.mdl"] = true,
    ["models/tnb/techcom/female_37.mdl"] = true,
    ["models/tnb/techcom/female_38.mdl"] = true,
    ["models/tnb/techcom/female_39.mdl"] = true,
    ["models/tnb/techcom/female_40.mdl"] = true,
    ["models/tnb/techcom/female_41.mdl"] = true,
    ["models/tnb/techcom/female_42.mdl"] = true,
    ["models/tnb/techcom/female_43.mdl"] = true,
    ["models/tnb/techcom/female_44.mdl"] = true,
    ["models/tnb/techcom/female_45.mdl"] = true,
    ["models/tnb/techcom/female_46.mdl"] = true,
    ["models/tnb/techcom/female_47.mdl"] = true,
    ["models/tnb/techcom/female_48.mdl"] = true,
    ["models/tnb/techcom/female_49.mdl"] = true,
    ["models/tnb/techcom/female_50.mdl"] = true,
    ["models/tnb/techcom/female_51.mdl"] = true,
    ["models/tnb/techcom/female_52.mdl"] = true,
    ["models/tnb/techcom/female_53.mdl"] = true,
    ["models/tnb/techcom/female_54.mdl"] = true,
    ["models/tnb/techcom/female_55.mdl"] = true,
    ["models/tnb/techcom/female_56.mdl"] = true,
    ["models/tnb/techcom/female_57.mdl"] = true,
    ["models/tnb/techcom/female_58.mdl"] = true,
    ["models/tnb/techcom/female_60.mdl"] = true,
    ["models/tnb/techcom/female_61.mdl"] = true,
    ["models/tnb/techcom/female_62.mdl"] = true,
    ["models/tnb/techcom/female_63.mdl"] = true,
    ["models/tnb/techcom/female_64.mdl"] = true,
    ["models/tnb/techcom/female_65.mdl"] = true,
    ["models/tnb/techcom/female_66.mdl"] = true,
    ["models/tnb/techcom/female_67.mdl"] = true,
    ["models/tnb/techcom/female_68.mdl"] = true,
    ["models/tnb/techcom/female_70.mdl"] = true,
    ["models/tnb/techcom/female_71.mdl"] = true,
    ["models/tnb/techcom/female_72.mdl"] = true,
    ["models/tnb/techcom/female_73.mdl"] = true,
    ["models/tnb/techcom/female_74.mdl"] = true,
}

PLUGIN.CanAdjust = {
    ["hats"] = true,
    ["glasses"] = true,
    ["neck"] = true,
    ["wrist"] = true,
    ["rightring"] = true,
    ["leftring"] = true,
    ["vest"] = true,
    ["face"] = true,
}

for model,_ in next, PLUGIN.ModelCheck do
    nut.anim.setModelClass( model, "player" )
end

local citizen = nut.faction.teams["citizen"]
if citizen then
    citizen.models = {}

    for model,_ in next, PLUGIN.ModelCheck do
        citizen.models[#citizen.models + 1] = model
    end
end

MALE_HANDS = "models/cultist/arm_set/male_arms.mdl"
FEMALE_HANDS = "models/cultist/arm_set/female_arms.mdl"

MALE_BODY = "models/cultist/clothing/male/ega_tshirt.mdl"
FEMALE_BODY = "models/cultist/clothing/female/aw_femshirt.mdl"

MALE_LEGS = "models/cultist/clothing/male/jeans.mdl"
FEMALE_LEGS = "models/cultist/clothing/female/zur_femjeans.mdl"

MALE_SHOES = "models/cultist/clothing/male/lowtopvans.mdl"
FEMALE_SHOES = "models/cultist/clothing/female/lowtopchucks.mdl"

nut.util.include( "sv_plugin.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_bonemerge.lua" )
nut.util.include( "cl_network.lua" )
--nut.util.include( "cl_vendor.lua" )

Bonemerge = PLUGIN