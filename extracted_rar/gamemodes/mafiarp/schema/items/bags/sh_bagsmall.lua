local INVENTORY_TYPE_ID = "grid"
ITEM.name = "Small Bag"
ITEM.desc = "A small bag."
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.permit = "permit_gen"
ITEM.isBag = true
ITEM.invWidth = 2
ITEM.invHeight = 2
ITEM.price = 150
ITEM.category = "Storage"
ITEM.flag = "v"
ITEM.uniqueID = "smallbag"

--this is used to make checking for other backpacks in the inventory a little less more efficient
ITEM.otherBags = {
	pack = true,
	pack_alice = true,
	pack_enhanced = true,
	stor_suitcase = true,
	stor_briefcase = true
}