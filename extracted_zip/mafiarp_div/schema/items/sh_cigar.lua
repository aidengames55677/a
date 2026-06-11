-- "gamemodes\\mafiarp\\schema\\items\\sh_cigar.lua"

ITEM.name = "Cigar"
ITEM.desc = "A rolled bundle of dried and fermented tobacco leaves made to be smoked."
ITEM.model = "models/polievka/cigar.mdl"
ITEM.price = 2500
ITEM.category = "Drugs"

ITEM.functions.TakeOutCigar = {
	name = "Light Up & Smoke",
	onRun = function(item)
		local client = item.player
		nut.chat.send(client, "me", "takes out a cigar and lights it up.")
		client:Give("weapon_ciga_blat")
		client:SelectWeapon("weapon_ciga_blat")
		timer.Create("Cigar_" ..client:UniqueID(), 2, 0, function()
			if (client:GetActiveWeapon():GetClass() != "weapon_ciga_blat") then
				client:StripWeapon("weapon_ciga_blat")
				nut.chat.send(client, "me", "finishes cigar and stomps it out.")
				timer.Remove("Cigar_" ..client:UniqueID())
			end
		end)
	end
}

