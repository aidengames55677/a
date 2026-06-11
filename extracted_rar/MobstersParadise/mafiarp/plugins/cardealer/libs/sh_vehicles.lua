-- "gamemodes\\mafiarp\\plugins\\cardealer\\libs\\sh_vehicles.lua"

local PLUGIN = PLUGIN

PLUGIN.Vehicle_Categories = {
	"Economy Vehicles",
	"Luxury Vehicles",
	"Super Vehicles",
	"Lowriders",
	"Motorcycles",
	"Custom Vehicles",

	"NYPD - Marked",
	"NYPD - Unmarked",
	"NYPD - Undercover",
	"NYPD - Board",
}

--Template to follow
/*
Vehicles[ "uniquename" ] = {
Name = "Name of Vehicle",
Category = "Type of Vehicle, see above for categories",
Identifier = "ID of vehicle",
Model = "model path of vehicle",
Price = price,
}
*/

PLUGIN.Vehicles = {}

PLUGIN.Vehicles[ "taxii" ] = {
	Name = "Taxi Cab",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_l4d_taxi_old",
	Model = "models/left4dead/vehicles/taxi_old.mdl",
	Price = 15000,
}

PLUGIN.Vehicles[ "elcamino" ] = {
	Name = "Chevrolet El-Camino SS",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_elcamino",
	Model = "models/sentry/elcamino.mdl",
	Price = 10000,
}

PLUGIN.Vehicles[ "citreonn" ] =  {
	Name = "Citroen SM",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_citroensm",
	Model = "models/diggercars/citoren_sm/v2.mdl",
	Price = 17000,
}

PLUGIN.Vehicles[ "monaco" ] = {
	Name = "Dodge Monaco",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_monaco",
	Model = "models/lonewolfie/dodge_monaco.mdl",
	Price = 25000,
}

PLUGIN.Vehicles[ "chevc10" ] = {
	Name = "Chevrolet C10",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_chev_c10",
	Model = "models/tdmcars/chev_c10.mdl",
	Price = 38000,
}

PLUGIN.Vehicles[ "pontiacgto" ] = {
	Name = "Pontiac GTO",
	Category = "Economy Vehicles",
	Identifier = "pontiacjudge_mcblyat",
	Model = "models/whitetiger/pontiacgtotheju69.mdl",
	Price = 50000,
}

PLUGIN.Vehicles[ "chevroletbelair" ] = {
	Name = "Chevrolet Belair",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_chev_belair",
	Model = "models/sentry/belair.mdl",
	Price = 60000,
}

PLUGIN.Vehicles[ "fordfalcon" ] = {
	Name = "Ford Falcon",
	Category = "Economy Vehicles",
	Identifier = "fordfalconfutura67",
	Model =  "models/falconfutura67/falconfutura67.mdl",
	Price = 75000,
}

PLUGIN.Vehicles[ "hudsonhornet" ] = {
	Name = "Hudson Hornet",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_hudson",
	Model = "models/tdmcars/hud_hornet.mdl",
	Price = 85000,
}

PLUGIN.Vehicles[ "grantorino" ] =  {
	Name = "Ford Gran Torino",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_ford_gran",
	Model = "models/crsk_autos/ford/grantorino_1972.mdl",
	Price = 95000,
}

PLUGIN.Vehicles[ "challenger" ] = {
	Name = "Dodge Challenger",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_dod_chall70",
	Model  = "models/tdmcars/dod_challenger70.mdl",
	Price = 95000,
}

PLUGIN.Vehicles[ "cossack" ] = {
	Name = "Cossack",
	Category = "Luxury Vehicles",
	Identifier = "simfphys_mafia2_trautenberg_grande",
	Model = "models/mafia2/trautenberg_grande.mdl",
	Price = 45000,
}

PLUGIN.Vehicles[ "shelbycobra" ] = {
	Name = "Shelby Cobra 427",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_shelb_cobra",
	Model = "models/sentry/shelbycobra.mdl",
	Price = 110000,
}

PLUGIN.Vehicles[ "rollsroycesilverr" ] = {
	Name = "Rolls-Royce Silver Silver Cloud III",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_crsk_rolls-royce_silvercloud3",
	Model =  "models/crsk_autos/rolls-royce/silvercloud3.mdl",
	Price = 150000,
}

PLUGIN.Vehicles[ "911" ] = {
	Name = "Porsche 911",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_911rsr30",
	Model = "models/diggercars/porsche_911rsr/v2.mdl",
	Price = 170000,
}

PLUGIN.Vehicles[ "ferrarigts" ] = {
	Name = "Ferrari 308GTS",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_308gts",
	Model = "models/diggercars/ferrari_308/gtsv1.mdl",
	Price = 185000,
}

PLUGIN.Vehicles[ "ferrarigtb" ] = {
	Name = "Ferrari 308GTB",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_308gtb",
	Price = 200000,
	Model = "models/diggercars/ferrari_308/v1.mdl",
}

PLUGIN.Vehicles[ "bmw_m1" ] = {
	Name = "BMW M1",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_bmw_m1",
	Price = 300000,
	Model = "models/tdmcars/bmwm1.mdl",
}

PLUGIN.Vehicles[ "alfa_33_stradale" ] = {
	Name = "Alfa Romeo 33 Stradale",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_alfa_33_stradale",
	Price = 420000,
	Model = "models/tdmcars/alfa_stradale.mdl",
}

PLUGIN.Vehicles[ "nis_2000gtr" ] = {
	Name = "Nissan Skyline 2000GT-R",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_nis_2000gtr",
	Price = 290000,
	Model = "models/lonewolfie/2000gtr_stock.mdl",
}

PLUGIN.Vehicles[ "fiat_abarth" ] = {
	Name = "Fiat Abarth 595 SS",
	Category = "Economy Vehicles",
	Identifier = "sim_fphys_fiat_595",
	Price = 10000,
	Model = "models/lonewolfie/fiat_595.mdl",
}

PLUGIN.Vehicles[ "mercedes_300sel" ] = {
	Name = "Mercedes-Benz 300 SEL",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_mercedes_300sel",
	Price = 600000,
	Model = "models/tdmcars/mer_300sel.mdl",
}

PLUGIN.Vehicles[ "lam_countach" ] = {
	Name = "Lamborghini Countach",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_lam_countach",
	Price = 1000000,
	Model = "models/lonewolfie/lam_countach.mdl",
}

PLUGIN.Vehicles[ "chev_corvette_c1" ] = {
	Name = "Chevrolet Corvette C1",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_chev_corvette_c1",
	Price = 190000,
	Model = "models/crsk_autos/chevrolet/corvette_c1_1957.mdl",
}

PLUGIN.Vehicles[ "dmc12" ] = {
	Name = "Delorean DMC-12",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_dmc12",
	Price = 220000,
	Model = "models/tdmcars/del_dmc.mdl",
}

PLUGIN.Vehicles[ "toy_ae86" ] = {
	Name = "Toytota Corolla AE86",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_toy_ae86_bl",
	Price = 140000,
	Model = "models/royscars/Toyota/Toyota_Black_Limited.mdl",
}

PLUGIN.Vehicles[ "mercedes300sl" ] = {
	Name = "Mercedez Benz 300SL Gullwing",
	Category = "Luxury Vehicles",
	Identifier = "sim_fphys_mercedes_300sl",
	Model = "models/tdmcars/mer_300slgull.mdl",
	Price = 2500000,
}

PLUGIN.Vehicles[ "Zombiebike" ] = {
	Name = "BMW R75",
	Category = "Motorcycles",
	Identifier = "r75",
	Price = 50000,
	Model = "models/bmw_r75.mdl",
}
	
PLUGIN.Vehicles[ "Diabolusbike" ] = {
	Name = "BMW R75 V2",
	Category = "Motorcycles",
	Identifier = "r75_2",
	Price = 85000,
	Model = "models/bmw_r75_2.mdl",
}

/*
	Lowriders:
*/

PLUGIN.Vehicles[ "blade" ] = {
	Name = "Blade",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_blade",
	Price = 15000,
	Model = "models/gta_sa/lowriders/blade.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "broadway" ] = {
	Name = "Broadway",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_broadway",
	Price = 30000,
	Model = "models/gta_sa/lowriders/broadway.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "remington" ] = {
	Name = "Remington",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_remingtn",
	Price = 25000,
	Model = "models/gta_sa/lowriders/remingtn.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "savanna" ] = {
	Name = "Savanna",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_savanna",
	Price = 28500,
	Model = "models/gta_sa/lowriders/savanna.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "slamvan" ] = {
	Name = "Slamvan",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_slamvan",
	Price = 30000,
	Model = "models/gta_sa/lowriders/slamvan.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "tahoma" ] = {
	Name = "Tahoma",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_tahoma",
	Price = 15500,
	Model = "models/gta_sa/lowriders/tahoma.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "tornado" ] = {
	Name = "Tornado",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_tornado",
	Price = 17500,
	Model = "models/gta_sa/lowriders/tornado.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "voodoo" ] = {
	Name = "Voodoo",
	Category = "Lowriders",
	Identifier = "simfphys_gta_sa_voodoo",
	Price = 20500,
	Model = "models/gta_sa/lowriders/voodoo.mdl",
	MiamiExclusive = true,
}

/*
	Super Cars:
*/

PLUGIN.Vehicles[ "sim_fphys__fastnfuriouscivic" ] = {
	Name = "Honda Civic SI",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfuriouscivic",
	Price = 2750000,
	Model = "models/fast_and_furious/civic.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfuriouss2000" ] = {
	Name = "Honda S2000",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfuriouss2000",
	Price = 3500000,
	Model = "models/fast_and_furious/s2000.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfuriousrx7dt" ] = {
	Name = "Mazda RX-7",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfuriousrx7dt",
	Price = 5250000,
	Model = "models/fast_and_furious/rx7dt.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfuriouseclipse" ] = {
	Name = "Mitsubushi Eclipse GSX",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfuriouseclipse",
	Price = 3750000,
	Model = "models/fast_and_furious/eclipse.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfuriousevo" ] = {
	Name = "Mitsubushi Lancer Evo",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfuriousevo",
	Price = 1550000,
	Model = "models/fast_and_furious/evo.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfurious350z" ] = {
	Name = "Nissan 350Z",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfurious350z",
	Price = 2050000,
	Model = "models/fast_and_furious/350zdk.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfuriousskyline" ] = {
	Name = "Nissan Skyline GT-R",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfuriousskyline",
	Price = 1450000,
	Model = "models/fast_and_furious/skyline.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfurioussti" ] = {
	Name = "Subaru Impreza WRX STI",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfurioussti",
	Price = 850000,
	Model = "models/fast_and_furious/sti.mdl",
	MiamiExclusive = true,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfurioussupra" ] = {
	Name = "Toyota Supra",
	Category = "Super Vehicles",
	Identifier = "sim_fphys__fastnfurioussupra",
	Price = 1100000,
	Model = "models/fast_and_furious/supra.mdl",
	MiamiExclusive = true,
}

/*
	Police Cars:
*/

PLUGIN.Vehicles[ "nypd_monaco" ] = { 
	Name = "Dodge Monaco (Marked)", 
	Category = "NYPD - Marked", 
	Identifier = "sim_fphys_monaco_cop", 
	Model = "models/lonewolfie/dodge_monaco.mdl", 
	NYPD = true,
	Price = 1000,
	OnSpawn = function(ent)
		ent:SetSkin(11)
	end
}

PLUGIN.Vehicles[ "nypd_crownvicunmarked" ] = {
    Name = "Ford Crown Victoria",
    Category = "NYPD - Unmarked",
    Identifier = "husky_cv_uc",
    Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
    NYPD = true,
    Price = 1000,
}

PLUGIN.Vehicles[ "nypd_charger69unmarked" ] = {
    Name = "Dodge Charger 1969 (Unmarked)",
    Category = "NYPD - Unmarked",
    Identifier = "sim_fphys_dod_char69_fbi",
    Model = "models/sentry/charger.mdl",
    NYPD = true,
    Price = 20000,
}

PLUGIN.Vehicles[ "nypd_tahoeucmarked" ] = {
    Name = "Chevrolet Tahoe (Unmarked))",
    Category = "NYPD - Unmarked",
    Identifier = "sim_fphys_chev_tahoe_fbi",
    Model = "models/lonewolfie/chev_tahoe_police.mdl",
    NYPD = true,
    Price = 30000,
}

PLUGIN.Vehicles[ "nypd_pontiacgto" ] = {
    Name = "Pontiac GTO",
    Category = "NYPD - Undercover",
    Identifier = "pontiacjudge_mcblyat",
    Model = "models/whitetiger/pontiacgtotheju69.mdl",
    NYPD = true,
    Price = 10000,
}

PLUGIN.Vehicles[ "nypd_shelbygt500kr" ] = {
    Name = "Ford Shelby GT500KR",
    Category = "NYPD - Undercover",
    Identifier = "sim_fphys_shel_gt500kr",
    Model = "models/lonewolfie/shelby_gt500kr.mdl",
    NYPD = true,
    Price = 15000,
}

PLUGIN.Vehicles[ "nypd_grantor" ] = {
    Name = "Ford Gran Torino",
    Category = "NYPD - Undercover",
    Identifier = "sim_fphys_ford_gran",
    Model = "models/crsk_autos/ford/grantorino_1972.mdl",
    NYPD = true,
    Price = 5000,
}

PLUGIN.Vehicles[ "nypd_crownvicundercover" ] = {
    Name = "Ford Crown Victoria",
    Category = "NYPD - Undercover",
    Identifier = "husky_cv",
    Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
    NYPD = true,
    Price = 5000,
}

PLUGIN.Vehicles[ "nypd_monacouc" ] = {
    Name = "Dodge Monaco",
    Category = "NYPD - Undercover",
    Identifier = "sim_fphys_dod_monaco",
    Model = "models/lonewolfie/dodge_monaco.mdl",
    NYPD = true,
    Price = 1000,
}

PLUGIN.Vehicles[ "nypd_charger69uc" ] = {
    Name = "Dodge Charger 1969",
    Category = "NYPD - Undercover",
    Identifier = "sim_fphys_dod_char69",
    Model = "models/sentry/charger.mdl",
    NYPD = true,
    Price = 15000,
}

PLUGIN.Vehicles[ "nypd_challenger" ] = {
    Name = "Dodge Challenger",
    Category = "NYPD - Undercover",
    Identifier = "sim_fphys_dod_chall70",
    Model = "models/tdmcars/dod_challenger15.mdl",
    NYPD = true,
    Price = 10000,
}

PLUGIN.Vehicles[ "nypd_citroensm" ] = {
    Name = "Citroen SM",
    Category = "NYPD - Undercover",
    Identifier = "sim_fphys_citroensm",
    Model = "models/diggercars/citoren_sm/v2.mdl",
    NYPD = true,
    Price = 1000,
}

PLUGIN.Vehicles[ "nypd_tahoeuc" ] = {
    Name = "Chevrolet Tahoe",
    Category = "NYPD - Undercover",
    Identifier = "sim_fphys_chev_tahoe",
    Model = "models/lonewolfie/chev_tahoe.mdl",
    NYPD = true,
    Price = 40000,
}

PLUGIN.Vehicles[ "nypd_bearcat" ] = {
    Name = "Lenco BearCat G3",
    Category = "NYPD - Marked",
    Identifier = "sim_fphys_bearcat_g3",
    Model = "models/perrynsvehicles/bearcat_g3/bearcat_g3.mdl",
    NYPD = true,
    Price = 30000,
	Allowed = function(ply)
		local char = ply:getChar()
		return char && char:hasFlags("B")
	end
}

PLUGIN.Vehicles[ "nypd_f150raptor" ] = {
    Name = "Ford F-150 Raptor",
    Category = "NYPD - Marked",
    Identifier = "sim_fphys_ford_f150_cop",
    Model = "models/sentry/17raptor_cop.mdl",
    NYPD = true,
    Price = 30000,
}

PLUGIN.Vehicles[ "nypd_crownvicmarked" ] = {
    Name = "Ford Crown Victoria (Marked)",
    Category = "NYPD - Marked",
    Identifier = "husky_cvpi",
    Model = "models/tdmcars/emergency/for_crownvic_fh3.mdl",
    NYPD = true,
    Price = 15000,
}

PLUGIN.Vehicles[ "nypd_r75" ] = {
    Name = "BMW R75 (Marked)",
    Category = "NYPD - Marked",
    Identifier = "r75_nypd",
    Model = "models/bmw_nypd_r75.mdl",
    NYPD = true,
    Price = 10000,
}

PLUGIN.Vehicles[ "nypd_r75s" ] = {
    Name = "BMW R75 Sidecar (Marked)",
    Category = "NYPD - Marked",
    Identifier = "r75_2_nypd",
    Model = "models/bmw_nypd_r75_2.mdl",
    NYPD = true,
    Price = 10000,
}

PLUGIN.Vehicles[ "nypd_tahoesub" ] = {
    Name = "Chevrolet Tahoe Suburban",
    Category = "NYPD - Board",
    Identifier = "sim_fphys_chev_suburban15",
    Model = "models/sim_fphys_chev_suburban15/chev_suburban15.mdl",
    NYPD = true,
    Price = 80000,
}


/*
	Custom Cars:
*/

PLUGIN.Vehicles[ "ratrod" ] = {
	Name = "Beck Kustoms F132 HotRod",
	Category = "Custom Vehicles",
	Identifier = "redcbeckkustoms",
	Model = "models/redc_beckkustoms/redc_beckkustoms.mdl",
	PlayersBuy = {["STEAM_0:0:95492178"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "infmerc" ] = {
	Name = "Mercedes-Benz 500 Series",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mer_w140",
	Model = "models/crsk_autos/mercedes-benz/500se_w140_1992.mdl",
	PlayersBuy = {["STEAM_0:1:562177687"] = true, ["STEAM_0:0:634628544"] = true, ["STEAM_0:0:217293411"] = true, ["STEAM_0:1:434305432"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "drunkenas" ] = {
	Name = "Aston Martin DB5",
	Category = "Custom Vehicles",
	Identifier = "db5007",
	Model = "models/tdmcars/ast_db5.mdl",
	PlayersBuy = {["STEAM_0:0:419429676"] = true, ["STEAM_0:0:106666063"] = true, ["STEAM_0:1:508048361"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:1:623477509"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "milktruck" ] = {
	Name = "Milk Truck",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_divco_milk_truck",
	Model = "models/sim_fphys_divco_milk_truck/divco_milk_truck.mdl",
	PlayersBuy = {["STEAM_0:0:93085786"] = true},
	FactionsBuy = {[FACTION_PRUSZ] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "jaguar" ] = {
	Name = "Jaguar XJ220",
	Category = "Custom Vehicles",
	Identifier = "simfphys_jag_xj220",
	Model = "models/lonewolfie/jaguar_xj220.mdl",
	PlayersBuy = {["STEAM_0:1:508954834"] = true, ["STEAM_0:0:164085753"] = true, ["STEAM_0:1:512687048"] = true, ["STEAM_0:0:451897176"] = true, ["STEAM_0:0:243227620"] = true, ["STEAM_0:1:512327016"] = true, ["STEAM_0:1:107955250"] = true, ["STEAM_0:1:708116014"] = true, ["STEAM_0:0:167548927"] = true },
	Price = 1000,
}

PLUGIN.Vehicles[ "ashwilliams" ] = {
	Name = "Ash Williams' Car",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ash_williams_car",
	Model = "models/evil-ash/whitetiger/ash_car.mdl",
	PlayersBuy = {["STEAM_0:0:193591710"] = true, ["STEAM_0:0:627321054"] = true, ["STEAM_0:0:630293847"] = true, ["STEAM_0:0:446624497"] = true, ["STEAM_0:0:626268130"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "jamesjag" ] = {
	Name = "1964 Jaguar E-Type",
	Category = "Custom Vehicles",
	Identifier = "Etype_mcblyat",
	Model = "models/tdmcars/jag_etype.mdl",
	PlayersBuy = {["STEAM_0:1:111458393"] = true},
	FactionsBuy = {[FACTION_PRUSZ] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mercedes_benz_560sec" ] = {
	Name = "Mercedes Benz 560 SEC",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mercedes_benz_560sec",
	Model = "models/sim_fphys_mercedes_benz_560sec/mercedes_benz_560sec.mdl",
	PlayersBuy = {["STEAM_0:0:217293411"] = true, ["STEAM_0:1:96580898"] = true, ["STEAM_0:0:446624497"] = true, ["STEAM_0:1:98431287"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ferrari_f40" ] = {
	Name = "Ferrari F40",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ferrari_f40",
	Model = "models/lonewolfie/ferrari_f40.mdl",
	PlayersBuy = {["STEAM_0:1:434305432"] = true, ["STEAM_0:0:47358017"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:0:78885988"] = true, ["STEAM_0:0:438339571"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ford_bronco" ] = {
	Name = "Ford Bronco",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ford_bronco",
	Model = "models/crsk_autos/ford/bronco_1982.mdl",
	PlayersBuy = {["STEAM_0:1:434305432"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:1:456087661"] = true, ["STEAM_0:0:444952271"] = true, ["STEAM_0:1:456087661"] = true, ["STEAM_0:1:527906280"] = true, ["STEAM_0:1:57050935"] = true, ["STEAM_0:0:231451774"] = true, ["STEAM_0:1:434954440"] = true, ["STEAM_0:1:438020834"] = true, ["STEAM_0:1:123057891"] = true, ["STEAM_0:1:33856806"] = true, ["STEAM_0:0:102763252"] = true, ["STEAM_0:0:184639903"] = true, ["STEAM_0:1:445618132"] = true, ["STEAM_0:1:443575519"] = true, ["STEAM_0:1:430029932"] = true, ["STEAM_0:1:59666025"] = true, ["STEAM_0:1:182519557"] = true},
	FactionsBuy = {[FACTION_GAMBINO] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_camaro_irocz" ] = {
	Name = "Chevrolet Camaro IROC-Z",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_camaro_irocz",
	Model = "models/diggercars/c_camaroirocz/v2.mdl",
	PlayersBuy = {
		["STEAM_0:1:434305432"] = true,
		["STEAM_0:0:9297940"] = true,
		["STEAM_0:0:455164769"] = true,
		["STEAM_0:1:90879973"] = true,
		["STEAM_0:1:562177687"] = true,
		["STEAM_0:1:460651949"] = true,
		["STEAM_0:0:644816017"] = true,
		["STEAM_0:0:96149603"] = true,
		["STEAM_0:1:460167886"] = true,
		["STEAM_0:1:59666025"] = true,
		["STEAM_0:0:79563902"] = true,
		["STEAM_0:0:626268130"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_m635csi" ] = {
	Name = "BMW M635CSi",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_m635csi",
	Model = "models/diggercars/bmw_m635csi/v1.mdl",
	PlayersBuy = {["STEAM_0:1:434305432"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:0:83458244"] = true, ["STEAM_0:1:59666025"] = true, ["STEAM_0:1:434954440"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_chev_impala_ss" ] = {
	Name = "Chevrolet Impala SS 1964",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_chev_impala_ss",
	Model = "models/sentry/impala.mdl",
	PlayersBuy = {
		["STEAM_0:1:434305432"] = true,
		["STEAM_0:1:460651949"] = true,
		["STEAM_0:1:562177687"] = true,
		["STEAM_0:0:627321054"] = true,
		["STEAM_0:1:444435754"] = true,
		["STEAM_0:0:204748581"] = true,
		["STEAM_0:1:97034501"] = true,
		["STEAM_0:0:455164769"] = true,
		["STEAM_0:1:123057891"] = true,
		["STEAM_0:1:434954440"] = true,
		["STEAM_0:0:455164769"] = true,
		["STEAM_0:1:445618132"] = true,
		["STEAM_0:1:59666025"] = true,
		["STEAM_0:1:635461734"] = true,
		["STEAM_0:0:626268130"] = true,
	},
	FactionsBuy = {[FACTION_GAMBINO] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_rx7_fd" ] = {
	Name = "Mazda RX-7",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_rx7_fd",
	Model = "models/tdmcars/maz_rx7.mdl",
	PlayersBuy = {["STEAM_0:1:434305432"] = true, ["STEAM_0:0:608670892"] = true, ["STEAM_0:0:580883479"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:0:209358482"] = true, ["STEAM_0:0:531177546"] = true, ["STEAM_0:0:630093145"] = true, ["STEAM_0:0:7980297"] = true, ["STEAM_0:1:554098116"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_dod_char69" ] = {
	Name = "Dodge Charger 1969",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_dod_char69",
	Model = "models/sentry/charger.mdl",
	PlayersBuy = {
		["STEAM_0:1:434954440"] = true,
		["STEAM_0:1:456087661"] = true,
		["STEAM_0:0:63629212"] = true,
		["STEAM_0:1:619100780"] = true,
		["STEAM_0:0:7980297"] = true,
		["STEAM_0:0:419429676"] = true,
		["STEAM_0:1:123057891"] = true,
		["STEAM_0:0:462569406"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_80transam" ] = {
	Name = "'80 Pontiac Firebird",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_80transam",
	Model = "models/props/80transam.mdl",
	PlayersBuy = {["STEAM_0:0:630293847"] = true, ["STEAM_0:0:193591710"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "bug_eb110" ] = {
	Name = "Bugatti EB110",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_bug_eb110",
	Model = "models/tdmcars/bug_eb110.mdl",
	PlayersBuy = {["STEAM_0:0:193591710"] = true, ["STEAM_0:0:78885988"] = true, ["STEAM_0:0:157132656"] = true, ["STEAM_0:1:564136784"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_lam_diablo" ] = {
	Name = "Lamborghini Diablo",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lam_diablo",
	Model = "models/tdmcars/lambo_diablo.mdl",
	PlayersBuy = {["STEAM_0:0:175606500"] = true, ["STEAM_0:1:107886776"] = true, ["STEAM_0:1:619100780"] = true, ["STEAM_0:0:503795411"] = true, ["STEAM_0:0:626268130"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_288gto" ] = {
	Name = "Ferrari 288 GTO",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_288gto",
	Model = "models/DiggerCars/F_288GTO/v5.mdl",
	PlayersBuy = {["STEAM_0:1:103194764"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:0:644816017"] = true, ["STEAM_0:0:78885988"] = true, ["STEAM_0:0:180291884"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_cad_eldorado" ] = {
	Name = "Cadillac Eldorado",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_cad_eldorado",
	Model = "models/lonewolfie/cad_eldorado.mdl",
	PlayersBuy = {["STEAM_0:0:630293847"] = true, ["STEAM_0:1:434305432"] = true, ["STEAM_0:1:68842975"] = true, ["STEAM_0:1:200566377"] = true, ["STEAM_0:0:446624497"] = true, ["STEAM_0:0:627321054"] = true, ["STEAM_0:1:76723962"] = true, ["STEAM_0:1:197133550"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_bentley_continental_gt" ] = {
	Name = "Bentley Continental GT",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_bentley_continental_gt",
	Model = "models/rwcars/continentalgt.mdl",
	PlayersBuy = {["STEAM_0:1:434305432"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:1:91644707"] = true, ["STEAM_0:1:461737961"] = true, ["STEAM_0:1:80566775"] = true, ["STEAM_0:1:102527132"] = true, ["STEAM_0:1:24692886"] = true, ["STEAM_0:0:30038771"] = true, ["STEAM_0:1:148399189"] = true, ["STEAM_0:1:58581674"] = true, ["STEAM_0:0:497379795"] = true, ["STEAM_0:0:89051498"] = true, ["STEAM_0:0:455164769"] = true },
	Price = 1000,
}

PLUGIN.Vehicles[ "cad_escaladetdm" ] = {
	Name = "Cadillac Escalade",
	Category = "Custom Vehicles",
	Identifier = "cad_escaladetdm",
	Model = "models/tdmcars/cad_escalade.mdl",
	PlayersBuy = {["STEAM_0:1:434305432"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:1:91644707"] = true, ["STEAM_0:1:461737961"] = true, ["STEAM_0:1:80566775"] = true, ["STEAM_0:1:102527132"] = true, ["STEAM_0:0:30038771"] = true, ["STEAM_0:1:24692886"] = true,},
	FactionsBuy = {[FACTION_GAMBINO] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_austin_healey3000" ] = {
	Name = "Austin Healey 3000",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_austin_healey3000",
	Model = "models/lonewolfie/austin_healey_3000.mdl",
	PlayersBuy = {["STEAM_0:1:434305432"] = true, ["STEAM_0:1:460651949"] = true, ["STEAM_0:0:644816017"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:1:438020834"] = true, ["STEAM_0:1:59666025"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_rolls_royce_silver_spirit_mk3" ] = {
	Name = "Rolls Royce Silver Spirit MK3",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_rolls_royce_silver_spirit_mk3",
	Model = "models/crsk_autos/rolls-royce/silverspiritmk3.mdl",
	PlayersBuy = {
		["STEAM_0:1:434305432"] = true,
		["STEAM_0:1:460651949"] = true,
		["STEAM_0:0:47358017"] = true,
		["STEAM_0:1:619100780"] = true,
		["STEAM_0:1:204366132"] = true,
		["STEAM_0:1:438020834"] = true,
		["STEAM_0:0:626268130"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_rolls_phantom_vii_ii" ] = {
	Name = "Rolls Royce Phantom VII",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_rolls_phantom_vii_ii",
	Model = "models/metrohd/rr_phantom_2013.mdl",
	PlayersBuy = {["STEAM_0:0:60061570"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_recr_vehicle" ] = {
	Name = "Recreational Vehicle",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_recr_vehicle",
	Model = "models/sentry/rv.mdl",
	PlayersBuy = {["STEAM_0:0:175606500"] = true, ["STEAM_0:1:102527132"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mer_g500" ] = {
	Name = "Mercedes-Benz G500",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mer_g500",
	Model = "models/crsk_autos/mercedes-benz/g500_2008.mdl",
	PlayersBuy = {["STEAM_0:0:193591710"] = true, ["STEAM_0:1:430029932"] = true, ["STEAM_0:1:564136784"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_robert_rtrx_new" ] = {
	Name = "1969 Ford Mustang RTR-X",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_robert_rtrx_new",
	Model = "models/sentry/rtrx_new.mdl",
	PlayersBuy = {["STEAM_0:0:496858831"] = true, ["STEAM_0:1:236541107"] = true, ["STEAM_0:0:63903468"] = true, ["STEAM_0:0:92805993"] = true, ["STEAM_0:1:65745569"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "ctv_1986_fleetwood_bounder" ] = {
	Name = "Fleetwood Bounder",
	Category = "Custom Vehicles",
	Identifier = "ctv_1986_fleetwood_bounder",
	Model = "models/ctvehicles/fleetwood/bounder.mdl",
	PlayersBuy = {
		["STEAM_0:0:175606500"] = true,
		["STEAM_0:1:434954440"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_lam_huracan_evo" ] = {
	Name = "Lamborghini Huracan EVO",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lam_huracan_evo",
	Model = "models/sim_fphys_lam_huracan_evo/lam_huracan_evo.mdl",
	PlayersBuy = {
		["STEAM_0:1:619100780"] = true,
		["STEAM_0:0:580883479"] = true,
		["STEAM_0:0:47358017"] = true,
		["STEAM_0:1:434305432"] = true,
		["STEAM_0:0:47358017"] = true,
		["STEAM_0:1:434954440"] = true,
		["STEAM_0:0:707034128"] = true,
		["STEAM_0:0:106666063"] = true,
		["STEAM_0:0:531177546"] = true,
		["STEAM_0:1:48995558"] = true,
		["STEAM_0:0:7980297"] = true,
		["STEAM_0:1:571051284"] = true,
		["STEAM_0:1:708116014"] = true,
		["STEAM_0:1:551108592"] = true,
		["STEAM_0:1:57263955"] = true,
		["STEAM_0:0:89223005"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_hon_int98" ] = {
	Name = "Honda Integra DC2 Type R 1998",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_hon_int98",
	Model = "models/crsk_autos/honda/integra_dc2_typer_1998.mdl",
	PlayersBuy = {["STEAM_0:0:630293847"] = true, ["STEAM_0:1:619100780"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_toy_mr2gt" ] = {
	Name = "Toyota MR2 GT SW20",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_toy_mr2gt",
	Model = "models/tdmcars/toy_mr2gt.mdl",
	PlayersBuy = {["STEAM_0:0:630293847"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_fer_458_spid" ] = {
	Name = "Ferrari 458 Spider",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_fer_458_spid",
	Model = "models/tdmcars/fer_458spid.mdl",
	PlayersBuy = {["STEAM_0:1:211216565"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:1:70905"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:0:564841374"] = true, ["STEAM_0:1:9831394"] = true, ["STEAM_0:0:117029257"] = true, ["STEAM_0:0:569969381"] = true, ["STEAM_0:0:209358482"] = true, ["STEAM_0:0:634913339"] = true, ["STEAM_0:0:191273262"] = true, ["STEAM_0:1:571051284"] = true, ["STEAM_0:0:644816017"] = true},
	Price = 1000,


}

PLUGIN.Vehicles[ "simfphys_mercedes_g65_6x6_boosted" ] = {
	Name = "Mercedes G65 6x6 AMG",
	Category = "Custom Vehicles",
	Identifier = "simfphys_mercedes_g65_6x6_boosted",
	Model = "models/mercedes_g65_6x6_phy01.mdl",
	PlayersBuy = {["STEAM_0:0:175606500"] = true, ["STEAM_0:1:90879973"] = true, ["STEAM_0:1:91644707"] = true, ["STEAM_0:1:102527132"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ford_raptor" ] = {
	Name = "Ford Raptor SVT",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ford_raptor",
	Model = "models/tdmcars/for_raptor.mdl",
	PlayersBuy = {["STEAM_0:0:496858831"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_bmw_750i_e38" ] = {
	Name = "BMW 750i E38",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_bmw_750i_e38",
	Model = "models/crsk_autos/bmw/750i_e38_1995.mdl",
	PlayersBuy = {["STEAM_0:0:630293847"] = true, ["STEAM_0:0:79563902"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_camaro_z28" ] = {
	Name = "Chevrolet Camaro Z28",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_camaro_z28",
	Model = "models/DiggerCars/C_CamaroZ28/v1.mdl",
	PlayersBuy = {["STEAM_0:0:630293847"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "r35_lb" ] = {
	Name = "Nissan GTR R35 Liberty Walk",
	Category = "Custom Vehicles",
	Identifier = "r35_lb",
	Model = "models/rwcars/r35_lb.mdl",
	PlayersBuy = {["STEAM_0:1:460651949"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ford_cobra_r93" ] = {
	Name = "Ford Cobra R '93",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ford_cobra_r93",
	Model = "models/simfphys_lonewolfie/ford_foxbody_stock.mdl",
	PlayersBuy = {["STEAM_0:0:630293847"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mer_g63_amg" ] = {
	Name = "Mercedes-Benz G63 AMG",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mer_g63_amg",
	Model = "models/crsk_autos/mercedes-benz/g63_amg_2019.mdl",
	PlayersBuy = {["STEAM_0:1:109126283"] = true, ["STEAM_0:1:88140590"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_robert_wrangler_fnf" ] = {
	Name = "Jeep Wrangler F&F",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_robert_wrangler_fnf",
	Model = "models/tdmcars/jeep_wrangler_fnf.mdl",
	PlayersBuy = {
		["STEAM_0:1:82813500"] = true,
		["STEAM_0:0:73271356"] = true,
		["STEAM_0:0:207879818"] = true,
		["STEAM_0:0:626268130"] = true,
		["STEAM_0:0:455164769"] = true,
		["STEAM_0:1:43191126"] = true,
		["STEAM_0:0:92166790"] = true,
		["STEAM_0:0:564841374"] = true,
		["STEAM_0:1:70905"] = true,
		["STEAM_0:0:190149895"] = true,
		["STEAM_0:1:154217922"] = true,
		["STEAM_0:0:243227620"] = true,
		["STEAM_0:0:150234913"] = true,
		["STEAM_0:0:771901161"] = true,
		["STEAM_0:0:521577462"] = true,
		["STEAM_0:0:80922832"] = true,
		["STEAM_0:0:179938847"] = true,
		["STEAM_0:0:150242301"] = true,
		["STEAM_0:0:91467105"] = true,
		["STEAM_0:1:560982810"] = true,
		["STEAM_0:0:515445868"] = true,
		["STEAM_0:1:41437658"] = true,
		["STEAM_0:1:526725088"] = true,
	},
	Price = 1000,

}

PLUGIN.Vehicles[ "mercedes300sl_c" ] = {
	Name = "Mercedez Benz 300SL Gullwing",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mercedes_300sl",
	Model = "models/tdmcars/mer_300slgull.mdl",
	PlayersBuy = {["STEAM_0:0:73271356"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys__fastnfuriouss2000_c" ] = {
	Name = "Honda S2000",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys__fastnfuriouss2000",
	Model = "models/fast_and_furious/s2000.mdl",
	PlayersBuy = {["STEAM_0:0:73271356"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_mafia2_Lass75" ] = {
	Name = "Lassiter Series 75 Hollywood",
	Category = "Custom Vehicles",
	Identifier = "simfphys_mafia2_Lass75",
	Model = "models/mafia2/lass75.mdl",
	PlayersBuy = {["STEAM_0:1:571051284"] = true, ["STEAM_0:1:619100780"] = true, ["STEAM_0:0:92166790"] = true, ["STEAM_0:1:571051284"] = true, ["STEAM_0:1:623477509"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_mafia2_potomac_indian" ] = {
	Name = "Potomac Indian",
	Category = "Custom Vehicles",
	Identifier = "simfphys_mafia2_potomac_indian",
	Model = "models/mafia2/potomac_indian.mdl",
	FactionsBuy = {[FACTION_RUSSOFAMILY] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_lancia_stradale" ] = {
	Name = "Lancia Stradale",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lancia_stradale",
	Model = "models/lonewolfie/lancia_037_stradale.mdl",
	PlayersBuy = {["STEAM_0:1:59666025"] = true, ["STEAM_0:1:96290721"] = true, ["STEAM_0:0:43097694"] = true, ["STEAM_0:1:512772668"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_l4d_ambulance" ] = {
	Name = "Ambulance",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_l4d_ambulance",
	Model = "models/left4dead/vehicles/ambulance.mdl",
	PlayersBuy = {["STEAM_0:1:163338293"] = true, ["STEAM_0:0:19050132"] = true, ["STEAM_0:0:741695560"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mclaren_senna" ] = {
	Name = "McLaren Senna",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mclaren_senna",
	Model = "models/crsk_autos/mclaren/senna_2019.mdl",
	PlayersBuy = {["STEAM_0:1:111458393"] = true, ["STEAM_0:1:438020834"] = true, ["STEAM_0:1:182519557"] = true, ["STEAM_0:0:41199306"] = true, ["STEAM_0:0:644816017"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_NV_v12vantage" ] = {
	Name = "Aston Martin DB11",
	Category = "Custom Vehicles",
	Identifier = "simfphys_NV_v12vantage",
	Model = "models/crsk_autos/aston_martin/db11_2017.mdl",
	PlayersBuy = {["STEAM_0:1:111458393"] = true, ["STEAM_0:1:114065865"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_lambo_miura" ] = {
	Name = "Lamborghini Miura",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lambo_miura",
	Model = "models/tdmcars/lam_miura_p400.mdl",
	PlayersBuy = {["STEAM_0:1:59666025"] = true, ["STEAM_0:1:96290721"] = true, ["STEAM_0:0:43097694"] = true, ["STEAM_0:0:180291884"] = true, ["STEAM_0:1:59656630"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mbw123" ] = {
	Name = "Mercedes Benz W123 230",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mbw123",
	Model = "models/DiggerCars/MB_W123/v2.mdl",
	PlayersBuy = {["STEAM_0:0:46755780"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mer_clk_gtr" ] = {
	Name = "Mercedes-Benz CLK GTR AMG Coupe '98",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mer_clk_gtr",
	Model = "models/crsk_autos/mercedes-benz/clk_gtr_amg_coupe_1998.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:1:98431287"] = true, ["STEAM_0:0:570212223"] = true, ["STEAM_0:0:560201698"] = true, ["STEAM_0:0:564841374"] = true, ["STEAM_0:0:49750737"] = true, ["STEAM_0:1:159737437"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_lexus_lfa" ] = {
	Name = "Lexus LFA",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lexus_lfa",
	Model = "models/skyautomotive/lexus_lfa.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:0:596466356"] = true, ["STEAM_0:0:207879818"] = true, ["STEAM_0:1:182519557"] = true },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mclaren_f1" ] = {
	Name = "McLaren F1",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mclaren_f1",
	Model = "models/sentry/mclarenf1.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:1:9831394"] = true, ["STEAM_0:1:62247713"] = true, ["STEAM_0:1:174576217"] = true, ["STEAM_0:1:429847568"] = true, ["STEAM_0:1:623477509"] = true, ["STEAM_0:0:735338730"] = true, },
	Price = 1000,

}

PLUGIN.Vehicles[ "sim_fphys_lam_lm002" ] = {
	Name = "Lamborighini LM002",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lam_lm002",
	Model = "models/sim_fphys_lamborghini_lm002/lamborghini_lm002.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:0:626268130"] = true, ["STEAM_0:1:9831394"] = true, ["STEAM_0:1:59491439"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_por_carr_gt" ] = {
	Name = "Posche Carrera GT",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_por_carr_gt",
	Model = "models/tdmcars/por_carreragt.mdl",
	PlayersBuy = {["STEAM_0:1:43191126"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:1:9831394"] = true, ["STEAM_0:1:70905"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mercedes_benz_560sel" ] = {
	Name = "Mercedes-Benz 560 SEL",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mercedes_benz_560sel",
	Model = "models/crsk_autos/mercedes-benz/560sel_1985.mdl",
	PlayersBuy = {["STEAM_0:0:92166790"] = true, ["STEAM_0:1:571051284"] = true, ["STEAM_0:0:626268130"] = true, ["STEAM_0:0:73271356"] = true, ["STEAM_0:1:571051284"] = true, ["STEAM_0:1:12464230"] = true, ["STEAM_0:0:207879818"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_fleetwood_brougham_1985" ] = {
	Name = "Cadillac Fleetwood Brougham 1985",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_fleetwood_brougham_1985",
	Model = "models/crsk_autos/cadillac/fleetwood_brougham_1985.mdl",
	PlayersBuy = {["STEAM_0:1:59666025"] = true, ["STEAM_0:1:460167886"] = true, ["STEAM_0:1:68842975"] = true, ["STEAM_0:1:445618132"] = true, ["STEAM_0:1:493953043"] = true, },
	FactionsBuy = {[FACTION_BONANNOO] = true},
	Price = 1000,
}
PLUGIN.Vehicles[ "crsk_nissan_fairladyz_s30z_devilz" ] = {
	Name = "Nissan Fairlady Z S30Z 'Devil Z'",
	Category = "Custom Vehicles",
	Identifier = "crsk_nissan_fairladyz_s30z_devilz",
	Model = "models/crsk_autos/nissan/fairladyz_s30z_devilz.mdl",
	PlayersBuy = {["STEAM_0:0:65792502"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:1:434954440"] = true, ["STEAM_0:0:616676056"] = true, },
	FactionsBuy = {[FACTION_CARTIER] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ferrari_gto" ] = {
	Name = "Ferrari 250 GTO",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ferrari_gto",
	Model = "models/tdmcars/fer_250gto.mdl",
	PlayersBuy = {["STEAM_0:1:59666025"] = true, ["STEAM_0:0:182086019"] = true, ["STEAM_0:0:60833542"] = true, ["STEAM_0:1:59656630"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mer_g65" ] = {
	Name = "Mercedes G65 AMG W463",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mer_g65",
	Model = "models/LoneWolfie/mer_g65.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:1:218715370"] = true, ["STEAM_0:1:59491439"] = true, ["STEAM_0:1:571051284"] = true, ["STEAM_0:0:771901161"] = true, ["STEAM_0:1:434954440"] = true, },
	Price = 1000,

}

PLUGIN.Vehicles[ "sim_fphys_apollo_intensa" ] = {
	Name = "Apollo Intensa Emozione",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_apollo_intensa",
	Model = "models/crsk_autos/apollo/intensa_emozione.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:0:741695560"] = true, ["STEAM_0:1:9831394"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "truppenfahrrad" ] = {
	Name = "Bicycle",
	Category = "Custom Vehicles",
	Identifier = "truppenfahrrad",
	Model = "models/truppenfahrrad.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:1:9831394"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:0:150234913"] = true, ["STEAM_0:0:626268130"] = true, ["STEAM_0:1:98431287"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:1:429847568"] = true, ["STEAM_0:0:73271356"] = true, ["STEAM_0:0:586225293"] = true, ["STEAM_0:1:41437658"] = true},
	FactionsBuy = {[FACTION_RIPOUX] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_rolls_phantom_viii" ] = {
	Name = "Rolls-Royce Phantom VIII",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_rolls_phantom_viii",
	Model = "models/crsk_autos/rolls-royce/phantom_viii_2018.mdl",
	PlayersBuy = {["STEAM_0:1:171886346"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_mazda_787b" ] = {
	Name = "Mazda 787B LeMans",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mazda_787b",
	Model = "models/lonewolfie/mazda_787b.mdl",
	PlayersBuy = {["STEAM_0:0:73271356"] = true, ["STEAM_0:0:626268130"] = true, ["STEAM_0:0:207879818"] = true, ["STEAM_0:0:92166790"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_nis_sky_r34" ] = {
	Name = "Nissan Skyline GT-R R34",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_nis_sky_r34",
	Model = "models/tdmcars/skyline_r34.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:0:626268130"] = true, ["STEAM_0:0:65792502"] = true, ["STEAM_0:0:455164769"] = true, ["STEAM_0:0:207879818"] = true, ["STEAM_0:1:554098116"] = true, ["STEAM_0:1:526506620"] = true, ["STEAM_0:1:159737437"] = true, ["STEAM_0:0:243227620"] = true},
	Price = 1000,

}

PLUGIN.Vehicles[ "sim_fphys_mercedes_benz_w111_civ" ] = {
	Name = "Mercedes-Benz 220S W111",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_mercedes_benz_w111_civ",
	Model = "models/sim_fphys_mercedes_benz_w111/mercedes_benz_w111_civ.mdl",
	PlayersBuy = {["STEAM_0:1:70905"] = true, ["STEAM_0:1:43191126"] = true, ["STEAM_0:1:182519557"] = true, },
	FactionsBuy = {[FACTION_RUSSOFAMILY] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ferrari_testa" ] = {
	Name = "Ferrari 512 Testarossa",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ferrari_testa",
	Model = "models/tdmcars/ferrari512tr.mdl",
	PlayersBuy = {["STEAM_0:1:59666025"] = true, ["STEAM_0:1:59656630"] = true, ["STEAM_0:1:460167886"] = true, ["STEAM_0:0:60833542"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ferrari_daytona" ] = {
	Name = "Ferrari 365 Daytona",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ferrari_daytona",
	Model = "models/lonewolfie/ferrari_365gts.mdl",
	PlayersBuy = {["STEAM_0:1:59666025"] = true, ["STEAM_0:1:59656630"] = true, ["STEAM_0:1:460167886"] = true, ["STEAM_0:0:182086019"] = true, ["STEAM_0:0:92166790"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_car_TFRE_Fizco_Supra" ] = {
	Name = "Toyota Supra TRD 1998",
	Category = "Custom Vehicles",
	Identifier = "simfphys_car_TFRE_Fizco_Supra",
	Model = "models/tfre/vehicles/fizco_supra/toyota_supra_fizco.mdl",
	PlayersBuy = {["STEAM_0:0:65792502"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_buick_regal_gnx" ] = {
	Name = "Buick Regal GNX",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_buick_regal_gnx",
	Model = "models/steelemancars/bui_regal_gnx/bui_regal_gnx.mdl",
	PlayersBuy = {
		["STEAM_0:1:33856806"] = true, 
		["STEAM_0:1:91207613"] = true, 
		["STEAM_0:1:180521832"] = true, 
		["STEAM_0:1:548719375"] = true, 
		["STEAM_0:1:434954440"] = true, 
		["STEAM_0:0:581040052"] = true,
		["STEAM_0:0:80922832"] = true,
		["STEAM_0:0:529022001"] = true,
		["STEAM_0:0:7980297"] = true,
		["STEAM_0:1:224970532"] = true,
		["STEAM_0:1:90879973"] = true,
		["STEAM_0:1:184283627"] = true,
		["STEAM_0:0:626268130"] = true,
		["STEAM_0:0:91138754"] = true,
		["STEAM_0:1:460496157"] = true,
		["STEAM_0:0:608670892"] = true,
		["STEAM_0:1:86270011"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_ford_mustang_boss302" ] = {
	Name = "Ford Mustang Boss 302 '69",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_ford_mustang_boss302",
	Model = "models/wizwagons/ford/mustang1969.mdl",
	PlayersBuy = {["STEAM_0:1:43191126"] = true, ["STEAM_0:1:70905"] = true, },
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_f40lm" ] = {
	Name = "Ferrari F40 LM",
	Category = "Custom Vehicles",
	Identifier = "simfphys_f40lm",
	Model = "models/rwcars/f40_lm.mdl",
	PlayersBuy = {["STEAM_0:1:43191126"] = true, ["STEAM_0:1:70905"] = true, ["STEAM_0:0:73271356"] = true, ["STEAM_0:0:150234913"] = true, ["STEAM_0:1:182519557"] = true, ["STEAM_0:0:141213624"] = true, ["STEAM_0:1:526506620"] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_lincoln_iv" ] = {
	Name = "Lincoln Continental Mark IV 1972",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lincoln_iv",
	Model = "models/whitetiger/lincolncontmk472.mdl",
	PlayersBuy = {
		["STEAM_0:1:430029932"] = true,
		["STEAM_0:0:102763252"] = true,
		["STEAM_0:1:155655459"] = true,
		["STEAM_0:0:184639903"] = true,
		["STEAM_0:1:86444211"] = true,
		["STEAM_0:1:443575519"] = true,
		["STEAM_0:1:445618132"] = true,
		["STEAM_0:1:460167886"] = true,
		["STEAM_0:0:96149603"] = true,
		["STEAM_0:1:59666025"] = true,
		["STEAM_0:1:88785775"] = true,
	},
	FactionsBuy = {[FACTION_BONANNOO] = true},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_lam_veneno" ] = {
	Name = "Lamborghini Veneno",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_lam_veneno",
	Model = "models/sentry/veneno_new.mdl",
	PlayersBuy = {
		["STEAM_0:1:70905"] = true, 
		["STEAM_0:1:43191126"] = true, 
		["STEAM_0:0:771901161"] = true, 
		["STEAM_0:0:193591710"] = true, 
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_r32gtr1994" ] = {
	Name = "Nissan Skyline GT-R BNR32 V-Spec II 1994",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_r32gtr1994",
	Model = "models/ads/nissan/r32gtr1994.mdl",
	PlayersBuy = {
		["STEAM_0:0:193591710"] = true
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_gta_sa_flatbed" ] = {
	Name = "Flatbed",
	Category = "Custom Vehicles",
	Identifier = "simfphys_gta_sa_flatbed",
	Model = "models/gta_sa/industrial/flatbed.mdl",
	PlayersBuy = {
		["STEAM_0:1:621654501"] = true,
		["STEAM_0:1:635461734"] = true,
		["STEAM_0:0:198044063"] = true,
		["STEAM_0:0:626268130"] = true,
		["STEAM_0:0:168019327"] = true,
		["STEAM_0:0:141213624"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_tdmwrxsti" ] = {
	Name = "Subaru Impreza WRX STi 05",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_tdmwrxsti",
	Model = "models/tdmcars/sub_wrxsti05.mdl",
	PlayersBuy = {
		["STEAM_0:0:44425038"] = true,
		["STEAM_0:0:150242301"] = true,
		["STEAM_0:0:241632752"] = true,
		["STEAM_0:1:196864130"] = true,
		["STEAM_0:1:635461734"] = true,
		["STEAM_0:1:560982810"] = true,
		["STEAM_0:0:98607731"] = true,
		["STEAM_0:1:41437658"] = true,
		["STEAM_0:0:735338730"] = true,
		["STEAM_0:1:70905"] = true,
		["STEAM_0:1:564136784"] = true,
		["STEAM_0:1:429847568"] = true,
		["STEAM_0:0:23088464"] = true,
		["STEAM_0:0:173324654"] = true,
		["STEAM_0:0:165705512"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_m3e46gtr" ] = {
	Name = "BMW M3 E46 GTR",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_m3e46gtr",
	Model = "models/DiggerCars/BMW_M3E46GTR/v5.mdl",
	PlayersBuy = {
		["STEAM_0:1:183121115"] = true,
		["STEAM_0:0:703672464"] = true,
		["STEAM_0:1:631241078"] = true,
		["STEAM_0:0:37345854"] = true,
		["STEAM_0:0:52323722"] = true,
		["STEAM_0:1:107068895"] = true,
		["STEAM_0:0:23352242"] = true,
		["STEAM_0:1:47629152"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_gta_sa_forklift" ] = {
	Name = "Forklift",
	Category = "Custom Vehicles",
	Identifier = "simfphys_gta_sa_forklift",
	Model = "models/gta_sa/indistrual/forklift.mdl",
	PlayersBuy = {
		["STEAM_0:1:429847568"] = true,
		["STEAM_0:1:23278376"] = true,
		["STEAM_0:0:57167772"] = true,
		["STEAM_0:1:70905"] = true,
		["STEAM_0:1:59666025"] = true,
		["STEAM_0:1:196864130"] = true,
		["STEAM_0:1:50454506"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_gta_sa_caddy" ] = {
	Name = "Golf Caddy",
	Category = "Custom Vehicles",
	Identifier = "simfphys_gta_sa_caddy",
	Model = "models/gta_sa/novelty/caddy.mdl",
	PlayersBuy = {
		["STEAM_0:1:48995558"] = true,
		["STEAM_0:1:635461734"] = true,
		["STEAM_0:1:70905"] = true,
		["STEAM_0:1:43191126"] = true,
		["STEAM_0:0:626268130"] = true,
		["STEAM_0:0:150234913"] = true,
		["STEAM_0:1:591824317"] = true,
		["STEAM_0:1:553757726"] = true,
		["STEAM_0:1:564136784"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_honda_nsx_r" ] = {
	Name = "Honda NSX-R",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_honda_nsx_r",
	Model = "models/loneWolfie/honda_nsxr.mdl",
	PlayersBuy = {
		["STEAM_0:0:241632752"] = true,
		["STEAM_0:0:44425038"] = true,
		["STEAM_0:1:425645995"] = true,
		["STEAM_0:0:581040052"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "r752" ] = {
	Name = "Kawasaki H2R",
	Category = "Custom Vehicles",
	Identifier = "r752",
	Model = "models/kawasaki_ninja_h2r.mdl",
	PlayersBuy = {
		["STEAM_0:1:571051284"] = true,
	},
	FactionsBuy = {
		[FACTION_KTRIAD] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_vnomfiero" ] = {
	Name = "1988 Pontiac Fiero GT",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_vnomfiero",
	Model = "models/tdmcars/pon_fierogt.mdl",
	PlayersBuy = {
		["STEAM_0:1:107068895"] = true,
		["STEAM_0:1:220691029"] = true,
		["STEAM_0:0:703672464"] = true,
		["STEAM_0:1:631241078"] = true,
		["STEAM_0:1:183121115"] = true,
		["STEAM_0:1:741119637"] = true,
		["STEAM_0:0:608670892"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "simfphys_gta_sa_quad" ] = {
	Name = "Quad Bike",
	Category = "Custom Vehicles",
	Identifier = "simfphys_gta_sa_quad",
	Model = "models/gta_sa/novelty/quad.mdl",
	PlayersBuy = {
		["STEAM_0:1:429847568"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_maserati_ghibli" ] = {
	Name = "Maserati Ghibli II",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_maserati_ghibli",
	Model = "models/AquilaCars/MaseratiGhibli.mdl",
	PlayersBuy = {
		["STEAM_0:1:59666025"] = true,
	},
	FactionsBuy = {
		[FACTION_BONANNOO] = true
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_cad_eldorado_limo" ] = {
	Name = "Cadillac Eldorado Limo",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_cad_eldorado_limo",
	Model = "models/lonewolfie/cad_eldorado_limo.mdl",
	PlayersBuy = {
		["STEAM_0:1:631241078"] = true,
		["STEAM_0:1:107068895"] = true,
		["STEAM_0:1:183121115"] = true,
		["STEAM_0:1:224970532"] = true,
		["STEAM_0:0:134882196"] = true,
		["STEAM_0:1:41437658"] = true,
		["STEAM_0:0:86218000"] = true,
		["STEAM_0:0:515445868"] = true,
		["STEAM_0:0:23352242"] = true,
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_bentley_arnage_t" ] = {
	Name = "Bentley Arnage T",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_bentley_arnage_t",
	Model = "models/lonewolfie/bentley_arnage_t.mdl",
	PlayersBuy = {
		["STEAM_0:1:107068895"] = true,
	},
	FactionsBuy = {
		[FACTION_DAVISBOYS] = true
	},
	Price = 1000,
}

PLUGIN.Vehicles[ "sim_fphys_dodge_viper" ] = {
	Name = "Dodge Viper GTS ACR",
	Category = "Custom Vehicles",
	Identifier = "sim_fphys_dodge_viper",
	Model = "models/lonewolfie/dodge_viper.mdl",
	PlayersBuy = {
		["STEAM_0:0:452993334"] = true,
		["STEAM_0:1:78949473"] = true,
		["STEAM_0:1:46412756"] = true,
	},
	Price = 1000,
}
