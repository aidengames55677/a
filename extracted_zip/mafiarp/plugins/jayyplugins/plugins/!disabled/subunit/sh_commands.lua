nut.command.add("setunit", {
    syntax = "<string target> <string unit>",
	onCheckAccess = function(client) return client:getChar():hasFlags("F") or client:IsAdmin() end,
    onRun = function(client, arguments)
		-- This command sets a player's unit.
		local target = nut.command.findPlayer(client, arguments[1])

		if IsValid(target) then
			PLUGIN:setPlayerUnit(target, arguments[2])
			client:notify(target:Name().." has been set to unit "..arguments[2]..".")
		end
	end
})

nut.command.add("removeunit", {
	syntax = "<string target>",
	onCheckAccess = function(client) return client:getChar():hasFlags("F") or client:IsAdmin() end,
    onRun = function(client, arguments)
		-- This command removes a player's unit.
		local target = nut.command.findPlayer(client, arguments[1])

		if IsValid(target) then
			PLUGIN:removePlayerUnit(target)
			client:notify(target:Name().." has been removed from their unit.")
		end
	end
})

