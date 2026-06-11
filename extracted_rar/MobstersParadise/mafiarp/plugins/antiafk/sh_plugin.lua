local PLUGIN = PLUGIN
PLUGIN.name = "Anti AFK"
PLUGIN.author = "Killing Torcher"
PLUGIN.desc = "If enabled, kick AFK players."

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")

nut.config.add("aa_enabled", false, "Whether or not AFK people should be kicked", nil, {
	category = "Anti AFK"
})

nut.config.add(
	"aa_playercount", 
	128, 
	"The player count in which AFK people are kicked.", 
    nil,
	{
		data = {min = 1, max = 128},
		category = "Anti AFK"
	}
)

nut.config.add(
	"aa_interval", 
	600, 
	"How long until AFK players should be kicked. (Seconds)", 
    nil,
	{
        data = {min = 1, max = 3600},
		category = "Anti AFK"
	}
)

nut.config.add(
	"aa_responsetime", 
	60, 
	"How long an AFK player has to respond before the kick. (Seconds)", 
    nil,
	{
        data = {min = 1, max = 3600},
		category = "Anti AFK"
	}
)