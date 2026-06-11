-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_suitpants2.lua"

ITEM.name = "Suit Pants (Navy)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/singlebuttonedsuitpants.mdl",
		Bodygroups = {
            {"lower", 1}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = false
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50