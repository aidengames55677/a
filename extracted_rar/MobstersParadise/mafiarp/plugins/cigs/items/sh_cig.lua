ITEM.name = "Cigarette"
ITEM.desc = "A Cigarette."
ITEM.model = "models/mordeciga/mordes/oldcigshib.mdl"

ITEM.functions.TakeOutCig = {
	name = "Light Up & Smoke",
	onRun = function(item)
		local client = item.player
		nut.chat.send(client, "me", "takes out a cigarette and lights it up.")
		client:Give("weapon_ciga")
		client:SelectWeapon("weapon_ciga")
		timer.Simple(math.random(20,45), function() 
			client:StripWeapon("weapon_ciga")
			nut.chat.send(client, "me", "finishes his smoke and stomps it out.")
		end	)
	end
}

