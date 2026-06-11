local PANEL = {}
local PLUGIN = PLUGIN

function PANEL:Init()
	self:SetTitle(L"equipSlot")
	self:SetSize(ScrW() / 4, ScrH() / 3)
	
	self.model = self:Add("nutModelPanel")
	self.model:SetWide(ScrW() * 0.25)
	self.model:Dock(FILL)
	self.model:SetFOV(80)
	self.model.enableHook = true
	self.model.copyLocalSequence = true
	self.model:SetModel(LocalPlayer():GetModel())
	
	hook.Run("OnCharInfoSetup", self)

	self.slots = {}
	local x, y = 4, 28
	local reachedOtherSide
	for id, data in ipairs(PLUGIN.equipSlots) do
		if y + 68 > self:GetTall() then
			x = x + 68
			y = 28
		end
		
		if x + 68 > self:GetWide() / 2 and !reachedOtherSide then
			x = self:GetWide() - self:GetWide() / 3
			reachedOtherSide = true
		end
	
		local slot = self:Add("NSEquipSlot")
		slot.slotIcon = data.icon
		slot.slotType = data.slot
		slot:SetSize(data.w or 48, data.h or 48)
		slot:SetPos(data.x or x, data.y or y)

		for _,item in next, LocalPlayer():getChar():getInv():getItems() do
			if item.usesEquipSlot and item.slot == slot.slotType and item:getData("equip") then
				slot:setItem(item)
			end
		end
		
		table.insert(self.slots, slot)
		y = y + 68
	end
end

vgui.Register("NSEquipMenu", PANEL, "DFrame")