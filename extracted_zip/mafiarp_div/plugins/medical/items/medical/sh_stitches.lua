-- "gamemodes\\mafiarp\\plugins\\medical\\items\\medical\\sh_stitches.lua"

ITEM.name = "Stitches"
ITEM.desc = "A box of stitches used to stitch open wounds closed."
ITEM.model = "models/illusion/eftcontainers/carmedkit.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.category = "Medical"
ITEM.color = Color(232, 0, 0)
ITEM.quantity2 = 5

ITEM.useTime = 10
ITEM.useText = "begins to apply stitches"
ITEM.healAmount = 0

ITEM.targetOnly = true

ITEM.injFix = {
	"bleeding",
}