local PLUGIN = PLUGIN

PLUGIN.name = "PK Script"
PLUGIN.desc = "Die with honor. Do not pass go, do not collect 200 dollars."
PLUGIN.author = "rusty"

PLUGIN.TransferWhitelist = {
	citizen = true,
	automated_delivery = true,
	automated_taxi = true,
	automated_worker = true,
	prisoner = true,
	a_astaff = true,
}

function PLUGIN:OnCharacterPermaKilled(character, time)
	local client = character:getPlayer()
	local faction = nut.faction.indices[character:getFaction()]

	if self.TransferWhitelist[faction.uniqueID] then
		return
	end

	local lastPK = client:getNutData("lastPK", {})
	lastPK[faction.uniqueID] = os.time()

	client:setNutData("lastPK", lastPK) -- just to make sure, probably only useful when the default is returned from getNutData
	client:saveNutData()
end

function PLUGIN:PreCharacterDelete(id)
	local character = nut.char.loaded[id]
	local client = character:getPlayer()
	local faction = nut.faction.indices[character:getFaction()]
	local lastPK = client:getNutData("lastPK", {})
	
	if lastPK[faction.uniqueID] and lastPK[faction.uniqueID] + 604800 > os.time() then return false end
	if character:getData("banned") then return false end

	if self.TransferWhitelist[faction.uniqueID] then
		return
	end

	local lastPK = client:getNutData("lastPK", {})
	lastPK[faction.uniqueID] = os.time()

	client:setNutData("lastPK", lastPK) -- just to make sure, probably only useful when the default is returned from getNutData
	client:saveNutData()
end

function PLUGIN:CanCharacterBeTransfered(character, faction, oldFaction)
	if self.TransferWhitelist[faction.uniqueID] then
		return
	end

	local client = character:getPlayer()
	local lastPK = client:getNutData("lastPK", {})

	if lastPK[faction.uniqueID] and lastPK[faction.uniqueID] + 604800 > os.time() then
		return false, "This player has been PK'd from this faction or deleted a character in it less than seven days ago."
	end
end

if (CLIENT) then
	net.Receive("CriminalFacNotify", function()
		Derma_Query("You've been transferred into a criminal faction. Joining an illegal organization means accepting the realities of criminal life. \nYou will have the possibility of becoming rich and powerful beyond your wildest dreams, but this comes with the risk of being permanently killed, \nincluding by fellow faction members on orders of your boss. By proceeding you understand this.",
			"Criminal Faction Warning",
			"I understand and accept the risks.",
			function() 
			end, 
			"I changed my mind! Please reverse this.",
			function()
				RunConsoleCommand("sam", "asay", "Please transfer me back into Citizens. I do not want to be in a criminal faction.")
			end
		)
	end)
else
	util.AddNetworkString("CriminalFacNotify")
end

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

nut.command.add("plytransfer", {
	syntax = "<string name> <string faction>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[client:GetUserGroup()]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])
		local faction = nut.command.findFaction(client, table.concat(arguments, " ", 2))
		local character = target:getChar()

		if !faction then
			return
		end

		if (not IsValid(target) or not character) then
			return "@plyNotExist"
		end

		-- Find the specified faction.
		local oldFaction = nut.faction.indices[character:getFaction()]

		local canTransfer, message = hook.Run("CanCharacterBeTransfered", character, faction, oldFaction)
		if canTransfer == false then
			return message
		end

		-- Change to the new faction.
		target:getChar():setFaction(faction.index)
		if (faction.onTransfered) then
			faction:onTransfered(target, oldFaction)
		end
		hook.Run("CharacterFactionTransfered", character, oldFaction, faction)
		SAdmin:AddLog("Faction Transfers", client:Nick().." transferred "..target:Nick().. " "..target:SteamID().." ["..target:getChar():getID().."] from "..oldFaction.name.. " to "..faction.name, client:SteamID())
		if client != target then
			SAdmin:AddLog("Faction Transfers", target:Nick().." was transferred by "..client:Nick().. " "..client:SteamID().." ["..client:getChar():getID().."] from "..oldFaction.name.. " to "..faction.name, target:SteamID())
		end

		client:notify("You have transferred " .. target:Name() .. " to " .. faction.name)
		target:notify("You have been transferred to " .. faction.name .. " by " .. client:Name())
		if faction.criminal then
			net.Start("CriminalFacNotify")
			net.Send(target)
		end
	end
})
