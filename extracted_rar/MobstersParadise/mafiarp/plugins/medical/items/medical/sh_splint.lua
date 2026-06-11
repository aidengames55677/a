-- "gamemodes\\mafiarp\\plugins\\medical\\items\\medical\\sh_splint.lua"

ITEM.name = "Splint"
ITEM.desc = "A strip of rigid material used for supporting and immobilizing a damaged bone."
ITEM.model = "models/illusion/eftcontainers/splint.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.category = "Medical"
ITEM.color = Color(232, 0, 0)
ITEM.quantity2 = 1

ITEM.healAmount = 0
ITEM.useTime = 5
ITEM.useText = "begins to apply a splint"

ITEM.targetOnly = false

ITEM.injFix = {
	"legShot",
}