PLUGIN.name = "Lockers"
PLUGIN.author = "Joshpai & Rook"
PLUGIN.desc = "Port of rook_lockers to a nutscript plugin."

Locker_List = {}

Locker_List[ "m16" ] = { 
Name = "M16",
Description = "Standard issue police rifle.",
Model = "models/weapons/w_dmg_m16ag.mdl",
LockerFunction = function( ply ) 
	ply:Give("bo_aron_m16")
	end,
}

Locker_List[ "shotgun1" ] = { 
Name = "Remington 870",
Description = "Standard issue police shotgun",
Model = "models/weapons/w_shotgun.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_ry_870")
	end,
}

Locker_List[ "revolver" ] = { 
Name = "Model 627 Revolver",
Description = "Standard issue police firearm.",
Model = "models/weapons/tfa_w_sw_model_627.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_azurzas_m29")
	end,
}

Locker_List[ "Colt M1911" ] = { 
Name = "Colt M1911",
Description = "Standard issue police firearm.",
Model = "models/weapons/tfa_nmrih/w_fa_1911.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_m1911")
	end,
}


Locker_List[ "tazer" ] = { 
Name = "Stun Gun",
Description = "A stungun used for restraining people.",
Model = "models/weapons/custom/taser.mdl",
LockerFunction = function( ply ) 
	ply:Give("weapon_stungun")	
	end,
}

Locker_List[ "radio" ] = { 
Name = "Radio",
Description = "A Radio used for long distance communicating via radio waves.",
Model = "models/gibs/shield_scanner_gib1.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("radio")
  end
end
}

Locker_List[ "zipties" ] = { 
Name = "Zip Ties",
Description = "A pair of Zip Ties used in the process of restraining individuals.",
Model = "models/items/crossbowrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("tie")
  end
end
}


Locker_List[ "armor" ] = { 
Name = "Kevlar Vest",
Description = "A vest of material used as a reinforcement agent to protect from bullets.",
Model = "models/sal/acc/armor01.mdl",
LockerFunction = function( ply ) 
	ply:SetArmor(100)	
	end,
}


Locker_List_Swat = {}

Locker_List_Swat[ "tazer" ] = { 
Name = "Stun Gun",
Description = "A stungun used for restraining people.",
Model = "models/weapons/custom/taser.mdl",
LockerFunction = function( ply ) 
	ply:Give("weapon_stungun")	
	end,
}

Locker_List_Swat[ "radio" ] = { 
Name = "Radio",
Description = "A Radio used for long distance communicating via radio waves.",
Model = "models/gibs/shield_scanner_gib1.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("radio")
  end
end
}

Locker_List_Swat[ "zipties" ] = { 
Name = "Zip Ties",
Description = "A pair of Zip Ties used in the process of restraining individuals.",
Model = "models/items/crossbowrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("tie")
  end
end
}

Locker_List_Swat[ "beretta" ] = { 
Name = "Glock19",
Description = "A gun used for restraining people.",
Model = "models/weapons/cw2_0_mach_para.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_nen_glock17")	
	end,
}

Locker_List_Swat[ "mp5" ] = { 
Name = "MP5 ",
Description = "MP5.",
Model = "models/weapons/w_smg_mp5.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_mp5")	
	end,
}

Locker_List_Swat[ "sako" ] = { 
Name = "Sako 85 ",
Description = "SAKO 05.",
Model = "models/weapons/tgr/w_spin_scout.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_trg42")	
	end,
}


Locker_List_Swat[ "remington" ] = { 
Name = "Remington 870",
Description = "Standard issue police shotgun",
Model = "models/weapons/w_shotgun.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_ry_870")
	end,
}


Locker_List_Swat[ "m16" ] = { 
Name = "M16",
Description = "Standard issue police rifle.",
Model = "models/weapons/w_dmg_m16ag.mdl",
LockerFunction = function( ply ) 
	ply:Give("bo_aron_m16")
	end,
}

/*

Locker_List_Swat[ "m24" ] = { 
	Name = "M24",
	Description = "M24",
	Model = "models/weapons/tfa_w_snip_m24_6.mdl",
	LockerFunction = function( ply ) 
		ply:Give("tfa_m24")	
		end,
}
*/

Locker_List_Swat[ "hk45c" ] = { 
	Name = "HK21",
	Description = "HK21",
	Model = "models/my_black_ops_weapons/hk21/w_aron_bo1_hk21.mdl",
	LockerFunction = function( ply ) 
		ply:Give("cw_hk_21")	
		end,
}

Locker_List_Swat[ "hk416" ] = { 
	Name = "HK416",
	Description = "Yes, have fun.",
	Model = "models/weapons/w_cwkk_hk416.mdl",
	LockerFunction = function( ply ) 
		ply:Give("cw_kk_hk416")	
		end,
}

/*
Locker_List_Swat[ "fubar" ] = { 
	Name = "Fubar",
	Description = "smack the doors with this.",
	Model = "models/weapons/tfa_nmrih/w_me_fubar.mdl",
	LockerFunction = function( ply ) 
		ply:Give("tfa_nmrih_fubar")	
		end,
}
*/

Locker_List_Swat[ "m14" ] = { 
	Name = "M14",
	Description = "gun go pew pew.",
	Model = "models/weapons/w_cstm_m14.mdl",
	LockerFunction = function( ply ) 
		ply:Give("cw_m14")	
		end,
}

Locker_List_Swat[ "armor" ] = { 
Name = "Kevlar Vest",
Description = "A vest of material used as a reinforcement agent to protect from bullets.",
Model = "models/sal/acc/armor01.mdl",
LockerFunction = function( ply ) 
	ply:SetArmor(100)	
	end,
}


Locker_List_Navy = {}


Locker_List_Navy[ "armor" ] = { 
Name = "Kevlar Vest",
Description = "A vest of material used as a reinforcement agent to protect from bullets.",
Model = "models/sal/acc/armor01.mdl",
LockerFunction = function( ply ) 
	ply:SetArmor(100)	
	end,
}

Locker_List_Navy[ "radio" ] = { 
Name = "Radio",
Description = "A Radio used for long distance communicating via radio waves.",
Model = "models/gibs/shield_scanner_gib1.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("radio")
  end
end
}

Locker_List_Navy[ "zipties" ] = { 
Name = "Zip Ties",
Description = "A pair of Zip Ties used in the process of restraining individuals.",
Model = "models/items/crossbowrounds.mdl",
LockerFunction = function( ply ) 
  local char = ply:getChar()
  local inv = char:getInv()

  if (IsValid(ply) and char) then
    inv:add("tie")
  end
end
}


Locker_List_Navy[ "Colt M1911" ] = { 
Name = "Colt M1911",
Description = "Standard issue police firearm.",
Model = "models/weapons/tfa_nmrih/w_fa_1911.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_m1911")
	end,
}


Locker_List_Navy[ "m16" ] = { 
Name = "M16",
Description = "Standard issue police rifle.",
Model = "models/weapons/w_dmg_m16ag.mdl",
LockerFunction = function( ply ) 
	ply:Give("bo_aron_m16")
	end,
}

Locker_List_Navy[ "jae700" ] = { 
Name = "Sako",
Description = "Jae 700",
Model = "models/weapons/tgr/w_spin_scout.mdl",
LockerFunction = function( ply ) 
	ply:Give("cw_trg42")	
	end,
}

if (SERVER) then
	util.AddNetworkString("Mission_Start_2")
	util.AddNetworkString("Mission_Start_22")
	util.AddNetworkString("Mission_Start_222")

	net.Receive('Mission_Start_2', function(length, ply)
	local locker = net.ReadString()
	Locker_List[locker].LockerFunction( ply, locker )

				
	ply:notify("You have taken a(n) " .. Locker_List[locker].Name .. " from the locker.")


	end)

	net.Receive('Mission_Start_22', function(length, ply)
	local locker = net.ReadString()
	Locker_List_Swat[locker].LockerFunction( ply, locker )

				
	ply:notify("You have taken a(n) " .. Locker_List_Swat[locker].Name .. " from the locker.")


	end)

	net.Receive('Mission_Start_222', function(length, ply)
	local locker = net.ReadString()
	Locker_List_Navy[locker].LockerFunction( ply, locker )

				
	ply:notify("You have taken a(n) " .. Locker_List_Navy[locker].Name .. " from the locker.")


	end)


	--hook.Add("OnNPCKilled", "NPCReward", function(npc, attacker, inflictor ) 
	--attacker:notify("Mission started, follow waypoint")

	--end)
end