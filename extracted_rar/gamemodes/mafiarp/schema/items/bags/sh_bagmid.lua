local INVENTORY_TYPE_ID = "grid"
ITEM.name = "Brief Case"
ITEM.desc = "A Brief Case."
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.isBag = true
ITEM.permit = "permit_gen"
ITEM.invWidth = 4
ITEM.invHeight = 4
ITEM.price = 350
ITEM.category = "Storage"
ITEM.flag = "v"
ITEM.uniqueID = "midbag"

--this is used to make checking for other backpacks in the inventory a little less more efficient
ITEM.otherBags = {
	pack = true,
	pack_alice = true,
	pack_enhanced = true,
	stor_suitcase = true,
	stor_briefcase = true
}