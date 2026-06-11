AddCSLuaFile()
SWEP.PrintName = "Pickaxe"
SWEP.Author = "Dr. Towers"
SWEP.Instructions = "Primary attack: Swing - Secondary attack : Push"
SWEP.Category = "HL2 Melee Pack"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.ViewModel = Model("models/weapons/HL2meleepack/v_pickaxe.mdl")
SWEP.WorldModel = Model("models/weapons/HL2meleepack/w_pickaxe.mdl")
SWEP.ViewModelFOV = 67
SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.HitDistance = 40
SWEP.HitInclination = 0.4
SWEP.HitPushback = 1000
SWEP.HitRate = 1.35
SWEP.MinDamage = 10
SWEP.MaxDamage = 10
local SwingSound = Sound("WeaponFrag.Roll")
local HitSoundWorld = Sound("Canister.ImpactHard")
local HitSoundBody = Sound("Flesh.ImpactHard")
local PushSoundBody = Sound("Flesh.ImpactSoft")
function SWEP:Initialize()
	self:SetHoldType("melee2")
end

function SWEP:PrimaryAttack()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	local vm = self:GetOwner():GetViewModel()
	self:EmitSound(SwingSound)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.HitRate)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.HitRate)
	vm:SendViewModelMatchingSequence(vm:LookupSequence("misscenter1"))
	timer.Create(
		"hitdelay",
		0.4,
		1,
		function()
			self:Hitscan()
		end
	)

	timer.Start("hitdelay")
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.35)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1.0)
	self:EmitSound(SwingSound)
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("pushback"))
	local tr = util.TraceLine(
		{
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 1.5 * 40,
			filter = self:GetOwner(),
			mask = MASK_SHOT_HULL
		}
	)

	if tr.Hit then
		self:EmitSound(PushSoundBody)
		if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(), "npc") or string.find(tr.Entity:GetClass(), "prop_ragdoll") or string.find(tr.Entity:GetClass(), "prop_physics") then
			tr.Entity:SetVelocity(self:GetOwner():GetAimVector() * Vector(1, 1, 0) * 500)
		end
	end
end

function SWEP:OnDrop()
end

function SWEP:Hitscan()
	--This function calculate the trajectory
	for i = 0, 170 do
		local tr = util.TraceLine(
			{
				start = self:GetOwner():GetShootPos() - (self:GetOwner():EyeAngles():Up() * 10),
				endpos = (self:GetOwner():GetShootPos() - (self:GetOwner():EyeAngles():Up() * 10)) + (self:GetOwner():EyeAngles():Up() * (self.HitDistance * 0.7 * math.cos(math.rad(i)))) + (self:GetOwner():EyeAngles():Forward() * (self.HitDistance * 1.5 * math.sin(math.rad(i)))) + (self:GetOwner():EyeAngles():Right() * self.HitInclination * self.HitDistance * math.cos(math.rad(i))),
				filter = self:GetOwner(),
				mask = MASK_SHOT_HULL
			}
		)

		--This if shot the bullets
		if tr.Hit then
			local strikevector = (self:GetOwner():EyeAngles():Up() * (self.HitDistance * 0.5 * math.cos(math.rad(i)))) + (self:GetOwner():EyeAngles():Forward() * (self.HitDistance * 1.5 * math.sin(math.rad(i)))) + (self:GetOwner():EyeAngles():Right() * self.HitInclination * self.HitDistance * math.cos(math.rad(i)))
			bullet = {}
			bullet.Num = 1
			bullet.Src = self:GetOwner():GetShootPos() - (self:GetOwner():EyeAngles():Up() * 15)
			bullet.Dir = strikevector:GetNormalized()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force = 15
			bullet.Hullsize = 0
			bullet.Distance = self.HitDistance * 1.5
			bullet.Damage = 10
			self:GetOwner():FireBullets(bullet)
			--local vPoint = (self:GetOwner():GetShootPos() - (self:GetOwner():EyeAngles():Up() * 10))
			--local effectdata = EffectData()
			--effectdata:SetOrigin( vPoint )
			--util.Effect( "BloodImpact", effectdata )
			self:EmitSound(SwingSound)
			--vm:SendViewModelMatchingSequence( vm:LookupSequence( "hitcenter1" ) )
			if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(), "npc") or string.find(tr.Entity:GetClass(), "prop_ragdoll") then
				self:EmitSound(HitSoundBody)
				tr.Entity:SetVelocity(self:GetOwner():GetAimVector() * Vector(1, 1, 0) * self.HitPushback)
			else
				self:EmitSound(HitSoundWorld)
			end

			--if break
			break
			--if end
			--else vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
		end
	end
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("draw"))
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)

	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	timer.Remove("hitdelay")

	return true
end