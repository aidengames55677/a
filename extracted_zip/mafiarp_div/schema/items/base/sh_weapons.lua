-- "gamemodes\\mafiarp\\schema\\items\\base\\sh_weapons.lua"

ITEM.name = "Weapon"
ITEM.desc = "A Weapon."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isWeapon = true
ITEM.weaponCategory = "sidearm"	

function ITEM:getDesc()
	if self:getData("SerialNumber_Scratched") then
		return self.desc.."\nSerial Number: [REDACTED]"
	end

	if !self:getData( "SerialNumber_Scratched") then
		return self.desc.."\nSerial Number: "..self:getID()
	end
end

-- Inventory drawing
if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.

ITEM:hook("drop", function(item)
	if (IsValid(item.player.nutRagdoll) || (item.player.canDropWeapons && item.player.canDropWeapons > SysTime())) then
		item.player:notify("You cannot do this while ragdolled.")
		return false
	end

	if item:getData("equip") then return false end

	if (item:getData("equip")) then
		item:setData("equip", nil)

		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon = item.player.carryWeapons[item.weaponCategory]
		
		if (!IsValid(weapon)) then
			weapon = item.player:GetWeapon(item.class)
		end

		if (IsValid(weapon)) then
			item:setData("ammo", weapon:Clip1())

			item.player:StripWeapon(item.class)
			item.player.carryWeapons[item.weaponCategory] = nil
			item.player:EmitSound("items/ammo_pickup.wav", 80)
		end
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
		local ply = item.player
		if (IsValid(item.player.nutRagdoll) || (item.player.canDropWeapons && item.player.canDropWeapons > SysTime())) then
			item.player:notify("You cannot do this while ragdolled.")
			return false
		end

		if ply.LastDamaged and ply.LastDamaged > CurTime() - 15 then
			ply:notify( "You dealt damage too soon to unequip this weapon. Please wait " .. math.Round( ply.LastDamaged - ( CurTime() - 15 ) ) .. " more seconds." )
			return false
		end
		
		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon = item.player.carryWeapons[item.weaponCategory]

		if (!weapon or !IsValid(weapon)) then
			weapon = item.player:GetWeapon(item.class)	
		end

		if (weapon and weapon:IsValid()) then
			item:setData("ammo", weapon:Clip1())
		
			item.player:StripWeapon(item.class)
		else
			print(Format("[Nutscript] Weapon %s does not exist!", item.class))
		end

		item.player:EmitSound("items/ammo_pickup.wav", 80)
		item.player.carryWeapons[item.weaponCategory] = nil
		if item.player.surrender then
			item.player.surrender[item.class] = nil
		end

		item:setData("equip", nil)

		if (item.onUnequipWeapon) then
			item:onUnequipWeapon(client, weapon)
		end

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true and nut.inventory.instances[item.invID] == item.player:getChar():getInv())
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		if (IsValid(item.player.nutRagdoll) || (item.player.canDropWeapons && item.player.canDropWeapons > SysTime())) then
			item.player:notify("You cannot do this while ragdolled.")
			return false
		end
		
		local client = item.player
		local items = client:getChar():getInv():getItems()

		if (item.invID != client:getChar():getInv():getID()) then
			client:notify("The weapon must be in your direct inventory!")
			return false
		end
		
		client.carryWeapons = client.carryWeapons or {}
		
		for k, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = nut.item.instances[v.id]
				
				if (!itemTable) then
					client:notifyLocalized("tellAdmin", "wid!xt")

					return false
				else
					if (itemTable.isWeapon and client.carryWeapons[item.weaponCategory] and itemTable:getData("equip")) then
						client:notifyLocalized("weaponSlotFilled")

						return false
					end
				end
			end
		end
		
		if (client:HasWeapon(item.class)) then
			client:StripWeapon(item.class)
		end

		local weapon = client:Give(item.class)

		if (IsValid(weapon)) then
			client.carryWeapons[item.weaponCategory] = weapon
			client:SelectWeapon("nut_keys")
			--[[timer.Simple(0.1, function()
				client:SelectWeapon(weapon:GetClass())
				client:SetActiveWeapon(weapon)
			end)--]]
			client:EmitSound("items/ammo_pickup.wav", 80)

			-- Remove default given ammo.
			if (client:GetAmmoCount(weapon:GetPrimaryAmmoType()) == weapon:Clip1() and item:getData("ammo", 0) == 0) then
				client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			end
			item:setData("equip", true)
			SerialNumbers:WeaponEquipped( client, item )

			weapon:SetClip1(item:getData("ammo", 0))

			if (item.onEquipWeapon) then
				item:onEquipWeapon(client, weapon)
			end
		else
			print(Format("[Nutscript] Weapon %s does not exist!", item.class))
		end

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") != true and nut.inventory.instances[item.invID] == item.player:getChar():getInv())
	end
}

ITEM.functions.zcopy = {
	name = "Copy Serial Number",
	onRun = function(item)
		local ply = item.player
		ply:SendLua([[SetClipboardText(]]..item:getID()..[[)]])
		ply:ChatPrint("Number copied to clipboard.")
		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) && !item:getData( "SerialNumber_Scratched")
	end,
}

function ITEM:onCanBeTransfered( oldInventory, newInventory )
	if ( newInventory and self:getData( "equip" ) ) then
		return false
	end
	
	local ply = (newInventory and oldInventory) and (newInventory ~= oldInventory) and (oldInventory:getData( "char" ) and oldInventory:getData( "char" ) ~= 0 ) and nut.char.loaded[oldInventory:getData( "char" )]:getPlayer()
	if ply and ply.LastDamaged and ply.LastDamaged > CurTime() - 120 then
		ply:notify( "You dealt damage too soon to move this weapon. Please wait " .. math.Round( ply.LastDamaged - ( CurTime() - 120 ) ) .. " more seconds." )
		return false
	end

	return true
end

function ITEM:onLoadout()
	if (self:getData("equip")) then
		local client = self.player
		client.carryWeapons = client.carryWeapons or {}

		local weapon = client:Give(self.class)

		if (IsValid(weapon)) then
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			client.carryWeapons[self.weaponCategory] = weapon

			weapon:SetClip1(self:getData("ammo", 0))
		else
			print(Format("[Nutscript] Weapon %s does not exist!", self.class))
		end
	end
end

function ITEM:onSave()
	local weapon = self.player:GetWeapon(self.class)

	if (IsValid(weapon)) then
		self:setData("ammo", weapon:Clip1())
	end
end

HOLSTER_DRAWINFO = HOLSTER_DRAWINFO or {}
HOLSTER_DRAWINFO_BACKUP = HOLSTER_DRAWINFO_BACKUP or {}
-- Called after the item is registered into the item tables.
function ITEM:onRegistered()
	if (self.holsterDrawInfo) then
		HOLSTER_DRAWINFO[self.class] = self.holsterDrawInfo
		HOLSTER_DRAWINFO_BACKUP[self.class] = self.holsterDrawInfo
	end
end

hook.Add("PlayerDeath", "nutStripClip", function(client)
	client.carryWeapons = {}

	for k, v in pairs(client:getChar():getInv():getItems()) do
		if (v.isWeapon and v:getData("equip")) then
			v:setData("ammo", nil)
		end
	end
end)

function ITEM:onRemoved()
	local inv = nut.item.inventories[self.invID]
	if (inv) then
		local receivers = inv.getRecipients and inv:getRecipients()

		for _,receiver in ipairs(receivers) do
			if (IsValid(receiver) and receiver:IsPlayer()) then
				local weapon = receiver:GetWeapon(self.class)

				if (IsValid(weapon)) then
					if receiver.nutRestrictWeps then
						table.RemoveByValue(receiver.nutRestrictWeps, self.class)
					end

					receiver.carryWeapons[self.weaponCategory] = nil
					receiver:StripWeapon(self.class)
					break
				end
			end
		end
	end
end
