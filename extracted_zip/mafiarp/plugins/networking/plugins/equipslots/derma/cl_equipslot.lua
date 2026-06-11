local PANEL = {}

function PANEL:setItem(item)
	if item then
		local icon = self:Add("nutGridInvItem")
		icon:setItem(item)
		icon:SetPos(0, 0)
		icon:SetSize(self:GetWide(), self:GetTall())
		icon:InvalidateLayout(true)
		icon.OnMousePressed = function(icon, keyCode)
			local inv = nut.gui["inv"..icon:getItem().invID]
			if !IsValid(inv) or !IsValid(inv.content) then return end

			inv.content:onItemPressed(icon, keyCode)
		end
		icon.OnMouseReleased = function(icon, keyCode)
			local heldPanel = nut.item.heldPanel
			if (IsValid(heldPanel)) then
				heldPanel:onItemReleased(icon, keyCode)
			end
			icon:DragMouseRelease(keyCode)
			icon:MouseCapture(false)
			nut.item.held = nil
			nut.item.heldPanel = nil
		end
		
		self.icon = icon
	else
		self.icon:Remove()
		self.icon = nil
	end
	
	self.item = item
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0,0,w,h)
	
	if self.slotIcon then
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(self.slotIcon)
		surface.DrawTexturedRect(0,0,w,h)
	end
end

vgui.Register("NSEquipSlot", PANEL, "DPanel")