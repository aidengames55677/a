-- "gamemodes\\mafiarp\\schema\\sh_schema.lua"

SCHEMA.name = "1980's Mafia Roleplay"
SCHEMA.author = "Diverge Networks"

if isMiami then
	SCHEMA.desc = "New York - UnionCity, 1986."
elseif !isMiami then
	SCHEMA.desc = "New York - SouthSide, 1988."
end
nut.currency.set("$", "Dollar", "Dollars")

nut.util.include("meta/sh_character.lua")
nut.util.include("cl_schema.lua")
nut.util.include("sv_schema.lua")
nut.util.include("sh_commands.lua")
nut.util.include("sv_commands.lua")

nut.flag.add("u", "Banned from OOC")
nut.flag.add("B", "Access to spawn a Bearcat")
nut.flag.add("T", "Access to queue media")

nut.config.add("f1date", 1984, "The date displayed on the F1 menu", nil, {category = "appearance", data = {min = 1000, max = 3000}})
nut.config.add("shipmentExclusiveAccessTime", 600, "How long the owner of the shipment will have exclusive access to it's contents.", nil, {category = "shipments", data = {min = 120, max = 1800}})
nut.config.add("cars_deleteplayercount", 75, "The player count in which cars are then deleted.", nil, {data = {min = 1, max = 128}, category = "cars"})

SCHEMA.RanksFounder = {founder = true, communitymanager = true}
SCHEMA.RanksCM = {founder = true, communitymanager = true}
SCHEMA.RanksHA = {founder = true, communitymanager = true, headadministrator = true}
SCHEMA.RanksSuper = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true}
SCHEMA.RanksSenior = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true}
SCHEMA.RanksSeasoned = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true,}
SCHEMA.RanksAdmin = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true,}
SCHEMA.RanksMod = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true, moderator = true}
SCHEMA.RanksDonator = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true, moderator = true, donator = true}

-- Don't draw crosshair.
hook.Add('ShouldDrawCrosshair', 'DisableCrosshair', function()
	return false
end)

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


local offDutyNoclip = {
    founder = true,
    communitymanager = true,
	headadministrator = true,
}

function GAMEMODE:PlayerNoClip(client)
    return offDutyNoclip[client:GetUserGroup()] or client:Team() == FACTION_STAFF
end

function SCHEMA:IsCharRecognized(char, id)
	if char:getFaction() == FACTION_STAFF or offDutyNoclip[char:getPlayer():GetUserGroup()] then
		return true
	end
end

local canSpawnStorage = {
	founder = true,
    communitymanager = true,
	headadministrator = true,
    superadministrator = true,
    senioradministrator = true,
	seasonedadministrator = true,
    administrator = true,
    moderator = true,
	headgamemaster = true,
}

function SCHEMA:CanPlayerSpawnStorage(client, ent, data)
	if !canSpawnStorage[client:GetUserGroup()] then
		return false
	end
end


hook.Add("InitializedConfig", "ChangeOOCChattype", function()
	nut.chat.register("ooc", {
		onCanSay =  function(speaker, text)
			if (!nut.config.get("allowGlobalOOC") && !SCHEMA.RanksMod[speaker:GetUserGroup()]) then
				speaker:notifyLocalized("Global OOC is disabled on this server.")
				speaker:notifyLocalized("If you need assistance use @ followed by your message in chat. E.g @I need assistance.")
				return false		
			else
				local delay = nut.config.get("oocDelay", 10)
				if (speaker:getChar():hasFlags("u")) then --ooc banning
					speaker:notifyLocalized("You are currently restricted from using OOC.")
					return false
				end

				if #text > 512 then
					speaker:notify("You can only type messages less than 512 characters in length.")
					return false
				end

				-- Only need to check the time if they have spoken in OOC chat before.
				if (delay > 0 and speaker.nutLastOOC) then
					local lastOOC = CurTime() - speaker.nutLastOOC

					-- Use this method of checking time in case the oocDelay config changes.
					if (lastOOC <= delay and speaker:IsUserGroup("user")) then
						speaker:notifyLocalized("oocDelay", delay - math.ceil(lastOOC))

						return false
					end
				end

				-- Save the last time they spoke in OOC.
				speaker.nutLastOOC = CurTime()
			end
		end,
		onChatAdd = function(speaker, text)
			local icon = "icon16/user.png"

			-- man, I did all that works and I deserve differnet icon on ooc chat
			-- if you dont like it
			-- well..
			-- it's on your own.
			if (speaker:SteamID() == "STEAM_0:0:1741704") then -- Chessnut
				icon = "icon16/script_gear.png"
			elseif (speaker:SteamID() == "STEAM_0:0:19814083") then -- Black Tea the edgiest man
				icon = "icon16/gun.png"
			elseif (speaker:IsUserGroup("founder") or speaker:IsUserGroup("communitymanager") or speaker:IsUserGroup("headadministrator") or speaker:IsUserGroup("servermanager") or speaker:IsUserGroup("advisor")) then
				icon = "icon16/shield.png"
			elseif (speaker:IsUserGroup("globalop") or speaker:IsUserGroup("superadministrator") or speaker:IsUserGroup("administrator") or speaker:IsUserGroup("moderator") or speaker:IsUserGroup("senioradministrator")) then
				icon = "icon16/star.png"
			elseif (speaker:IsUserGroup("donator")) then
				icon = "icon16/heart.png"
			end

			icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

			chat.AddText(icon, Color(255, 50, 50), " [OOC] ", speaker, color_white, ": "..text)
		end,
		prefix = {"//", "/ooc"},
		noSpaceAfter = true,
		filter = "ooc"
	})
	
	local globalRanks = {
		eventmanager = true,
		moderator = true,
		administrator = true,
		seasonedadministrator = true,
		senioradministrator = true,
		advisor = true,
		superadministrator = true,
		headadministrator = true,
		communitymanager = true,
		founder = true,
	}

	nut.chat.register("event", {
		onCanSay =  function(speaker, text)
			local uniqueID = speaker:GetUserGroup()
			if(globalRanks[uniqueID]) then
				return true
			else
				speaker:notify("You do not have access to this command.")
				return false
			end
		end,
		onCanHear = 1000000,
		onChatAdd = function(speaker, text)
			chat.AddText(Color(255, 150, 0), text)
		end,
		prefix = {"/event"}
	})
	-- Roll information in chat.
	nut.chat.register("roll", {
		format = "%s has rolled %s.",
		color = Color(155, 111, 176),
		filter = "actions",
		font = "nutChatFontItalics",
		onCanHear = nut.config.get("chatRange", 280),
		deadCanChat = true
	})

	nut.chat.register("it", {
		onCanSay =  function(speaker, text)
			local uniqueID = speaker:GetUserGroup()
			if(globalRanks[uniqueID]) then
				return true
			else
				speaker:notify("You do not have access to this command.")
				return false
			end
		end,
		onChatAdd = function(speaker, text)
			chat.AddText(nut.config.get("chatColor"), "**"..text)
		end,
		onCanHear = nut.config.get("chatRange", 280),
		prefix = {"/it"},
		font = "nutChatFontItalics",
		filter = "actions",
		deadCanChat = true
	})
end)

hook.Add("InitializedPlugins", "loadstorages", function()
	local INV_TYPE_ID = "grid"

	local STORAGE_DEFINITIONS = nut.plugin.list.storage.definitions
	STORAGE_DEFINITIONS["models/props_junk/wood_crate001a.mdl"] = {
		name = "Wood Crate",
		desc = "A crate made out of wood.",
		invType = INV_TYPE_ID,
		invData = {
			w = 8,
			h = 8
		}
	}
	STORAGE_DEFINITIONS["models/props_c17/lockers001a.mdl"] = {
		name = "Locker",
		desc = "A white locker.",
		invType = INV_TYPE_ID,
		invData = {
			w = 8,
			h = 10
		}
	}
	STORAGE_DEFINITIONS["models/props_wasteland/controlroom_storagecloset001a.mdl"] = {
		name = "Metal Closet",
		desc = "A green storage closet.",
		invType = INV_TYPE_ID,
		invData = {
			w = 10,
			h = 10
		}
	}
	STORAGE_DEFINITIONS["models/props_wasteland/controlroom_filecabinet002a.mdl"] = {
		name = "File Cabinet",
		desc = "A metal file cabinet.",
		invType = INV_TYPE_ID,
		invData = {
			w = 3,
			h = 6
		}
	}
	STORAGE_DEFINITIONS["models/props_c17/furniturefridge001a.mdl"] = {
		name = "Refrigerator",
		desc = "A metal box to keep food in",
		invType = INV_TYPE_ID,
		invData = {
			w = 3,
			h = 4
		}
	}
	STORAGE_DEFINITIONS["models/props_wasteland/kitchen_fridge001a.mdl"] = {
		name = "Large Refrigerator",
		desc = "A large metal box to keep even more food in.",
		invType = INV_TYPE_ID,
		invData = {
			w = 7,
			h = 7
		}
	}
	STORAGE_DEFINITIONS["models/props_junk/trashbin01a.mdl"] = {
		name = "Trash Bin",
		desc = "A container for junk.",
		invType = INV_TYPE_ID,
		invData = {
			w = 1,
			h = 3
		}
	}
	STORAGE_DEFINITIONS["models/items/ammocrate_smg1.mdl"] = {
		name = "Ammo Crate",
		desc = "A heavy crate for storing ammunition.",
		invType = INV_TYPE_ID,
		invData = {
			w = 5,
			h = 3
		},
		onOpen = function(entity, activator)
			entity:ResetSequence("Close")

			timer.Create("CloseLid"..entity:EntIndex(), 2, 1, function()
				if (IsValid(entity)) then
					entity:ResetSequence("Open")
				end
			end)
		end
	}
end)

if CLIENT then
	hook.Add("InitPostEntity", "RemoveChatBubble", function()
		hook.Remove("StartChat", "StartChatIndicator")
		hook.Remove("FinishChat", "EndChatIndicator")

		hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator")
		hook.Remove("CreateClientsideRagdoll", "DarkRP_ChatIndicator")
		hook.Remove("player_disconnect", "DarkRP_ChatIndicator")
	end)
end

local canEditSimfphys = {
	["STEAM_0:0:1015165"] = true,
}

hook.Add("CanProperty", "AllowSteamIDEditProperties", function(ply, property, ent)
	if property == "editentity" and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then
		return canEditSimfphys[ply:SteamID()] or ply:IsSuperAdmin() or false
	end
end)


// Disable toolgun noises
local sounds = {
	["weapons/airboat/airboat_gun_lastshot1.wav"] = true,
	["weapons/airboat/airboat_gun_lastshot2.wav"] = true
}

hook.Add( "EntityEmitSound", "removeToolgunSound", function( tab )
	if (SERVER) then	
		if sounds[tab.SoundName] then 
			return false	
		end
	end
end)

local solidCosmetics = {
	"dn_cosmetic_blue",
	"dn_cosmetic_lime",
	"dn_cosmetic_olive",
	"dn_cosmetic_pink",
	"dn_cosmetic_purple",
	"dn_cosmetic_red",
	"dn_cosmetic_teal",
	"dn_cosmetic_yellow",
	"mw2_wepcamo_blackout",
	"mw2_wepcamo_whiteout",
}

local armyCosmetics = {
	"dn_cosmetic_arctic",
	"dn_cosmetic_autumn",
	"dn_cosmetic_desert",
	"dn_cosmetic_goldentiger",
	"dn_cosmetic_m81",
	"dn_cosmetic_navy",
	"dn_cosmetic_tiger",
	"dn_cosmetic_urban",
	"dn_cosmetic_carpet",
	"dn_cosmetic_citrus",
	"mw2_wepcamo_desert",
	"mw2_wepcamo_arctic",
	"mw2_wepcamo_woodland",
	"mw2_wepcamo_bushdweller",
	"mw2_wepcamo_fall",
	"mw2_wepcamo_redtiger",
	"mw2_wepcamo_bluetiger",
	"mw2_wepcamo_urban",
}

local patternCosmetics = {
	"dn_cosmetic_jazz",
	"dn_cosmetic_marbled",
	"dn_cosmetic_scarred",
	"dn_cosmetic_hairy",
	"dn_cosmetic_storm",
	"dn_cosmetic_tab",
	"dn_cosmetic_pinstripe",
	"dn_cosmetic_threestripes",
	"mw2_wepcamo_thunderstorm",
}

local donoRanks = {
	founder = true,
	communitymanager = true,
	headadministrator = true,
	superadministrator = true,
	senioradministrator = true,
	seasonedadministrator = true,
	administrator = true,
	moderator = true,
	donator = true,
}

hook.Add("ArcCW_PlayerCanAttach", "PreventNonDonator", function(ply, wep, attname, slot, detach)
	if string.find(attname, "charm") && !ply:getNutData("hasCharms") then
		nut.util.notify("This is apart of the charms pack which can be obtained via donation. Type !donate for more information.")
		chat.AddText("This is apart of the charms pack which can be obtained via donation. Type !donate for more information.")
		return false
	end	

	if table.HasValue(solidCosmetics, attname) && !ply:getNutData("hasSolidCosmetics") then
		nut.util.notify("This skin is apart of the solids cosmetics weapon pack which can be obtained via donation. Type !donate for more information.")
		chat.AddText("This skin is apart of the solids cosmetics weapon pack which can be obtained via donation. Type !donate for more information.")
		return false
	end

	if table.HasValue(armyCosmetics, attname) && !ply:getNutData("hasArmyCosmetics") then
		nut.util.notify("This skin is apart of the camouflage cosmetics weapon pack which can be obtained via donation. Type !donate for more information.")
		chat.AddText("This skin is apart of the camouflage cosmetics weapon pack which can be obtained via donation. Type !donate for more information.")
		return false
	end

	if table.HasValue(patternCosmetics, attname) && !ply:getNutData("hasPatternCosmetics") then
		nut.util.notify("This skin is apart of the patterns cosmetics weapon pack which can be obtained via donation. Type !donate for more information.")
		chat.AddText("This skin is apart of the patterns cosmetics weapon pack which can be obtained via donation. Type !donate for more information.")
		return false
	end

	if attname == "dn_cosmetic_money" && !donoRanks[ply:GetUserGroup()] then
		nut.util.notify("This skin is exclusive to the donator package. Type !donate for more information.")
		chat.AddText("This skin is exclusive to the donator package. Type !donate for more information.")
		return false
	end
end)