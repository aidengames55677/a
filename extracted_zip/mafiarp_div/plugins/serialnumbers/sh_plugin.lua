-- "gamemodes\\mafiarp\\plugins\\serialnumbers\\sh_plugin.lua"


local PLUGIN = PLUGIN

--[[ Meta Info ]]--
PLUGIN.name = "Serial Numbers"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "Serial numbers for weapons"

--[[ Includes ]]--
nut.util.include( "sv_plugin.lua" )
nut.util.include( "cl_plugin.lua" )

SerialNumbers = PLUGIN