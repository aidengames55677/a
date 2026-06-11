-- "gamemodes\\mafiarp\\plugins\\holsteredweps\\sh_plugin.lua"

PLUGIN.name = "Holstered Weapons"
PLUGIN.author = "Black Tea and rusty"
PLUGIN.desc = "Shows holstered weapons on players."

PLUGIN.TotalWeapons = PLUGIN.TotalWeapons or {}

nut.config.add(
	"showHolsteredWeps",
	true,
	"Whether or not holstered weapons show on players.",
	nil,
	{category = PLUGIN.name}
)

function PLUGIN:InitializedPlugins()
	local visibleOnBack = {	
		arccw_mp5n = true,
		arccw_m14 = true,
		arccw_chinalake = true,
		arccw_type100 = true,
		arccw_minimi = true,
		arccw_xl64 = true,
		arccw_dragunov = true,
		arccw_m24 = true,
		arccw_aa12 = true,
		arccw_thompson_m1921 = true,
		arccw_g3 = true,
		arccw_ar15 = true,
		arccw_carbine = true,
		arccw_rpk = true,
		arccw_ak5 = true,
		arccw_springfield = true,
		arccw_crossbow = true,
		arccw_usas12 = true,
		arccw_famas = true,
		arccw_ithaca = true,
		arccw_m60 = true,
		arccw_striker = true,
		arccw_ak47 = true,
		arccw_aek971 = true,
		arccw_fal = true,
		arccw_hs10 = true,
		arccw_garand = true,
		arccw_m249 = true,
		arccw_k98k = true,
		arccw_m16 = true,
		arccw_s682 = true,
		arccw_fg42 = true,
		arccw_m870 = true,
		arccw_wa2000 = true,
		arccw_akm = true,
		arccw_bazooka = true,
		arccw_m1887 = true,
		arccw_spas12 = true,
		arccw_m202 = true,
		arccw_mg42 = true,
		arccw_m3 = true,
		arccw_vollmer = true,
		arccw_w1200 = true,
		arccw_sg550 = true,
		arccw_spectre = true,
		arccw_m79 = true,
		arccw_law = true,
		arccw_galil = true,
		arccw_aug = true,
		arccw_panzerschreck = true,
		arccw_trenchgun = true,
		arccw_sten = true,
		arccw_ppsh41 = true,
		arccw_rpg7 = true,
		arccw_doublebarrel = true,
		arccw_mp5 = true,
		arccw_toz34 = true,
		arccw_akmu = true,
		arccw_ptrs41 = true,
		arccw_l96 = true,
		arccw_mosin = true,
		arccw_type99 = true,
		arccw_g43 = true,
		arccw_stg44 = true,
		arccw_mg08 = true,
		arccw_m700 = true,
		arccw_g11 = true,
		arccw_bar = true,
		arccw_hk21 = true,
		arccw_thompson_m1a1 = true,
		arccw_car15 = true,
		arccw_rpd = true,
		arccw_dp27 = true,
		arccw_m1919 = true,
		arccw_mp40 = true,
		arccw_p90 = true,
		arccw_arisaka = true,
		arccw_mini14 = true,
		arccw_svt40 = true,
		arccw_m82 = true,
		arccw_stoner = true,
		arccw_ks23 = true,
		arccw_mu_aus1756 = true,
		weapon_combatninjasword = true,
	}

    local holsterOverride = {
        arccw_sg550 = {
            bone = "ValveBiped.Bip01_Spine2",
            ang = Angle(-19.440,0,0),
            pos = Vector(3.719997, 0.000000, -6.279995),
        },
        arccw_vollmer = {
            bone = "ValveBiped.Bip01_Spine2",
            ang = Angle(-5.560, 0.000, 270.000),
            pos = Vector(12.200089, 1.419999, -3.659997),
        },        
		arccw_ks23 = {
            bone = "ValveBiped.Bip01_Spine2",
            ang = Angle(17.880, 180.000, 0.000),
            pos = Vector(6.940000, 22.440331, -1.000000),
        },
		arccw_aek971 = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(20, 180, 0),
			pos = Vector(9.5000324249268, 15.400169372559, -2.3999984264374),
		},
		arccw_rpk = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(20, 0, 0),
			pos = Vector(0.30000507831573, -21.200286865234, -0.63999992609024),
		},
		arccw_mg42 = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(20, 180, 0),
			pos = Vector(4.6600012779236, 27.100437164307, 0),
		},
		arccw_g3 = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(20, 180, 0),
			pos = Vector(6.4199995994568, 20.480285644531, -1.4599993228912),
		},
		arccw_akm = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(20, 180, 0),
			pos = Vector(7.199999332428, 20.760292053223, -2.539998292923),
		},
		arccw_m1887 = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(20, 180, 0),
			pos = Vector(6.5999994277954, 17.540218353271, -2.0199987888336),
		},
		weapon_combatninjasword = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(101.63468933105, 90.255233764648, 0),
			pos = Vector(-5.1399908065796, -0.13999292254448, -6.7599949836731),
		},
    }

    for uniqueID, metaitem in next, nut.item.list do
        if not metaitem.isWeapon then continue end
        if not visibleOnBack[metaitem.class] then continue end

        local override = holsterOverride[metaitem.class]
        if override then
            HOLSTER_DRAWINFO[metaitem.class] = {
                model = metaitem.model,
                bone = override.bone,
                ang = override.ang,
                pos = override.pos,
            }
        else
            HOLSTER_DRAWINFO[metaitem.class] = {
                model = metaitem.model,
                bone = "ValveBiped.Bip01_Spine2",
                ang = Angle(20, 180, 0),
                pos = Vector(6, 8, 0),
            }
        end
    end
end


nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")

-- To add your own holstered weapon model, add a new entry to HOLSTER_DRAWINFO
-- in *your* code (not here) where the key is the weapon class and the value
-- is a table that contains:
--   1. pos: a vector offset
--   2. ang: the angle of the model
--   3. bone: the bone to attach the model to
--   4. model: the model to show
HOLSTER_DRAWINFO = HOLSTER_DRAWINFO or {}

HOLSTER_DRAWINFO["weapon_pistol"] = {
	pos = Vector(4, -8, -1),
	ang = Angle(0, 90, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/w_pistol.mdl"
}
HOLSTER_DRAWINFO["weapon_357"] = {
	pos = Vector(-2, -8, -4),
	ang = Angle(0, -90, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/w_357.mdl"
}
HOLSTER_DRAWINFO["weapon_frag"] ={
	pos = Vector(4, 8, 0),
	ang = Angle(15, 0, 270),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/items/grenadeammo.mdl"
}
HOLSTER_DRAWINFO["weapon_slam"] ={
	pos = Vector(4, 8, 0),
	ang = Angle(-90, 0, 180),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/w_slam.mdl"
}
HOLSTER_DRAWINFO["weapon_crowbar"] = {
	pos = Vector(4, 8, 0),
	ang = Angle(45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_crowbar.mdl"
}
HOLSTER_DRAWINFO["weapon_ar2"] = {
	pos = Vector(4, 16, 0),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_irifle.mdl"
}
HOLSTER_DRAWINFO["weapon_shotgun"] = {
	pos = Vector(4, 16, 0),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_shotgun.mdl"
}
HOLSTER_DRAWINFO["weapon_rpg"] = {
	pos = Vector(4, 24, 8),
	ang = Angle(-45, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_rocket_launcher.mdl"
}
HOLSTER_DRAWINFO["weapon_crossbow"] = {
	pos = Vector(0, -2, -2),
	ang = Angle(0, 0, 90),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_crossbow.mdl"
}
HOLSTER_DRAWINFO["weapon_smg1"] = {
	pos = Vector(4, 8, 0),
	ang = Angle(135, 180, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_smg1.mdl"
}