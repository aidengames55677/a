ITEM.name = "Bandages"
ITEM.desc = "A box of regular bandages used to stop or slow down bleeding."
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.category = "Medical"
ITEM.color = Color(232, 0, 0)
ITEM.quantity2 = 5

ITEM.useTime = 5
ITEM.useText = "begins to apply bandages to"

ITEM.injFix = {
	--[WOUND_BULLET] = 10,
	[2] = 10,
}