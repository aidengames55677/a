-- "gamemodes\\mafiarp\\plugins\\nypdsergeant\\sh_plugin.lua"


local PLUGIN = PLUGIN

--[[ Meta Info ]]--
PLUGIN.name = "NYPD Desk Sergeant"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "Interaction menu for the NYPD"

--[[ Includes ]]--
nut.util.include( "sv_plugin.lua" )
nut.util.include( "cl_plugin.lua" )
nut.util.include( "cl_config.lua" )

function PLUGIN:TablesMatch( table1, table2 )
    if #table1 ~= #table2 then
        return false
    end

    local copyTable2 = {}
    for _, value in ipairs( table2 ) do
        copyTable2[value] = true
    end

    for _, value in ipairs( table1 ) do
        if not copyTable2[value] then
            return false
        end
        copyTable2[value] = nil
    end

    return next( copyTable2 ) == nil
end

function PLUGIN:CharPassedTest( char )
    return char:getData( "NYPDTestPassed", false )
end

function PLUGIN:IsCharBlacklisted( char )
    local unblacklistTime = char:getData( "NYPDUnblacklistTime", 0 )
    return os.time() < unblacklistTime
end

function PLUGIN:IsNYPD( char )
    return char:getFaction() == FACTION_POLICE
end

NYPDSergeant = PLUGIN