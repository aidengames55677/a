-- "gamemodes\\mafiarp\\plugins\\bonemerge\\sh_plugin.lua"


local PLUGIN = PLUGIN

PLUGIN.name = "Bonemerge"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "Strut in style."

function PLUGIN:GetModelGender( model )
    if ( string.lower( model ):find( "female", 1, true ) ) then
        return "female"
    end

    return "male"
end

function PLUGIN:HasCustomHead( ply, model )
    local steamID, gender = ply:SteamID(), ply:GetGender()

    if model then
        local head = PLUGIN.CustomHeads[model]
        return head and head.Access[steamID] and gender == head.Gender
    else
        for _, head in pairs( PLUGIN.CustomHeads ) do
            if head.Access[steamID] and gender == head.Gender then
                return true
            end
        end
    end
    return false
end

function PLUGIN:IsCustomHead( model )
    return PLUGIN.CustomHeads[model] ~= nil
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

/*
    0 = White
    1 = Black  
    2 = Asian
*/

PLUGIN.CustomHeads = {
    ["models/tnb/techcom/brot/diverge/male_119.mdl"] = {
        Gender = "male",
        Skin = 0,
        Access = {
            ["STEAM_0:0:175606500"] = true,
        }
    },    
    
    ["models/tnb/techcom/brot/diverge/male_114.mdl"] = {
        Gender = "male",
        Skin = 0,
        Access = {
            ["STEAM_0:1:43191126"] = true,
        }
    },    
    
    ["models/tnb/techcom/brot/diverge/female_liz.mdl"] = {
        Gender = "female",
        Skin = 0,
        Access = {
            ["STEAM_0:1:70905"] = true,
        }
    },    
    
    ["models/tnb/techcom/brot/diverge/male_109.mdl"] = {
        Gender = "male",
        Skin = 0,
        Access = {
            ["STEAM_0:1:434305432"] = true,
        }
    },    
    
    ["models/tnb/techcom/brot/diverge/male_110.mdl"] = {
        Gender = "male",
        Skin = 0,
        Access = {
            ["STEAM_0:1:434305432"] = true,
            ["STEAM_0:0:209358482"] = true, 
            ["STEAM_0:1:98870025"] = true, 
            ["STEAM_0:1:123057891"] = true, 
        }
    }, 

    ["models/tnb/techcom/brot/diverge/male_vito.mdl"] = {
        Gender = "male",
        Skin = 0,
        Access = {
            ["STEAM_0:0:175606500"] = true,
        }
    },     
    
    ["models/tnb/techcom/brot/diverge/female_meredith.mdl"] = {
        Gender = "female",
        Skin = 0,
        Access = {
            ["STEAM_0:0:420758647"] = true,
            ["STEAM_0:0:1015165"] = true,
        }
    },    
    
    ["models/diverge/clothing/male/anzati/toni_head.mdl"] = {
        Gender = "male",
        Skin = 0,
        Access = {
            ["STEAM_0:1:183121115"] = true,
            ["STEAM_0:0:1015165"] = true,
        }
    },     
    ["models/diverge/heads/male/laden.mdl"] = {
        Gender = "male",
        Skin = 2,
        Access = {
            ["STEAM_0:0:60061570"] = true,
            ["STEAM_0:1:508048361"] = true,
        }
    }, 
}

PLUGIN.SkinTranslation = {
    ["models/tnb/techcom/brot/male_01.mdl"] = 1,
    ["models/tnb/techcom/brot/male_02.mdl"] = 0,
    ["models/tnb/techcom/brot/male_03.mdl"] = 1,
    ["models/tnb/techcom/brot/male_04.mdl"] = 0,
    ["models/tnb/techcom/brot/male_05.mdl"] = 0,
    ["models/tnb/techcom/brot/male_06.mdl"] = 0,
    ["models/tnb/techcom/brot/male_07.mdl"] = 0,
    ["models/tnb/techcom/brot/male_08.mdl"] = 0,
    ["models/tnb/techcom/brot/male_09.mdl"] = 0,
    ["models/tnb/techcom/brot/male_10.mdl"] = 0,
    ["models/tnb/techcom/brot/male_11.mdl"] = 0,
    ["models/tnb/techcom/brot/male_12.mdl"] = 2,
    ["models/tnb/techcom/brot/male_14.mdl"] = 0,
    ["models/tnb/techcom/brot/male_15.mdl"] = 2,
    ["models/tnb/techcom/brot/male_16.mdl"] = 0,
    ["models/tnb/techcom/brot/male_17.mdl"] = 2,
    ["models/tnb/techcom/brot/male_18.mdl"] = 2,
    ["models/tnb/techcom/brot/male_19.mdl"] = 2,
    ["models/tnb/techcom/brot/male_20.mdl"] = 0,
    ["models/tnb/techcom/brot/male_21.mdl"] = 0,
    ["models/tnb/techcom/brot/male_22.mdl"] = 2,
    ["models/tnb/techcom/brot/male_23.mdl"] = 0,
    ["models/tnb/techcom/brot/male_24.mdl"] = 0,
    ["models/tnb/techcom/brot/male_25.mdl"] = 0,
    ["models/tnb/techcom/brot/male_26.mdl"] = 0,
    ["models/tnb/techcom/brot/male_27.mdl"] = 0,
    ["models/tnb/techcom/brot/male_28.mdl"] = 2,
    ["models/tnb/techcom/brot/male_29.mdl"] = 0,
    ["models/tnb/techcom/brot/male_30.mdl"] = 0,
    ["models/tnb/techcom/brot/male_31.mdl"] = 0,
    ["models/tnb/techcom/brot/male_32.mdl"] = 1,
    ["models/tnb/techcom/brot/male_33.mdl"] = 1,
    ["models/tnb/techcom/brot/male_34.mdl"] = 0,
    ["models/tnb/techcom/brot/male_35.mdl"] = 0,
    ["models/tnb/techcom/brot/male_36.mdl"] = 0,
    ["models/tnb/techcom/brot/male_37.mdl"] = 0,
    ["models/tnb/techcom/brot/male_38.mdl"] = 0,
    ["models/tnb/techcom/brot/male_39.mdl"] = 2,
    ["models/tnb/techcom/brot/male_40.mdl"] = 0,
    ["models/tnb/techcom/brot/male_41.mdl"] = 2,
    ["models/tnb/techcom/brot/male_42.mdl"] = 0,
    ["models/tnb/techcom/brot/male_43.mdl"] = 0,
    ["models/tnb/techcom/brot/male_44.mdl"] = 0,
    ["models/tnb/techcom/brot/male_45.mdl"] = 1,
    ["models/tnb/techcom/brot/male_47.mdl"] = 0,
    ["models/tnb/techcom/brot/male_48.mdl"] = 0,
    ["models/tnb/techcom/brot/male_49.mdl"] = 1,
    ["models/tnb/techcom/brot/male_50.mdl"] = 0,
    ["models/tnb/techcom/brot/male_51.mdl"] = 0,
    ["models/tnb/techcom/brot/male_52.mdl"] = 2,
    ["models/tnb/techcom/brot/male_53.mdl"] = 0,
    ["models/tnb/techcom/brot/male_54.mdl"] = 0,
    ["models/tnb/techcom/brot/male_55.mdl"] = 0,
    ["models/tnb/techcom/brot/male_56.mdl"] = 2,
    ["models/tnb/techcom/brot/male_57.mdl"] = 2,
    ["models/tnb/techcom/brot/male_58.mdl"] = 0,
    ["models/tnb/techcom/brot/male_59.mdl"] = 0,
    ["models/tnb/techcom/brot/male_60.mdl"] = 0,
    ["models/tnb/techcom/brot/male_61.mdl"] = 0,
    ["models/tnb/techcom/brot/male_62.mdl"] = 0,
    ["models/tnb/techcom/brot/male_63.mdl"] = 0,
    ["models/tnb/techcom/brot/male_64.mdl"] = 0,
    ["models/tnb/techcom/brot/male_65.mdl"] = 2,
    ["models/tnb/techcom/brot/male_66.mdl"] = 0,
    ["models/tnb/techcom/brot/male_67.mdl"] = 0,
    ["models/tnb/techcom/brot/male_68.mdl"] = 0,
    ["models/tnb/techcom/brot/male_69.mdl"] = 1,
    ["models/tnb/techcom/brot/male_70.mdl"] = 1,
    ["models/tnb/techcom/brot/male_71.mdl"] = 1,
    ["models/tnb/techcom/brot/male_72.mdl"] = 0,
    ["models/tnb/techcom/brot/male_73.mdl"] = 0,
    ["models/tnb/techcom/brot/male_74.mdl"] = 2,
    ["models/tnb/techcom/brot/male_75.mdl"] = 2,
    ["models/tnb/techcom/brot/male_76.mdl"] = 0,
    ["models/tnb/techcom/brot/male_77.mdl"] = 1,
    ["models/tnb/techcom/brot/male_78.mdl"] = 1,
    ["models/tnb/techcom/brot/male_79.mdl"] = 0,
    ["models/tnb/techcom/brot/male_80.mdl"] = 2,
    ["models/tnb/techcom/brot/male_81.mdl"] = 0,
    ["models/tnb/techcom/brot/male_82.mdl"] = 0,
    ["models/tnb/techcom/brot/male_83.mdl"] = 0,
    ["models/tnb/techcom/brot/male_84.mdl"] = 0,
    ["models/tnb/techcom/brot/male_85.mdl"] = 2,
    ["models/tnb/techcom/brot/male_86.mdl"] = 0,
    ["models/tnb/techcom/brot/male_87.mdl"] = 0,
    ["models/tnb/techcom/brot/male_88.mdl"] = 0,
    ["models/tnb/techcom/brot/male_89.mdl"] = 2,
    ["models/tnb/techcom/brot/male_90.mdl"] = 1,
    ["models/tnb/techcom/brot/male_91.mdl"] = 0,
    ["models/tnb/techcom/brot/male_92.mdl"] = 0,
    ["models/tnb/techcom/brot/male_93.mdl"] = 0,
    ["models/tnb/techcom/brot/male_94.mdl"] = 2,
    ["models/tnb/techcom/brot/male_95.mdl"] = 0,
    ["models/tnb/techcom/brot/male_96.mdl"] = 2,
    ["models/tnb/techcom/brot/male_97.mdl"] = 0,
    ["models/tnb/techcom/brot/male_98.mdl"] = 0,
    ["models/tnb/techcom/brot/male_99.mdl"] = 2,
    ["models/tnb/techcom/brot/male_100.mdl"] = 1,
    ["models/tnb/techcom/brot/female_01.mdl"] = 0,
    ["models/tnb/techcom/brot/female_02.mdl"] = 0,
    ["models/tnb/techcom/brot/female_03.mdl"] = 1,
    ["models/tnb/techcom/brot/female_04.mdl"] = 0,
    ["models/tnb/techcom/brot/female_05.mdl"] = 0,
    ["models/tnb/techcom/brot/female_06.mdl"] = 0,
    ["models/tnb/techcom/brot/female_07.mdl"] = 0,
    ["models/tnb/techcom/brot/female_08.mdl"] = 0,
    ["models/tnb/techcom/brot/female_09.mdl"] = 0,
    ["models/tnb/techcom/brot/female_10.mdl"] = 0,
    ["models/tnb/techcom/brot/female_11.mdl"] = 0,
    ["models/tnb/techcom/brot/female_12.mdl"] = 0,
    ["models/tnb/techcom/brot/female_13.mdl"] = 0,
    ["models/tnb/techcom/brot/female_14.mdl"] = 0,
    ["models/tnb/techcom/brot/female_15.mdl"] = 0,
    ["models/tnb/techcom/brot/female_16.mdl"] = 2,
    ["models/tnb/techcom/brot/female_17.mdl"] = 0,
    ["models/tnb/techcom/brot/female_18.mdl"] = 2,
    ["models/tnb/techcom/brot/female_19.mdl"] = 0,
    ["models/tnb/techcom/brot/female_20.mdl"] = 0,
    ["models/tnb/techcom/brot/female_21.mdl"] = 0,
    ["models/tnb/techcom/brot/female_23.mdl"] = 0,
    ["models/tnb/techcom/brot/female_24.mdl"] = 0,
    ["models/tnb/techcom/brot/female_25.mdl"] = 0,
    ["models/tnb/techcom/brot/female_26.mdl"] = 0,
    ["models/tnb/techcom/brot/female_27.mdl"] = 0,
    ["models/tnb/techcom/brot/female_28.mdl"] = 0,
    ["models/tnb/techcom/brot/female_29.mdl"] = 0,
    ["models/tnb/techcom/brot/female_30.mdl"] = 2,
    ["models/tnb/techcom/brot/female_31.mdl"] = 0,
    ["models/tnb/techcom/brot/female_32.mdl"] = 0,
    ["models/tnb/techcom/brot/female_33.mdl"] = 2,
    ["models/tnb/techcom/brot/female_34.mdl"] = 0,
    ["models/tnb/techcom/brot/female_35.mdl"] = 0,
    ["models/tnb/techcom/brot/female_36.mdl"] = 2,
    ["models/tnb/techcom/brot/female_37.mdl"] = 0,
    ["models/tnb/techcom/brot/female_38.mdl"] = 2,
    ["models/tnb/techcom/brot/female_39.mdl"] = 0,
    ["models/tnb/techcom/brot/female_40.mdl"] = 0,
    ["models/tnb/techcom/brot/female_41.mdl"] = 0,
    ["models/tnb/techcom/brot/female_42.mdl"] = 0,
    ["models/tnb/techcom/brot/female_43.mdl"] = 0,
    ["models/tnb/techcom/brot/female_44.mdl"] = 0,
    ["models/tnb/techcom/brot/female_45.mdl"] = 1,
    ["models/tnb/techcom/brot/female_46.mdl"] = 0,
    ["models/tnb/techcom/brot/female_47.mdl"] = 0,
    ["models/tnb/techcom/brot/female_48.mdl"] = 0,
    ["models/tnb/techcom/brot/female_49.mdl"] = 0,
    ["models/tnb/techcom/brot/female_50.mdl"] = 0,
    ["models/tnb/techcom/brot/female_51.mdl"] = 0,
    ["models/tnb/techcom/brot/female_52.mdl"] = 1,
    ["models/tnb/techcom/brot/female_53.mdl"] = 2,
    ["models/tnb/techcom/brot/female_54.mdl"] = 0,
    ["models/tnb/techcom/brot/female_55.mdl"] = 0,
    ["models/tnb/techcom/brot/female_56.mdl"] = 0,
    ["models/tnb/techcom/brot/female_57.mdl"] = 0,
    ["models/tnb/techcom/brot/female_58.mdl"] = 0,
    ["models/tnb/techcom/brot/female_60.mdl"] = 0,
    ["models/tnb/techcom/brot/female_61.mdl"] = 0,
    ["models/tnb/techcom/brot/female_62.mdl"] = 0,
    ["models/tnb/techcom/brot/female_63.mdl"] = 2,
    ["models/tnb/techcom/brot/female_64.mdl"] = 2,
    ["models/tnb/techcom/brot/female_65.mdl"] = 0,
    ["models/tnb/techcom/brot/female_66.mdl"] = 2,
    ["models/tnb/techcom/brot/female_67.mdl"] = 0,
    ["models/tnb/techcom/brot/female_68.mdl"] = 0,
    ["models/tnb/techcom/brot/female_70.mdl"] = 1,
    ["models/tnb/techcom/brot/female_71.mdl"] = 0,
    ["models/tnb/techcom/brot/female_72.mdl"] = 0,
    ["models/tnb/techcom/brot/female_73.mdl"] = 2,
    ["models/tnb/techcom/brot/female_74.mdl"] = 0,
}

PLUGIN.ModelCheck = {
    ["models/cultist/heads/female_01.mdl"] = true,
    ["models/tnb/techcom/brot/male_01.mdl"] = true,
    ["models/tnb/techcom/brot/male_02.mdl"] = true,
    ["models/tnb/techcom/brot/male_03.mdl"] = true,
    ["models/tnb/techcom/brot/male_04.mdl"] = true,
    ["models/tnb/techcom/brot/male_05.mdl"] = true,
    ["models/tnb/techcom/brot/male_06.mdl"] = true,
    ["models/tnb/techcom/brot/male_07.mdl"] = true,
    ["models/tnb/techcom/brot/male_08.mdl"] = true,
    ["models/tnb/techcom/brot/male_09.mdl"] = true,
    ["models/tnb/techcom/brot/male_10.mdl"] = true,
    ["models/tnb/techcom/brot/male_11.mdl"] = true,
    ["models/tnb/techcom/brot/male_12.mdl"] = true,
    ["models/tnb/techcom/brot/male_14.mdl"] = true,
    ["models/tnb/techcom/brot/male_15.mdl"] = true,
    ["models/tnb/techcom/brot/male_16.mdl"] = true,
    ["models/tnb/techcom/brot/male_17.mdl"] = true,
    ["models/tnb/techcom/brot/male_18.mdl"] = true,
    ["models/tnb/techcom/brot/male_19.mdl"] = true,
    ["models/tnb/techcom/brot/male_20.mdl"] = true,
    ["models/tnb/techcom/brot/male_21.mdl"] = true,
    ["models/tnb/techcom/brot/male_22.mdl"] = true,
    ["models/tnb/techcom/brot/male_23.mdl"] = true,
    ["models/tnb/techcom/brot/male_24.mdl"] = true,
    ["models/tnb/techcom/brot/male_25.mdl"] = true,
    ["models/tnb/techcom/brot/male_26.mdl"] = true,
    ["models/tnb/techcom/brot/male_27.mdl"] = true,
    ["models/tnb/techcom/brot/male_28.mdl"] = true,
    ["models/tnb/techcom/brot/male_29.mdl"] = true,
    ["models/tnb/techcom/brot/male_30.mdl"] = true,
    ["models/tnb/techcom/brot/male_31.mdl"] = true,
    ["models/tnb/techcom/brot/male_32.mdl"] = true,
    ["models/tnb/techcom/brot/male_33.mdl"] = true,
    ["models/tnb/techcom/brot/male_34.mdl"] = true,
    ["models/tnb/techcom/brot/male_35.mdl"] = true,
    ["models/tnb/techcom/brot/male_36.mdl"] = true,
    ["models/tnb/techcom/brot/male_37.mdl"] = true,
    ["models/tnb/techcom/brot/male_38.mdl"] = true,
    ["models/tnb/techcom/brot/male_39.mdl"] = true,
    ["models/tnb/techcom/brot/male_40.mdl"] = true,
    ["models/tnb/techcom/brot/male_41.mdl"] = true,
    ["models/tnb/techcom/brot/male_42.mdl"] = true,
    ["models/tnb/techcom/brot/male_43.mdl"] = true,
    ["models/tnb/techcom/brot/male_44.mdl"] = true,
    ["models/tnb/techcom/brot/male_45.mdl"] = true,
    ["models/tnb/techcom/brot/male_47.mdl"] = true,
    ["models/tnb/techcom/brot/male_48.mdl"] = true,
    ["models/tnb/techcom/brot/male_49.mdl"] = true,
    ["models/tnb/techcom/brot/male_50.mdl"] = true,
    ["models/tnb/techcom/brot/male_51.mdl"] = true,
    ["models/tnb/techcom/brot/male_52.mdl"] = true,
    ["models/tnb/techcom/brot/male_53.mdl"] = true,
    ["models/tnb/techcom/brot/male_54.mdl"] = true,
    ["models/tnb/techcom/brot/male_55.mdl"] = true,
    ["models/tnb/techcom/brot/male_56.mdl"] = true,
    ["models/tnb/techcom/brot/male_57.mdl"] = true,
    ["models/tnb/techcom/brot/male_58.mdl"] = true,
    ["models/tnb/techcom/brot/male_59.mdl"] = true,
    ["models/tnb/techcom/brot/male_60.mdl"] = true,
    ["models/tnb/techcom/brot/male_61.mdl"] = true,
    ["models/tnb/techcom/brot/male_62.mdl"] = true,
    ["models/tnb/techcom/brot/male_63.mdl"] = true,
    ["models/tnb/techcom/brot/male_64.mdl"] = true,
    ["models/tnb/techcom/brot/male_65.mdl"] = true,
    ["models/tnb/techcom/brot/male_66.mdl"] = true,
    ["models/tnb/techcom/brot/male_67.mdl"] = true,
    ["models/tnb/techcom/brot/male_68.mdl"] = true,
    ["models/tnb/techcom/brot/male_69.mdl"] = true,
    ["models/tnb/techcom/brot/male_70.mdl"] = true,
    ["models/tnb/techcom/brot/male_71.mdl"] = true,
    ["models/tnb/techcom/brot/male_72.mdl"] = true,
    ["models/tnb/techcom/brot/male_73.mdl"] = true,
    ["models/tnb/techcom/brot/male_74.mdl"] = true,
    ["models/tnb/techcom/brot/male_75.mdl"] = true,
    ["models/tnb/techcom/brot/male_76.mdl"] = true,
    ["models/tnb/techcom/brot/male_77.mdl"] = true,
    ["models/tnb/techcom/brot/male_78.mdl"] = true,
    ["models/tnb/techcom/brot/male_79.mdl"] = true,
    ["models/tnb/techcom/brot/male_80.mdl"] = true,
    ["models/tnb/techcom/brot/male_81.mdl"] = true,
    ["models/tnb/techcom/brot/male_82.mdl"] = true,
    ["models/tnb/techcom/brot/male_83.mdl"] = true,
    ["models/tnb/techcom/brot/male_84.mdl"] = true,
    ["models/tnb/techcom/brot/male_85.mdl"] = true,
    ["models/tnb/techcom/brot/male_86.mdl"] = true,
    ["models/tnb/techcom/brot/male_87.mdl"] = true,
    ["models/tnb/techcom/brot/male_88.mdl"] = true,
    ["models/tnb/techcom/brot/male_89.mdl"] = true,
    ["models/tnb/techcom/brot/male_90.mdl"] = true,
    ["models/tnb/techcom/brot/male_91.mdl"] = true,
    ["models/tnb/techcom/brot/male_92.mdl"] = true,
    ["models/tnb/techcom/brot/male_93.mdl"] = true,
    ["models/tnb/techcom/brot/male_94.mdl"] = true,
    ["models/tnb/techcom/brot/male_95.mdl"] = true,
    ["models/tnb/techcom/brot/male_96.mdl"] = true,
    ["models/tnb/techcom/brot/male_97.mdl"] = true,
    ["models/tnb/techcom/brot/male_98.mdl"] = true,
    ["models/tnb/techcom/brot/male_99.mdl"] = true,
    ["models/tnb/techcom/brot/male_100.mdl"] = true,
    ["models/tnb/techcom/brot/female_01.mdl"] = true,
    ["models/tnb/techcom/brot/female_02.mdl"] = true,
    ["models/tnb/techcom/brot/female_03.mdl"] = true,
    ["models/tnb/techcom/brot/female_04.mdl"] = true,
    ["models/tnb/techcom/brot/female_05.mdl"] = true,
    ["models/tnb/techcom/brot/female_06.mdl"] = true,
    ["models/tnb/techcom/brot/female_07.mdl"] = true,
    ["models/tnb/techcom/brot/female_08.mdl"] = true,
    ["models/tnb/techcom/brot/female_09.mdl"] = true,
    ["models/tnb/techcom/brot/female_10.mdl"] = true,
    ["models/tnb/techcom/brot/female_11.mdl"] = true,
    ["models/tnb/techcom/brot/female_12.mdl"] = true,
    ["models/tnb/techcom/brot/female_13.mdl"] = true,
    ["models/tnb/techcom/brot/female_14.mdl"] = true,
    ["models/tnb/techcom/brot/female_15.mdl"] = true,
    ["models/tnb/techcom/brot/female_16.mdl"] = true,
    ["models/tnb/techcom/brot/female_17.mdl"] = true,
    ["models/tnb/techcom/brot/female_18.mdl"] = true,
    ["models/tnb/techcom/brot/female_19.mdl"] = true,
    ["models/tnb/techcom/brot/female_20.mdl"] = true,
    ["models/tnb/techcom/brot/female_21.mdl"] = true,
    ["models/tnb/techcom/brot/female_23.mdl"] = true,
    ["models/tnb/techcom/brot/female_24.mdl"] = true,
    ["models/tnb/techcom/brot/female_25.mdl"] = true,
    ["models/tnb/techcom/brot/female_26.mdl"] = true,
    ["models/tnb/techcom/brot/female_27.mdl"] = true,
    ["models/tnb/techcom/brot/female_28.mdl"] = true,
    ["models/tnb/techcom/brot/female_29.mdl"] = true,
    ["models/tnb/techcom/brot/female_30.mdl"] = true,
    ["models/tnb/techcom/brot/female_31.mdl"] = true,
    ["models/tnb/techcom/brot/female_32.mdl"] = true,
    ["models/tnb/techcom/brot/female_33.mdl"] = true,
    ["models/tnb/techcom/brot/female_34.mdl"] = true,
    ["models/tnb/techcom/brot/female_35.mdl"] = true,
    ["models/tnb/techcom/brot/female_36.mdl"] = true,
    ["models/tnb/techcom/brot/female_37.mdl"] = true,
    ["models/tnb/techcom/brot/female_38.mdl"] = true,
    ["models/tnb/techcom/brot/female_39.mdl"] = true,
    ["models/tnb/techcom/brot/female_40.mdl"] = true,
    ["models/tnb/techcom/brot/female_41.mdl"] = true,
    ["models/tnb/techcom/brot/female_42.mdl"] = true,
    ["models/tnb/techcom/brot/female_43.mdl"] = true,
    ["models/tnb/techcom/brot/female_44.mdl"] = true,
    ["models/tnb/techcom/brot/female_45.mdl"] = true,
    ["models/tnb/techcom/brot/female_46.mdl"] = true,
    ["models/tnb/techcom/brot/female_47.mdl"] = true,
    ["models/tnb/techcom/brot/female_48.mdl"] = true,
    ["models/tnb/techcom/brot/female_49.mdl"] = true,
    ["models/tnb/techcom/brot/female_50.mdl"] = true,
    ["models/tnb/techcom/brot/female_51.mdl"] = true,
    ["models/tnb/techcom/brot/female_52.mdl"] = true,
    ["models/tnb/techcom/brot/female_53.mdl"] = true,
    ["models/tnb/techcom/brot/female_54.mdl"] = true,
    ["models/tnb/techcom/brot/female_55.mdl"] = true,
    ["models/tnb/techcom/brot/female_56.mdl"] = true,
    ["models/tnb/techcom/brot/female_57.mdl"] = true,
    ["models/tnb/techcom/brot/female_58.mdl"] = true,
    ["models/tnb/techcom/brot/female_60.mdl"] = true,
    ["models/tnb/techcom/brot/female_61.mdl"] = true,
    ["models/tnb/techcom/brot/female_62.mdl"] = true,
    ["models/tnb/techcom/brot/female_63.mdl"] = true,
    ["models/tnb/techcom/brot/female_64.mdl"] = true,
    ["models/tnb/techcom/brot/female_65.mdl"] = true,
    ["models/tnb/techcom/brot/female_66.mdl"] = true,
    ["models/tnb/techcom/brot/female_67.mdl"] = true,
    ["models/tnb/techcom/brot/female_68.mdl"] = true,
    ["models/tnb/techcom/brot/female_70.mdl"] = true,
    ["models/tnb/techcom/brot/female_71.mdl"] = true,
    ["models/tnb/techcom/brot/female_72.mdl"] = true,
    ["models/tnb/techcom/brot/female_73.mdl"] = true,
    ["models/tnb/techcom/brot/female_74.mdl"] = true,
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

local citizen = nut.faction.teams["citizen"]
if citizen then
    citizen.models = {}

    for model,_ in next, PLUGIN.ModelCheck do
        if string.find(model, "diverge") then continue end
        citizen.models[#citizen.models + 1] = model
    end
end

for k, v in pairs( PLUGIN.CustomHeads ) do
    PLUGIN.SkinTranslation[k] = v.Skin
    PLUGIN.ModelCheck[k] = true
end

for model,_ in next, PLUGIN.ModelCheck do
    nut.anim.setModelClass( model, "player" )
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
nut.util.include( "sv_network.lua" )
nut.util.include( "sv_ragdollrewrite.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_bonemerge.lua" )
nut.util.include( "cl_network.lua" )
nut.util.include( "cl_vendor.lua" )

Bonemerge = PLUGIN