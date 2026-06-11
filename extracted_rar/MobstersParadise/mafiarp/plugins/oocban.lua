local PLUGIN = PLUGIN
PLUGIN.name = "OOC Bans"
PLUGIN.author = "It's A Narco"
PLUGIN.desc = "An OOC banlist."

PLUGIN.oocBans = PLUGIN.oocBans or {}

--saves the bans
function PLUGIN:SaveData()
	self:setData(self.oocBans)
end

--loads the bans
function PLUGIN:LoadData()
	self.oocBans = self:getData()
end

nut.command.add("banooc", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]) or client	

		if(target) then
			PLUGIN.oocBans[target:SteamID64()] = true
			client:notify(target:Name().. " has been banned from OOC.")
		else
			client:notify("Invalid target.")
		end	
	end
})

nut.command.add("unbanooc", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1]) or client	
		if(target) then
			PLUGIN.oocBans[target:SteamID64()] = nil
			client:notify(target:Name().. " has been unbanned from OOC.")
		end	
	end
})

-- Out of character.
nut.chat.register("ooc", {
	onCanSay =  function(speaker, text)
		local delay = nut.config.get("oocDelay", 10)
		
		if (PLUGIN.oocBans[speaker:SteamID64()]) then
			return false
		end

		if(!speaker:IsAdmin()) then
			-- Only need to check the time if they have spoken in OOC chat before.
			if (delay > 0 and speaker.nutLastOOC) then
				local lastOOC = CurTime() - speaker.nutLastOOC

				-- Use this method of checking time in case the oocDelay config changes.
				if (lastOOC <= delay) then
					speaker:notifyLocalized("oocDelay", delay - math.ceil(lastOOC))

					return false
				end
			end
		end

		-- Save the last time they spoke in OOC.
		speaker.nutLastOOC = CurTime()
	end,
	onChatAdd = function(speaker, text)
		local icon = "icon16/user.png"

		if (speaker:SteamID() == "STEAM_0:1:34930764") then
			icon = "icon16/script_gear.png"
		elseif (speaker:SteamID() == "STEAM_0:0:19814083") then
			icon = "icon16/gun.png"
		elseif (speaker:IsSuperAdmin()) then
			icon = "icon16/shield.png"
		elseif (speaker:IsAdmin()) then
			icon = "icon16/star.png"
		elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
			icon = "icon16/wrench.png"
		elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
			icon = "icon16/heart.png"
		end

		icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)
		
		chat.AddText(icon, Color(255, 50, 50), " [OOC] ", speaker, color_white, ": "..text)
	end,
	prefix = {"//", "/ooc"},
	noSpaceAfter = true,
	filter = "ooc"
})