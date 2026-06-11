-- "gamemodes\\mafiarp\\plugins\\arccwsupport_diverge\\items\\ammo\\sh_nade_gas.lua"

ITEM.name = "Gas Grenade"
ITEM.class = "arccw_nade_gas"
ITEM.desc = "Stick grenade which produces a large cloud of irritant gas that can be fatal in large doses."
ITEM.category = "Weapons - Throwable"
ITEM.ammo = "arccw_nade_gas"
ITEM.maxQuantity = 1
ITEM.exRender = true
ITEM.model = "models/weapons/arccw/w_nade_gas.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 200, 3.75),
	ang = Angle(0, 270, 45),
	fov = 4.5,
}