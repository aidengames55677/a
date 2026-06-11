-- "gamemodes\\mafiarp\\plugins\\police\\sh_plugin.lua"

PLUGIN.name = "Police"
PLUGIN.author = "Pendred"
PLUGIN.desc = "Stuff for Police."

POLICE = POLICE or {}

if CLIENT then
	surface.CreateFont("Title_Font", {
		font = "Times New Roman",
		extended = false,
		size = 28,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})
    surface.CreateFont("POLICE_NPC", {
        font = "Arial",
        extended = false,
        size = 80,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    })
    
    surface.CreateFont("PoliceSurrender", {
        font = "Arial",
        extended = false,
        size = 24,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    })
end

nut.flag.add("L", "Access to the standard Police Locker")
nut.flag.add("y", "Access to the special Police Locker")

PLUGIN.Lockers = {}

PLUGIN.Lockers.Police = {
    Faction = {[FACTION_POLICE] = true},
    Selections = {
        glock = {
            Name = "Glock 17",
            Model = "models/weapons/arccw/c_ud_glock.mdl",
            WeaponClass = "arccw_glock",
            Secondary = true,
        },
        p226 = {
            Name = "SIG Sauer P226",
            Model = "models/weapons/arccw/mifl/fas2/c_p226.mdl",
            WeaponClass = "arccw_p226",
            Secondary = true,
        },
		python = {
            Name = "Colt Python",
            Model = "models/weapons/arccw/w_bo1_python.mdl",
            WeaponClass = "arccw_python",
            Secondary = true,
        },
        sw27 = {
            Name = "S&W Model 27",
            Model = "models/weapons/arccw/w_waw_357.mdl",
            WeaponClass = "arccw_sw27",
            Secondary = true,
		},
		m9 = {
            Name = "Beretta M9",
            Model = "models/weapons/arccw_ins2/w_m9.mdl",
            WeaponClass = "arccw_m9",
            Secondary = true,
        },
        w1200 = {
            Name = "Winchester 1200 Defender",
            Model = "models/weapons/arccw/w_ultra_cod4_w1200.mdl",
            WeaponClass = "arccw_w1200",
            Primary = true,
		},
		rem870 = {
            Name = "Remington Model 870",
            Model ="models/weapons/arccw/c_ud_870.mdl",
            Price = 50,
            WeaponClass = "arccw_m870",
            Primary = true,
		},
		mp5n = {
            Name = "HK MP5N",
            Model = "models/weapons/arccw/mifl/fas2/c_mp5.mdl",
			Price = 100,
            WeaponClass = "arccw_mp5n",
            Primary = true,
        },
		carbine = {
            Name = "M1 Carbine",
            Model = "models/weapons/arccw/c_waw_carbine.mdl",
            WeaponClass = "arccw_carbine",
            Primary = true,
        },
		m16 = {
            Name = "Colt M16A2",
            Model = "models/weapons/arccw/c_ud_m16.mdl",
			Price = 250,
            WeaponClass = "arccw_m16",
            Primary = true,
		},
		nade_smoke = {
            Name = "M18 Smoke Grenade",
            Model = "models/weapons/w_eq_smokegrenade.mdl",
            LockerFunction = function(ply) 
				if !ply:HasWeapon("arccw_nade_smoke") then
					ply:Give("arccw_nade_smoke")
				elseif ply:HasWeapon("arccw_nade_smoke") && ply:GetAmmoCount("arccw_nade_smoke") < 2 then
					ply:GiveAmmo(1, "arccw_nade_smoke")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
        ammo_pistol = {
            Name = "Pistol Ammo",
            Model = "models/Items/BoxSRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "pistol")
            end
        },
        ammo_357 = {
            Name = "Magnum Ammo",
            Model = "models/Items/357ammo.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(30, "357")
            end
        },
        ammo_buckshot = {
            Name = "Shotgun Ammo",
            Model = "models/Items/BoxBuckshot.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(30, "buckshot")
            end
        },
		ammo_smg1 = {
            Name = "Carbine Ammo",
            Model = "models/Items/BoxSRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "smg1")
            end
        },
        stungun = {
            Name = "Taser",
            Model = "models/weapons/Custom/w_taser.mdl",
			Cadet = true,
            WeaponClass = "weapon_stungun",
        },
        baton = {
            Name = "Baton",
            Model = "models/weapons/w_police_baton_plr.mdl",
			Cadet = true,
            WeaponClass = "police_baton",
        },
        cuffs = { 
            Name = "Handcuffs",
            Model = "models/weapons/spy/w_handcuffs.mdl",
			Cadet = true,
            WeaponClass = "diverge_handcuffs",
        },
		radio = { 
            Name = "Radio",
            Model = "models/gibs/shield_scanner_gib1.mdl",
			Cadet = true,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) then
                    inv:add("radio")
                end
            end
        },
		stitches = { 
            Name = "Stitches",
            Model = "models/props_lab/box01a.mdl",
			Price = 10,
			Cadet = true,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) and char:hasMoney(10) then
					char:takeMoney(10)
                    inv:add("stitches")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		splint = { 
            Name = "Splint",
            Model = "models/props_junk/wood_crate001a_chunk05.mdl",
			Price = 10,
			Cadet = true,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) and char:hasMoney(10) then
					char:takeMoney(10)
                    inv:add("splint")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		bandages = { 
            Name = "Bandages",
            Model = "models/props_lab/box01a.mdl",
			Price = 5,
			Cadet = true,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()
               if (IsValid(ply) and char) and char:hasMoney(5) then
					char:takeMoney(5)
                    inv:add("bandages")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		armor = { 
            Name = "Kevlar Vest",
            Model = "models/sal/acc/armor01.mdl",
			Cadet = true,
            LockerFunction = function( ply ) 
                ply:SetArmor(100)
            end
        },
    }
}

PLUGIN.Lockers.Police2 = {
    Faction = {[FACTION_POLICE] = true},
    Selections = {
		m92 = {
            Name = "Beretta 92",
            Model = "models/weapons/arccw/c_cde_m92.mdl",
            WeaponClass = "arccw_m92",
            Secondary = true,
		},
		ten = {
			Name = "Bren Ten",
			Model = "models/weapons/arccw/eap/c_brenten.mdl",
			WeaponClass = "arccw_brenten",
			Secondary = true,
        },
		superm3 = {
            Name = "Benelli M3",
            Model = "models/weapons/arccw/mifl/fas2/c_m3s90.mdl",
			Price = 125,
            WeaponClass = "arccw_m3",
            Primary = true,
        },
		mp5n = {
            Name = "HK MP5N",
            Model = "models/weapons/arccw/mifl/fas2/c_mp5.mdl",
			Price = 50,
            WeaponClass = "arccw_mp5n",
            Primary = true,
        },
		ar15 = {
            Name = "Colt AR-15",
            Model = "models/weapons/arccw/w_ultra_bo1_car15.mdl",
			Price = 150,
            WeaponClass = "arccw_ar15",
            Primary = true,
        },
		coltcommando = {
            Name = "Colt Commando",
            Model = "models/weapons/arccw/c_bo1_car15.mdl",
			Price = 250,
            WeaponClass = "arccw_car15",
            Primary = true,
        },
		l96a1 = {
            Name = "L96A1",
            Model = "models/weapons/arccw/w_ultra_cod4_r700.mdl",
			Price = 750,
            WeaponClass = "arccw_l96",
            Primary = true,
        },
		g3a3 = {
            Name = "G3A3",
            Model = "models/weapons/arccw/mifl/fas2/c_g3.mdl",
			Price = 500,
            WeaponClass = "arccw_g3",
            Primary = true,
        },
		nade_smoke = {
            Name = "M18 Smoke Grenade",
            Model = "models/weapons/w_eq_smokegrenade.mdl",
            LockerFunction = function(ply) 
				if !ply:HasWeapon("arccw_nade_smoke") then
					ply:Give("arccw_nade_smoke")
				elseif ply:HasWeapon("arccw_nade_smoke") && ply:GetAmmoCount("arccw_nade_smoke") < 2 then
					ply:GiveAmmo(1, "arccw_nade_smoke")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
		nade_teargas = {
            Name = "Tear Gas Grenade",
            Model = "models/weapons/w_eq_smokegrenade.mdl",
			Price = 25,
            LockerFunction = function(ply) 
				if !ply:HasWeapon("arccw_nade_teargas") then
					ply:Give("arccw_nade_teargas")
				elseif ply:HasWeapon("arccw_nade_teargas") && ply:GetAmmoCount("arccw_nade_teargas") < 2 then
					ply:GiveAmmo(1, "arccw_nade_teargas")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
		nade_flash = {
            Name = "Stun Grenade",
            Model = "models/weapons/w_eq_flashbang.mdl",
			Price = 10,
            LockerFunction = function(ply) 
				if !ply:HasWeapon("arccw_nade_flash") then
					ply:Give("arccw_nade_flash")
				elseif ply:HasWeapon("arccw_nade_flash") && ply:GetAmmoCount("arccw_nade_flash") < 2 then
					ply:GiveAmmo(1, "arccw_nade_flash")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
        ammo_pistol = {
            Name = "Pistol Ammo",
            Model = "models/Items/BoxSRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "pistol")
            end
        },
        ammo_357 = {
            Name = "Magnum Ammo",
            Model = "models/Items/357ammo.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(30, "357")
            end
        },
        ammo_buckshot = {
            Name = "Shotgun Ammo",
            Model = "models/Items/BoxBuckshot.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(30, "buckshot")
            end
        },
		ammo_smg1 = {
            Name = "Carbine Ammo",
            Model = "models/Items/BoxSRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "smg1")
            end
        },
		ammo_ar2 = {
            Name = "Rifle Ammo",
            Model = "models/Items/BoxMRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "ar2")
            end
        },
		ammo_sniper = {
            Name = "Sniper Ammo",
            Model = "models/Items/BoxMRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "SniperPenetratedRound")
            end
        },
		stungun = {
            Name = "Taser",
            Model = "models/weapons/Custom/w_taser.mdl",
            WeaponClass = "weapon_stungun",
        },
        baton = {
            Name = "Baton",
            Model = "models/weapons/w_police_baton_plr.mdl",
            WeaponClass = "police_baton",
        },
		cuffs = { 
            Name = "Handcuffs",
            Model = "models/weapons/spy/w_handcuffs.mdl",
            WeaponClass = "diverge_handcuffs",
        },
		radio = { 
            Name = "Radio",
            Model = "models/gibs/shield_scanner_gib1.mdl",
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) then
                    inv:add("radio")
                end
            end
        },
		stitches = { 
            Name = "Stitches",
            Model = "models/props_lab/box01a.mdl",
			Price = 10,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) and char:hasMoney(10) then
					char:takeMoney(10)
                    inv:add("stitches")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		splint = { 
            Name = "Splint",
            Model = "models/props_junk/wood_crate001a_chunk05.mdl",
			Price = 10,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) and char:hasMoney(10) then
					char:takeMoney(10)
                    inv:add("splint")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		bandages = { 
            Name = "Bandages",
            Model = "models/props_lab/box01a.mdl",
			Price = 5,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()
               if (IsValid(ply) and char) and char:hasMoney(5) then
					char:takeMoney(5)
                    inv:add("bandages")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		armor = { 
            Name = "Kevlar Vest",
            Model = "models/sal/acc/armor01.mdl",
            LockerFunction = function( ply ) 
                ply:SetArmor(100)
            end
        },
    }
}
--[[
PLUGIN.Lockers.FBI = {
    Faction = FACTION_FBI,
    Selections = {
		m1911 = {
            Name = "Colt M1911",
            Model = "models/weapons/w_cw_kk_ins2_m1911.mdl",
            WeaponClass = "cw_kk_ins2_m1911_gov",
            Secondary = true,
        },
		deagle = {
            Name = "Desert Eagle",
            Model = "models/weapons/w_des.mdl",
            WeaponClass = "cw_khr_ins2_deagle",
            Secondary = true,
        },
		spas12 = {
            Name = "SPAS-12",
            Model = "models/weapons/w_cw_kk_ins2_cstm_spas12.mdl",
            WeaponClass = "cw_kk_ins2_cstm_spas12",
            Primary = true,
        },
		thom_m1a1 = {
            Name = "Thompson M1A1",
            Model = "models/weapons/w_thompson_m1a1.mdl",
            WeaponClass = "cw_kk_ins2_doi_thom_m1a1_gov",
            Primary = true,
        },
		mp5a4 = {
            Name = "HK MP5A4",
            Model = "models/weapons/w_cw_kk_ins2_cstm_mp5a4.mdl",
            WeaponClass = "cw_kk_ins2_cstm_mp5a4_gov",
            Primary = true,
        },
		colt = {
            Name = "Colt Commando",
            Model = "models/weapons/w_cw_kk_ins2_cstm_colt.mdl",
            WeaponClass = "cw_kk_ins2_cstm_colt_gov",
            Primary = true,
        },
		aug = {
            Name = "Steyr AUG",
            Model = "models/weapons/w_cw_kk_ins2_cstm_aug.mdl",
            WeaponClass = "cw_kk_ins2_cstm_aug",
            Primary = true,
        },
		fnfal = {
            Name = "FN FAL",
            Model = "models/weapons/w_fal.mdl",
            WeaponClass = "cw_kk_ins2_fnfal",
            Primary = true,
        },
		m40a1 = {
            Name = "Remington M40A1",
            Model = "models/weapons/w_m40.mdl",
            WeaponClass = "cw_kk_ins2_m40a1_gov",
            Primary = true,
        },
		rpk = {
            Name = "RPK",
            Model = "models/weapons/w_rpk.mdl",
            WeaponClass = "cw_kk_ins2_rpk",
            Primary = true,
        },
		nade_m18 = {
            Name = "M18 Smoke Grenade",
            Model = "models/weapons/w_m18.mdl",
            LockerFunction = function(ply) 
				if !ply:HasWeapon("cw_kk_ins2_nade_m18") then
					ply:Give("cw_kk_ins2_nade_m18")
				elseif ply:HasWeapon("cw_kk_ins2_nade_m18") && ply:GetAmmoCount("M18 Smoke Grenade") < 2 then
					ply:GiveAmmo(1, "M18 Smoke Grenade")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
		nade_n77 = {
            Name = "No. 77 Smoke Grenade",
            Model = "models/weapons/w_no79.mdl",
            LockerFunction = function(ply) 
				if !ply:HasWeapon("cw_kk_ins2_doi_nade_n77") then
					ply:Give("cw_kk_ins2_doi_nade_n77")
				elseif ply:HasWeapon("cw_kk_ins2_doi_nade_n77") && ply:GetAmmoCount("No. 77 Smoke Grenade") < 2 then
					ply:GiveAmmo(1, "No. 77 Smoke Grenade")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
		teargas = {
            Name = "Tear Gas Grenade",
            Model = "models/weapons/w_m18.mdl",
            LockerFunction = function(ply) 
				if !ply:HasWeapon("cw_kk_ultra_nade_teargas") then
					ply:Give("cw_kk_ultra_nade_teargas")
				elseif ply:HasWeapon("cw_kk_ultra_nade_teargas") && ply:GetAmmoCount("Tear Gas Grenade") < 2 then
					ply:GiveAmmo(1, "Tear Gas Grenade")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
		teargas2 = {
            Name = "Tear Gas Impact Grenade",
            Model = "models/weapons/w_no79.mdl",
            LockerFunction = function(ply) 
				if !ply:HasWeapon("cw_kk_ultra_nade_teargas2") then
					ply:Give("cw_kk_ultra_nade_teargas2")
				elseif ply:HasWeapon("cw_kk_ultra_nade_teargas2") && ply:GetAmmoCount("Tear Gas Impact Grenade") < 2 then
					ply:GiveAmmo(1, "Tear Gas Impact Grenade")
				else
					ply:notify("You can only carry 2 of this type of grenade at once!")
				end
            end
        },
		ammo_9x19mm = {
            Name = "9x19mm Parabellum",
            Model = "models/Items/BoxSRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(100, "9x19MM")
            end
        },
		ammo_45acp = {
            Name = ".45 ACP",
            Model = "models/Items/BoxSRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(100, ".45 ACP")
            end
        },
		ammo_50ae = {
            Name = ".50 Action Express",
            Model = "models/Items/357ammo.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(100, ".50 AE")
            end
        },
		ammo_12gauge = {
            Name = "12 Gauge",
            Model = "models/Items/BoxBuckshot.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(30, "12 Gauge")
            end
        },
		ammo_556x45mm = {
            Name = "5.56x45mm NATO",
            Model = "models/Items/BoxMRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "5.56x45MM")
            end
        },
		ammo_762x51mm = {
            Name = "7.62x51mm NATO",
            Model = "models/Items/BoxMRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "7.62x51MM")
            end
        },
		ammo_762x39mm = {
            Name = "7.62x39mm",
            Model = "models/Items/BoxMRounds.mdl",
            LockerFunction = function(ply) 
                ply:GiveAmmo(60, "7.62x39MM")
            end
        },
		bino = {
            Name = "Binoculars",
            Model = "models/weapons/w_binoculars_german.mdl",
            WeaponClass = "cw_kk_ins2_doi_bino_de",
        },
		stungun = {
            Name = "Taser",
            Model = "models/weapons/Custom/w_taser.mdl",
            WeaponClass = "weapon_stungun",
        },
        baton = {
            Name = "Baton",
            Model = "models/weapons/w_police_baton_plr.mdl",
            WeaponClass = "police_baton",
        },
		zipties = { 
            Name = "Restraints",
            Model = "models/items/crossbowrounds.mdl",
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) then
                    inv:add("tie")
                end
            end
        },
		radio = { 
            Name = "Radio",
            Model = "models/gibs/shield_scanner_gib1.mdl",
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) then
                    inv:add("radio")
                end
            end
        },
		stitches = { 
            Name = "Stitches",
            Model = "models/props_lab/box01a.mdl",
			Price = 10,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) and char:hasMoney(10) then
					char:takeMoney(10)
                    inv:add("stitches")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		splint = { 
            Name = "Splint",
            Model = "models/props_junk/wood_crate001a_chunk05.mdl",
			Price = 10,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()

                if (IsValid(ply) and char) and char:hasMoney(10) then
					char:takeMoney(10)
                    inv:add("splint")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		bandages = { 
            Name = "Bandages",
            Model = "models/props_lab/box01a.mdl",
			Price = 5,
            LockerFunction = function( ply ) 
                local char = ply:getChar()
                local inv = char:getInv()
               if (IsValid(ply) and char) and char:hasMoney(5) then
					char:takeMoney(5)
                    inv:add("bandages")
				else
					ply:notify("You don't have enough money to take this!")
                end
            end
        },
		armor = { 
            Name = "Kevlar Vest",
            Model = "models/sal/acc/armor01.mdl",
            LockerFunction = function( ply ) 
                ply:SetArmor(100)
            end
        },
    }
}

--]]

nut.util.include("sv_plugin.lua", "server")