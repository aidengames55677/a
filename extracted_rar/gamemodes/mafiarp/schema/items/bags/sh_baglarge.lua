local INVENTORY_TYPE_ID = "grid"
ITEM.name = "Large Brief Case"
ITEM.desc = "A Large Brief Case."
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.isBag = true
ITEM.permit = "permit_gen"
ITEM.invWidth = 5
ITEM.invHeight = 5
ITEM.price = 400
ITEM.category = "Storage"
ITEM.flag = "v"
ITEM.uniqueID = "largebag"

--this is used to make checking for other backpacks in the inventory a little less more efficient
ITEM.otherBags = {
	pack = true,
	pack_alice = true,
	pack_enhanced = true,
	stor_suitcase = true,
	stor_briefcase = true
}