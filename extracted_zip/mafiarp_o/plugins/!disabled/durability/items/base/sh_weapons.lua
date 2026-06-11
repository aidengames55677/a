ITEM.name = "Weapon"
ITEM.desc = "A Weapon."
ITEM.category = "tfaweapon"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isWeapon = true
ITEM.weaponCategory = "sidearm"

ITEM.noDurability = false -- If true disables durability wear and tear
ITEM.defaultHealth = 100 -- The max health of the weapon, can be higher than 100%
ITEM.damageChance = 16 -- 1 in X chance of taking 0-10% damage per shot (Recommend: MagSize / 2 = dmgChance)

-- Inventory drawing
if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
		
		if !item.noDurability then
			draw.SimpleText(item:getData("health", item.defaultHealth).."%", "DermaDefault", 5, h-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end
	end
end
--------------------------------------------------------------------	ENGRAVE STUFF
ITEM.functions._Engrave = { -- not sorry for name order, nerd.
	name = "Engrave Weapon",
	tip = "Engrave this weapon with a custom name",
	icon = "icon16/brick_edit.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local inventory = char:getInv()
		
		local engraveKit = inventory:getFirstItemOfType("engravekit")
		local Uses = engraveKit:getData("Uses") or engraveKit.Uses
		
		if Uses == 0 then
			client:notify("You need to replenish your tools.")
			return false
		end
		
		client:requestString("Engraving Text", "Please enter the engraved text", function(text)	
				item:setData("itemCustomName", text)
				client:EmitSound("ambient/materials/dinnerplates1.wav", 65, 130)
		end, "Engraved Name")
		
		client:EmitSound("physics/metal/weapon_impact_soft"..math.random(1,3)..".wav")
		engraveKit:setData("Uses", Uses - 1)
		
		return false
	end,
	onCanRun = function(item)
		local char = item.player:getChar()
		local hasEngraveKit = char:getInv():hasItem("engravekit")
		local notNamed = item:getData("itemCustomName", nil) == nil

		return (!IsValid(item.entity) and char:hasFlags("W") and hasEngraveKit and notNamed)
	end
}

ITEM.functions._EngraveScrub = {
	name = "Scrub Engraving",
	tip = "Removes the engraved name",
	icon = "icon16/brick_delete.png",
	onRun = function(item)
	local client = item.player
	local char = client:getChar()
	local inventory = char:getInv()
	
	local engraveKit = inventory:getFirstItemOfType("engravekit")
	local Uses = engraveKit:getData("Uses") or engraveKit.Uses
	
	if Uses == 0 then
		client:notify("You need to replenish your tools.")
		return false
	end
	
	item:setData("itemCustomName", nil)
	client:EmitSound("physics/metal/paintcan_impact_soft"..math.random(1,3)..".wav")
	engraveKit:setData("Uses", Uses - 1)
	
	return false
	end,
	onCanRun = function(item)
		local char = item.player:getChar()
		local hasEngraveKit = char:getInv():hasItem("engravekit")
		local hasName = item:getData("itemCustomName", nil) ~= nil

		return (!IsValid(item.entity) and char:hasFlags("W") and hasEngraveKit and hasName)
	end
}

function ITEM:getName()
	local name = self.name
	
	if self:getData("itemCustomName", nil) ~= nil then
		name = ("\""..self:getData("itemCustomName").."\" - "..self.name)
	else name = self.name end
	
	return Format(name)
end

--------------------------------------------------------------------	CHECK GUN DURABILITY
ITEM.functions._CheckDurability = {
	name = "Check Durability",
	tip = "Checks Durability",
	icon = "icon16/cog_add.png",
	onRun = function(item)

	local client = item.player
	local char = client:getChar()
	local inventory = char:getInv()
	
	client:notify("Durability: ".. (item:getData("health", item.defaultHealth)))
	return false
	end
}

--------------------------------------------------------------------	REPAIR KIT STUFF
ITEM.functions._RepairPro = {
	name = "Gun Oil",
	tip = "Adds +25% to the durability",
	icon = "icon16/cog_add.png",
	onRun = function(item)
	local client = item.player
	local char = client:getChar()
	local inventory = char:getInv()
	
	local repairkitPro = inventory:getFirstItemOfType("repairkit")
	local Uses = repairkitPro:getData("Uses") or repairkitPro.Uses
	
	if Uses == 0 then
		client:notify("You need to replenish your tools.")
		return false
	end
	
	repairkitPro:setData("Uses", Uses - 1)
	item:setData("health", math.min(item:getData("health") + repairkitPro.healAmount, item.defaultHealth))
	client:EmitSound("misc/crafting/tools/wrench.wav")
	
	return false
	end,
	onCanRun = function(item)
		local itemHealth = item:getData("health") or item.defaultHealth
		local char = item.player:getChar()
		local hasRepairkitPro = char:getInv():hasItem("repairkit")

		return (!IsValid(item.entity) and hasRepairkitPro and char:hasFlags("W") and (itemHealth < item.defaultHealth))
	end
}

ITEM.functions._RepairReg = {
	name = "Makeshift Repair",
	tip = "Repairs to 40% of maximum health",
	icon = "icon16/cog.png",
	onRun = function(item)
	local client = item.player
	local char = client:getChar()
	local inventory = char:getInv()
	
	local repairkitReg = inventory:getFirstItemOfType("repairkit_makeshift")
	
	repairkitReg:remove()
	item:setData("health", math.ceil(item.defaultHealth / 2.5))
	client:EmitSound("misc/crafting/tailoring"..math.random(6,9)..".wav")
	
	return false
	end,
	onCanRun = function(item)
		local itemHealth = item:getData("health") or item.defaultHealth
		local char = item.player:getChar()
		local hasRepairkitReg = char:getInv():hasItem("repairkit_makeshift")

		return (!IsValid(item.entity) and hasRepairkitReg and (itemHealth < math.ceil(item.defaultHealth / 2.5)))
	end
}
--------------------------------------------------------------------	BASE STUFF

-- On item is dropped, Remove a weapon from the player and keep the ammo in
-- the item.
ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		item:setData("equip", nil)

		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon = item.player.carryWeapons[item.weaponCategory]

		if (IsValid(weapon)) then
			item:setData("ammo", weapon:Clip1())

			item.player:StripWeapon(item.class)
			item.player.carryWeapons[item.weaponCategory] = nil
			item.player:EmitSound(item.unequipSound or "items/ammo_pickup.wav", 80)
		end
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep
-- the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
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

		item.player:EmitSound(item.unequipSound or "items/ammo_pickup.wav", 80)
		item.player.carryWeapons[item.weaponCategory] = nil

		item:setData("equip", nil)

		if (item.onUnequipWeapon) then
			item:onUnequipWeapon(client, weapon)
		end

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data
-- from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		local client = item.player
		local items = client:getChar():getInv():getItems()
		
		if item:getData("health", item.defaultHealth) == 0 then
			client:notify("You need to repair this weapon before you can equip it again.")
			return false
		end

		client.carryWeapons = client.carryWeapons or {}

		for k, v in pairs(items) do
			if (v.id != item.id) then
				if (
					v.isWeapon and
					client.carryWeapons[item.weaponCategory] and
					v:getData("equip")
			 	) then
					client:notifyLocalized("weaponSlotFilled")
					return false
				end
			end
		end
		
		if (client:HasWeapon(item.class)) then
			client:StripWeapon(item.class)
		end

		local weapon = client:Give(item.class)

		if (IsValid(weapon)) then
			timer.Simple(0, function()
				client:SelectWeapon(weapon:GetClass())
			end)
			client.carryWeapons[item.weaponCategory] = weapon
			client:EmitSound(item.equipSound or "items/ammo_pickup.wav", 80)

			-- Remove default given ammo.
			local ammoCount =  client:GetAmmoCount(weapon:GetPrimaryAmmoType())
			if (
				ammoCount == weapon:Clip1() and
				item:getData("ammo", 0) == 0
			) then
				client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			end
			item:setData("equip", true)

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
		return (!IsValid(item.entity) and item:getData("equip") != true)
	end
}

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
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

-- Called after the item is registered into the item tables.
function ITEM:onRegistered()
	if (self.holsterDrawInfo) then
		HOLSTER_DRAWINFO[self.class] = self.holsterDrawInfo
	end
end

hook.Add("PlayerDeath", "nutStripClip", function(client)
	client.carryWeapons = {}

	local inventory = client:getChar() and client:getChar():getInv()
	if (not inventory) then return end
	for k, v in pairs(inventory:getItems()) do
		if (v.isWeapon and v:getData("equip")) then
			v:setData("ammo", nil)
		end
	end
end)

function ITEM:onRemoved()
	local inv = nut.item.inventories[self.invID]
	if (inv) then
		local receiver = inv.getReceiver and inv:getReceiver()

		if (IsValid(receiver) and receiver:IsPlayer()) then
			local weapon = receiver:GetWeapon(self.class)

			if (IsValid(weapon)) then
				weapon:Remove()
			end
		end
	end
end
