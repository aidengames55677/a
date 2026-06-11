-- "gamemodes\\mafiarp\\plugins\\gamemaster\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Gamemasters"
PLUGIN.author = "rusty"
PLUGIN.Gamemasters = PLUGIN.Gamemasters or {}
PLUGIN.GamemasterCommands = {
	"chargiveitem",
	"adminspawnmenu",
	"itemforge",
	"itemforgelist",
	"itemforgedetails",
}
PLUGIN.OverrideRanks = {
	founder = true,
	communitymanager = true,
	headadministrator = true,
	superadministrator = true,
}

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")

local meta = FindMetaTable("Player")

function meta:isGamemaster()
	return (PLUGIN.Gamemasters[self:SteamID()] && SCHEMA.RanksMod[self:GetUserGroup()]) or PLUGIN.OverrideRanks[self:GetUserGroup()] or false
end

/*
	Some cool code from my WIP admin plugin
*/

function PLUGIN:InitializedPlugins()
	for _,cmd in ipairs(self.GamemasterCommands) do
		local info = nut.command.list[cmd]
		if !info then continue end

		if info.gameMaster then
			info.onCheckAccess = function(client)
				return client:isGamemaster()
			end
			info._onRun = info._onRun or info.onRun
			info.onRun = function(client, arguments)
				if !info.onCheckAccess(client) then
					return "@noPerm"
				else
					return info._onRun(client, arguments)
				end
			end
		end
	end
end

/*
	Functions
*/

function PLUGIN:AddGamemaster(steamID)
	self.Gamemasters[steamID] = true

	if SERVER then
		net.Start("nutGamemasterInfo")
			net.WriteUInt(1, 32)
			net.WriteString(steamID)
			net.WriteBool(true)
		net.Broadcast()

		nut.db.preparedCall("nutAddGamemaster", nil, steamID)
	end
end

function PLUGIN:RemoveGamemaster(steamID)
	self.Gamemasters[steamID] = nil

	if SERVER then
		net.Start("nutGamemasterInfo")
			net.WriteUInt(1, 32)
			net.WriteString(steamID)
			net.WriteBool(false)
		net.Broadcast()

		nut.db.preparedCall("nutRemoveGamemaster", nil, steamID)
	end
end

/*
	Commands
*/

nut.command.add("chargiveitem", {
	syntax = "<string name> <string item>",
	gameMaster = true,
	onRun = function(client, arguments)
		local usergrp = client:GetUserGroup()
		if (!arguments[2]) then
			return L("invalidArg", client, 2)
		end
		
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:getChar()) then
			local uniqueID = arguments[2]:lower()

			if (!nut.item.list[uniqueID]) then
				for k, v in SortedPairs(nut.item.list) do
					if (nut.util.stringMatches(v.name, uniqueID)) then
						uniqueID = k

						break
					end
				end
			end

			if !nut.item.list[uniqueID] then
				client:notify("This item does not exist.")
				return
			end

			if (nut.item.list[uniqueID].VIP || nut.item.list[uniqueID].NoClothingVendor || nut.item.list[uniqueID].plyExclusive || nut.item.list[uniqueID].noSpawning) && !SCHEMA.RanksCM[client:GetUserGroup()] then
				client:notify("You cannot spawn this.")
				return false
			end

			if !PLUGIN.OverrideRanks[usergrp] and client:isGamemaster() and !client.ItemPromptFinished then
				net.Start("nutItemSpawnPrompt")
					net.WriteString(arguments[1])
					net.WriteString(uniqueID)
				net.Send(client)

				client.ItemPromptStarted = true

				return
			end

			local inv = target:getChar():getInv()
			if not inv:findFreePosition(uniqueID) then
				client:notify("There isn't sufficient inventory space to spawn this!")
				return false
			end

			local succ, err = target:getChar():getInv():add(uniqueID)

			if (succ) then
				target:notifyLocalized("itemCreated")
				if(target != client) then
					client:notifyLocalized("itemCreated")
				end
			else
				target:notify(tostring(succ))
				target:notify(tostring(err))
			end

			client.ItemPromptStarted = nil
			client.ItemPromptFinished = nil
		end
	end
})