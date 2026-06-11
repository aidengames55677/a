if not SERVER then return end

--Weapons
local donatorPermaWeps = {
	["76561198114113337"] = {
		"tfa_nmrih_sw686" -- Omar
	},
	["76561198292081566"] = {
		"tfa_nmrih_sako", "tfa_nmrih_sw686", "tfa_dbarrel", "tfa_nmrih_m16_rt" -- Captain
	},
	["76561198176039281"] = {
		"tfa_nmrih_sw686" -- KOSS
	},
	["76561198010832544"] = {
		"tfa_nmrih_sw686" -- Justin Davis
	},
	["76561198316588978"] = {
		"tfa_nmrih_sw686" -- Cyan Flyer
	},
	["76561198125534310"] = {
		"tfa_nmrih_sw686" -- Unknown
	},
	["76561198316882214"] = {
		"tfa_nmrih_sw686" -- Glasslowman
	},
	["76561198130157171"] = {
		"tfa_nmrih_sw686" -- King of Numenor Solomon
	},
	["76561198076282242"] = {
		"tfa_nmrih_sw686" -- Preacher
	},
	["76561198228996988"] = {
		"tfa_deagle" -- .Cons
	},
	["76561198236345026"] = {
		"tfa_nmrih_sw686", "tfa_uzi" -- Holiday Inn
	},
	["76561198805020407"] = {
		"tfa_nmrih_sw686" -- Kunai
	},
	["76561198216061580"] = {
		"tfa_nmrih_m16_rt" -- Remmy
	},
	["76561198313342536"] = {
		"tfa_ak47" -- Nero/Ski
	},
	["76561198125534310"] = {
		"tfa_thompson" -- Rome/EriC
	},
	["76561198157404535"] = {
		"tfa_nmrih_sw686" -- Lapis
	},
	["76561198077888192"] = {
		"tfa_nmrih_sw686" -- Montana
	},
	["76561198122027599"] = {
		"tfa_nmrih_mp5" -- Schmo0d
	},
	["76561198152847171"] = {
		"tfa_nmrih_sw686", "tfa_mp5sd" -- Michael
	},
	["76561198044795756"] = {
		"tfa_nmrih_sw686" -- Flaco/Henry Faggatoni
	},
	["76561198079107551"] = {
		"tfa_nmrih_sw686" -- Thotimus
	},
	["76561198089354006"] = {
		"tfa_nmrih_sv10"  -- Murky
	},
	["76561198068632161"] = {
		"tfa_nmrih_sw686" -- Crispin
	},
	["76561198000622268"] = {
		"tfa_nmrih_sw686" -- J.Stein
	},
	["76561198354252239"] = {
		"tfa_nmrih_sw686" -- Mista OG
	},
	["76561198413412013"] = {
		"tfa_mp5sd" -- Supreme Mexican
	},
	["76561198356194899"] = {
		"tfa_nmrih_sw686" -- Fanta Man
	},
	["76561198113112419"] = {
		"tfa_nmrih_sw686" -- Weldon
	},
	["76561198165319993"] = {
		"tfa_nmrih_sw686" -- Jimmys
	},
	["76561198097279180"] = {
		"tfa_nmrih_sw686" --Recruity_Mcruit
	},
	["76561198202398725"] = {
		"tfa_dbarrel" -- Alexis
	},
	["76561198251352406"] = {
		"tfa_nmrih_m16_rt" -- Xmurphy
	},
	["76561198095805475"] = {
		"tfa_thompson" -- Warmachine
	},
	["76561198098447837"] = {
		"tfa_thompson" -- Mr. Red
	},
	["76561198303650730"] = {
		"tfa_thompson" -- Vinyx
	},
	["76561198042465285"] = {
		"tfa_nmrih_mp5", "tfa_nmrih_sw686" -- Sex Robot
	},
	["76561198252904560"] = {
		"tfa_thompson" -- Dox
	},
	["76561198027228429"] = {
		"tfa_thompson" -- ShogunDreams
	},        
	["76561198452340011"] = {
		"tfa_nmrih_sw686" -- Logan
	},      
	["76561197970491936"] = {
		"tfa_nmrih_sw686" -- Motherducks
	},
	["76561198817012718"] = {
		"tfa_nmrih_sw686" -- realxtsi
	},  
	["76561198368238174"] = {
		"tfa_nmrih_sw686" -- Tony Vincetti
	},              
	["76561198085793102"] = {
		"tfa_nmrih_mp5", "tfa_nmrih_g17", -- Turts
	},
	["76561198028104785"] = {
		"tfa_nmrih_870", "tfa_nmrih_1911", -- Flux
	},
	["76561198120546120"] = {
		"tfa_nmrih_sw686" -- El_BANDITO_JR
	},
	["76561198318222663"] = {
		"tfa_thompson", "tfa_nmrih_sw686" -- LUCA CHANGRETTA
	},
	["76561198053893748"] = {
		"tfa_nmrih_kknife", "tfa_mp40" -- Piepieman
	},
}

local function checkWeapons(ply)
	local weps = donatorPermaWeps[ply:SteamID64()] or {}
	for _, wep in ipairs(weps) do
		ply:Give(wep)
	end
	return #weps > 0
end

-- Yes, the function is there for a reason since checkWeapons returns a value.
hook.Add("PlayerLoadout", "mafiarp.donator.loadouts", function (ply) checkWeapons(ply) end)

nut.command.add("claimweapons", {
	syntax = "",
	onRun = function(client, args)
		client:notify(Either(
			checkWeps(client),
			"There you go. Thanks for donating!",
			"There's no weapons to claim :("
		))
	end
})