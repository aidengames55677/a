local PLUGIN = PLUGIN
local INVENTORY_TYPE_ID = "grid"

local PANEL_WIDE = ScrW() / 4
local PANEL_HEIGHT = ScrH() / 3

-- limit is 16 slots
PLUGIN.equipSlots = {
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "fulloutfit",
		w = PANEL_WIDE / 6,
		h = PANEL_HEIGHT / 1.15,
		x = 10,
		y = PANEL_HEIGHT / 2 - ((PANEL_HEIGHT / 1.25) / 2),
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "hats",
		x = PANEL_WIDE / 2 - 26.5,
		y = PANEL_HEIGHT / 4.5 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "glasses",
		x = PANEL_WIDE / 2 + 50,
		y = PANEL_HEIGHT / 4.5 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "neck",
		x = PANEL_WIDE / 3 - 26.5,
		y = PANEL_HEIGHT / 4.5 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "shirt",
		x = PANEL_WIDE / 2 - 26.5,
		y = PANEL_HEIGHT / 4.5 + 34,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "tie",
		x = PANEL_WIDE / 2 + 50,
		y = PANEL_HEIGHT / 4.5 + 34,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "wrist",
		x = PANEL_WIDE / 2 + 120,
		y = PANEL_HEIGHT / 4.5 + 100,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "rightring",
		x = PANEL_WIDE / 2 + 50,
		y = PANEL_HEIGHT / 4.5 + 100,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "leftring",
		x = PANEL_WIDE / 3 - 26.5,
		y = PANEL_HEIGHT / 4.5 + 100,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "pants",
		x = PANEL_WIDE / 2 - 26.5,
		y = PANEL_HEIGHT / 4.5 + 144,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "shoes",
		x = PANEL_WIDE / 2 - 26.5,
		y = PANEL_HEIGHT / 4.5 + 220,
	},
}
/*
PLUGIN.equipSlots = {
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "glasses",
		x = PANEL_WIDE / 3 - 24,
		y = PANEL_HEIGHT / 4 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "hats",
		x = PANEL_WIDE / 2 - 24,
		y = PANEL_HEIGHT / 4 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "shirt",
		x = PANEL_WIDE / 2 - 24,
		y = PANEL_HEIGHT / 2.2 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "pants",
		x = PANEL_WIDE / 2 - 24,
		y = PANEL_HEIGHT / 1.5 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "shoes",
		x = PANEL_WIDE / 2 - 24,
		y = PANEL_HEIGHT / 1.1 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "tie",
		x = PANEL_WIDE / 3 - 24,
		y = PANEL_HEIGHT / 2.2 - 24,
	},
	{
		--icon = Material("sloticons/slot_helmet.png", "smooth noclamp"),
		slot = "fulloutfit",
		w = PANEL_WIDE / 6,
		h = PANEL_HEIGHT / 1.15,
		x = 10,
		y = PANEL_HEIGHT / 2 - ((PANEL_HEIGHT / 1.25) / 2),
	},
}
*/

function PLUGIN:InitializedPlugins()
	local PANEL = vgui.GetControlTable("nutGridInventoryPanel")
	self.oldOnItemReleased = self.oldOnItemReleased or PANEL.onItemReleased
	
	--[[ inline hook hack ]]--
	function PANEL:onItemReleased(itemIcon, keyCode)
		local item = itemIcon.itemTable
		if !item then return end
		
		local result = hook.Run("CanRequestItemTransfer", self, item:getID(), self.inventory:getID())
		if result == false then
			return result
		end
		
		PLUGIN.oldOnItemReleased(self, itemIcon, keyCode)
	end
	
	function PANEL:populateItems()
		for key, icon in pairs(self.icons) do
			if (IsValid(icon)) then
				icon:Remove()
			end
			self.icons[key] = nil
		end
		for _, item in pairs(self.inventory:getItems(true)) do
			if item:getData("x") == -1 or item:getData("y") == -1 then continue end
			
			self:addItem(item)
		end
		self:computeOccupied()
	end
	
	function PANEL:computeOccupied()
		if (not self.inventory) then return end

		for y = 0, self.gridH do
			self.occupied[y] = {}
			for x = 0, self.gridW do
				self.occupied[y][x] = false
			end
		end

		for _, item in pairs(self.inventory:getItems(true)) do
			local x, y = item:getData("x"), item:getData("y")
			if (not x or x == -1 or y == -1) then continue end

			for offsetX = 0, (item.width or 1) - 1 do
				for offsetY = 0, (item.height or 1) - 1 do
					self.occupied[y + offsetY - 1][x + offsetX - 1] = true
				end
			end
		end
	end

	/*
		Remove gridinvui's CreateInventoryPanel hook
	*/

	hook.Remove("CreateInventoryPanel", nut.plugin.list.gridinvui)
end

function PLUGIN:CreateInventoryPanel(inventory, parent)
	if (inventory.typeID ~= INVENTORY_TYPE_ID) then
		return
	end

	local panel = vgui.Create("nutGridInventory", parent)
	panel:setInventory(inventory)
	panel:Center()

	if !parent then return panel end

	--[[ 
		why is this returning global coords? wiki says:
		Returns the position of the panel relative to its Panel:GetParent.
		makes this really annoying
	]]--
	
	if !inventory:getData("item") or parent.equipSlots then
		-- this sucks.
		local equipPanel = parent:Add("NSEquipMenu")
		local x, y = panel:GetPos()
		local _, newY = parent:LocalToScreen(x, equipPanel:GetTall())
		
		equipPanel:SetPos(parent:GetWide() / 2 - equipPanel:GetWide() / 2, 0)
		panel:SetPos(x, newY + 4)
		
		parent.equipSlots = equipPanel
	end
	
	return panel
end

--[[ hacky and bad!!! ]]--
local function findEquipSlot(item, isNew)
	-- lol
	local invPanel = nut.gui["inv"..item.invID]
	if !IsValid(invPanel) then return end

	local parent = invPanel:GetParent()
	local equipPanel = parent.equipSlots

	if !IsValid(equipPanel) then return end
	
	for _,slot in ipairs(equipPanel.slots) do
		if !isNew then
			if slot.item == item then
				return slot
			end
		else
			if slot.slotType == item.slot then
				return slot
			end
		end
	end
end

--[[ this sucks, but NS doesnt use the dragndrop library for drop detection. ]]--
function PLUGIN:CanRequestItemTransfer(pnl, itemID, invID)
	local item = nut.item.instances[itemID]
	local hoveredPnl = vgui.GetHoveredPanel()
	if !hoveredPnl then return end
	local isEquipSlot = hoveredPnl:GetName() == "NSEquipSlot"
	local isInventorySlot = hoveredPnl:GetName() == "nutGridInventoryPanel"

	if !item.usesEquipSlot then return end
	
	if isEquipSlot then
		if item.slot == hoveredPnl.slotType and !hoveredPnl.item then
		--[[ 1.1-b seems to use the net library much more than netstream, so we'll follow that pattern. is also more efficient ]]--
			net.Start("nutEquipToSlot")
				net.WriteUInt(itemID, 32)
			net.SendToServer()
		end
		
		return false
	elseif item:getData("equip") and isInventorySlot then
		netstream.Start("invAct", "Unequip", itemID, hoveredPnl.inventory:getID())
	elseif hoveredPnl:GetName() == "nutGridInvItem" then
		return false
	end
end

function PLUGIN:ItemDataChanged(item, key, oldValue, value)
	if item.usesEquipSlot then
		if key == "equip" then
			if value then
				local slot = findEquipSlot(item, true)
				if !IsValid(slot) then return end

				--nut.inventory.instances[item.invID].items[item:getID()] = nil
				slot:setItem(item)
			else
				local slot = findEquipSlot(item)
				if !IsValid(slot) then return end

				--nut.inventory.instances[item.invID].items[item:getID()] = item
				slot:setItem(nil)
			end
			
			local inv = nut.gui["inv"..item.invID]
			
			if inv then
				inv.content:populateItems()
			end
		end
	end
end