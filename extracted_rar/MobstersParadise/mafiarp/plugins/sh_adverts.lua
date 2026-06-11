PLUGIN.name = "Advertising"
PLUGIN.author = "AngryBaldMan"
PLUGIN.desc = "Adds an advert command."

nut.chat.register("announcement", {
	onCanSay =  function(speaker, text)
		return speaker:IsAdmin()
	end,
	onCanHear = 1000000,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(255, 0, 250), " [Admin Announcement] ", color_white, text)
	end,
	prefix = {"/announce"}
})

nut.chat.register("advert", {
	onCanSay =  function(speaker, text)	
		if speaker:getChar():hasMoney(0) then
			speaker:getChar():takeMoney(0)
			speaker:notify("Your advertisement has been posted successfully.")
			return true
		else 
			speaker:notify("You lack sufficient funds to advertise.")
			return false 
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 238, 0), " [Advertisement by " .. speaker:Nick() .. "] ", color_white, text)
	end,
	prefix = {"/advertisement"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.chat.register("rumour", {
	onCanSay =  function(speaker, text)
		if speaker:Team() == FACTION_POLICE or speaker:Team() == FACTION_BANK then
			speaker:notify("You do not have the permissions to do this.")
			return false 
		end
		if speaker:getChar():hasMoney(50) then
			speaker:getChar():takeMoney(50)
			speaker:notify("$50 has been deducted from your account for illegal advertising.")
			return true
		else 
			speaker:notify("You lack sufficient funds to illegally advertise.")
			return false 
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 76, 0), " [Underground Advertisement] ", color_white, text)
	end,
	onCanHear = function(speaker, listener)
		return listener:Team() == FACTION_BUSINESS or listener:Team() == FACTION_EMT or listener:Team() == FACTION_FBI or listener:Team() == FACTION_MIAMIGOV or listener:Team() == FACTION_SWAT or listener:Team() == FACTION_POLICE or listener:Team() == FACTION_NEWS or listener:Team() == FACTION_ESTATE or listener:Team() == FACTION_PRISON or listener == speaker
	end,
	prefix = {"/rumour"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.chat.register("911", {
    onCanSay =  function(speaker, text)
        if speaker:Team() == FACTION_POLICE or speaker:Team() == FACTION_EMT then
            speaker:notify("Use /radiopd!")
            return false
        else
            return true
        end
    end,
    onChatAdd = function(speaker, text)
        chat.AddText( Color(255, 0, 0), "[911 Call from " .. speaker:Nick() .. "]", color_white, text)
    end,
    onCanHear = function(speaker, listener)
    	return listener:Team() == FACTION_POLICE or listener:Team() == FACTION_EMT or listener:Team() == FACTION_SWAT or speaker == listener
    end,
    prefix = {"/911"},
    noSpaceAfter = true,
    filter = "IC"
})

nut.chat.register("rpd", {
	onCanSay =  function(speaker, text)
		if speaker:Team() == FACTION_POLICE or speaker:Team() == FACTION_EMT or speaker:Team() == FACTION_SWAT then
			return true
		else
			speaker:notify("Only emergency services can access this channel!")
			return false
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(0, 0, 210), " [Emergency Services Radio] ", color_white, text, " - " .. speaker:Nick())
		speaker:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", math.random(50, 60), math.random(80, 120))
	end,
	onCanHear = function(speaker, listener)
		return listener:Team() == FACTION_POLICE or listener:Team() == FACTION_SWAT or listener:Team() == FACTION_FBI or listener:Team() == FACTION_EMT or speaker == listener
	end,
	prefix = {"/rpd"},
	noSpaceAfter = true,
	filter = "IC"
})

function PLUGIN:PlayerLoadedChar(client, id)
    client:notify('Welcome to Mobsters Paradise, if you need help getting started, use the /wiki command.')
end