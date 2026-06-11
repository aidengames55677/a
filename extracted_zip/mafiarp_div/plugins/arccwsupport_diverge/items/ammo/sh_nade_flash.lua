-- "gamemodes\\mafiarp\\plugins\\arccwsupport_diverge\\items\\ammo\\sh_nade_flash.lua"

ITEM.name = "Stun Grenade"
ITEM.class = "arccw_nade_flash"
ITEM.desc = "Grenade designed to produce a loud bang accompanied with a bright flash, disorienting targets."
ITEM.category = "Weapons - Throwable"
ITEM.ammo = "arccw_nade_flash"
ITEM.maxQuantity = 1
ITEM.exRender = true
ITEM.model = "models/weapons/w_eq_flashbang.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 200, 4.5),
	ang = Angle(0, 270, 0),
	fov = 2.75,
}