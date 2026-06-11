-- BASIC SHEMA INFORMATION

SCHEMA.name = "Red Dawn Networks 1990's Mafia RP"
SCHEMA.author = "JayyKashtaCodes"
SCHEMA.desc = "1990's Mafia RP."

-- CURRENCY

nut.currency.set("$", "Dollar", "Dollars")

-- FLAGS

nut.flag.add("F", "Faction High Command.")
nut.flag.add("L", "Loyalty Point Management.")
nut.flag.add("U", "Business Menu")
nut.flag.add("u", "Banned from OOC")

-- DUMB CODE

-- UTILS (So NS Schema Working)

nut.util.includeDir("core/hooks")
nut.util.includeDir("core/libs")
nut.util.includeDir("derma")
nut.util.includeDir("meta")

nut.util.include( "sh_config.lua" )
nut.util.include( "sh_commands.lua" )
nut.util.include( "sv_database.lua" )
--nut.util.include( "sh_dev.lua" )
nut.util.include("cl_schema.lua")

SCHEMA.RanksFounder = {founder = true, communitymanager = true}
SCHEMA.RanksCM = {founder = true, communitymanager = true}
SCHEMA.RanksHA = {founder = true, communitymanager = true, headadministrator = true}
SCHEMA.RanksSuper = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true}
SCHEMA.RanksSenior = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true}
SCHEMA.RanksSeasoned = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true,}
SCHEMA.RanksAdmin = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true,}
SCHEMA.RanksMod = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true, moderator = true}
SCHEMA.RanksDonator = {founder = true, communitymanager = true, headadministrator = true, superadministrator = true, senioradministrator = true, seasonedadministrator = true, administrator = true, moderator = true, donator = true}


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

--[[
nut.util.include( "sv_permaguns.lua" )

nut.util.include( "sv_hooks.lua" )

nut.util.include( "sh_commands.lua" )

nut.util.include( "sh_libs.lua" )
nut.util.include( "sv_libs.lua" )
]]
-- Auto Flags
--[[
function SCHEMA:PlayerLoadedChar(client, character, lastChar)
    if (team.GetName(client:Team()) == "Staff on Duty")
end
-------------------------------

function SCHEMA:PlayerLoadedChar(client, character, lastChar)
    if ((client:IsUserGroup("superadmin") or client:IsUserGroup("network_owner") or client:IsUserGroup("network_coowner") or client:IsUserGroup("network_executive") or client:IsUserGroup("head_developer") or client:IsUserGroup("community_director")) and not client:getChar():hasFlags("petrcPCULFdelnwybBma")) then
        client:getChar():giveFlags("petrcPCULFdelnwybBma")
        client:notify("petrcPCULFdelnwybBma Flag's added")
    elseif ((client:IsUserGroup("trial_moderator") or client:IsUserGroup("moderator") or client:IsUserGroup("admin") or client:IsUserGroup("administrator") or client:IsUserGroup("head_administrator") or client:IsUserGroup("supervising_administrator") or client:IsUserGroup("community_manager")) and not client:getChar():hasFlags("petrc")) then
        client:getChar():giveFlags("petrcF")
        client:notify("petrcF Flag's added")
    end
end
------------------------------------------------------------------------------------------------------
function SCHEMA:PlayerLoadedChar(client, character, lastChar)
    if client:IsUserGroup("superadmin") and not client:getChar():hasFlags("petrcPCULFdelnwybBma") then
        client:getChar():giveFlags("petrcPCULFdelnwybBma")
        client:notify("petrcPCULFdelnwybBma Flag's added")
    elseif client:IsUserGroup("Network Owner") and not client:getChar():hasFlags("petrcPCULFdelnwybBma") then
        client:getChar():giveFlags("petrcPCULFdelnwybBma")
        client:notify("petrcPCULFdelnwybBma Flag's added")
    elseif client:IsUserGroup("network Co-Owner") and not client:getChar():hasFlags("petrcPCULFdelnwybBma") then
        client:getChar():giveFlags("petrcPCULFdelnwybBma")
        client:notify("petrcPCULFdelnwybBma Flag's added")
    elseif client:IsUserGroup("Head Developer") and not client:getChar():hasFlags("petrcPCULFdelnwybBma") then
        client:getChar():giveFlags("petrcPCULFdelnwybBma")
        client:notify("petrcPCULFdelnwybBma Flag's added")
    elseif client:IsUserGroup("Community Director") and not client:getChar():hasFlags("petrcPCULFdelnwybBma") then
        client:getChar():giveFlags("petrcPCULFdelnwybBma")
        client:notify("petrcPCULFdelnwybBma Flag's added")
    elseif client:IsUserGroup("Supervising Administrator") and not client:getChar():hasFlags("petrc") then
        client:getChar():giveFlags("petrc")
    elseif client:IsUserGroup("Community Manager") and not client:getChar():hasFlags("petrc") then
        client:getChar():giveFlags("petrc")
    elseif client:IsUserGroup("Head Administrator") and not client:getChar():hasFlags("petrc") then
        client:getChar():giveFlags("petrc")
    elseif client:IsUserGroup("Administrator") and not client:getChar():hasFlags("petrc") then
        client:getChar():giveFlags("petrc")
    elseif client:IsUserGroup("admin") and not client:getChar():hasFlags("petrc") then
        client:getChar():giveFlags("petrc")
    elseif client:IsUserGroup("Moderator") and not client:getChar():hasFlags("petrc") then
        client:getChar():giveFlags("petrc")
    elseif client:IsUserGroup("Trial Moderator") and not client:getChar():hasFlags("petrc") then
        client:getChar():giveFlags("petrc")
    end
end
]]
-- ANTI MINGE

local blockedItemID = "imp_docs"

hook.Add("PlayerCanDropItem", "PreventItemDrop", function(ply, item)
    if item.uniqueID == blockedItemID then
        return false
    end
end)

hook.Add("CheckValidSit", "noVehSit", function(ply, trace)
    local ent = trace.Entity
    if ent:IsVehicle() then return false end
end)

-- WEAPON AUTO RAISER

-- Tools
ALWAYS_RAISED["hl2_m_axe"]=true
ALWAYS_RAISED["hl2_m_pickaxe"]=true

-- ALLIES GUNS
ALWAYS_RAISED["doi_atow_m1carbine"]=true
ALWAYS_RAISED["doi_atow_sw1917"]=true
ALWAYS_RAISED["doi_atow_bren"]=true
ALWAYS_RAISED["doi_atow_browninghp"]=true
ALWAYS_RAISED["doi_atow_enfield"]=true
ALWAYS_RAISED["doi_atow_m1carbine"]=true
ALWAYS_RAISED["doi_atow_m1garand"]=true
ALWAYS_RAISED["doi_ws_atow_kp31"]=true
ALWAYS_RAISED["doi_atow_m1903a3"]=true
ALWAYS_RAISED["doi_atow_m1911a1"]=true
ALWAYS_RAISED["doi_atow_m1918a2"]=true
ALWAYS_RAISED["doi_atow_k98k"]=true
ALWAYS_RAISED["doi_atow_m1928a1"]=true
ALWAYS_RAISED["doi_atow_m1a1"]=true
ALWAYS_RAISED["doi_atow_m3greasegun"]=true
ALWAYS_RAISED["doi_atow_ithaca37"]=true
ALWAYS_RAISED["doi_atow_owen"]=true
ALWAYS_RAISED["doi_atow_sten"]=true
ALWAYS_RAISED["doi_atow_vickers"]=true
ALWAYS_RAISED["doi_atow_webley"]=true
ALWAYS_RAISED["doi_atow_welrod"]=true

-- AXIS GUNS
ALWAYS_RAISED["doi_atow_k98k"]=true
ALWAYS_RAISED["doi_atow_c96"]=true
ALWAYS_RAISED["doi_atow_c96carbine"]=true
ALWAYS_RAISED["doi_atow_fg42"]=true
ALWAYS_RAISED["doi_atow_g43"]=true
ALWAYS_RAISED["doi_atow_mg34"]=true
ALWAYS_RAISED["doi_atow_mg42"]=true
ALWAYS_RAISED["doi_ws_atow_mp34"]=true
ALWAYS_RAISED["doi_atow_mp40"]=true
ALWAYS_RAISED["doi_atow_p08"]=true
ALWAYS_RAISED["doi_atow_p38"]=true
ALWAYS_RAISED["doi_atow_ppk"]=true
ALWAYS_RAISED["doi_atow_stg44"]=true
