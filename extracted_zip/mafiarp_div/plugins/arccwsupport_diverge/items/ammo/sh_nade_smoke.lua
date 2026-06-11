-- "gamemodes\\mafiarp\\plugins\\arccwsupport_diverge\\items\\ammo\\sh_nade_smoke.lua"

ITEM.name = "M18 Smoke Grenade"
ITEM.class = "arccw_nade_smoke"
ITEM.desc = "Grenade which produces a wide smokescreen for obscuring movement on the battlefield. Smoke comes out in a ring, allowing for a small area of visibility in the center."
ITEM.category = "Weapons - Throwable"
ITEM.ammo = "arccw_nade_smoke"
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