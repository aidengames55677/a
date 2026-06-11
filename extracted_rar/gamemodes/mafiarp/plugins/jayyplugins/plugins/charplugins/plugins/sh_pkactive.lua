PLUGIN.name = "PK Command"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "Adds a command to PK certain people after they die."

local characterMeta = nut.meta.character

local staffList = {
    "superadmin",
    "network_owner",
    "network_coowner",
    "network_executive",
    "head_developer",
    "community_director",
    "head_administrator",
    "supervising_administrator",
    "administrator",
    "admin",
    "moderator",
    "trial_moderator",
    "community_manager"
}

function PLUGIN:isStaff(player)
    local usergroup = player:GetUserGroup()
    return table.HasValue(staffList, usergroup)
end

nut.command.add("pkenable", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		if not PLUGIN:isStaff(client) then
            client:notify("You do not have permission to use this command.")
            return
        end
		
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) && target:getChar()) then
			target:getChar():enablePK(target:getChar())
			client:notify("Setting "..(target:getChar():getName()).."\'s PK status to "..tostring(target:getChar():getData("pkCom")))
		end
	end
})

-- Prevents death glitch
hook.Add("PlayerLoadedChar", "pkvarset", function(client, character)
	character:setData("pkCom", false, false, player.GetAll())
end)

if SERVER then

	function characterMeta:enablePK(char)
		if (char:getData("pkCom")) then
			char:setData("pkCom", false, false, player.GetAll())
		else
			char:setData("pkCom", true, false, player.GetAll())
		end
	end

	hook.Add("PlayerDeath", "pkCommand", function(victim, inflictor, attacker)
		local char = victim:getChar()

		if (victim:getChar() && victim:getChar():getData("pkCom")) then
			--if nut.config.get("deathTimer") then
			char:ban()
			victim:notify("You have been Permakilled. If you wish to appeal this PK, you may go to the discord.")
		end
	end)

end	