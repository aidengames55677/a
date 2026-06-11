-- "gamemodes\\mafiarp\\plugins\\pkwar\\cl_plugin.lua"


local PLUGIN = PLUGIN
PLUGIN.Wars = PLUGIN.Wars or {}

--[[ Functions ]]--
function PLUGIN:EnsureCharacterParticipation( char )
    if tobool( self:GetCharacterWar( char ) ) and not self:IsCharacterBoundToWar( char ) then
        Derma_Query( "Would you like to participate in the faction war with this character?\n\nSelecting \"Yes\" will bind your character to this war and you cannot load other characters in this faction.\nSelecting \"No\" will force you to choose a different character.", "War Participation",
        "Yes", function()
            self:BindCharacterToWar( char:getID() )
        end,
        "No", function()
            self:RefuseCharacterBinding( char:getID() )
        end )
    end
end

--[[ Hooks ]]--
function PLUGIN:GetDisguised( ply )
    local localPlayer = LocalPlayer()
    if ply ~= localPlayer and self:AreCharactersEnemiesInWar( localPlayer:getChar(), ply:getChar() ) then
        return true
    end
end

function PLUGIN:CharacterLoaded( char )
    self:EnsureCharacterParticipation( char )
end

hook.Add( "FactionWars.WarsSynced", "FactionWars.EnsureCharacter.WarsSynced", function()
    local char = LocalPlayer():getChar()
    if not char then return end
    PLUGIN:EnsureCharacterParticipation( char  )
end )