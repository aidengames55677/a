-- "gamemodes\\mafiarp\\plugins\\hopstop.lua"

PLUGIN.name = "Hop Stop"
PLUGIN.author = "Vex"
PLUGIN.desc = "Prevents people from being able to Bunny Hop."

if (SERVER) then
	function PLUGIN:KeyPress(player, key)
		if (key == IN_JUMP && !player:InVehicle()) then
			local stamima = player:getLocalVar("stm", 0)
			if (stamima >= 15) then
				player:setLocalVar("stm", stamima - 15)
			end
		end
	end
end

function PLUGIN:StartCommand(ply, cmd)
	if ply:getLocalVar("stm", 0) < 15 and cmd:KeyDown(IN_JUMP) and ply:GetMoveType() == MOVETYPE_WALK then
		cmd:RemoveKey(IN_JUMP)
	end
end