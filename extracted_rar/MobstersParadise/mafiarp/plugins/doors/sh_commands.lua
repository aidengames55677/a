-- "gamemodes\\mafiarp\\plugins\\doors\\sh_commands.lua"

local PLUGIN = PLUGIN

local globalRanks = {
	founder = true,
	communitymanager = true,
	servermanager = true,
	advisor = true,
	headadministrator = true,
	superadministrator = true,
	senioradministrator = true,
	seasonedadministrator = true,
	administrator = true,
	moderator = true,
	eventmanager = true,
}

local superRanks = {
	founder = true,
	communitymanager = true,
	headadministrator = true,
	superadministrator = true,
	senioradministrator = true,
	eventmanager = true,
}

nut.command.add("doorsell", {
	onRun = function(client, arguments)
		-- Get the entity 96 units infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Check if the entity is a valid door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			-- Check if the player owners the door.
			if (client == entity:GetDTEntity(0)) then
				if entity:getNetVar("owner", 0) > 0 then
					client:notify("You cannot sell a door that you permanently own.")
					return false
				end
			
				-- Get the price that the door is sold for.
				local price = math.Round(entity:getNetVar("price", nut.config.get("doorCost")) * nut.config.get("doorSellRatio"))

				-- Remove old door information.
				entity:removeDoorAccessData()

				-- Remove door information on child doors
				PLUGIN:callOnDoorChildren(entity, function(child)
					child:removeDoorAccessData()
				end)

				-- Take their money and notify them.
				client:getChar():giveMoney(price)
				client:notifyLocalized("dSold", nut.currency.get(price))
				hook.Run("OnPlayerPurchaseDoor", client, entity, false, PLUGIN.callOnDoorChildren) -- i fucking hate this life
				nut.log.add(client, "selldoor")
			else
				-- Otherwise tell them they can not.
				client:notifyLocalized("notOwner")
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})

nut.command.add("doorbuy", {
	onRun = function(client, arguments)
		-- Get the entity 96 units infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Check if the entity is a valid door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			if (entity:getNetVar("noSell") or entity:getNetVar("faction") or entity:getNetVar("class")) then
				return client:notifyLocalized("dNotAllowedToOwn")
			end

			if (IsValid(entity:GetDTEntity(0))) then
				client:notifyLocalized("dOwnedBy", entity:GetDTEntity(0):Name())
				return false
			end
			
			if (entity:getNetVar("owner", 0) > 0) then
				client:notify("This door is owned.")
				return false
			end
			-- Get the price that the door is bought for.
			local price = entity:getNetVar("price", nut.config.get("doorCost"))

			-- Check if the player can actually afford it.
			if (client:getChar():hasMoney(price)) then
				-- Set the door to be owned by this player.
				entity:SetDTEntity(0, client)
				entity.nutAccess = {
					[client] = DOOR_OWNER
				}
				
				PLUGIN:callOnDoorChildren(entity, function(child)
					child:SetDTEntity(0, client)
				end)

				-- Take their money and notify them.
				client:getChar():takeMoney(price)
				client:notifyLocalized("dPurchased", nut.currency.get(price))

				hook.Run("OnPlayerPurchaseDoor", client, entity, true, PLUGIN.callOnDoorChildren) -- i fucking hate this life
				nut.log.add(client, "buydoor")
			else
				-- Otherwise tell them they can not.
				client:notifyLocalized("canNotAfford")
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetunownable", {
	syntax = "[string name]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		local name = table.concat(arguments, " ")

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			-- Set it so it is unownable.
			entity:setNetVar("noSell", true)

			-- Change the name of the door if needed.
			if (arguments[1] and name:find("%S")) then
				entity:setNetVar("name", name)
			end

			PLUGIN:callOnDoorChildren(entity, function(child)
				child:setNetVar("noSell", true)

				if (arguments[1] and name:find("%S")) then
					child:setNetVar("name", name)
				end
			end)

			-- Tell the player they have made the door unownable.
			client:notifyLocalized("dMadeUnownable")

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetownable", {
	syntax = "[string name]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		local name = table.concat(arguments, " ")

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			-- Set it so it is ownable.
			entity:setNetVar("noSell", nil)

			-- Update the name.
			if (arguments[1] and name:find("%S")) then
				entity:setNetVar("name", name)
			end

			PLUGIN:callOnDoorChildren(entity, function(child)
				child:setNetVar("noSell", nil)

				if (arguments[1] and name:find("%S")) then
					child:setNetVar("name", name)
				end
			end)

			-- Tell the player they have made the door ownable.
			client:notifyLocalized("dMadeOwnable")

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("dooraddfaction", {
	syntax = "[string faction]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			local faction

			-- Check if the player supplied a faction name.
			if (arguments[1]) then
				-- Get all of the arguments as one string.
				local name = table.concat(arguments, " ")

				-- Loop through each faction, checking the uniqueID and name.
				for k, v in pairs(nut.faction.teams) do
					if (nut.util.stringMatches(k, name) or nut.util.stringMatches(L(v.name, client), name)) then
						-- This faction matches the provided string.
						faction = v

						-- Escape the loop.
						break
					end
				end
			end

			-- Check if a faction was found.
			if (faction) then
				local factions = string.Split(entity:getNetVar("faction", ""), ",")

				if table.HasValue(factions, tostring(faction.uniqueID)) then
					client:notify(L(faction.name, client) .. " is already a member of this door.")
					return false
				end

				table.insert(factions, tostring(faction.uniqueID))
				entity:setNetVar("faction", table.concat(factions, ","))

				PLUGIN:callOnDoorChildren(entity, function()
					local factions = string.Split(entity:getNetVar("faction", ""), ",")
					if not table.HasValue(factions, tostring(faction.uniqueID)) then
    				    table.insert(factions, tostring(faction.uniqueID))
    				    entity:setNetVar("faction", table.concat(factions, ","))
				    end
				end)

				client:notifyLocalized("dSetFaction", L(faction.name, client))
			-- The faction was not found.
			elseif (arguments[1]) then
				client:notifyLocalized("invalidFaction")
			-- The player didn't provide a faction.
			else
				entity:setNetVar("faction", nil)

				PLUGIN:callOnDoorChildren(entity, function()
					entity:setNetVar("faction", nil)
				end)

				client:notifyLocalized("dRemoveFaction")
			end

			-- Save the door information.
			PLUGIN:SaveDoorData()
		end
	end
})

nut.command.add("doorremovefaction", {
	syntax = "[string faction]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			local faction

			-- Check if the player supplied a faction name.
			if (arguments[1]) then
				-- Get all of the arguments as one string.
				local name = table.concat(arguments, " ")

				-- Loop through each faction, checking the uniqueID and name.
				for k, v in pairs(nut.faction.teams) do
					if (nut.util.stringMatches(k, name) or nut.util.stringMatches(L(v.name, client), name)) then
						-- This faction matches the provided string.
						faction = v

						-- Escape the loop.
						break
					end
				end
			end

			-- Check if a faction was found.
			if (faction) then
				local factions = string.Split(entity:getNetVar("faction", ""), ",")

				if not table.HasValue(factions, tostring(faction.uniqueID)) then
					client:notify(L(faction.name, client) .. " is not a member of this door.")
					return false
				end

			    table.RemoveByValue(factions, tostring(faction.uniqueID))
			    entity:setNetVar("faction", table.concat(factions, ","))

				PLUGIN:callOnDoorChildren(entity, function()
				    local factions = string.Split(entity:getNetVar("faction", ""), ",")
				    table.RemoveByValue(factions, tostring(faction.uniqueID))
				    entity:setNetVar("faction", table.concat(factions, ","))
				end)

				client:notify(L(faction.name, client) .. " was removed from this door.")
				if entity:getNetVar("faction") == "" then
					entity:setNetVar("faction", nil)
				end
			-- The faction was not found.
			elseif (arguments[1]) then
				client:notifyLocalized("invalidFaction")
			-- The player didn't provide a faction.
			else
				entity:setNetVar("faction", nil)

				PLUGIN:callOnDoorChildren(entity, function()
					entity:setNetVar("faction", nil)
				end)

				client:notifyLocalized("dRemoveFaction")
			end

			-- Save the door information.
			PLUGIN:SaveDoorData()
		end
	end
})

nut.command.add("doorsetdisabled", {
	syntax = "<bool disabled>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!superRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor()) then
			local disabled = util.tobool(arguments[1] or true)

			-- Set it so it is ownable.
			entity:setNetVar("disabled", disabled)

			PLUGIN:callOnDoorChildren(entity, function(child)
				child:setNetVar("disabled", disabled)
			end)

			-- Tell the player they have made the door (un)disabled.
			client:notifyLocalized("dSet"..(disabled and "" or "Not").."Disabled")

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsettitle", {
	syntax = "<string title>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Validate the door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			-- Get the supplied name.
			local name = table.concat(arguments, " ")

			-- Make sure the name contains actual characters.
			if (!name:find("%S")) then
				return client:requestString("Change Door Title", "Enter title", function(text)
					client:ConCommand("say /doorsettitle "..text)
				end, entity:getNetVar("name"))
			end

			--[[
				NOTE: Here, we are setting two different networked names.
				The title is a temporary name, while the other name is the
				default name for the door. The reason for this is so when the
				server closes while someone owns the door, it doesn't save THEIR
				title, which could lead to unwanted things.
			--]]

			-- Check if they are allowed to change the door's name.
			
			if (entity:checkDoorAccess(client, DOOR_TENANT)) then
				entity:setNetVar("name", name)
				
				PLUGIN:callOnDoorChildren(entity, function(child)
					child:setNetVar("name", name)
				end)
				
				PLUGIN:SaveDoorData()
			elseif (globalRanks[uniqueID]) then
				entity:setNetVar("name", name)

				PLUGIN:callOnDoorChildren(entity, function(child)
					child:setNetVar("name", name)
				end)
				
				PLUGIN:SaveDoorData()
			else
				-- Otherwise notify the player he/she can't.
				client:notifyLocalized("notOwner")
			end
		else
			-- Notification of the door not being valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

--[[
nut.command.add("doorsetparent", {
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end

		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			client.nutDoorParent = entity
			client:notifyLocalized("dSetParentDoor")
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})

nut.command.add("doorsetchild", {
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			if (client.nutDoorParent == entity) then
				return client:notifyLocalized("dCanNotSetAsChild")
			end

			-- Check if the player has set a door as a parent.
			if (IsValid(client.nutDoorParent)) then
				-- Add the door to the parent's list of children.
				client.nutDoorParent.nutChildren = client.nutDoorParent.nutChildren or {}
				client.nutDoorParent.nutChildren[entity:MapCreationID()] = true

				-- Set the door's parent to the parent.
				entity.nutParent = client.nutDoorParent

				client:notifyLocalized("dAddChildDoor")

				-- Save the door information.
				PLUGIN:SaveDoorData()
				PLUGIN:copyParentDoor(entity)
			else
				-- Tell the player they do not have a door parent.
				client:notifyLocalized("dNoParentDoor")
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})

nut.command.add("doorremovechild", {
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			if (client.nutDoorParent == entity) then
				PLUGIN:callOnDoorChildren(entity, function(child)
					child.nutParent = nil
				end)

				entity.nutChildren = nil

				return client:notifyLocalized("dRemoveChildren")
			end

			-- Check if the player has set a door as a parent.
			if (IsValid(entity.nutParent) and entity.nutParent.nutChildren) then
				-- Remove the door from the list of children.
				entity.nutParent.nutChildren[entity:MapCreationID()] = nil
				-- Remove the variable for the parent.
				entity.nutParent = nil

				client:notifyLocalized("dRemoveChildDoor")

				-- Save the door information.
				PLUGIN:SaveDoorData()
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})
--]]

nut.command.add("doorsethidden", {
	onRun = function(client)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor()) then
			if entity:getNetVar("hidden") == nil or entity:getNetVar("hidden") == false then
				entity:setNetVar("hidden", true)
				client:notifyLocalized("Door set to hidden.")
			elseif entity:getNetVar("hidden") == true then
				entity:setNetVar("hidden", false)
				client:notifyLocalized("Door set to visible.")
			end

			-- Save the door information.
			PLUGIN:SaveDoorData()
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end
	end
})

nut.command.add("doorsetclass", {
	syntax = "[string faction]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			local class, classData

			if (arguments[1]) then
				local name = table.concat(arguments, " ")

				for k, v in pairs(nut.class.list) do
					if (nut.util.stringMatches(v.name, name) or nut.util.stringMatches(L(v.name, client), name)) then
						class, classData = k, v

						break
					end
				end
			end

			-- Check if a faction was found.
			if (class) then
				entity.nutClassID = class
				entity:setNetVar("class", class)

				PLUGIN:callOnDoorChildren(entity, function()
					entity.nutClassID = class
					entity:setNetVar("class", class)
				end)

				client:notifyLocalized("dSetClass", L(classData.name, client))
			elseif (arguments[1]) then
				client:notifyLocalized("invalidClass")
			else
				entity:setNetVar("class", nil)

				PLUGIN:callOnDoorChildren(entity, function()
					entity:setNetVar("class", nil)
				end)

				client:notifyLocalized("dRemoveClass")
			end

			PLUGIN:SaveDoorData()
		end
	end,
	alias = {"jobdoor"}
})

nut.flag.add("d", "Allows access to /doorsetpermaowner")

nut.command.add("doorsetpermaowner", {
	onRun = function(client, arguments)
		if (!client:getChar():getFlags("d")) then
			client:notify("You do not have access to this command.")
			return false
		end

		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		local target
		if arguments[1] then
			target = nut.command.findPlayer(client, arguments[1])
		end

		-- Validate it is a door.
		if (IsValid(entity) and entity:isDoor() and !entity:getNetVar("disabled")) then
			entity:setPermanentOwner(target)
			if target then
				client:notify("Door's permanent owner has now been set.")
			else
				client:notify("Door's permanent owner has been removed.")
			end
		else
			-- Tell the player the door isn't valid.
			client:notifyLocalized("dNotValid")
		end		
	end
})
