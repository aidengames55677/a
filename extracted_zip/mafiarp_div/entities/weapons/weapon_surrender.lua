-- "gamemodes\\mafiarp\\entities\\weapons\\weapon_surrender.lua"

AddCSLuaFile()

SWEP.PrintName = "Surrender"
SWEP.Author = "damiankil1999"
SWEP.Purpose = ""

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Spawnable = false

SWEP.Category = "NutScript"

SWEP.ViewModel = Model( "" )
SWEP.WorldModel = Model("")
SWEP.ViewModelFOV = 55
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.IsAlwaysRaised = false

SWEP.HitDistance = 125

function SWEP:Deploy()
	local Owner = self:GetOwner()

	for k,v in pairs(nut.plugin.list.animations.Surrender) do
		local bone = Owner:LookupBone(k)
		if bone then
			Owner:ManipulateBoneAngles(bone, v)
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		draw.SimpleTextOutlined("You have surrendered! Press F7 to lower your hands", "nutBigFont", ScrW() * 0.5, ScrH() * 0.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	end
end
