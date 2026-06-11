local INVENTORY_TYPE_ID = "grid"
ITEM.name = "Small Box"
ITEM.desc = "small box."
ITEM.model = "models/nseven/cardboard_box02.mdl"
ITEM.width = 3
ITEM.height = 3
ITEM.isBag = true
ITEM.invWidth = 8
ITEM.invHeight = 8
ITEM.price = 1000
ITEM.permit = "permit_gen"
ITEM.category = "Storage"
ITEM.flag = "v"
ITEM.uniqueID = "smallbox"

--this is used to make checking for other backpacks in the inventory a little less more efficient
ITEM.otherBags = {
	pack = true,
	pack_alice = true,
	pack_enhanced = true,
	stor_suitcase = true,
	stor_briefcase = true
}