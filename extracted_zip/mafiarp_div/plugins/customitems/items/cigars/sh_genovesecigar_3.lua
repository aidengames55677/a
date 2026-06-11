-- "gamemodes\\mafiarp\\plugins\\customitems\\items\\cigars\\sh_genovesecigar_3.lua"

ITEM.name = "Canes Grandeur Opulento"
ITEM.desc = "An opulent and luxurious cigar for the aficionado who seeks the finest smoking experience. The Canes Grandeur Opulento features a rare aged wrapper, and its blend of Italian and Cuban fillers delivers a full-bodied, complex flavor profile with hints of espresso, leather, and a lingering sweetness."
ITEM.model = "models/diverge/genovesecigars/cigar3.mdl"
ITEM.price = 2500
ITEM.category = "Custom Items"
ITEM.noSpawning = true

ITEM.functions.TakeOutCigar3 = {
	name = "Light Up & Smoke",
	onRun = function( item )
		local client = item.player
		nut.chat.send( client, "me", "takes out a cigar and lights it up." )
		client:Give( "genovesecigar_3" )
		client:SelectWeapon( "genovesecigar_3" )

		timer.Simple( 900, function()
			if IsValid( client ) and client:HasWeapon("genovesecigar_3") then
				client:StripWeapon( "genovesecigar_3" )
				nut.chat.send( client, "me", "finishes smoking and throws the cigar away." )
			end
		end )
	end,
    onCanRun = function( item )
        return item.uniqueID == "genovesecigar_3" and not item.entity
    end
}

