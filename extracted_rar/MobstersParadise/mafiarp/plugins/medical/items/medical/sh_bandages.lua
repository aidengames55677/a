-- "gamemodes\\mafiarp\\plugins\\medical\\items\\medical\\sh_bandages.lua"

ITEM.name = "Bandages"
ITEM.desc = "A box of regular bandages used to stop or slow down bleeding."
ITEM.model = "models/polievka/bandagetin01.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.category = "Medical"
ITEM.color = Color(232, 0, 0)
ITEM.quantity2 = 5

ITEM.useTime = 5
ITEM.useText = "begins to apply bandages"
ITEM.healAmount = 20

ITEM.injFix = {
	"bleeding",
}