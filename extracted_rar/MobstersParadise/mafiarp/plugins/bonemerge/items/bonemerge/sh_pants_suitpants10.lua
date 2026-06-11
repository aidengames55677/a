-- "gamemodes\\mafiarp\\plugins\\bonemerge\\items\\bonemerge\\sh_pants_suitpants10.lua"

ITEM.name = "Suit Pants (Blue)"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.isPendretti = true
ITEM.Bonemerge = {
    {
        Model = "models/brot/diverge/civilianclothing/80s/jacketblazerpants.mdl",
		Bodygroups = {
            {"lower", 2}
        },
    },
}
ITEM.RemoveLegs = true
ITEM.CanWearShoes = false
ITEM.gender = "male"
ITEM.slot = "pants"
ITEM.price = 50