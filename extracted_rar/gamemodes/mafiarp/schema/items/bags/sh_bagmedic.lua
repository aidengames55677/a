local INVENTORY_TYPE_ID = "grid"
ITEM.name = "Medical Bag"
ITEM.desc = "A Medical Bag for Medical Personnel."
ITEM.model = "models/nseven/cardboard_box02.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.isBag = true
ITEM.permit = "permit_med"
ITEM.invWidth = 7
ITEM.invHeight = 7
ITEM.price = 250
ITEM.category = "Storage"
ITEM.flag = "v"
ITEM.uniqueID = "medbag"

--this is used to make checking for other backpacks in the inventory a little less more efficient
ITEM.otherBags = {
	pack = true,
	pack_alice = true,
	pack_enhanced = true,
	stor_suitcase = true,
	stor_briefcase = true
}