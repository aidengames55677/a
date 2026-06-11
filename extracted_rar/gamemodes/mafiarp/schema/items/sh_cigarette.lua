ITEM.name = "Cigarette"
ITEM.desc = "A narrow cylinder containing tobacco, rolled into thin paper for smoking."
--ITEM.model = "models/jellik/cigarette.mdl"
ITEM.model = "models/mordeciga/mordes/oldcigshib.mdl"
ITEM.uniqueid = "cigarette"
ITEM.category = "Drugs"

ITEM.functions.TakeOutCig = {
	name = "Light Up & Smoke",
	onRun = function(item)
		local client = item.player
		nut.chat.send(client, "me", "takes out a cigarette and lights it up.")
		client:Give("weapon_ciga")
		client:SelectWeapon("weapon_ciga")
		timer.Create("Cig_" ..client:UniqueID(), 2, 0, function()
			if (IsValid(client) and client:GetActiveWeapon():GetClass() ~= "weapon_ciga") then
				client:StripWeapon("weapon_ciga")
				nut.chat.send(client, "me", "finishes cigarette and stomps it out.")
				timer.Remove("Cig_" ..client:UniqueID())
			end
		end)
	end
}

