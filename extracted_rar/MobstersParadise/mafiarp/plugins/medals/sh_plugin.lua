-- "gamemodes\\mafiarp\\plugins\\medals\\sh_plugin.lua"


local PLUGIN = PLUGIN

PLUGIN.name = "Medals"
PLUGIN.author = "Diverge Networks"

nut.util.include( "sv_plugin.lua" )
nut.util.include( "sv_network.lua" )
nut.util.include( "sv_commands.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_network.lua" )
nut.util.include( "cl_commands.lua" )

PLUGIN.PlayerMedals = PLUGIN.PlayerMedals or {}
PLUGIN.AwardableMedals = PLUGIN.AwardableMedals or {}

function PLUGIN:HasManagePerms( ply )
    return SCHEMA.RanksSenior[ply:GetUserGroup()]
end

function PLUGIN:CanManageMedal( char, medalId )
    local medals = char:getData( "medalsManage", {} )
    if not istable( medals ) then
        medals = util.JSONToTable( medals )
    end
    return medals and medals[medalId]
end

function PLUGIN:InitializedPlugins()
    timer.Simple(5, function()
        for _, v in ipairs( ents.FindByClass( "nut_vendor" ) ) do 
            if v:getNetVar( "name" ) == "Pin Seller" then
                for _, medal in pairs( nut.item.list ) do
                    if medal.base ~= "base_medals" then continue end
                    if not medal.plyExclusive then continue end
                    v:setTradeMode( medal.uniqueID, 2 )
                end
            end
        end
    end )
    for _, item in pairs( nut.item.list ) do
        if item.base == "base_medals" and item.isAwardable then
            PLUGIN.AwardableMedals[item.uniqueID] = {name = item.name, icon = item.medalIcon, uniqueID = item.uniqueID}
        end
    end
end