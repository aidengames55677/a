-- "gamemodes\\mafiarp\\plugins\\flashlight\\sh_plugin.lua"

PLUGIN.name = "Flashlight"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Provides a flashlight item to regular flashlight usage."

function PLUGIN:PlayerSwitchFlashlight(client, state)
	if (state and !client:getChar():getInv():hasItem("flashlight")) then
		return false
	end

	client:SendLua(Format("RunConsoleCommand('r_shadows', %s)", state and "\"1\"" or "\"0\""))
	return true
end