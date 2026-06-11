-- "gamemodes\\mafiarp\\plugins\\arccwsupport_diverge\\items\\ammo\\sh_nade_teargas.lua"

ITEM.name = "Tear Gas Grenade"
ITEM.class = "arccw_nade_teargas"
ITEM.desc = "Grenade which produces a large cloud of irritant gas used for riot control."
ITEM.category = "Weapons - Throwable"
ITEM.ammo = "arccw_nade_teargas"
ITEM.maxQuantity = 1
ITEM.exRender = true
ITEM.model = "models/weapons/w_eq_smokegrenade.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 200, 4.5),
	ang = Angle(0, 270, 0),
	fov = 2.75,
}