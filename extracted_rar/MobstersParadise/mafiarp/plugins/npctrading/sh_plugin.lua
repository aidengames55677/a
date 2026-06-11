-- "gamemodes\\mafiarp\\plugins\\npctrading\\sh_plugin.lua"


local PLUGIN = PLUGIN

--[[ Meta Info ]]--
PLUGIN.name = "NPC Trading"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "NPC trading system for MafiaRP"

--[[ Includes ]]--
nut.util.include( "sv_plugin.lua" )
nut.util.include( "sv_sql.lua" )
nut.util.include( "sv_commands.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_commands.lua" )

function PLUGIN:FormatTime( seconds )
    local h, m, s = math.floor( seconds / 3600 ), math.floor( ( seconds / 60 ) % 60 ), math.floor( seconds % 60 )
    return string.format( "%02i:%02i:%02i", h, m, s )
end

function PLUGIN:ValidateRecipeInfo( id, cooldown, inputs, outputs )
    if not id or string.len( id ) < 3 or string.len( id ) > 32 then return false end
    if not isnumber( cooldown ) or cooldown < 0 then return false end

    if not inputs or not outputs then return false end
    local inputsCount, outputsCount = table.Count( inputs ), table.Count( outputs )
    if inputsCount < 1 or inputsCount > 4 then return false end
    if outputsCount < 1 or outputsCount > 4 then return false end

    for k, v in pairs( inputs ) do
        if v <= 0 then return false end
        if string.len( k ) < 1 then return false end
    end

    for k, v in pairs( outputs ) do
        if v <= 0 then return false end
        if string.len( k ) < 1 then return false end
    end

    return true
end

function PLUGIN:CanMakeTrade( ply, recipeId, inputItems, outputItems )
    local cooldowns = util.JSONToTable( ply:getChar():getData( "trading_cooldowns", "[]" ) )

    if cooldowns[recipeId] and os.time() < cooldowns[recipeId] then
        return false, "That recipe is on cooldown"
    end

    local inputItemCount, outputItemCount = 0, 0
    for k, v in pairs( inputItems ) do inputItemCount = inputItemCount + v end
    for k, v in pairs( outputItems ) do inputItemCount = outputItemCount + v end

    local inv = ply:getChar():getInv()

    for k, v in pairs( inputItems ) do
        if inv:getItemCount( k ) < v then
            return false, "You do not have all the required items"
        end
    end

    return true
end

NPCTrading = PLUGIN