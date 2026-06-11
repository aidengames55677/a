-- "gamemodes\\mafiarp\\plugins\\tying\\sh_admincharsearch.lua"

local PLUGIN = PLUGIN
local globalRanks = {
	eventmanager = true,
	moderator = true,
	administrator = true,
	seasonedadministrator = true,
	senioradministrator = true,
	advisor = true,
	superadministrator = true,
	servermanager = true,
	headadministrator = true,
	communitymanager = true,
	founder = true,
}

PLUGIN.canSearcherAccessInv = function(inv, action, context)
	if IsValid(context.client) then
		local character = nut.char.loaded[inv:getData("char")]
		if !character then return end

		local owner = character:getPlayer()
		if !IsValid(owner) then return end

		local searcher = owner:getNetVar("searcher")

		if !context.client:getChar() then return end
		
		if owner:GetPos():DistToSqr(searcher:GetPos()) > (256*256) then return false end

		return (searcher == context.client) or context.client:getChar():getID() == inv:getData("char")
	end
end

PLUGIN.canSearcherViewInv = function(inv, action, context)
	if action == INV_REPLICATE and IsValid(context.client) then
		local character = nut.char.loaded[inv:getData("char")]
		if !character then return end

		local owner = character:getPlayer()
		if !IsValid(owner) then return end

		local searcher = owner:getNetVar("searcher")

		if !context.client:getChar() then return end
		
		if owner:GetPos():DistToSqr(searcher:GetPos()) > (256*256) then return false end

		return (searcher == context.client) or context.client:getChar():getID() == inv:getData("char")
	end
end

PLUGIN.canSearcherAccessItemBank = function(inv, action, context)
	if IsValid(context.client) then
		local character

		-- yuck as fuck
		for _,ply in ipairs(player.GetAll()) do
			local activeCharacter = ply.getChar and ply:getChar()

			if !activeCharacter then continue end

			if activeCharacter:getData("itemBankInvID") == inv:getID() then
				character = activeCharacter
			end
		end

		if !character then return end

		local owner = character:getPlayer()
		if !IsValid(owner) then return end

		local searcher = owner:getNetVar("searcher")

		if !context.client:getChar() then return end
		
		return (searcher == context.client) or context.client:getChar():getID() == inv:getData("char")
	end
end

if (SERVER) then
	function PLUGIN:searchPlayer(client, target, viewOnly, isAdmin)
		if (IsValid(target:getNetVar("searcher")) or IsValid(client.nutSearchTarget)) then
			return false
		end

		if (!target:getChar() or !target:getChar():getInv()) then
			return false
		end

		if isAdmin then
			client.nutAdminSearch = true
		end
		
		client.nutSearchTarget = target
		target:setNetVar("searcher", client)

		local inventory = target:getChar():getInv()
		if viewOnly then
			inventory:addAccessRule(self.canSearcherViewInv, 1)
		else
			inventory:addAccessRule(self.canSearcherAccessInv, 1)
		end
		inventory:sync(client)

		-- Show the inventory menu to the searcher.
		netstream.Start(client, "searchPly", target, target:getChar():getInv():getID())

		return true
	end

	function PLUGIN:searchPlayerItemBank(client, target)
		if (IsValid(target:getNetVar("searcher")) or IsValid(client.nutSearchTarget)) then
			return false
		end

		if !target:getChar() then return false end

		local inventory = nut.inventory.instances[target:getChar():getData("itemBankInvID")]

		if !inventory then return false end

		client.nutSearchTarget = target
		target:setNetVar("searcher", client)

		inventory:addAccessRule(self.canSearcherAccessItemBank, 1)
		inventory:sync(client)

		-- Show the inventory menu to the searcher.
		netstream.Start(client, "searchPly", target, inventory:getID())

		return true
	end

	function PLUGIN:CanPlayerInteractItem(client, action, item)
		if (IsValid(client:getNetVar("searcher"))) then
			return false
		end
	end

	netstream.Hook("searchExit", function(client, index)
		local target = client.nutSearchTarget

		if (IsValid(target) and target:getNetVar("searcher") == client) then
			local inventory = nut.inventory.instances[index]
			inventory:removeAccessRule(nut.plugin.list.tying.canSearcherAccessInv)
			inventory:removeAccessRule(nut.plugin.list.tying.canSearcherViewInv)
			inventory:removeAccessRule(nut.plugin.list.tying.canSearcherAccessItemBank)

			target:setNetVar("searcher", nil)
			client.nutSearchTarget = nil
			client.nutAdminSearch = nil
		end
	end)

	function PLUGIN:PlayerDisconnected(client)
		local target = client.nutSearchTarget
		if IsValid(target) && target:getNetVar("searcher") then
			local inventory = nut.inventory.instances[target:getChar():getInv():getID()]
			inventory:removeAccessRule(nut.plugin.list.tying.canSearcherAccessInv)
			inventory:removeAccessRule(nut.plugin.list.tying.canSearcherViewInv)
			inventory:removeAccessRule(nut.plugin.list.tying.canSearcherAccessItemBank)
			target:setNetVar("searcher", nil)
		end
	end

else
	function PLUGIN:CanPlayerViewInventory()
		if (IsValid(LocalPlayer():getNetVar("searcher"))) then
			return false
		end
	end

	netstream.Hook("searchPly", function(target, index)
		local inventory = nut.inventory.instances[index]

		if (!inventory) then
			return netstream.Start("searchExit", index)
		end

		local local_inv = nut.inventory.show(LocalPlayer():getChar():getInv())
		local remote_inv = nut.inventory.show(inventory)

		remote_inv:ShowCloseButton(true)
		remote_inv:SetTitle("Player's Inventory")
		remote_inv:MoveLeftOf(local_inv, 4)
		remote_inv.OnClose = function(this)
			if (IsValid(local_inv) and !IsValid(nut.gui.menu)) then
				local_inv:Remove()
			end

			netstream.Start("searchExit", index)
		end

		local oldClose = local_inv.OnClose
		local_inv.OnClose = function()
			if (IsValid(panel) and !IsValid(nut.gui.menu)) then
				panel:Remove()
			end

			netstream.Start("searchExit", index)
			local_inv.OnClose = oldClose
		end
	end)
end

nut.command.add("admincharsearch", {
	syntax = "<string target>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:IsPlayer()) then
			PLUGIN:searchPlayer(client, target, false, true)
		end
	end
})

nut.command.add("admincharbanksearch", {
	syntax = "<string target>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target) and target:IsPlayer()) then
			PLUGIN:searchPlayerItemBank(client, target)
		end
	end
})

nut.command.add("charsearch", {
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:getNetVar("restricted") and !client:getNetVar("restricted")) then
			if (target.DLastKeyPress or 0) <= SysTime() - 150 then 
				return "This player is AFK, you cannot search them!"
			end

			if target:getNetVar("cuffed") && !PLUGIN.PoliceCuffFactions[client:Team()] then 
				return "You can not search this person." 
			end
			
			client:EmitSound("npc/combine_soldier/gear5.wav", 100, 100)
			client:setAction("Reaching into pockets...", 2)
			target:setAction("You feel something in your pockets...", 2)
			client:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_PLACE)
			client:doStaredAction(target, function()	
				PLUGIN:searchPlayer(client, target)
				
				SAdmin:AddLog("Searching", client:Nick().." searched "..target:Nick().. " "..target:SteamID(), client:SteamID())
				SAdmin:AddLog("Searching", target:Nick().." was searched by "..client:Nick().. " "..client:SteamID(), target:SteamID())
				
				client:ConCommand("say /me reaches into tied persons pockets.")
				client:EmitSound("npc/combine_soldier/gear4.wav", 100, 100)
			end, 2, function()
				client:setAction()
				target:setAction()
			end)
		end
	end
})

nut.command.add("requestsearch", {
	onRun = function(client, arguments)
		if (client.LastSearchRequest or 0) > CurTime() - 30 then
			return "You can't send search requests this quickly!"
		end

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and !target:getNetVar("restricted") and !target.SearchRequested and !client.SearchRequested) then
			if (target.DLastKeyPress or 0) <= SysTime() - 150 then 
				return "This player is AFK, you cannot search them!"
			end

			net.Start("nutRequestSearch")
			net.Send(target)

			client:notify("Request to search sent.")

			target.SearchRequested = client
			client.SearchRequested = target

			client.LastSearchRequest = CurTime()

			timer.Simple(30, function()
				target.SearchRequested = nil
				client.SearchRequested = nil
			end)
		end
	end
})

if SERVER then
	util.AddNetworkString("nutApproveSearch")
	util.AddNetworkString("nutRequestSearch")

	local function nutApproveSearch(len, ply)
		local requester = ply.SearchRequested

		if !requester then return end
		if !requester.SearchRequested then return end

		local approveSearch = net.ReadBool()

		if !approveSearch then
			requester:notify("Player denied your request to view their inventory.")

			requester.SearchRequested = nil
			ply.SearchRequested = nil

			return
		end

		if requester:GetPos():DistToSqr(ply:GetPos()) > 250*250 then return end

		PLUGIN:searchPlayer(requester, ply, true)
		requester.SearchRequested = nil
		ply.SearchRequested = nil
	end
	net.Receive("nutApproveSearch", nutApproveSearch)
else
	local function nutRequestSearch(len)
		nut.util.notifQuery("A player is requesting to search your inventory.", "Accept", "Deny", true, NOT_CORRECT, function(code)
			if code == 1 then
				net.Start("nutApproveSearch")
					net.WriteBool(true)
				net.SendToServer()
			elseif code == 2 then
				net.Start("nutApproveSearch")
					net.WriteBool(false)
				net.SendToServer()
			end
		end)
	end
	net.Receive("nutRequestSearch", nutRequestSearch)
end