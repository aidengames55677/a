-- "gamemodes\\mafiarp\\plugins\\customitems\\items\\cigars\\sh_genovesecigar_1.lua"

ITEM.name = "Santino's Semplice Leggero"
ITEM.desc = "An affordable delight Santino's Semplice Leggero offers a light and approachable smoke. Wrapped in a Connecticut leaf, this cigar delivers a mild-bodied experience with nuances of toasted almond and a subtle hint of vanilla."
ITEM.model = "models/diverge/genovesecigars/cigar1.mdl"
ITEM.price = 2500
ITEM.category = "Custom Items"
ITEM.noSpawning = true

ITEM.functions.TakeOutCigar1 = {
	name = "Light Up & Smoke",
	onRun = function( item )
		local client = item.player
		nut.chat.send( client, "me", "takes out a cigar and lights it up." )
		client:Give( "genovesecigar_1" )
		client:SelectWeapon( "genovesecigar_1" )

		timer.Simple( 300, function()
			if IsValid( client ) and client:HasWeapon("genovesecigar_1") then
				client:StripWeapon( "genovesecigar_1" )
				nut.chat.send( client, "me", "finishes smoking and throws the cigar away." )
			end
		end )
	end,
    onCanRun = function( item )
        return item.uniqueID == "genovesecigar_1" and not item.entity
    end
}

