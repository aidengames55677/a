-- "gamemodes\\mafiarp\\plugins\\pkwar\\sh_plugin.lua"


local PLUGIN = PLUGIN

--[[ Meta Info ]]--
PLUGIN.name = "Faction Wars"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "System for wars between factions"

--[[ Enum ]]--
WAR_EDIT_NAME = 1
WAR_EDIT_FACTIONS = 2

--[[ Includes ]]--
nut.util.include( "library/sh_largenetstrings.lua" )
nut.util.include( "sv_plugin.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_networking.lua" )

--[[ Functions ]]--
PLUGIN.ModifyWarPermissions = {
    ["founder"] = true,
    ["communitymanager"] = true,
    ["headadministrator"] = true,
    ["superadmin"] = true,
}

function PLUGIN:CanPlayerModifyWar( ply )
    return self.ModifyWarPermissions[ply:GetUserGroup()]
end

function PLUGIN:AreCharactersEnemiesInWar( char1, char2 )
    if not char1 or not char2 then return end

    if not char1:getFaction() then return end
    if not char1:getFaction() then return end

    local char1FacId = nut.faction.indices[char1:getFaction()].uniqueID
    local char2FacId = nut.faction.indices[char2:getFaction()].uniqueID

    for id, war in pairs( self.Wars ) do
        local char1InTeam1 = war.Team1[char1FacId]
        local char1InTeam2 = war.Team2[char1FacId]

        if not char1InTeam1 and not char1InTeam2 then continue end

        local char2Team = char1InTeam1 and war.Team2 or war.Team1

        if char2Team[char2FacId] then
            return true, war
        end
    end
    return false
end

function PLUGIN:CheckIfCharacterIsPlayable( ply, char )
    local charId = char:getID()
    local foundOtherCharacter = false

    for k, v in pairs( self.Wars ) do
        local charInWar = v.Participants[ply:SteamID()]
        if tobool( charInWar ) then
            if charInWar == charId then
                return true
            end

            local charFacId = nut.faction.indices[char:getFaction()].uniqueID
            if ( v.Team1[charFacId] or v.Team2[charFacId] ) then
                foundOtherCharacter = true
            end
        end
    end
    return not foundOtherCharacter
end

function PLUGIN:GetCharacterWar( char )
    if not char then return end

    local charFacId = nut.faction.indices[char:getFaction()].uniqueID

    for id, war in pairs( self.Wars ) do
        local charInTeam1 = war.Team1[charFacId]
        local charInTeam2 = war.Team2[charFacId]

        if charInTeam1 or charInTeam2 then
            return war
        end
    end
end

function PLUGIN:IsCharacterBoundToWar( char )
    local war = self:GetCharacterWar( char )
    for k, v in pairs( war.Participants ) do
        if v == char:getID() then
            return true
        end
    end
    return false
end

function PLUGIN:CanPlayerUseChar( ply, char )
    if not self:CheckIfCharacterIsPlayable( ply, char ) then
        return false, "You are in a war that makes this character unplayable."
    end
end

--[[ Hooks ]]--
nut.command.add( "warmanage", {
    onCheckAccess = function( ply )
        return hook.Run( "CanPlayerModifyWar", ply )
    end,
    onRun = function( ply )
        ply:SendLua( "vgui.Create( 'FactionWars.ManageWars' )" ) -- Fuck SendLua but this is so basic we may as well.
    end
} )