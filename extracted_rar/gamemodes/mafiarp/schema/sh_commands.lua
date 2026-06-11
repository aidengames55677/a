-------------------------------------------------------------------------------------------------------------------------
--[[nut.command.add("nuttimeset", {
    onCheckAccess = function(client) return client:IsSuperAdmin() end,
    syntax = "<hour> <min> <sec>",
	onRun = function(client, arguments)
        local newHour = tonumber(arguments[1])
        local newMin = tonumber(arguments[2])
        local newSec = tonumber(arguments[3])
        if newHour and newHour >= 0 and newHour <= 23 and
           newMin and newMin >= 0 and newMin <= 59 and
           newSec and newSec >= 0 and newSec <= 59 then
            local newTime = os.time({
                year = tonumber(nut.config.get("year")),
                month = tonumber(nut.config.get("month")),
                day = tonumber(nut.config.get("day")),
                hour = newHour,
                min = newMin,
                sec = newSec
            })
            nut.date.diff = os.difftime(newTime, os.time())
            for k, client in pairs(player.GetHumans()) do
                nut.date.syncClientTime(client)
            end
        else
            client:notify("Wrong input values")
        end
    end
})]]
-------------------------------------------------------------------------------------------------------------------------
--[[nut.command.add("serverreset", {
    onCheckAccess = function(client)
        return client:IsSuperAdmin()
    end,
    onRun = function(client)
        local delayInSeconds = 60 -- Set your desired delay here
        timer.Simple(delayInSeconds, function()
            game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
        end)
    end
})
]]
-------------------------------------------------------------------------------------------------------------------------
nut.command.add("charsetname", {
	onCheckAccess = function(client) return client:getChar():hasFlags("F") or client:IsAdmin() end,
	syntax = "<string name> [string newName]",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and not arguments[2]) then
			return client:requestString("@chgName", "@chgNameDesc", function(text)
				nut.command.run(client, "charsetname", {target:Name(), text})
			end, target:Name())
		end

		table.remove(arguments, 1)

		local targetName = table.concat(arguments, " ")

		if (IsValid(target) and target:getChar()) then
			nut.util.notifyLocalized("cChangeName", nil, client:Name(), target:Name(), targetName)

			target:getChar():setName(targetName)
            target:getChar():save()
		end
	end
})

nut.command.add("plytransfer", {
	onCheckAccess = function(client) return client:getChar():hasFlags("F") or client:IsAdmin() end,
	syntax = "<string name> <string faction>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		local faction = nut.command.findFaction(client, table.concat(arguments, " ", 2))
		local character = target:getChar()

		if (not IsValid(target) or not character) then
			return "@plyNotExist"
		end

		-- Find the specified faction.
		local oldFaction = nut.faction.indices[character:getFaction()]

		-- Change to the new faction.
		target:getChar():setFaction(faction.index)
		if (faction.onTransfered) then
			faction:onTransfered(target, oldFaction)
		end
		hook.Run("CharacterFactionTransfered", character, oldFaction, faction)

		-- Notify everyone of the change.
		for k, v in ipairs(player.GetAll()) do
			nut.util.notifyLocalized(
				"cChangeFaction",
				v, client:Name(), target:Name(), L(faction.name, v)
			)
		end
        target:getChar():save()
	end
})

nut.command.add("charsetmodel", {
	onCheckAccess = function(client) return client:getChar():hasFlags("F") or client:IsAdmin() end,
	syntax = "<string name> <string model>",
	onRun = function(client, arguments)
		if (not arguments[2]) then
			return L("invalidArg", client, 2)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			target:getChar():setModel(arguments[2])
			target:SetupHands()

			nut.util.notifyLocalized("cChangeModel", nil, client:Name(), target:Name(), arguments[2])
		end
        target:getChar():save()
	end
})

-- Define a table to store the last use time of each client for each command
local cooldowns = {
    charsave = {},
    dropmoney = {}
}

-- Define a table to store the use count of each client for each command
local commandUses = {
    charsave = {},
    dropmoney = {}
}

-- Define a table to store the last reset time of each client for each command
local lastReset = {
    charsave = {},
    dropmoney = {}
}

nut.command.add("charsave", {
	syntax = "",
	onRun = function(client, arguments)
        -- Define your cooldown time (in seconds)
        local cooldown = 60 -- Change this to your desired cooldown time

        -- Define your use limit
        local useLimit = 5 -- Change this to your desired use limit

        -- Define your reset time (in seconds)
        local resetTime = 3600 -- Change this to your desired reset time

        -- Get the current time
        local currentTime = os.time()

        -- Check if the client has used the command before and if the cooldown has passed
        if cooldowns["charsave"][client] and currentTime - cooldowns["charsave"][client] < cooldown then
            client:notify("You must wait before using this command again.")
            return
        end

        -- Check if the reset time has passed
        if lastReset["charsave"][client] and currentTime - lastReset["charsave"][client] >= resetTime then
            -- Reset the use count
            commandUses["charsave"][client] = 0
        end

        -- Save the character
        local status, err = pcall(function() client:getChar():save() end)
        if status then
            client:notify("Your Character Has Been Force Saved.")

            -- Update the cooldown for the "charsave" command
            cooldowns["charsave"][client] = currentTime + cooldown

            -- Update the use count for the "charsave" command
            commandUses["charsave"][client] = (commandUses["charsave"][client] or 0) + 1

            -- Update the last reset time for the "charsave" command
            lastReset["charsave"][client] = currentTime

            -- Check if the use count exceeds the limit
            if commandUses["charsave"][client] >= useLimit then
                -- Define the list of user groups
                local userGroups = {
                    "superadmin",
                    "Network Owner",
                    "Network CO-Owner",
                    "Head Developer",
                    "Community Director",
                    "Supervising Administrator",
                    "Community Manager",
                    "Head Administrator",
                    "Administrator",
                    "admin",
                    "Moderator",
                    "Trial Moderator"
                }

                -- Send a message to all users in the user groups
                for _, ply in ipairs(player.GetAll()) do
                    if table.HasValue(userGroups, ply:GetUserGroup()) then
                        ply:ChatPrint(client:Nick() .. " has used the 'charsave' command " .. commandUses["charsave"][client] .. " times.")
                    end
                end
            end
        else
            client:notify("Your Character Save Unsuccessful. Error: " .. err)
        end
	end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("dropmoney", {
	syntax = "<number amount>",
	onRun = function(client, arguments)
		local userID = client:getChar()
		local curTime = CurTime()

		-- Define your use limit
		local useLimit = 5 -- Change this to your desired use limit

		-- Define your reset time (in seconds)
		local resetTime = 3600 -- Change this to your desired reset time

		-- Check if the player has a cooldown and if it's still active
		if cooldowns["dropmoney"][userID] and cooldowns["dropmoney"][userID] > curTime then
			local timeLeft = math.ceil(cooldowns["dropmoney"][userID] - curTime)
			local minutes = math.floor(timeLeft / 60)
			local seconds = timeLeft % 60
			return client:notify("You need to wait "..minutes..":"..seconds.." before using this command again.")
		end

		-- Check if the reset time has passed
		if lastReset["dropmoney"][userID] and curTime - lastReset["dropmoney"][userID] >= resetTime then
			-- Reset the use count
			commandUses["dropmoney"][userID] = 0
		end

		local amount = tonumber(arguments[1])

		if (not amount or not isnumber(amount) or amount < 1) then
			return "@invalidArg", 1
		end

		amount = math.Round(amount)

		if (not client:getChar():hasMoney(amount)) then
			return
		end

		client:getChar():takeMoney(amount)
		local money = nut.currency.spawn(client:getItemDropPos(), amount)
		money.client = client
		money.charID = client:getChar():getID()

		client:doGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)

		-- Set the cooldown
		cooldowns["dropmoney"][userID] = curTime + nut.config.get("moneyspawndelay")

		-- Update the use count
		commandUses["dropmoney"][userID] = (commandUses["dropmoney"][userID] or 0) + 1

		-- Update the last reset time
		lastReset["dropmoney"][userID] = curTime

		-- Check if the use count exceeds the limit
		if commandUses["dropmoney"][userID] >= useLimit then
			-- Define the list of user groups
			local userGroups = {
				"superadmin",
				"Network Owner",
				"Network CO-Owner",
				"Head Developer",
				"Community Director",
				"Supervising Administrator",
				"Community Manager",
				"Head Administrator",
				"Administrator",
				"admin",
				"Moderator",
				"Trial Moderator"
			}

			-- Send a message to all users in the user groups
			for _, ply in ipairs(player.GetAll()) do
				if table.HasValue(userGroups, ply:GetUserGroup()) then
					ply:ChatPrint(client:Nick() .. " has used the 'dropmoney' command " .. commandUses["dropmoney"][userID] .. " times.")
				end
			end
		end
	end
})

-------------------------------------------------------------------------------------------------------------------------

nut.command.add("menu", {
	adminOnly = true,
	onRun = function(client, arguments)
        client:notify("Dont use this use !menu")
	end
})

nut.command.add("charsetfaction", {
	syntax = "<dont use>",
	adminOnly = true,
    onRun = function(client, arguments)
        client:notify("Dont use this use /plytransfer")
	end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("clearworlditems", {
    syntax = "",
    superAdminOnly = true,
    onRun = function(client, arguments)
        local count = 0

        for i, v in pairs(ents.FindByClass("nut_item")) do
            count = count + 1
            v:Remove()
        end

        nut.util.notifyLocalized("Cleared " .. count .. " world items!")
    end;
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("factionbroadcast", {
    syntax = "[Message]",
    onCheckAccess = function(client) return client:getChar():hasFlags("O") end,
    onRun = function(client, arguments)
        for k, factionmember in pairs(player.GetHumans()) do
            if factionmember:Team() == client then
                client:ChatPrint("[FACTION BROADCAST] " .. arguments[1])
            end
        end
    end;
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("cleannpcs", {
    adminOnly = true,
    onRun = function(client, arguments)
        local count = 0

        if (not arguments[1]) then
            for k, v in pairs(ents.GetAll()) do
                if IsValid(v) and (v:IsNPC() or v.chance) and not IsFriendEntityName(v:GetClass()) then
                    count = count + 1
                    v:Remove()
                end
            end
        else
            local trace = client:GetEyeTraceNoCursor()
            local hitpos = trace.HitPos + trace.HitNormal * 5

            for k, v in pairs(ents.FindInSphere(hitpos, arguments[1] or 100)) do
                if IsValid(v) and (v:IsNPC() or v.chance) and not IsFriendEntityName(v:GetClass()) then
                    count = count + 1
                    v:Remove()
                end
            end
        end

        client:notify(count .. " NPCs and Nextbots have been cleaned up from the map.")
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("doorname", {
    adminOnly = true,
    onRun = function(client, arguments)
        local tr = util.TraceLine(util.GetPlayerTrace(client))

        if IsValid(tr.Entity) then
            print("I saw a " .. tr.Entity:GetName())
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("clearinv", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target) and target:getChar()) then
            for k, v in pairs(target:getChar():getInv():getItems()) do
                v:remove()
            end

            client:notifyLocalized("resetInv", target:getChar():getName())
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("announce", {
    syntax = "<string msg>",
    adminOnly = true,
    onRun = function(ply, args, msg)
        if ply:IsSuperAdmin() then
            nut.util.notify("ANNOUNCEMENT: " .. args[1])
        else
            ply:ChatPrint("You need to be SuperAdmin")
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("setclass", {
    onCheckAccess = function(client) return client:getChar():hasFlags("F") or client:IsAdmin() end,
    syntax = "<string target> <string class>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])

        if (target and target:getChar()) then
            local character = target:getChar()
            local classFound

            if (nut.class.list[name]) then
                classFound = nut.class.list[name]
            end

            if (not classFound) then
                for k, v in ipairs(nut.class.list) do
                    if (nut.util.stringMatches(L(v.name, client), arguments[2])) then
                        classFound = v --This interrupt means we don't need an if statement below.
                        break
                    end
                end
            end

            if (classFound) then
                character:joinClass(classFound.index, true)
                target:notify("Your class was set to " .. classFound.name .. (client ~= target and "by " .. client:GetName() or "") .. ".")

                if (client ~= target) then
                    client:notify("You set " .. target:GetName() .. "'s class to " .. classFound.name .. ".")
                end
                target:getChar():save()
            else
                client:notify("Invalid class.")
            end
        end
    end,
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("chargetmoney", {
    adminOnly = true,
    syntax = "<string target>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])
        local character = target:getChar()
        client:notifyLocalized(character:getName() .. " has " .. character:getMoney() .. " bullets.")
    end
})

-------------------------------------------------------------------------------------------------------------------------
--[[
nut.command.add("charaddmoney", {
    superAdminOnly = true,
    syntax = "<string target> <number amount>",
    onRun = function(client, arguments)
        local amount = tonumber(arguments[2])
        if (not amount or not isnumber(amount) or amount < 0) then return "@invalidArg", 2 end
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target)) then
            local char = target:getChar()

            if (char and amount) then
                amount = math.Round(amount)
                char:giveMoney(amount)
                client:notify("You gave " .. nut.currency.get(amount) .. " to " .. target:Name())
            end
        end
    end
})
]]

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("getpos", {
    adminOnly = true,
    onRun = function(client, arguments)
        client:ChatPrint(tostring(client:GetPos()))
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("findallflags", {
    adminOnly = true,
    onRun = function(client, arguments)
        for k, v in pairs(player.GetAll()) do
            if IsValid(v) then
                if (v:getChar():getFlags() == "") then continue end
                client:ChatPrint(v:Name() .. " — " .. v:getChar():getFlags())
            end
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("checkallmoney", {
    adminOnly = true,
    syntax = "<string charname>",
    onRun = function(client, arguments)
        for k, v in pairs(player.GetAll()) do
            if v:getChar() then
                client:ChatPrint(v:Name() .. " has " .. v:getChar():getMoney())
            end
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
nut.command.add("bringlostitems", {
    adminOnly = true,
    syntax = "",
    onRun = function(client, arguments)
        for k, v in pairs(ents.FindInSphere(client:GetPos(), 500)) do
            if v:GetClass() == "nut_item" then
                v:SetPos(client:GetPos())
            end
        end
    end
})

-------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
    util.AddNetworkString("OpenInvMenu")

    function ItemCanEnterForEveryone(inventory, action, context)
        if (action == "transfer") then return true end
    end

    function CanReplicateItemsForEveryone(inventory, action, context)
        if (action == "repl") then return true end
    end
else
    net.Receive("OpenInvMenu", function()
        local target = net.ReadEntity()
        local index = net.ReadType()
        local targetInv = nut.inventory.instances[index]
        local myInv = LocalPlayer():getChar():getInv()
        local inventoryDerma = targetInv:show()
        inventoryDerma:SetTitle(target:getChar():getName() .. "'s Inventory")
        inventoryDerma:MakePopup()
        inventoryDerma:ShowCloseButton(true)
        local myInventoryDerma = myInv:show()
        myInventoryDerma:MakePopup()
        myInventoryDerma:ShowCloseButton(true)
        myInventoryDerma:SetParent(inventoryDerma)
        myInventoryDerma:MoveLeftOf(inventoryDerma, 4)
    end)
end

--[[-------------------------------------------------------------------------

	Purpose: Check other players inventory's

	---------------------------------------------------------------------------]]
nut.command.add("checkinventory", {
    adminOnly = true,
    syntax = "<string target>",
    onRun = function(client, arguments)
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target) and target:getChar() and target ~= client) then
            local inventory = target:getChar():getInv()
            inventory:addAccessRule(ItemCanEnterForEveryone, 1)
            inventory:addAccessRule(CanReplicateItemsForEveryone, 1)
            inventory:sync(client)
            net.Start("OpenInvMenu")
            net.WriteEntity(target)
            net.WriteType(inventory:getID())
            net.Send(client)
        elseif (target == client) then
            client:notifyLocalized("This isn't meant for checking your own inventory.")
        end
    end
})

---------------------------------------------------------------------------]]
--[[
nut.command.add("classlist", {
    onRun = function(client)
        PrintTable(nut.class.list)
    end
})
nut.command.add("playerclass", {
    onRun = function(client)
        if (client:getChar():getClass()) then
            local playerClass = client:getChar():getClass()

            client:notify(nut.class.list[playerClass].name)
            client:notify(nut.class.list[playerClass].uniqueID)
        else
            client:notify("NO CLASS TO FIND")
        end
    end
})
]]
----------------------------------------------------------------------------
nut.chat.register("advert", {
    onCanSay = function(speaker, text)
        local plyFaction = nut.faction.indices[speaker:getChar():getFaction()].name
        if ((plyFaction != "Citizens of Moscow") and (plyFaction != "Gulag Inmate")) then
            if speaker:getChar():hasMoney(10) then
                speaker:getChar():takeMoney(10)
                speaker:notify("10 Rubles have been deducted from your wallet for advertising.")

                return true
            else
                speaker:notify("You lack sufficient funds to make an advertisement.")

                return false
            end
        elseif (plyFaction == "Citizens of Moscow") then
            speaker:notify("You cannot use that command.")

            return false
        else
            speaker:notify("You cannot use that command.")

            return false
        end
    end,
    onChatAdd = function(speaker, text)
        chat.AddText(Color(255, 238, 0), " [Advertisement] ", " ", speaker, ": ", color_white, text)
    end,
    prefix = {"/advert"},
    noSpaceAfter = true,
    filter = "advertisements"
})

----------------------------------------------------------------------------------------------------------------------------------------------
--[[
nut.command.add("store", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("https://externalgaming.noclip.me/")]]--[[)
    end
})
]]
nut.command.add("discord", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("https://discord.gg/esqs2p9K7x")]])
    end
})

nut.command.add("steam", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("")]])
    end
})

nut.command.add("content", {
    syntax = "<No Input>",
    onRun = function(client, arguments)
        client:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3038279239")]])
    end
})

-----------------------------------------------------------------------------------------------------------------------------