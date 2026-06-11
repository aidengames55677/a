local PLUGIN = PLUGIN





if (SERVER) then


	local playerMeta = FindMetaTable("Player")


	


	function playerMeta:notifyP(tx) -- helper func


		self:notify(tx)


		self:ChatPrint(tx)


	end


	


/////////////////////////////////////////////////////////////////////


///	                      Perma Flags


/////////////////////////////////////////////////////////////////////


	


	function playerMeta:getPermFlags()


		return self:getNutData("permflags", "")


	end





	function playerMeta:setPermFlags(val)


		self:setNutData("permflags", val or "")


		self:saveNutData()


	end





	function playerMeta:givePermFlags(flags)


		local curFlags = self:getPermFlags()


		for i=1, #flags do


			local flag = flags[i]


			if (!self:hasPermFlag(flag) && !self:hasFlagBlacklist(flag)) then


				curFlags = curFlags .. flag


			end


		end


		self:setPermFlags(curFlags)


		


		if (self.nutCharList) then


			for k,v in pairs(self.nutCharList) do


				local char = nut.char.loaded[v]


				if (char) then


					char:giveFlags(flags)


				end


			end


		end


	end





	function playerMeta:takePermFlags(flags)


		local curFlags = self:getPermFlags()


		


		for i=1, #flags do


			curFlags = curFlags:gsub(flags[i], "")


		end


		


		self:setPermFlags(curFlags)


		


		if (self.nutCharList) then


			for k,v in pairs(self.nutCharList) do


				local char = nut.char.loaded[v]


				if (char) then


					char:takeFlags(flags)


				end


			end


		end


	end





	function playerMeta:hasPermFlag(flag)


		if (!flag || #flag != 1) then return end


		


		local curFlags = self:getPermFlags()


		


		for i=1, #curFlags do


			if (curFlags[i] == flag) then


				return true


			end


		end


		


		return false


	end





	hook.Add("OnCharCreated", "permflags::OnCharCreated", function(client, char)


		local permFlags = client:getPermFlags()


		if (permFlags && #permFlags > 0) then


			char:giveFlags(permFlags)


		end


	end)


	


/////////////////////////////////////////////////////////////////////


///	                      Blacklist


/////////////////////////////////////////////////////////////////////








	


	function playerMeta:getFlagBlacklist()


		return self:getNutData("flagblacklist", "")


	end


	


	function playerMeta:setFlagBlacklist(flags)


		self:setNutData("flagblacklist", flags)


		self:saveNutData()


	end


	


	function playerMeta:addFlagBlacklist(flags, blacklistInfo)


		local curBlack = self:getFlagBlacklist()


		for i=1, #flags do


			local curFlag = flags[i]


			if (!self:hasFlagBlacklist(curFlag)) then


				curBlack = curBlack .. flags[i]


			end


		end


		self:setFlagBlacklist(curBlack)


		self:takePermFlags(flags)


		


		if (blacklistInfo) then


			local blacklistLog = self:getNutData("flagblacklistlog", {})


			blacklistInfo.starttime = os.time()


			blacklistInfo.time = blacklistInfo.time or 0


			blacklistInfo.endtime = blacklistInfo.time <= 0 and 0 or (os.time() + blacklistInfo.time)


			blacklistInfo.admin = blacklistInfo.admin or "N/A"


			blacklistInfo.adminsteam = blacklistInfo.adminsteam or "N/A"


			blacklistInfo.active = true


			blacklistInfo.flags = blacklistInfo.flags or ""


			blacklistInfo.reason = blacklistInfo.reason or "N/A"


			


			table.insert(blacklistLog, blacklistInfo)


			self:setNutData("flagblacklistlog", blacklistLog)


			self:saveNutData()


		end


	end


	


	timer.Create("flagBlacklistTick", 10, 0, function()


		for k,v in pairs(player.GetAll()) do


			local blacklistLog = v:getNutData("flagblacklistlog")


			if (blacklistLog) then


				for m,bl in pairs(blacklistLog) do


					if (!bl.active && !bl.remove) then continue end


					if ((bl.endtime <= 0 || bl.endtime > os.time()) && !bl.remove) then continue end


					


					bl.active = false


					bl.remove = nil


					local flagBuffer = bl.flags


					for a,b in pairs(blacklistLog) do


						if (b != bl && b.active) then


							for i=1, #b.flags do


								flagBuffer = string.Replace(flagBuffer, b.flags[i], "")


							end


						end


					end


					


					v:removeFlagBlacklist(flagBuffer)


				end


			end


		end


	end)


	


	netstream.Hook("unflagblacklistRequest", function(ply, target, bid)


		if (!ply:IsAdmin()) then return end


		if (!IsValid(target)) then


			ply:notify("That target is no longer online")


			return


		end


		


		local bData = target:getNutData("flagblacklistlog", {})[bid]


		if (!bData) then


			ply:notify("Blacklist ID invalid")


			return


		end


		


		bData = target:getNutData("flagblacklistlog")


		bData[bid].remove = true


		target:setNutData("flagblacklistlog", bData)


		target:saveNutData()


		


		ply:notify("Target blacklist has been flagged for deactivation. It may take up to 10 seconds.")


	end)


	


	function playerMeta:removeFlagBlacklist(flags)


		local curBlack = self:getFlagBlacklist()


		for i=1, #flags do


			local curFlag = flags[i]


			curBlack = curBlack:gsub(curFlag, "")


		end


		self:setFlagBlacklist(curBlack)


	end


	


	function playerMeta:hasFlagBlacklist(flag)


		local flags = self:getFlagBlacklist()


		for i=1, #flags do


			if (flags[i] == flag) then return true end


		end


		return false


	end


	


	function playerMeta:hasAnyFlagBlacklist(flags)


		for i=1, #flags do


			if (self:hasFlagBlacklist(flags[i])) then return true end


		end


		return false


	end


	


end





/////////////////////////////////////////////////////////////////////


///	                      Perm Flag Commands


/////////////////////////////////////////////////////////////////////





nut.command.add("permflaggive", {


	adminOnly = true,


	syntax = "<string name> [string flags]",


	onRun = function(client, arguments)


		local target = nut.command.findPlayer(client, arguments[1])





		if (IsValid(target)) then


			local flags = arguments[2]


			if (!flags) then client:notify("No flags specified") return end


			


			if (target:hasAnyFlagBlacklist(flags)) then


				client:notifyP("Failed to give PermFlags. Player is blacklisted from '"..target:getFlagBlacklist().."'.")


				client:notifyP("Last reason for blacklist: "..target:getNutData("LastBlacklistReason", "N/A"))


				return


			end


			target:givePermFlags(flags)





			nut.util.notifyLocalized(client:Name() .. " has given PermFlags '"..flags.."' to " .. target:Name())


		end


	end


})





nut.command.add("permflagtake", {


	adminOnly = true,


	syntax = "<string name> [string flags]",


	onRun = function(client, arguments)


		local target = nut.command.findPlayer(client, arguments[1])





		if (IsValid(target)) then


			local flags = arguments[2]


			if (!flags) then client:notify("No flags specified") return end


			


			target:takePermFlags(flags)


			nut.util.notifyLocalized(client:Name() .. " has taken PermFlags '"..flags.."' from " .. target:Name())


		end


	end


})





nut.command.add("permflags", {


	adminOnly = true,


	syntax = "<string name>",


	onRun = function(client, arguments)


		local target = nut.command.findPlayer(client, arguments[1])





		if (IsValid(target) and target:getChar()) then


			client:notifyP("Their PermFlags are: '"..target:getPermFlags().."'")


		end


	end


})





/////////////////////////////////////////////////////////////////////


///	                      Blacklist Commands


/////////////////////////////////////////////////////////////////////


/*


	blacklistInfo.starttime = os.time()


	blacklistInfo.time = blacklistInfo.time or 0


	blacklistInfo.endtime = blacklistInfo.time <= 0 and 0 or (os.time() + blacklistInfo.time)


	blacklistInfo.admin = blacklistInfo.admin or "N/A"


	blacklistInfo.adminsteam = blacklistInfo.adminsteam or "N/A"


	blacklistInfo.active = true


	blacklistInfo.flags = blacklistInfo.flags or ""


	blacklistInfo.reason = blacklistInfo.reason or "N/A"


*/





nut.command.add("flagblacklist", {


	adminOnly = true,


	syntax = "<string name> <string flags> <number minutes> <string reason>",


	onRun = function(client, arguments)


		local target = nut.command.findPlayer(client, arguments[1])





		if (IsValid(target)) then


			if (#arguments < 4) then


				return "Invalid syntax"


			end


			


			if (!tonumber(arguments[3]) || tonumber(arguments[3]) < 0) then


				return "Blacklist time (minutes) must be a number. Invalid syntax"


			end


			


			


			local flags = arguments[2]


			local time = tonumber(arguments[3])


			local reason = table.concat(arguments, " ", 4)


			if (!flags) then client:notify("No flags specified") return end


			if (!reason) then client:notify("No reason specified") return end


			


			nut.util.notifyLocalized(client:Name() .. " has blacklisted " .. target:Name() .. " from '"..flags.."' flags " .. (time == 0 and "permanently" or " for " .. time .. " minute(s)."))


			


			local blInfo = {


				time = time*60,


				admin = client:SteamName(),


				adminsteam = client:SteamID(),


				flags = flags,


				reason = reason


			}


			target:addFlagBlacklist(flags, blInfo)


			target:setNutData("LastBlacklistReason", reason)


			target:saveNutData()


		end


	end


})





nut.command.add("flagunblacklist", {


	adminOnly = true,


	syntax = "<string name> [string flags]",


	onRun = function(client, arguments)


		local target = nut.command.findPlayer(client, arguments[1])





		if (IsValid(target)) then


			local flags = arguments[2]


			if (!flags) then client:notify("No flags specified") return end


			


			if (!target:hasAnyFlagBlacklist(flags)) then


				client:notify("They aren't blacklisted from any of those flags.")


			end


			


			nut.util.notifyLocalized(client:Name() .. " has lifted " .. target:Name() .. "'s '"..flags.."' flag blacklists")


			target:removeFlagBlacklist(flags)


		end


	end


})





nut.command.add("flagblacklists", {


	adminOnly = true,


	syntax = "<string name>",


	onRun = function(client, arguments)


		local target = nut.command.findPlayer(client, arguments[1])





		if (IsValid(target) and target:getChar()) then


			local blacklists = target:getFlagBlacklist() or ""


			local blacklistLog = target:getNutData("flagblacklistlog", {})


			netstream.Start(client, "openBlacklistLog", target, blacklists, blacklistLog)


		end


	end


})





if (CLIENT) then


	netstream.Hook("openBlacklistLog", function(target, blacklists, blacklistLog)


		local fr = vgui.Create("DFrame")


		fr:SetSize(700, 500)


		fr:Center()


		fr:MakePopup()


		fr:SetTitle(target:Nick() .. " (" .. target:SteamID() .. ")'s Blacklists")


		


		local blText = "N/A"


		if (blacklists && blacklists != "") then


			blText = blacklists


		end


		


		local label = vgui.Create("DLabel", fr)


		label:SetPos(5, 29)


		label:SetText("Current Blacklists: " .. blText)


		label:SizeToContents()


		label:SetFont("nutBigFont")


		label:SizeToContents()


		


		label = vgui.Create("DLabel", fr)


		label:SetPos(5, 29 + 16*3)


		label:SetText("!NOTE! Do not use /flagunblacklist for logged blacklists. Use Deactive-Blacklist instead!\nAll times are in your Local Timezone!")


		label:SizeToContents()


		label:SetTextColor(Color(255, 0, 0))


		


		local listView = vgui.Create("DListView", fr)


		listView:SetPos(5, 110)


		listView:SetSize(690, 335)


		listView:AddColumn("Timestamp (Local)")


		listView:AddColumn("Active?")


		listView:AddColumn("Unblacklist Time")


		listView:AddColumn("Blacklist Length")


		listView:AddColumn("Flags")


		listView:AddColumn("AdminSteam")


		listView:AddColumn("Admin")


		listView:AddColumn("Reason")


		


		local unbanButton = vgui.Create("DButton", fr)


		unbanButton:SetPos(5, 448)


		unbanButton:SetWidth(690)


		unbanButton:SetText("Deactive Selected Blacklist (Unblacklist)")


		unbanButton:SetSkin("Default")


		unbanButton.DoClick = function()


			if (IsValid(listView:GetSelected()[1])) then


				netstream.Start("unflagblacklistRequest", target, listView:GetSelected()[1].bID)


			end


		end


		


		local printButton = vgui.Create("DButton", fr)


		printButton:SetPos(5, 473)


		printButton:SetWidth(690)


		printButton:SetText("Print Selected Blacklist To Console")


		printButton:SetSkin("Default")


		printButton.DoClick = function()


			if (IsValid(listView:GetSelected()[1])) then


				print(listView:GetSelected()[1].printData)


			end


		end


		for k,v in pairs(blacklistLog) do


			v.bID = k


		end


		


		table.sort(blacklistLog, function(a, b)


			return a.starttime > b.starttime


		end)


		


		for k,v in pairs(blacklistLog) do


			local ln = listView:AddLine(os.date("%d/%m/%Y %H:%M:%S", v.starttime), v.active and "Yes" or "No", v.endtime != 0 and os.date("%d/%m/%Y %H:%M:%S", v.endtime) or "Never", v.time != 0 and string.NiceTime(v.time) or "Perm", v.flags, v.adminsteam, v.admin, v.reason)


			if (v.active) then


				ln.OldPaint = ln.Paint


				ln.Paint = function(pnl, w, h)


					pnl:OldPaint(w, h)


					surface.SetDrawColor(255, 0, 0, 100)


					surface.DrawRect(0, 0, w, h)


				end


			end


			ln.bID = v.bID


			ln.printData = target:Nick() .. " [" .. target:SteamID() .. "] Blacklist ID " .. v.bID .. 


				"\nStart: " .. os.date("%d/%m/%Y %H:%M:%S", v.starttime) .. "\n" .. "Active: " .. (v.active and "Yes" or "No") ..


				"\nEnd Time: " .. (v.endtime != 0 and os.date("%d/%m/%Y %H:%M:%S", v.endtime) or "Never") ..


				"\nLength: " .. (v.time != 0 and string.NiceTime(v.time) or "Perm") ..


				"\nFlags: " .. v.flags .. 


				"\nAdminSteam: " .. v.adminsteam ..


				"\nAdmin: " .. v.admin ..


				"\nReason: " .. v.reason


		end


	end)


end





/////////////////////////////////////////////////////////////////////


///	                      Misc


/////////////////////////////////////////////////////////////////////





nut.command.add("flags", {


	adminOnly = true,


	syntax = "<string name>",


	onRun = function(client, arguments)


		local target = nut.command.findPlayer(client, arguments[1])





		if (IsValid(target) and target:getChar()) then


			client:notifyP("Their character flags are: '"..target:getChar():getFlags().."'")


		end


	end


})








/////////////////////////////////////////////////////////////////////


///	                      One-Time Give VIP Perm Flags


/////////////////////////////////////////////////////////////////////


if (SERVER) then


	function PermFlags_ExecuteOneTimeVIPGive()


		print("[!] Performing one-time Give All VIPs Perm Flags command")


		local ranks_to_give = { ["vip"] = true }


		local give_flags = "pet"


		local OnlineVIPs = {}


		for k,v in pairs(player.GetAll()) do


			if (ranks_to_give[v:GetUserGroup()]) then


				v:givePermFlags(give_flags)


				OnlineVIPs[v:SteamID()] = true


				v:ChatPrint("You have automatically been given permanent '"..give_flags.."' due to being a VIP. All existing and new characters will automatically have these flags applied.")


			end


		end


		local SuccessCount=0


		local ErrorCount=0


		for k,v in pairs(ULib.ucl.users) do


			if (ranks_to_give[v.group] && !OnlineVIPs[k]) then


				local steam64 = util.SteamIDTo64(k)


				local res = sql.Query("SELECT _data FROM nut_players WHERE _steamID="..steam64) 


				if (res == false) then


					print("[!] SQL Error: " .. sql.LastError())


					ErrorCount = ErrorCount + 1


				elseif (res != nil) then


					local dataTbl = util.JSONToTable(res[1]._data or "{}")


					if (!dataTbl || type(dataTbl) != "table") then


						print("[!] Error trying to retrieve dataTbl! SteamID: "..k..", data: " .. (res[1]._data or "nil"))


						ErrorCount = ErrorCount + 1


					else


						dataTbl.permflags = dataTbl.permflags or ""


						for i=1, #give_flags do


							local iterFlag = give_flags[i]


							if (!dataTbl.permflags:find(iterFlag)) then


								dataTbl.permflags = dataTbl.permflags .. iterFlag


							end


						end


						dataTbl = util.TableToJSON(dataTbl)


						local updateQuery = sql.Query("UPDATE nut_players SET _data="..sql.SQLStr(dataTbl).." WHERE _steamID="..steam64)


						if (updateQuery == false) then


							print("[!] SQL Update Error: " .. sql.LastError())


							ErrorCount = ErrorCount + 1


						else


							SuccessCount = SuccessCount + 1


						end


					end


				end


			end


		end


		print("[!] Done. ErrorCount: " .. ErrorCount .. ", SuccessCount: " .. SuccessCount)


	end


end
