-- "gamemodes\\mafiarp\\plugins\\arccwsupport_diverge\\items\\ammo\\sh_nade_impact.lua"

ITEM.name = "Impact Grenade"
ITEM.class = "arccw_nade_impact"
ITEM.desc = "Fragmentation grenade that explodes on impact."
ITEM.category = "Weapons - Throwable"
ITEM.ammo = "arccw_nade_impact"
ITEM.maxQuantity = 1
ITEM.exRender = true
ITEM.model = "models/weapons/arccw/w_nade_impact.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0.125, 200, 1),
	ang = Angle(0, 270, 45),
	fov = 3,
}