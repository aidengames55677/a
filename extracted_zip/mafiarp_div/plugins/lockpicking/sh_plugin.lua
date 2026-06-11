-- "gamemodes\\mafiarp\\plugins\\lockpicking\\sh_plugin.lua"

PLUGIN.name = "Lockpick"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Lockpicking!"

if (SERVER) then
	function PLUGIN:PlayerLoadout(ply)
		ply:setNetVar("isPicking")
	end
	
else
	function PLUGIN:DrawCharInfo(client, character, info)
		if (client:getNetVar("isPicking")) then
			info[#info + 1] = {"Lockpicking", Color(255, 100, 100)}
		end
	end
end

