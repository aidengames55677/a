-- "gamemodes\\mafiarp\\entities\\weapons\\fishing_rod\\shared.lua"

-----------------------------------------------------
if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Fishing Rod"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Slot = 4
	SWEP.SlotPos = 3
end

SWEP.Author = "Diverge Networks"
SWEP.Contact = ""
SWEP.Purpose = "A tool used for catching fish."
SWEP.Instructions = "Left Click: Fish by aiming at nearby water."
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/PG_props/pg_weapons/pg_fishing_rod_v.mdl"
SWEP.WorldModel = "models/PG_props/pg_weapons/pg_fishing_rod_w.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
function SWEP:Initialize()
	self:SetHoldType("revolver")
	self:SetSkin(1)
end

function SWEP:PrimaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	if CLIENT then
		RunConsoleCommand("-attack")

		return
	end

	if SERVER then
		self.Owner:ConCommand("-attack")
	end

	self.Owner:EmitSound(Sound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav"))
	self.Owner:GetTable().LastFishingNotify = self.Owner:GetTable().LastFishingNotify or 0
	self.Owner.NextFishTime = self.Owner.NextFishTime or 0
	if CurTime() < self.Owner.NextFishTime then
		if self.Owner:GetTable().LastFishingNotify + 1 < CurTime() then
			self.Owner:notify("You've recently tried fishing! Please wait another " .. math.Round(self.Owner.NextFishTime - CurTime()) .. " seconds before trying again")
		end

		self.Owner:GetTable().LastFishingNotify = CurTime()

		return
	end

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 300)
	trace.mask = MASK_WATER or MASK_SOLID
	trace.filter = self.Owner
	local tr = util.TraceLine(trace)
	local ownerTrace = self.Owner:GetEyeTrace()
	--if ownerTrace.Entity:GetClass() != "pond" and ownerTrace.Entity:GetPos():Distance(self.Owner:GetPos()) < 200 then
	if tr.Hit and (tr.MatType == MAT_SLOSH or string.find(tr.HitTexture, "water")) then
		local data = {}
		local FishTime = math.random(20, 60)
		data.Entity = tr.Entity
		if self.Owner:getChar():getInv():hasItem("bait") then
			self.Owner:GetTable().FishingClicks = self.Owner:GetTable().FishingClicks or 0
			self.Owner:GetTable().FishingClicks = self.Owner:GetTable().FishingClicks + 1
			if self.Owner:GetTable().FishingClicks == 10 then
				self.Owner:SelectWeapon("hands")
				self.Owner:GetTable().FishingClicks = 0
			end

			self.Owner:Freeze(true)
			self.Owner:setAction(
				"Fishing",
				FishTime,
				function()
					self.Owner:Freeze(false)
					local items = self.Owner:getChar():getInv():getItemsOfType("bait")
					if #items == 0 then return end -- The player doesn't have that item, stopping
					local itemsDeleted = 0
					for k, v in pairs(items) do
						if itemsDeleted == 1 then break end
						v:remove()
						itemsDeleted = itemsDeleted + 1
					end

					local fish = {"fish_anchovy", "fish_pirahna", "fish_mussel", "fish_scallop", "fish_oyster", "fish_geoduck", "fish_tasmaniancrab", "fish_catfish", "fish_pufferfish", "fish_electriceel", "fish_lobster", "fish_humboltsquid", "fish_octopus", "fish_trout", "fish_bass", "fish_salmon", "fish_snappingturtles", "fish_carp", "fish_greenlandshark", "fish_bluemarlin",}
					local catch = "none"
					local chance = math.random(1, 100)
					for _, class in ipairs(fish) do
						local item = nut.item.list[class]
						if chance < item.rarity then
							catch = class
						end
					end

					local itemTable = nut.item.list[catch]
					if chance <= 2 then
						self.Owner:notify("Your fishing rod has broken!")
						for _, v in next, self.Owner:getChar():getInv():getItems() do
							local itemTable = nut.item.instances[v.id]
							if itemTable.uniqueID == "fishingrod" and itemTable:getData("equip") then
								itemTable:interact("Unequip", self.Owner)
								v:remove()
							end
						end

						self.Owner:StripWeapon("fishing_rod")

						return
					end

					if catch == "none" then
						self.Owner:notify("You have failed to catch anything.")
					else
						self.Owner:notify("You have caught a " .. itemTable.name .. "!")
						self.Owner:getChar():getInv():add(catch)
					end
				end
			)

			self.Owner.NextFishTime = CurTime() + FishTime
		else
			self.Owner:notify("You don't have any bait!")
		end
	else
		self.Owner:notify("You need to be aiming at nearby water to fish!")

		return
	end
	--end
	--if tr.MatType != MAT_SLOSH and !IsInWater(tr.HitPos + Vector(0,0,30)) then
	--if !IsInWater(tr.HitPos + Vector(0,0,30)) then
	--	DarkRP.notify(self.Owner, 1, 4, "You need to be aiming at nearby water to fish! (2)")
	--	return
	--end 
end

function SWEP:SecondaryAttack()
	return false
end