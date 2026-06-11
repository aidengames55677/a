-- "gamemodes\\mafiarp\\schema\\sh_commands.lua"

/*
	Permission Tables:
*/
local owner = {
	founder = true,
	communitymanager = true,
}

local haowner = {
	founder = true,
	communitymanager = true,
	headadministrator = true,
}

local globalRanks = {
	eventmanager = true,
	moderator = true,
	administrator = true,
	seasonedadministrator = true,
	senioradministrator = true,
	superadministrator = true,
	headadministrator = true,
	communitymanager = true,
	founder = true,
}

local adminRanks = {
	eventmanager = true,
	headgamemaster = true,
	administrator = true,
	seasonedadministrator = true,
	senioradministrator = true,
	superadministrator = true,
	headadministrator = true,
	communitymanager = true,
	founder = true,
}

local sadminRanks = {
	eventmanager = true,
	senioradministrator = true,
	superadministrator = true,
	headadministrator = true,
	communitymanager = true,
	founder = true,
}

local ssadminRanks = {
	superadministrator = true,
	headadministrator = true,
	communitymanager = true,
	founder = true,
}

local legalFacs = {
	[FACTION_GOVERNMENT] = true,
	[FACTION_UCS] = true,
	[FACTION_GOVERNMENTSTATE] = true,
	[FACTION_POLICE] = true,
	[FACTION_DELIVERY] = true,
	[FACTION_TAXI] = true,
	[FACTION_WORKER] = true,
	[FACTION_CITIZEN] = true, 
	[FACTION_prisoner] = true,
}

/*
	Console Commands
*/

if (CLIENT) then
	concommand.Add("findents", function( ply, cmd, args )
		if !ply:IsSuperAdmin() then return end
		hook.Remove("HUDPaint", "FindEntity")
		if !args[1] then return end
		hook.Add("HUDPaint", "FindEntity", function()
			for _, ent in ipairs(ents.FindByClass(args[1])) do
				local point = ent:GetPos() + ent:OBBCenter() 
				local data2D = point:ToScreen() 
				if ( not data2D.visible ) then continue end
				draw.SimpleText( args[1], "Default", data2D.x, data2D.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end)
	end)
end

/*
	Nutscript Commands:
*/
nut.command.add("sit", {
	syntax = "<sit number>",
	onRun = function(client, arguments)
	end
})

nut.command.add("roll", {
	syntax = "[number maximum]",
	onRun = function(client, arguments)
		local outOf = tonumber(arguments[1]) or 100

		nut.chat.send(client, "roll", math.random(0, math.min(outOf, 100)).."/"..outOf)
	end
})


nut.command.add("pm", {
	syntax = "<string target> <string message>",
	onRun = function(client, arguments)
		if client:Team() != FACTION_STAFF && !owner[client:GetUserGroup()] then
			client:notify("Only staff on duty can use this command! If you wish to communicate with another user in RP, use a phone.")
			return false
		end
		local message = table.concat(arguments, " ", 2)
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local voiceMail = target:getNutData("vm")

			if (voiceMail and voiceMail:find("%S")) then
				return target:Name()..": "..voiceMail
			end

			if ((client.nutNextPM or 0) < CurTime()) then
				nut.chat.send(client, "pm", message, false, {client, target})

				client.nutNextPM = CurTime() + 0.5
				target.nutLastPM = client
			end
		end
	end
})

nut.command.add("reply", {
	syntax = "<string message>",
	onRun = function(client, arguments)
		local target = client.nutLastPM

		if (IsValid(target) and (client.nutNextPM or 0) < CurTime()) then
			nut.chat.send(client, "pm", table.concat(arguments, " "), false, {client, target})
			client.nutNextPM = CurTime() + 0.5
		end
	end
})


nut.command.add("flaggive", {
	syntax = "<string name> [string flags]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!ssadminRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			local flags = arguments[2]

			if (!flags) then
				local available = ""

				-- Aesthetics~~
				for k, v in SortedPairs(nut.flag.list) do
					if (!target:getChar():hasFlags(k)) then
						available = available..k
					end
				end

				return client:requestString("@flagGiveTitle", "@flagGiveDesc", function(text)
					nut.command.run(client, "flaggive", {target:SteamID(), text})
				end, available)
			end

			target:getChar():giveFlags(flags)

			nut.util.notifyLocalized("flagGive", {target, client}, client:Name(), target:Name(), flags)
		end
	end
})

local function createDermaQuery()
    Derma_Query(
        'You are seeing this message because the name you have chosen for your character has been flagged as inappropriate. Your name "'..LocalPlayer():Name()..'" is unacceptable.\nYou now have an opportunity to correct this. When choosing a new name, pick something unique. No TV shows or movie characters, be original. You should have a first and last name.', 
        'Name Change Notification', 
        'Change my name.', 
        function() 
            Derma_StringRequest(
                'Name Change', 
                'Input a new name for your character below.', 
                '', 
                function(text)
                    if (!text or #text:gsub("%s", "") > 64) then
						nut.util.notify("Your name is too long. Try again.")
                        createDermaQuery()
					elseif (#text:gsub("%s", "") < 8) then
						nut.util.notify("Your name is too short. Try again.")
						createDermaQuery()
                    else
                        net.Start("doNameChange")
                            net.WriteString(text)
                        net.SendToServer()
                    end
                end
            )
        end
    )
end

net.Receive("nameChangeNotify", function()
    createDermaQuery()
end)

net.Receive("New911", function()
	local number = net.ReadString()
	local text = net.ReadTable()
	text = table.concat(text, " ")
	local pos = net.ReadVector()

	surface.PlaySound('buttons/blip1.wav')
	chat.AddText( Color(255, 0, 0), "[911 from "..number.."] ", color_white, text)

	LocalPlayer():SetWeighPoint("911 Call", Vector(pos))
end)


nut.command.add("911", {
	syntax = "<string text>",
	onRun = function(client, arguments)
	end
})

nut.command.add("namechange", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("gotopos", {
	syntax = "<string cords>",
	onRun = function(client, arguments)
	end
})

nut.command.add("charcomplost", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("banooc", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("flagbearcat", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})


nut.command.add("flagmedal", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("flagbroadcast", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("flagpolice", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("flagragdoll", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("flagpolicespecial", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("mediagive", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("mediatake", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})

nut.command.add("mediagiveoffline", {
	syntax = "<string steamID>",
	onRun = function(client, arguments)
	end
})

nut.command.add("mediatakeoffline", {
	syntax = "<string steamID>",
	onRun = function(client, arguments)
	end
})

nut.command.add("mediaunblacklist", {
	syntax = "<string name>",
	onRun = function(client, arguments)
	end
})



nut.command.add("flagtake", {
	syntax = "<string name> [string flags]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			local flags = arguments[2]

			if (!flags) then
				return client:requestString("@flagTakeTitle", "@flagTakeDesc", function(text)
					nut.command.run(client, "flagtake", {target:SteamID(), text})
				end, target:getChar():getFlags())
			end

			target:getChar():takeFlags(flags)

			nut.util.notifyLocalized("flagTake", {target, client}, client:Name(), flags, target:Name())
		end
	end
})

nut.command.add("massgivemoney", {
	syntax = "<number amount>",
	onRun = function(client, arguments)
	end
})

nut.command.add("massgiveitem", {
	syntax = "<string item>",
	onRun = function(client, arguments)
	end
})

nut.command.add("masssetmodel", {
	syntax = "<string model>",
	onRun = function(client, arguments)
	end
})

nut.command.add("massreversemodel", {
	syntax = "",
	onRun = function(client, arguments)
	end
})

nut.command.add("charsetmodel", {
	syntax = "<string name> <string model>",
	onCheckAccess = function(client)
		return SCHEMA.RanksSenior[client:GetUserGroup()] or client:isGamemaster()
	end,
	onRun = function(client, arguments)
		local model = arguments[2]
		if (!model) then
			return L("invalidArg", client, 2)
		end

		local target = nut.command.findPlayer(client, arguments[1])
		local plugin = nut.plugin.list.bonemerge
		if plugin:IsCustomHead( model ) and not plugin:HasCustomHead( target, model ) then
			client:notify( "This is a custom model belonging to another user. You may not set someone to it." )
			return false
		end

		if (IsValid(target) and target:getChar()) then
			target:getChar():setModel(model)
			target:SetupHands()
			nut.util.notifyLocalized("cChangeModel", {client, target}, client:Name(), target:Name(), arguments[2])
		end
	end
})

if (CLIENT) then
    netstream.Hook("sendToClipboard", function(mdl)
        SetClipboardText(mdl)
    end)
end


nut.command.add("chargetmodel", {
    syntax = "<string name>",
    onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		
        local target = nut.command.findPlayer(client, arguments[1])

        if (IsValid(target) and target:getChar()) then
            client:notify("You have copied the model '"..target:GetModel().."' to your clipboard.")
            netstream.Start(client, "sendToClipboard", target:GetModel())
        end
    end
})

nut.command.add("charsetskin", {
	syntax = "<string name> [number skin]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local skin = tonumber(arguments[2])
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			target:getChar():setData("skin", skin)
			target:SetSkin(skin or 0)

			nut.util.notifyLocalized("cChangeSkin", {client, target}, client:Name(), target:Name(), skin or 0)
		end
	end
})

nut.command.add("charsetattrib", {
	syntax = "<string charname> <string attribname> <number level>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!owner[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local attribName = arguments[2]
		if (!attribName) then
			return L("invalidArg", client, 2)
		end

		local attribNumber = arguments[3]
		attribNumber = tonumber(attribNumber)
		if (!attribNumber or !isnumber(attribNumber)) then
			return L("invalidArg", client, 3)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			if (char) then
				for k, v in pairs(nut.attribs.list) do
					if (nut.util.stringMatches(L(v.name, client), attribName) or nut.util.stringMatches(k, attribName)) then
						char:setAttrib(k, math.abs(attribNumber))
						client:notifyLocalized("attribSet", target:Name(), L(v.name, client), math.abs(attribNumber))

						return
					end
				end
			end
		end
	end
})

nut.command.add("charaddattrib", {
	syntax = "<string charname> <string attribname> <number level>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!owner[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local attribName = arguments[2]
		if (!attribName) then
			return L("invalidArg", client, 2)
		end

		local attribNumber = arguments[3]
		attribNumber = tonumber(attribNumber)
		if (!attribNumber or !isnumber(attribNumber)) then
			return L("invalidArg", client, 3)
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			if (char) then
				for k, v in pairs(nut.attribs.list) do
					if (nut.util.stringMatches(L(v.name, client), attribName) or nut.util.stringMatches(k, attribName)) then
						char:updateAttrib(k, math.abs(attribNumber))
						client:notifyLocalized("attribUpdate", target:Name(), L(v.name, client), math.abs(attribNumber))

						return
					end
				end
			end
		end
	end
})

nut.command.add("charsetname", {
	syntax = "<string name> [string newName]",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and !arguments[2]) then
			return client:requestString("@chgName", "@chgNameDesc", function(text)
				nut.command.run(client, "charsetname", {target:SteamID(), text})
			end, target:Name())
		end

		table.remove(arguments, 1)

		local targetName = table.concat(arguments, " ")

		if (IsValid(target) and target:getChar()) then
			nut.util.notifyLocalized("cChangeName", {target, client}, client:Name(), target:Name(), targetName)
			SAdmin:AddLog("Name Changes", client:Nick().." changed "..target:Nick().."'s ("..target:SteamID()..") name to "..targetName, client:SteamID())
			SAdmin:AddLog("Name Changes", target:Nick().. " had their name changed by "..client:Nick().." ("..client:SteamID()..") to "..targetName, target:SteamID())
			target:getChar():setName(targetName:gsub("#", "#​"))
		end
	end
})

nut.command.add("charsetdesc", {
	syntax = "<string name> <string desc>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])
		if (!IsValid(target)) then return end
		if (!target:getChar()) then
			return "No character loaded"
		end
		
		local arg = table.concat(arguments, " ", 2)

		if (!arg:find("%S")) then
			return client:requestString("Change " .. target:Nick() .. "'s Description", "Enter new description", function(text)
				nut.command.run(client, "charsetdesc", {arguments[1], text})
			end, target:getChar():getDesc())
		end

		local info = nut.char.vars.desc
		local result, fault, count = info.onValidate(arg)

		if (result == false) then
			return "@"..fault, count
		end

		target:getChar():setDesc(arg)

		return "Successfully changed " .. target:Nick() .. "'s description"
	end
})

nut.command.add("charkick", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			if !client:CanTargetRank(target:GetUserGroup()) then
				return false, "You cannot run this command on this user!"
			end
			local char = target:getChar()
			if (char) then
				for k, v in ipairs(player.GetAll()) do
					v:notifyLocalized("charKick", client:Name(), target:Name())
				end

				char:kick()
			end
		end
	end
})



nut.command.add("charban", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!adminRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()

			if (char) then
				SAdmin:AddLog("Permanent Kills", client:Nick().." PK'd "..target:Nick().." "..target:SteamID().." ["..target:getChar():getID().."] using /charban", client:SteamID())
				if client != target then
					SAdmin:AddLog("Permanent Kills", target:Nick().." was PK'd by "..client:Nick().." "..client:SteamID().." using /charban", target:SteamID())
				end
				nut.util.notifyLocalized("charBan", {target, client}, client:Name(), target:Name())
				
                local descTbl = isstring( char.vars.descgenerator ) and util.JSONToTable( char.vars.descgenerator ) or char.vars.descgenerator
                local age = "???"
                if descTbl and descTbl[ 'Age' ] then
                    age = descTbl[ 'Age' ]
                end
            
                net.Start( "PK.ShowScreen" )
                net.WriteString( char:getName() )
                net.WriteUInt( ( descTbl and descTbl["Age"] ) and tonumber( descTbl["Age"] ) or 0, 16 )
                net.Send( target )

                char:ban()
                target:SetPos(Vector(1365.387207, -335.377136, 2642.427246))
			end
		end
	end
})

nut.command.add("charunban", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!sadminRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		if ((client.nutNextSearch or 0) >= CurTime()) then
			return L("charSearching", client)
		end

		local name = table.concat(arguments, " ")

		for k, v in pairs(nut.char.loaded) do
			if (nut.util.stringMatches(v:getName(), name)) then
				if (v:getData("banned")) then
					v:setData("banned")
				else
					return "@charNotBanned"
				end
				local play = v:getPlayer()
				SAdmin:AddLog("Permanent Kills", client:Nick().." unPK'd "..play:Nick().." "..play:SteamID().." ["..v:getID().."] using /charunban", client:SteamID())
				if client != play then
					SAdmin:AddLog("Permanent Kills", v:getName().." ["..v:getID().."] was unPK'd by "..client:Nick().." "..client:SteamID().." using /charunban", play:SteamID())
				end
				return nut.util.notifyLocalized("charUnBan", client, client:Name(), v:getName())
			end
		end

		client.nutNextSearch = CurTime() + 15
	

		nut.db.query("SELECT _id, _name, _data FROM nut_characters WHERE _name LIKE \"%"..nut.db.escape(name).."%\" LIMIT 1", function(data)
			if (data and data[1]) then
				local charID = tonumber(data[1]._id)
				local name = data[1]._name
				local data = util.JSONToTable(data[1]._data or "[]")

				client.nutNextSearch = 0

				if (!data.banned) then
					return client:notifyLocalized("charNotBanned")
				end

				data.banned = nil
				
				nut.db.updateTable({_data = data}, nil, nil, "_id = "..charID)
				nut.util.notifyLocalized("charUnBan", client, client:Name(), v:getName())
			end
		end)
	end
})

nut.command.add("givemoney", {
	syntax = "<number amount>",
	onRun = function(client, arguments)
		local number = tonumber(arguments[1])
		number = number or 0
		local amount = math.floor(number)

		if (!amount or !isnumber(amount) or amount <= 0) then
			return L("invalidArg", client, 1)
		end

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:getChar()) then
			amount = math.Round(amount)

			if (!client:getChar():hasMoney(amount)) then
				return
			end

			target:getChar():giveMoney(amount)
			client:getChar():takeMoney(amount)
			client:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)

			local balance = nut.currency.get( amount )
            balance = balance:gsub("(%d+)", function(n) return string.Comma(n) end)
			target:notifyLocalized("moneyTaken", balance)
			client:notifyLocalized("moneyGiven", balance)
			
			SAdmin:AddLog("Money", client:Nick().." gave $"..amount.." to "..target:Nick().." "..target:SteamID().." ["..target:getChar():getID().."]", client:SteamID())
			SAdmin:AddLog("Money", target:Nick().." was given  $"..amount.." by" ..client:Nick().." "..client:SteamID(), target:SteamID())
				
		end
	end
})

nut.command.add("charsetmoney", {
	syntax = "<string target> <number amount>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!owner[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local amount = tonumber(arguments[2])

		if (!amount or !isnumber(amount) or amount < 0) then
			return "@invalidArg", 2
		end

		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()
			
			if (char and amount) then
				amount = math.Round(amount)
				char:setMoney(amount)
				client:notifyLocalized("setMoney", target:Name(), nut.currency.get(amount))
			end
		end
	end
})

nut.command.add("dropmoney", {
	syntax = "<number amount>",
	onRun = function(client, arguments)
		local amount = tonumber(arguments[1])

		if (!amount or !isnumber(amount) or amount < 1) then
			return "@invalidArg", 1
		end

		amount = math.Round(amount)
		
		if (amount < 100) then
			client:notify("You cannot drop less than $100. Use /givemoney instead")
			return
		end
		
		if (!client:getChar():hasMoney(amount)) then
			return
		end
		
		if (client.NextDropMoney && SysTime() < client.NextDropMoney) then
			client:notify("You can't drop money that quickly.")
			return
		end
		
		client.NextDropMoney = SysTime() + 2

		client:getChar():takeMoney(amount)
		client:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)
		local money = nut.currency.spawn(client:getItemDropPos(), amount)
		money.client = client
		money.charID = client:getChar():getID()
	end
})

nut.command.add("plywhitelist", {
	syntax = "<string name> <string faction>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!owner[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])
		local name = table.concat(arguments, " ", 2)

		if (IsValid(target)) then
			local faction = nut.faction.teams[name]

			if (!faction) then
				for k, v in ipairs(nut.faction.indices) do
					if (nut.util.stringMatches(L(v.name, client), name) or nut.util.stringMatches(v.uniqueID, name)) then
						faction = v

						break
					end
				end
			end

			if (faction) then
				if (target:setWhitelisted(faction.index, true)) then
					for k, v in ipairs(player.GetAll()) do
						v:notifyLocalized("whitelist", client:Name(), target:Name(), L(faction.name, v))
					end
				end
			else
				return "@invalidFaction"
			end
		end
	end
})

nut.command.add("chargetup", {
	onRun = function(client, arguments)
		local entity = client.nutRagdoll

		if (IsValid(entity) and entity.nutGrace and entity.nutGrace < CurTime() and entity:GetVelocity():Length2D() < 8 and !entity.nutWakingUp) then
			entity.nutWakingUp = true

			client:setAction("@gettingUp", 5, function()
				if (!IsValid(entity)) then
					return
				end

				entity:Remove()
			end)
		end
	end
})

nut.command.add("plyunwhitelist", {
	syntax = "<string name> <string faction>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!owner[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])
		local name = table.concat(arguments, " ", 2)

		if (IsValid(target)) then
			local faction = nut.faction.teams[name]

			if (!faction) then
				for k, v in ipairs(nut.faction.indices) do
					if (nut.util.stringMatches(L(v.name, client), name) or nut.util.stringMatches(v.uniqueID, name)) then
						faction = v

						break
					end
				end
			end

			if (faction) then
				if (target:setWhitelisted(faction.index, false)) then
					for k, v in ipairs(player.GetAll()) do
						v:notifyLocalized("unwhitelist", client:Name(), target:Name(), L(faction.name, v))
					end
				end
			else
				return "@invalidFaction"
			end
		end
	end
})

nut.command.add("fallover", {
	syntax = "[number time]",
	onRun = function(client, arguments)
		if (client:getNetVar("restricted") or client:IsFrozen() or client:InVehicle() or client:getNetVar("hasRepair") or (client.LastDamaged and client.LastDamaged > CurTime() - 30) ) then
			client:notify("You can't use this command currently!")	
			return false
		end
		local time = tonumber(arguments[1])

		if (!isnumber(time)) then
			time = 5
		end

		if (time > 2) then
			time = math.Clamp(time, 1, 60)
		else
			time = 2
		end

		if (!IsValid(client.nutRagdoll)) then
			client:setRagdolled(true, time)
		end
	end
})

nut.command.add("chardesc", {
	syntax = "<string desc>",
	onRun = function(client, arguments)
		arguments = table.concat(arguments, " ")

		if (!arguments:find("%S")) then
			return client:requestString("@chgDesc", "@chgDescDesc", function(text)
				nut.command.run(client, "chardesc", {text})
			end, client:getChar():getDesc())
		end

		local info = nut.char.vars.desc
		local result, fault, count = info.onValidate(arguments)

		if (result == false) then
			return "@"..fault, count
		end

		client:getChar():setDesc(arguments)

		return "@descChanged"
	end
})

nut.command.add("clearinv", {
	syntax = "<string name>",
	onRun = function (client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])
		
		if (IsValid(target) and target:getChar()) then
			for k, v in pairs(target:getChar():getInv():getItems()) do
				v:remove()
			end

			client:notifyLocalized("resetInv", target:getChar():getName())
		end
	end
})

nut.command.add("flags", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			client:notify(target:Name().. "'s character flags are: '"..target:getChar():getFlags().."'")
		end
	end
})

nut.command.add("money", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			client:notify(target:Name().. " has in their wallet: $"..target:getChar():getMoney())
		end
	end
})

nut.command.add("bankbal", {
	syntax = "<string name>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			client:notify(target:Name().. " has in their bank account: $"..target:getChar():getData("bankBal"))
		end
	end
})

nut.command.add("logs", {
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end

		client:SendLua([[
			local f = vgui.Create("DFrame")
			f:SetSize(ScrW()*0.8, ScrH()*0.8)
			f:SetTitle("Logs")
			f:Center()
			f:MakePopup()
			local h = vgui.Create("DHTML", f)
			h:Dock(FILL)
			h:OpenURL("https://bans.divergenet.works/logs")
		]])
	end
})

ITEM_IGNORE_ITEMS = {
	["acid_hydro"] = true,
	["acid_lysergic"] = true,
	["acid_muri"] = true,
	["bakingsoda"] = true,
	["bulk_cocaine"] = true,
	["bulk_heroin"] = true,
	["bulk_lsd"] = true,
	["bulk_mdma"] = true,
	["bulk_meth"] = true,
	["bulk_methaqualone"] = true,
	["bulk_oil"] = true,
	["bulk_opium"] = true,
	["bulk_shrooms"] = true,
	["bulk_weed"] = true,
	["drug_lab"] = true,
	["matchbook"] = true,
	["poppy_plant"] = true,
	["poppy_seed"] = true,
	["pot_empty"] = true,
	["soil"] = true,
	["spores"] = true,
	["water_jug"] = true,
	["weed_plant"] = true,
	["weed_seed"] = true,
	["cocaine"] = true,
	["crack"] = true,
	["heroin"] = true,
	["lsd"] = true,
	["mdma"] = true,
	["meth"] = true,
	["methaqualone"] = true,
	["opium"] = true,
	["sanpedro"] = true,
	["shrooms"] = true,
	["weed"] = true,
	["weed_imported"] = true,
	["drug_refiner"] = true,
}

nut.command.add("cleanitems", {
    onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
 
	for k, v in pairs(ents.FindByClass("nut_item")) do
		local itemTable = v:getItemTable()
		if (v:getNetVar("id") && ITEM_IGNORE_ITEMS[v:getNetVar("id")]) then continue end
		if itemTable.isWeapon then continue end
        v:Remove()
    end
        client:notify("All non drug items have been cleaned up from the map.")
    end
})

nut.command.add("rootcleanitems", {
    onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!owner[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
    for k, v in pairs(ents.FindByClass("nut_item")) do
        v:Remove()
    end
        client:notify("All items including drugs have been cleaned up from the map.")
    end
})

nut.command.add("freezeprops", {
	syntax = "<string target>",
	onRun = function(client, arguments) 
	end
})

nut.command.add("forums", {
	onRun = function(client, arguments)
		client:SendLua([[
			local f = vgui.Create("DFrame")
			f:SetSize(ScrW()*0.8, ScrH()*0.8)
			f:SetTitle("divergenet.works/forums")
			f:Center()
			f:MakePopup()
			local h = vgui.Create("DHTML", f)
			h:Dock(FILL)
			h:OpenURL("https://divergenet.works/forums/")
		]])
	end
})

if isMiami then
	nut.command.add("content", {
		onRun = function(client, arguments)
		client:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2757673673")]])
		end
	})
	nut.command.add("workshop", {
		onRun = function(client, arguments)
		client:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2757673673")]])
		end
	})
elseif !isMiami then
	nut.command.add("content", {
		onRun = function(client, arguments)
		client:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2238810677")]])
		end
	})
	nut.command.add("workshop", {
		onRun = function(client, arguments)
		client:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2238810677")]])
		end
	})
end

nut.command.add("discord", {
	onRun = function(client, arguments)
		client:SendLua([[gui.OpenURL("https://discord.gg/2cyknbWqtm")]])
	end
})

nut.command.add("steam", {
	onRun = function(client, arguments)
	client:SendLua([[gui.OpenURL("https://steamcommunity.com/groups/dv-n")]])
	end
})

nut.command.add("rules", {
	onRun = function(client, arguments)
		client:SendLua([[
			local f = vgui.Create("DFrame")
			f:SetSize(ScrW()*0.8, ScrH()*0.8)
			f:SetTitle("Rules")
			f:Center()
			f:MakePopup()
			local h = vgui.Create("DHTML", f)
			h:Dock(FILL)
			h:OpenURL("https://divergenet.works/forums/forumdisplay.php?fid=34")
		]])
	end
})

nut.command.add("motd", {
	onRun = function(client, arguments)
		client:SendLua([[
			local f = vgui.Create("DFrame")
			f:SetSize(ScrW()*0.8, ScrH()*0.8)
			f:SetTitle("Rules")
			f:Center()
			f:MakePopup()
			local h = vgui.Create("DHTML", f)
			h:Dock(FILL)
			h:OpenURL("https://divergenet.works/forums/forumdisplay.php?fid=34")
		]])
	end
})

nut.command.add("guides", {
	onRun = function(client, arguments)
		client:SendLua([[
			local f = vgui.Create("DFrame")
			f:SetSize(ScrW()*0.8, ScrH()*0.8)
			f:SetTitle("Guides")
			f:Center()
			f:MakePopup()
			local h = vgui.Create("DHTML", f)
			h:Dock(FILL)
			h:OpenURL("https://divergenet.works/forums/forumdisplay.php?fid=26")
		]])
	end
})

nut.command.add("announce", {
	syntax = "<string message>",
	onRun = function(client, text)
	end,
	prefix = {"/announce"},
})

if CLIENT then
    
	Announce = Announce or {}
	AnnounceNext = AnnounceNext or 1
	AnnounceLength = 20
	AnnounceSound = "buttons/button19.wav"
	
	net.Receive("sendAnnouncement", function()
		local announce = {
			admin = net.ReadString(),
			text = net.ReadString(),
			start = SysTime()
		}
		Announce[AnnounceNext] = announce
		AnnounceNext = AnnounceNext + 1
		
		if (AnnounceSound && AnnounceSound != "") then
			surface.PlaySound(AnnounceSound)
		end
	end)
	
	function string.wrapwords(Str,font,width)
		if( font ) then--Dr Magnusson's much less prone to failure and more optimized version
			surface.SetFont( font )  
		end 
		
		local tbl, len, Start, End = {}, string.len( Str ), 1, 1
		
		while ( End < len ) do  
			End = End + 1
			if ( surface.GetTextSize( string.sub( Str, Start, End ) ) > width ) then
			local n = string.sub( Str, End, End )  
			local I = 0
			for i = 1, 15
				do  
					I = i  
					if( n != " "and n != ","and n != "."and n != "\n" ) then  
						End = End - 1  
						n = string.sub( Str, End, End )  
					else
						break
					end
				end
				
				if( I == 15 ) then  
					End = End + 14
				end
				
				local FnlStr = string.Trim( string.sub( Str, Start, End ) )  
				table.insert( tbl, FnlStr )  
				Start = End + 1
			end
		end
		table.insert( tbl, string.sub( Str, Start, End ) )  
		return tbl
	end
	
	hook.Add("HUDPaint", "Announce::HUDPaint", function()
		local cols = {
			bg = Color( 37, 37, 37 ),
			purple = Color( 128, 128, 128 ),
		}
		
		local activeAnnouncements = {}
		local deadKeys = {}
		for i=1,AnnounceNext-1 do
			if (Announce[i]) then
				if (SysTime() - Announce[i].start >= AnnounceLength) then
					Announce[i] = nil
				else
					table.insert(activeAnnouncements, 1, Announce[i])
				end
			end
		end
		
		local buffer = 0
		local startPoint = ScrH()/2-200
		local announceWidth = 900
		for k,v in pairs(activeAnnouncements) do
			local textWrapped = string.wrapwords(v.text, "DermaLarge", announceWidth)
			
			local delta = SysTime() - v.start
			local alpha = 255
			if (delta < 0.5) then -- Animation
				alpha = Lerp(delta*2, 0, 255)
			elseif (delta > AnnounceLength - 0.5) then
				alpha = Lerp((delta - AnnounceLength + 0.5)*2, 255, 0)
			end
			
			surface.SetFont("DermaLarge")
			local t_w, t_h = surface.GetTextSize("Admin Announcement (" .. v.admin .. ")")
			
			surface.SetDrawColor(Color(cols.bg.r,cols.bg.g, cols.bg.b, alpha))
			surface.DrawRect(ScrW()/2 - announceWidth/2 - 4, startPoint + buffer - 4, announceWidth + 8, t_h * (#textWrapped + 1) + 8)
			
			surface.SetDrawColor(Color(cols.purple.r,cols.purple.g, cols.purple.b, alpha))
			surface.DrawRect(ScrW()/2 - announceWidth/2 - 2, startPoint + buffer - 2, announceWidth + 4, t_h)
			
			draw.SimpleText("Admin Announcement (" .. v.admin .. ")", "DermaLarge", ScrW()/2, startPoint + buffer, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			
			local localbuffer = t_h
			for k,v in pairs(textWrapped) do
				draw.SimpleText(v, "DermaLarge", ScrW()/2, startPoint + localbuffer + buffer, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
				localbuffer = localbuffer + t_h
			end
			
			v.buffer_add = t_h * (#textWrapped + 1) + 8 + 5
			buffer = buffer + Lerp(delta * 2, 0, v.buffer_add)
		end

	end)
end

----------------------------------------------------------------------------------------------
// Communication Commands

nut.chat.register("rumour", {
	onCanSay =  function(speaker, text)
		if legalFacs[speaker:Team()] or speaker:getNetVar("restricted") then
			speaker:notify("You do not have the permissions to do this.")
			return false 
		end
		if speaker:getChar():hasMoney(100) then
			speaker:getChar():takeMoney(100)
			speaker:notify("$100 has been deducted from your account for illegal advertising.")
			return true
		else 
			speaker:notify("You lack sufficient funds to illegally advertise.")
			return false 
		end
		if speaker:sam_get_play_time() < 7200 then
			speaker:ChatPrint("You may not post an advertisement with less than 2 hours playtime! Type !time to check your playtime.")
			return false
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 76, 0), " [Underground Advertisement] ", color_white, text)
	end,
	onCanHear = function(speaker, listener)
		if (legalFacs[listener:Team()] && !haowner[listener:GetUserGroup()]) or listener:getNetVar("restricted") then
			return false
		else
			return true
		end
	end,
	prefix = {"/rumour"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.chat.register("taxiadvert", {
	onCanSay =  function(speaker, text)	
		if speaker:Team() != FACTION_TAXI then
			speaker:notify("You are not a Taxi Driver!")
			return false 
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 238, 0), " [Taxi Advertisement] ", color_white, text)
	end,
	prefix = {"/taxiadvert"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.chat.register("taxi", {
	onCanSay =  function(speaker, text)	
		if (speaker.LastTaxi or 0) > CurTime() - 120 then
			speaker:notify("You can only send Taxi Requests every 2 minutes.")
			return false
		end

		if speaker:Team() == FACTION_TAXI then
			speaker:notify("You are a Taxi Driver!")
			return false 
		end

		speaker.LastTaxi = CurTime()
		local pos = speaker:GetPos()
		for k, v in ipairs(player.GetAll()) do
			if v:Team() == FACTION_TAXI then
				v:notify("Player has requested a taxi. Their location has been marked on your screen.")
				v:SendLua([[LocalPlayer():SetWeighPoint("Taxi Pickup", Vector(]]..pos.x..[[,]]..pos.y..[[,]]..pos.z..[[), function() end)]])
			end
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 238, 0), " [Taxi Request] ", color_white, text)
	end,
	onCanHear = function(speaker, listener)
		if listener:Team() == FACTION_TAXI or listener:Team() == FACTION_STAFF or owner[listener:GetUserGroup()] then 
			return true 
		else 
			return false
		end
	end,
	prefix = {"/taxi"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.chat.register("advertisement", {
	onCanSay =  function(speaker, text)
		if speaker:sam_get_play_time() < 7200 then
			speaker:ChatPrint( "You may not post an advertisement with less than 2 hours playtime! Type !time to check your playtime." )
			return false
		end

		if speaker:getNetVar("restricted") then return false end

		if ( speaker.LastAdvertisement or 0 ) > CurTime() - 120 then
			speaker:notify( "You can only send advertisements every 2 minutes." )
			return false
		end

		if LastAdvert and LastAdvert > CurTime() - 5 then
			speaker:notify( "An advertisement was recently posted. Please wait " .. math.Round ( 5 - ( CurTime() - LastAdvert ) ) .. " seconds." )
			return false
		end

		if speaker:getChar():hasMoney(50) then
			speaker:getChar():takeMoney(50)
			speaker:notify("Your advert has been posted successfully and $50 has been taken from you.")

			speaker.LastAdvertisement = CurTime()
			LastAdvert = CurTime()
			return true
		else 
			speaker:notify("You lack sufficient funds to advert.")
			return false 
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 238, 0), " [Advertisement by " .. speaker:Nick() .. "] ", color_white, text)
	end,
	onCanHear = function(speaker, listener)
		if listener:getNetVar("restricted") then return false end 
	end,
	prefix = {"/advertisement"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.flag.add("a", "Ability to use /pdannounce")
nut.chat.register("pdbroadcast", {
	onCanSay =  function(speaker, text)
		if !speaker:getChar():hasFlags("a") then
			speaker:notify("You don't have the permissions required for this!")
			return false 
		else 
			return true
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(54,127,255), " [Police Department Broadcast by " .. speaker:Nick() .. "] ", color_white, text)
	end,
	prefix = {"/pdbroadcast"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.chat.register("rpd", {
    onCanSay = function(speaker, text)
        if speaker:getNetVar("restricted") then
            speaker:notify("You can't use this whilst tied!")
            return false
        end
        
        if speaker:Team() == FACTION_POLICE and speaker:getChar():getInv():hasItem("radio") then
            return true
        else
            speaker:notify("You need to be a member of the NYPD and have a radio to use this command!")
            return false
        end
    end,
    onChatAdd = function(speaker, text)
        chat.AddText(Color(0, 0, 210), " [Police Radio] ", color_white, text, " - " .. speaker:Nick())
        speaker:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))
    end,
    onCanHear = function(speaker, listener)
        local listenerTeam = listener:Team()
        local listenerChar = listener:getChar()
        
        if listenerChar and listenerChar:getInv():hasItem("radio") and listenerTeam == FACTION_POLICE and not listener:getNetVar("restricted") then 
            return true
        else
            return false
        end
    end,
    prefix = {"/rpd"},
    noSpaceAfter = true,
})

local govFacs = {[FACTION_GOVERNMENT] = true, [FACTION_GOVERNMENTSTATE] = true, [FACTION_UCS] = true}
nut.chat.register("gpd", {
    onCanSay = function(speaker, text)
        if speaker:getNetVar("restricted") then
            speaker:notify("You can't use this whilst tied!")
            return false
        end

        local speakerTeam = speaker:Team()
        if govFacs[speakerTeam] and speaker:getChar():getInv():hasItem("radio") then
            return true
        else
            speaker:notify("You need to be a member of the Government and have a radio to use this command!")
            return false
        end
    end,
    onChatAdd = function(speaker, text)
        chat.AddText(Color(230, 184, 0), " [Government Radio] ", color_white, text, " - " .. speaker:Nick())
        speaker:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))
    end,
    onCanHear = function(speaker, listener)
        local listenerTeam = listener:Team()
        local listenerChar = listener:getChar()
        
        if listenerChar and listenerChar:getInv():hasItem("radio") and govFacs[listenerTeam] and not listener:getNetVar("restricted") or owner[listener:GetUserGroup()] then
            return true
        else
            return false
        end
    end,
    prefix = {"/gpd"},
    noSpaceAfter = true,
})


if (SERVER) then
	timer.Create("Cleanup Decals", 120, 0, function ()
		for _, v in pairs(player.GetHumans()) do
			v:ConCommand("r_cleardecals")
		end
	end)
end
