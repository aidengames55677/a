PLUGIN.name = "Business Permits"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Permits for businesses."

function PLUGIN:CanPlayerUseBusiness(client, uniqueID)
	local itemTable = nut.item.list[uniqueID]

	if (!client:getChar()) then
		return false
	end

	if (itemTable.permit) then
		local char = client:getChar()
		local inventory = char:getInv()
		
		local permit = inventory:hasItem(itemTable.permit) --the actual permit item in their inventory
		
		if(permit) then --if they have the right permit
			if(permit:getData("owner", 0) == char:getID()) then --if they own the permit
				return true
			end
		end
		
		if(!itemTable.flag) then
			return false
		end
	end
	
	if (itemTable.noBusiness) then
		return false
	end
	
	if (itemTable.factions) then
		local allowed = false

		if (type(itemTable.factions) == "table") then
			for k, v in pairs(itemTable.factions) do
				if (client:Team() == v) then
					allowed = true

					break
				end
			end
		elseif (client:Team() != itemTable.factions) then
			allowed = false
		end

		if (!allowed) then
			return false
		end
	end

	if (itemTable.classes) then
		local allowed = false

		if (type(itemTable.classes) == "table") then
			for k, v in pairs(itemTable.classes) do
				if (client:getChar():getClass() == v) then
					allowed = true

					break
				end
			end
		elseif (client:getChar():getClass() == itemTable.classes) then
			allowed = true
		end

		if (!allowed) then
			return false
		end
	end

	if (itemTable.flag) then
		if (!client:getChar():hasFlags(itemTable.flag)) then
			return false
		end
	end

	return true
end

nut.flag.add("a", "Access to permits.")

nut.chat.register("buyadvert", {
	onCanHear = 1000000,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(100,150,100), "[Radio Broadcast] ", Color(100, 200, 100), speaker:Nick(), Color(255, 255, 255), ": ", text)
	end,
	deadCanChat = true
})

nut.command.add("buyadvert", {
	onRun = function(client, arguments)
		if(client:getChar():getMoney() < 100) then
			client:notify("You do not have 100 RM.")
			return
		else
			client:getChar():setMoney(client:getChar():getMoney() - 100)
			client:notify("You have spent 100 RM.")
		end
		
		nut.chat.send(client, "buyadvert", table.concat(arguments, " "))
	end
})

nut.flag.add("B", "Access to the /factionbroadcast command")
nut.command.add("factionbroadcast", {
	syntax = "<string factions> <string text>",
	onRun = function(client, arguments)
		if (!client:getChar() || !client:getChar():hasFlags("B")) then
			return "Your character does not have the required flags for this command."
		end
		
		if (!arguments[1]) then
			return "Invalid argument (#1)"
		end
		
		if (!arguments[2]) then
			return "Invalid argument (#2)"
		end
		
		local message = table.concat(arguments, " ", 2)
		local factionList = {}
		local factionListSimple = {}
		
		for k,v in pairs(string.Explode(",", arguments[1])) do
			local foundFaction
			local foundID
			local multiFind
			for m,n in pairs(nut.faction.indices) do
				if (string.lower(n.uniqueID) == string.lower(v)) then
					foundFaction = m
					foundID = n.name
					multiFind = false
					break
				elseif (string.lower(n.uniqueID):find(string.lower(v), 1, true)) then
					if (foundFaction) then
						multiFind = true
					end
					
					foundID = n.name
					foundFaction = m
				end
			end
			
			if (!foundFaction) then
				return "Cannot find faction '" .. v .. "' - use the unique IDs of factions (example: okw, okh, citizen, etc)"
			end
			
			if (multiFind) then
				return "Ambiguous entry (multiple possible factions) - '" .. v .. "'"
			end
			
			factionList[foundFaction] = foundID
			factionListSimple[#factionListSimple + 1] = foundID
		end
		
		if (table.Count(factionList) == 0) then
			return "No valid factions found"
		end
		
		for k,v in pairs(player.GetAll()) do
			if (v == client || (v:getChar() && factionList[v:getChar():getFaction()])) then
				v:SendMessage(Color(200, 200, 100), "[Local Broadcast]", Color(255, 255, 255),": ", Color(180, 180, 100), client:Nick(), Color(255, 255, 255), ": ", message);
				v:SendMessage(Color(200, 200, 100), "[Local Broadcast]", Color(255, 255, 255), ": This message was sent to ", table.concat(factionListSimple, ", "), ".")
			end
		end
		
		client:notify("Broadcast sent.")
	end
})


