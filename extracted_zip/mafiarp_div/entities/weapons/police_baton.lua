-- "gamemodes\\mafiarp\\entities\\weapons\\police_baton.lua"


AddCSLuaFile()

SWEP.PrintName = "Police Baton"
SWEP.Author = "nvc_dmn_ch"
SWEP.Purpose = "*bonk*"

SWEP.Slot = 0
SWEP.SlotPos = 5

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/police_baton.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_police_baton_plr.mdl" )
SWEP.ViewModelFOV = 59
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.IsAlwaysRaised = true

SWEP.DrawAmmo = false

SWEP.HitDistance = 48

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

local isItemEquipped = false
local drawHolstered = false



-- HOLSTERED WEAPON STUFF (BEGINS HERE)

--util.PrecacheModel( "models/weapons/w_police_baton.mdl" )
--local modelexample = ClientsideModel( "models/weapons/w_police_baton.mdl", RENDERGROUP_OPAQUE )
--modelexample:SetNoDraw( true )
--
--hook.Add( "PostPlayerDraw" , "manual_model_draw_example" , function( ply )
--	
--	
--	local offsetvec = Vector( -9.531, -3.421, -0.0315 )
--	local offsetang = Angle( 180.001, -98.525, -90.012 )
--	
--	local boneid = ply:LookupBone( "ValveBiped.Bip01_Pelvis" )
--	
--	if not boneid then
--		return
--	end
--	
--	local matrix = ply:GetBoneMatrix( boneid )
--	
--	if not matrix then 
--		return 
--	end
--	
--	if(drawHolstered == false || isItemEquipped == false) then
--		return
--	end
--	
--	local newpos, newang = LocalToWorld( offsetvec, offsetang, matrix:GetTranslation(), matrix:GetAngles() )
--	
--	
--	modelexample:SetPos( newpos )
--	modelexample:SetAngles( newang )
--	modelexample:SetupBones()
--	modelexample:DrawModel()
--end)

-- HOLSTERED WEAPON STUFF (ENDS HERE)


function SWEP:Initialize()

	self:SetHoldType( "melee" )

end

function SWEP:Holster( wep )
	drawHolstered = true
	return true
end


function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end

function SWEP:PrimaryAttack( right )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local anim = "misscenter" .. math.random( 1, 2 )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( SwingSound )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.2 )

	self:SetNextPrimaryFire( CurTime() + 0.9 )
	self:SetNextSecondaryFire( CurTime() + 0.9 )

end

function SWEP:SecondaryAttack()
	local owner = self.Owner
    local weaponanim = self.Weapon
	local numbertree = 150
    local velAng = owner:EyeAngles():Forward()

	owner:SetAnimation( PLAYER_ATTACK1 )
	local anim = "misscenter" .. math.random( 1, 2 )

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	self:EmitSound( SwingSound )
	self:UpdateNextIdle()
	self:SetNextPrimaryFire( CurTime() + 0.9 )
	self:SetNextSecondaryFire( CurTime() + 0.9 )

	owner:LagCompensation(true)
		local ent = owner:GetEyeTrace().Entity
	owner:LagCompensation(false)

	if CLIENT then return end
	if !ent:IsPlayer() then return end
    if not IsValid(ent) or (owner:GetPos():Distance(ent:GetPos()) > numbertree) then return end

    if ent or ent:IsPlayer() then
		ent:SetVelocity( velAng * 200 )
	end
end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 10 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )

		local amount = math.random(5, 20)

		if tr.Entity:Health() - amount <= 10 then
			dmginfo:SetDamage(0)
			tr.Entity:SetHealth(10)
		else
			dmginfo:SetDamage(amount)
		end
		
		dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 * scale + self.Owner:GetForward() * 9998 * scale )

		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )

		if !tr.Entity:IsFrozen() then
			tr.Entity:Freeze(true)
			timer.Simple(0.5, function()
				tr.Entity:Freeze(false)
			end)
		end
		SuppressHostEvents( self.Owner )
		hit = true

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
		end
	end

	if ( SERVER ) then
		
	end

	self.Owner:LagCompensation( false )

end

function SWEP:OnDrop()
	isItemEquipped = false
	--self:Remove()

end

function SWEP:Deploy()
	isItemEquipped = true;
	
	local speed = GetConVarNumber( "sv_defaultdeployspeed" )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )
	vm:SetPlaybackRate( speed )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()

	if ( SERVER ) then
		self:SetCombo( 0 )
	end

	return true

end

function SWEP:Think()
	drawHolstered = false
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle0" .. math.random( 1, 1 ) ) )

		self:UpdateNextIdle()

	end

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end

	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then

		self:SetCombo( 0 )

	end

end
