-- "gamemodes\\mafiarp\\plugins\\customitems\\items\\cigars\\sh_genovesecigar_2.lua"

ITEM.name = "Barzini Riserva Toscano"
ITEM.desc = "A medium-priced cigar that boasts a well-balanced blend of Italian and Nicaraguan tobaccos. The Barzini Riserva Toscano is wrapped in a Habano leaf, offering a richer flavor profile with notes of leather, dark chocolate, and a subtle spice."
ITEM.model = "models/diverge/genovesecigars/cigar2.mdl"
ITEM.price = 2500
ITEM.category = "Custom Items"
ITEM.noSpawning = true

ITEM.functions.TakeOutCigar2 = {
	name = "Light Up & Smoke",
	onRun = function( item )
		local client = item.player
		nut.chat.send( client, "me", "takes out a cigar and lights it up." )
		client:Give( "genovesecigar_2" )
		client:SelectWeapon( "genovesecigar_2" )

		timer.Simple( 600, function()
			if IsValid( client ) and client:HasWeapon("genovesecigar_2") then
				client:StripWeapon( "genovesecigar_2" )
				nut.chat.send( client, "me", "finishes smoking and throws the cigar away." )
			end
		end )
	end,
    onCanRun = function( item )
        return item.uniqueID == "genovesecigar_2" and not item.entity
    end
}

