ITEM.name = "Defibrillator"
ITEM.desc = "A device used to restore a normal heartbeat by sending an electric pulse or shock to the heart."
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.category = "Medical"
ITEM.color = Color(232, 0, 0)
ITEM.quantity2 = 5

ITEM.useTime = 5
ITEM.useText = "begins to use a defibrillator on"

ITEM.targetOnly = true

ITEM.charges = true
ITEM.chargeReq = "battery_defib"

ITEM.restore = {
	["heart"] = 1000,
}