-- "gamemodes\\mafiarp\\plugins\\medical\\items\\medical\\sh_firstaidkit.lua"

ITEM.name = "First Aid Kit"
ITEM.desc = "First Aid Kit."
ITEM.model = "models/illusion/eftcontainers/ifak.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.category = "Medical"
ITEM.color = Color(232, 0, 0)
ITEM.quantity2 = 1

ITEM.useTime = 10
ITEM.useText = "begins to use a first aid kit"
ITEM.healAmount = 100

ITEM.injFix = {
	"bleeding",
}