SCHEMA.name = "Mobsters Paradise"
SCHEMA.author = "Null"
SCHEMA.desc = "Manhattan, New York, 2002."

-- Initialize currency
nut.currency.set("$", "Dollar", "Dollars")

-- ============ CORE SCHEMA INCLUDES ============
-- Load core framework and character system
nut.util.include("meta/sh_character.lua")
nut.util.include("sh_config.lua")
nut.util.include("sh_dev.lua")
nut.util.include("sv_database.lua")

-- ============ SCHEMA DIRECTORIES ============
-- Load all subdirectory systems in order
nut.util.includeDir("core")
nut.util.includeDir("derma")
nut.util.includeDir("factions")
nut.util.includeDir("classes")
nut.util.includeDir("items")

-- ============ SCHEMA FILES ============
-- Load individual schema system files
nut.util.include("cl_schema.lua")
nut.util.include("sv_schema.lua")
nut.util.include("sh_commands.lua")
nut.util.include("sv_commands.lua")
nut.util.include("sh_wiretap.lua")
nut.util.include("sh_addiction.lua")

-- ============ FLAG SYSTEM ============
nut.flag.add("u", "Banned from OOC")
nut.flag.add("B", "Access to spawn restricted vehicles")
nut.flag.add("T", "Access to queue media")
nut.flag.add("W", "Can manage wiretaps")
nut.flag.add("C", "Can access crew systems")
nut.flag.add("M", "Can manage money laundering")
nut.flag.add("D", "Can distribute drugs")
nut.flag.add("L", "Can loan shark")

-- ============ CONFIGURATION ============
nut.config.add("f1date", 2002, "The year displayed on the F1 menu", nil, {category = "appearance", data = {min = 2000, max = 2010}})
nut.config.add("shipmentExclusiveAccessTime", 600, "How long the owner of the shipment has exclusive access to its contents.", nil, {category = "shipments", data = {min = 120, max = 1800}})
nut.config.add("cars_deleteplayercount", 75, "The player count at which cars are then deleted.", nil, {data = {min = 1, max = 128}, category = "cars"})
nut.config.add("overdoseThreshold", 3, "Number of drugs before overdose chance appears.", nil, {category = "drugs", data = {min = 1, max = 10}})
nut.config.add("overdoseDamage", 50, "Damage taken from overdose.", nil, {category = "drugs", data = {min = 10, max = 100}})
nut.config.add("withdrawalDamage", 5, "Damage per tick from withdrawal.", nil, {category = "drugs", data = {min = 1, max = 20}})
nut.config.add("wiretapDetectionRange", 500, "Range in which wiretaps can be detected by law enforcement.", nil, {category = "crime", data = {min = 100, max = 1000}})
nut.config.add("crackProductionTime", 180, "Time in seconds to cook crack cocaine.", nil, {category = "drugs", data = {min = 60, max = 600}})
nut.config.add("dmt_productionTime", 240, "Time in seconds to extract DMT.", nil, {category = "drugs", data = {min = 60, max = 600}})

-- ============ ADMIN RANK SYSTEM ============
SCHEMA.RanksFounder = {founder = true, communitymanager = true}
SCHEMA.RanksCM = {founder = true, communitymanager = true}
SCHEMA.RanksHA = {founder = true, communitymanager = true, headadministrator = true}
SCHEMA.RanksSuper = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true}
SCHEMA.RanksSenior = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true}
SCHEMA.RanksSeasoned = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true}
SCHEMA.RanksAdmin = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true}
SCHEMA.RanksMod = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true, moderator = true}
SCHEMA.RanksDonator = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true, moderator = true, donator = true}

-- ============ CHARACTER DATA SCHEMA ============
-- Extended character data for crime mechanics
SCHEMA.charData = {
	faction = "Civilian",
	crew = nil,
	crewRank = 0,
	money = 0,
	launderedMoney = 0,
	heat = 0, -- Police heat level
	wantedLevel = 0,
	criminalRecord = {},
	knownConnections = {},
	safeHouses = {},
	businesses = {},
	loans = {},
	loanActivity = {},
	drugAddictions = {}, -- Addiction tracking (format: [drugID] = intensity)
	overdoseCount = 0,
	jailTime = 0,
	lastHospitalVisit = 0,
	streetRep = 0, -- Reputation points
	wantedForCrimes = {}, -- List of crimes player is wanted for
}

-- ============ DISABLE DEFAULT VISUALS ============
hook.Add('ShouldDrawCrosshair', 'DisableCrosshair', function()
	return false
end)

-- ============ MODEL ANIMATIONS (Y2K NYC/NJ Style) ============
local nyc_models = {
	-- Federal agents
	"models/fbi_pack/fbi_01.mdl",
	"models/fbi_pack/fbi_02.mdl",
	"models/fbi_pack/fbi_03.mdl",
	"models/fbi_pack/fbi_04.mdl",
	"models/fbi_pack/fbi_05.mdl",
	"models/fbi_pack/fbi_06.mdl",
	"models/fbi_pack/fbi_07.mdl",
	-- NYPD Classic
	"models/nypd_old/nypd_vin_1.mdl",
	"models/nypd_old/nypd_vin_2.mdl",
	"models/nypd_old/nypd_vin_3.mdl",
	"models/nypd_old/nypd_vin_4.mdl",
	"models/nypd_old/nypd_vin_5.mdl",
	"models/nypd_old/nypd_vin_6.mdl",
	"models/nypd_old/nypd_vin_7.mdl",
	"models/nypd_old/nypd_vin_8.mdl",
	"models/nypd_old/nypd_vin_9.mdl",
	-- Generic civilians
	"models/humans/adaster/male_01.mdl",
	"models/humans/adaster/male_02.mdl",
	"models/humans/adaster/male_03.mdl",
	"models/humans/adaster/male_04.mdl",
	"models/humans/adaster/male_05.mdl",
	"models/humans/adaster/male_06.mdl",
	"models/humans/adaster/male_07.mdl",
	"models/humans/adaster/male_08.mdl",
	"models/humans/adaster/male_09.mdl",
	"models/humans/adaster/female_01.mdl",
	"models/humans/adaster/female_02.mdl",
	"models/humans/adaster/female_04.mdl",
	"models/humans/adaster/female_06.mdl",
	-- Paramedics
	"models/kerry/ag_paramedic/male_01.mdl",
	"models/kerry/ag_paramedic/male_02.mdl",
	"models/kerry/ag_paramedic/male_03.mdl",
	"models/kerry/ag_paramedic/male_04.mdl",
}

for _, model in ipairs(nyc_models) do
	nut.anim.setModelClass(model, "player")
end

-- ============ STORAGE DEFINITIONS ============
hook.Add("InitPostEntity", "InitializeStorageContainers", function()
	STORAGE_DEFINITIONS = STORAGE_DEFINITIONS or {}
	
	STORAGE_DEFINITIONS["models/props_c17/FurnitureDrawer01a.mdl"] = {
		name = "Filing Cabinet",
		desc = "A secure filing cabinet for documents and valuables.",
		invType = INV_TYPE_ID,
		invData = {w = 5, h = 5}
	}
	
	STORAGE_DEFINITIONS["models/props_junk/trashbin01a.mdl"] = {
		name = "Trash Bin",
		desc = "For disposing of evidence.",
		invType = INV_TYPE_ID,
		invData = {w = 3, h = 3}
	}
	
	STORAGE_DEFINITIONS["models/props_wasteland/laundry_basket001.mdl"] = {
		name = "Drug Manufacturing Station",
		desc = "For processing and refining narcotics.",
		invType = INV_TYPE_ID,
		invData = {w = 7, h = 7}
	}
	
	STORAGE_DEFINITIONS["models/items/ammocrate_smg1.mdl"] = {
		name = "Weapons Cache",
		desc = "Secure storage for firearms and ammunition.",
		invType = INV_TYPE_ID,
		invData = {w = 5, h = 5},
		onOpen = function(entity, activator)
			entity:ResetSequence("Close")
			timer.Create("CloseLid"..entity:EntIndex(), 2, 1, function()
				if (IsValid(entity)) then
					entity:ResetSequence("Open")
				end
			end)
		end
	}
	
	STORAGE_DEFINITIONS["models/props_c17/cashregister01a.mdl"] = {
		name = "Money Stash",
		desc = "For storing large amounts of cash.",
		invType = INV_TYPE_ID,
		invData = {w = 6, h = 6}
	}
end)

-- ============ CLIENT-SIDE OPTIMIZATIONS ============
if CLIENT then
	hook.Add("InitPostEntity", "RemoveChatBubble", function()
		hook.Remove("StartChat", "StartChatIndicator")
		hook.Remove("FinishChat", "EndChatIndicator")
		hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator")
		hook.Remove("CreateClientsideRagdoll", "DarkRP_ChatIndicator")
		hook.Remove("player_disconnect", "DarkRP_ChatIndicator")
	end)
	
	-- Performance tweaks
	hook.Add("EntityEmitSound", "removeToolgunSound", function(tab)
		if SERVER then
			local sounds = {
				["weapons/airboat/airboat_gun_lastshot1.wav"] = true,
				["weapons/airboat/airboat_gun_lastshot2.wav"] = true
			}
			if sounds[tab.SoundName] then
				return false
			end
		end
	end)
end

-- ============ PROPERTY EDITING RESTRICTIONS ============
local canEditProperties = {
	["STEAM_0:0:00000000"] = true, -- Add trusted modders here
}

hook.Add("CanProperty", "AllowPropertyEditing", function(ply, property, ent)
	if property == "editentity" and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then
		return canEditProperties[ply:SteamID()] or ply:IsSuperAdmin() or false
	end
end)

-- ============ GLOBAL DRUG COUNTERS (prevents abuse) ============
KTDrugCounter = KTDrugCounter or {}

-- ============ SERVER-SIDE INITIALIZATION ============
if SERVER then
	-- Initialize crew system
	CREWS = CREWS or {}
	TERRITORIES = TERRITORIES or {}
	WIRETAPS = WIRETAPS or {}
	LOAN_RECORDS = LOAN_RECORDS or {}
	
	-- Register NPCs for addiction clearing
	hook.Add("InitPostEntity", "RegisterHospitalNPCs", function()
		-- Hospital NPCs will be spawned in sv_schema.lua with dialogue for addiction treatment
	end)
	
	-- Anti-cheat: Monitor drug usage
	hook.Add("PlayerUseItem", "MonitorDrugUse", function(ply, item)
		if item and item.category == "Drugs" then
			local char = ply:getChar()
			if char then
				local steamID = ply:SteamID64()
				KTDrugCounter[steamID] = KTDrugCounter[steamID] or {drugCount = 0}
				KTDrugCounter[steamID].drugCount = KTDrugCounter[steamID].drugCount + 1
				
				-- Overdose check
				if KTDrugCounter[steamID].drugCount >= nut.config.get("overdoseThreshold") then
					if math.random(1, 100) <= (KTDrugCounter[steamID].drugCount * 15) then
						-- Overdose event triggered
						ply:TakeDamage(nut.config.get("overdoseDamage"))
						ply:EmitSound("vo/npc_citizen/pain/citizen_pain0"..math.random(1,7)..".wav")
						char:setData("overdoseCount", char:getData("overdoseCount", 0) + 1)
						
						nut.log.add(ply, "overdose", item.name, KTDrugCounter[steamID].drugCount)
						
						if ply:Health() <= 0 then
							ply:Kill()
						end
					end
				end
			end
		end
	end)
	
	-- Reset drug count periodically
	timer.Create("ResetDrugCounters", 300, 0, function()
		KTDrugCounter = {}
	end)
end

-- Fix model animations.
nut.anim.setModelClass("models/ninja/mgs5gz/mgs5_gz_xof.mdl", "player")
nut.anim.setModelClass("models/winningrook/gtav/clowns/clown_001.mdl", "player")
nut.anim.setModelClass("models/ninja/mgs4_praying_mantis_merc.mdl", "player")
nut.anim.setModelClass("models/ninja/mgs4_praying_mantis_merc_short_sleeved.mdl", "player")
nut.anim.setModelClass("models/player/fenix/females/elizabeth/liz2_pm.mdl", "player")
nut.anim.setModelClass("models/diverge/gunman/gun_man.mdl", "player")
nut.anim.setModelClass("models/char/leader_3.mdl", "player")
nut.anim.setModelClass("models/winningrook/gtav/clowns/clown_000.mdl", "player")
nut.anim.setModelClass("models/stahl/humans/female/female_01.mdl", "player")
nut.anim.setModelClass("models/stahl/humans/female/female_02.mdl", "player")
nut.anim.setModelClass("models/stahl/humans/female/female_04.mdl", "player")
nut.anim.setModelClass("models/stahl/humans/female/female_06.mdl", "player")
nut.anim.setModelClass("models/stahl/humans/female/female_10.mdl", "player")
nut.anim.setModelClass("models/stahl/humans/female/female_11.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_01.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_02.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_03.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_04.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_05.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_06.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_07.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_08.mdl", "player")
nut.anim.setModelClass("models/fbi_pack/fbi_09.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_1.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_2.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_3.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_4.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_5.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_6.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_7.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_8.mdl", "player")
nut.anim.setModelClass("models/nypd_old/nypd_vin_9.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_01.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_02.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_03.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_04.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_05.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_01_arm.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_02_arm.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_03_arm.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_04_arm.mdl", "player")
nut.anim.setModelClass("models/portal/sheriff_05_arm.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_01.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_02.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_03.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_04.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_05.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_06.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_07.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_08.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/male_09.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/female_01.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/female_02.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/female_04.mdl", "player")
nut.anim.setModelClass("models/humans/adaster/female_06.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/swat.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_03.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_03_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_03_b.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_04.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_04_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_04_b.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_05.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_05_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_05_b.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_06.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_06_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_06_b.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_07.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_07_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nypd/nypdmale_07_b.mdl", "player")
nut.anim.setModelClass("models/kerry/atf_01.mdl", "player")
nut.anim.setModelClass("models/kerry/atf_02.mdl", "player")
nut.anim.setModelClass("models/kerry/atf_03.mdl", "player")
nut.anim.setModelClass("models/kerry/atf_04.mdl", "player")
nut.anim.setModelClass("models/kerry/atf_05.mdl", "player")
nut.anim.setModelClass("models/kerry/atf_06.mdl", "player")
nut.anim.setModelClass("models/kerry/atf_07.mdl", "player")
nut.anim.setModelClass("models/kerry/male_01.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_01.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_02.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_03.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_04.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_05.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_06.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_07.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_paramedic/male_08.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_01.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_02.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_03.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_04.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_05.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_06.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_07.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_08.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_01.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_02.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_03.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_04.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_05.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_06.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_07.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_08.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_01_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_02_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_03_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_04_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_05_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_06_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_07_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_08_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_09_cheff.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_01_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_02_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_03_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_04_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_05_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_06_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_07_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_08_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/ag_player/male_09_fbi.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/medic_ag/male_09.mdl", "player")
nut.anim.setModelClass("models/kerry/ppd_1_03.mdl", "player")
nut.anim.setModelClass("models/kerry/ppd_1_04.mdl", "player")
nut.anim.setModelClass("models/player/kerry/swat_ls.mdl", "player")
nut.anim.setModelClass("models/player/kerry/swat_ls_2.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_03.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_04.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_05.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_06.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_07.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_03_arm", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_04_arm", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_05_arm", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_06_arm", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_07_arm", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_03_arm", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_03_b.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_04_b.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_05_b.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_06_b.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_07_b.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_03_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_04_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_05_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_06_arm.mdl", "player")
nut.anim.setModelClass("models/portal/nycpd/nycpdmale_07_arm.mdl", "player")
nut.anim.setModelClass("models/palyer/kerry/jew_boss.mdl", "player")
nut.anim.setModelClass("models/palyer/kerry/jew.mdl", "player")
nut.anim.setModelClass("models/player/darkley/marshal_01.mdl", "player")
nut.anim.setModelClass("models/player/darkley/marshal_02.mdl", "player")
nut.anim.setModelClass("models/player/darkley/marshal_03.mdl", "player")
nut.anim.setModelClass("models/player/darkley/marshal_04.mdl", "player")
nut.anim.setModelClass("models/player/darkley/marshal_05.mdl", "player")
nut.anim.setModelClass("models/omgwtfbbq/Quantum_Break/Characters/Operators/MonarchOperator01PlayerModel.mdl", "player")
nut.anim.setModelClass("models/pm/moviebaddies/baddie1.mdl", "player")
nut.anim.setModelClass("models/pm/moviebaddies/baddie2.mdl", "player")
nut.anim.setModelClass("models/pm/moviebaddies/baddie3.mdl", "player")
nut.anim.setModelClass("models/player/kuma/alqaeda_commando.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier1.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier1b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier1c.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier2.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier2b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier2c.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier3.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier3b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier3c.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier4.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier4b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/desert/soldier4c.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/soldier1nbc.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier1.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier1b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier1c.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier2.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier2b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier2c.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier3.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier3b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier3c.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier4.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier4b.mdl", "player")
nut.anim.setModelClass("models/gulfamericans/woodland/soldier4c.mdl", "player")
nut.anim.setModelClass("models/iraqiarmy/soldier1_ddpm.mdl", "player")
nut.anim.setModelClass("models/iraqiarmy/soldier1_dpm.mdl", "player")
nut.anim.setModelClass("models/iraqiarmy/soldier1_od.mdl", "player")
nut.anim.setModelClass("models/iraqiarmy/soldier1.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator1b.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator1c.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator2.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator2b.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator2c.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator3.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator3b.mdl", "player")
nut.anim.setModelClass("models/pm/moviesf/operator3c.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us01.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us02.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us03.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us04.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us05.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us06.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us07.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us08.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us09.mdl", "player")
nut.anim.setModelClass("models/jessev92/soldier_vietnam/us11.mdl", "player")
nut.anim.setModelClass("models/player/kuma/taliban_bomber.mdl", "player")
nut.anim.setModelClass("models/player/kuma/taliban_grunt.mdl", "player")
nut.anim.setModelClass("models/player/kuma/taliban_rpg.mdl", "player")
nut.anim.setModelClass("models/kemot44/models/re2_remake/characters/ada_wong_coat_pm.mdl", "player")
nut.anim.setModelClass("models/kemot44/models/re2_remake/characters/ada_wong_dress_pm.mdl", "player")
nut.anim.setModelClass("models/survivors/survivor_adacoat.mdl", "player")
nut.anim.setModelClass("models/survivors/survivor_adanocoat.mdl", "player")
nut.anim.setModelClass("models/kuma96/2b/2b_pm.mdl", "player")
nut.anim.setModelClass("models/tpamodern.mdl", "player")
nut.anim.setModelClass("models/tpamodern2.mdl", "player")
nut.anim.setModelClass("models/mgsv_russian_soldier_pm.mdl", "player")
nut.anim.setModelClass("models/ninja/mgs5gz/mgs5_gz_xof.mdl", "player")
nut.anim.setModelClass("models/ninja/mgs5gz/mgs5_gz_xof2.mdl", "player")
nut.anim.setModelClass("models/ninja/mgs5gz/mgs5_gz_xof3.mdl", "player")

print("[Mobsters Paradise] Schema loaded successfully!")
