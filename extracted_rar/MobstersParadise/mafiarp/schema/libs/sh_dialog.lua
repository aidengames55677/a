NITORIA = NITORIA or {}
NT = NT or {}
nitoria = nitoria or {}
nt = nt or {}

include("cardealer/sh_vehicles.lua")
include("sv_shop.lua")

if (CLIENT) then
	local playerMeta = FindMetaTable("PLAYER")
	local MaxW = ScrW() * .4
	local MaxH = ScrH() * .2

	surface.CreateFont( "Credentials_Font", {
		font = "Times New Roman", 
		extended = false,
		size = 35,
	} )

	surface.CreateFont( "Dialog_Font", {
		font = "Times New Roman", 
		extended = false,
		size = 25,
	} )

	surface.CreateFont( "Item_Font", {
		font = "Times New Roman",
		size = 18,
		weight = 800,
		antialias = true,
	} )

	function nitoria.dialog(name, model, profession, place_of_employment, dialog )
		local npc_name = name
		local npc_model = model
		local npc_profession = profession
		local npc_place_of_employment = place_of_employment	

		self = vgui.Create("DFrame")
		self:SetTitle(name .. " - " .. place_of_employment .. " " ..  profession)
		self:SetPos(ScrW() * .5 - MaxW * .5, ScrH() - MaxH * 1.5)
		self:SetSize(MaxW, MaxH)
		self:MakePopup()
		self:ShowCloseButton(true)

		self.ModelPanel = vgui.Create("DModelPanel", self)
		self.ModelPanel:SetFOV(70)
		self.ModelPanel:SetCamPos(Vector(14, 0, 60))
		function self.ModelPanel:LayoutEntity( Entity ) end

		self.ModelPanel:SetPos(3, 3)
		self.ModelPanel:SetSize(MaxH - 6, MaxH - 6)

		self.ModelPanel:SetLookAt(Vector(-1, 0, 66))
		self.ModelPanel:SetModel(npc_model)


		self.credentials = vgui.Create("DLabel", self)
		self.credentials:SetFont("Credentials_Font")
		self.credentials:SetText("Name: " .. name .. "\n" .. "Occupation: " .. profession .. "\n" .. "Employer: " .. place_of_employment)
		self.credentials:SizeToContents()
		self.credentials:SetPos(250, 35)

		self.buttonbox = vgui.Create("DPanel", self)
		self.buttonbox:SetSize((ScrW() * .5 - MaxW * .5) /1.11, ScrH() - MaxH * 1.5)
		self.buttonbox:Dock(RIGHT)

		self.closebutton = vgui.Create("DButton", self.buttonbox)
		self.closebutton:SetHeight(20)
		self.closebutton:SetText("Close")
		self.closebutton:Dock(BOTTOM)
		self.closebutton:SetTextColor(Color(255,255,255,255))
		self.closebutton.DoClick = function(ply)
			self:Close()
			self:Remove()
		end

		self.speakbutton = vgui.Create("DButton", self.buttonbox)
		self.speakbutton:SetHeight(20)
		self.speakbutton:SetText("Speak to " .. name)
		self.speakbutton:Dock(BOTTOM)
		self.speakbutton:SetTextColor(Color(255,255,255,255))
		self.speakbutton.DoClick = function(ply)
			self:Close()
			self:Remove()
			dialog(name, model, profession, place_of_employment)
		end
	end

	function nitoria.dialogframe(name, model, profession, place_of_employment)
		self = vgui.Create("DFrame")
		self:SetTitle(name .. " - " .. place_of_employment .. " " ..  profession)
		self:SetPos(ScrW() * .5 - MaxW * .5, ScrH() - MaxH * 1.5)
		self:SetSize(MaxW, MaxH)
		self:MakePopup()
		self:ShowCloseButton(true)

		self.ModelPanel = vgui.Create("DModelPanel", self)
		self.ModelPanel:SetFOV(70)
		self.ModelPanel:SetCamPos(Vector(14, 0, 60))
		function self.ModelPanel:LayoutEntity( Entity ) end

		self.ModelPanel:SetPos(3, 3)
		self.ModelPanel:SetSize(MaxH - 6, MaxH - 6)

		self.ModelPanel:SetLookAt(Vector(-1, 0, 66))
		self.ModelPanel:SetModel(model)

		self.buttonbox = vgui.Create("DPanel", self)
		self.buttonbox:SetSize((ScrW() * .5 - MaxW * .5) /1.11, ScrH() - MaxH * 1.5)
		self.buttonbox:Dock(RIGHT)
	end

	function nitoria.dialogbutton(text, height, doclick)
		self.button = vgui.Create("DButton", self.buttonbox)
		self.button:SetText(text)
		self.button:Dock(BOTTOM)
		self.button:SetTextColor(Color(255,255,255,255))
		self.button:SetTall(height)
		self.button.DoClick = function(len, ply)
			doclick()
		end
	end

	function nitoria.dialogtext(text, height)
		self.text = vgui.Create("RichText", self.buttonbox)
		if !height then
			self.text:SetTall(55)		
		else
			self.text:SetTall(height)
		end
		self.text.Paint = function()
		    self.text.m_FontName = "Dialog_Font"
		    self.text:SetFontInternal( "Dialog_Font" )	
		    self.text:SetBGColor(Color(0,0,0,0))		
		    self.text.Paint = nil
		end
		self.text:Dock(TOP)
		self.text:AppendText(text)
	end

	function nitoria.dialogtextlong(text, height)
		 
	end

	function nitoria.shopframe(name, model, profession, place_of_employment, category_name, height, width)
		self = vgui.Create("DFrame")
		self:SetTitle(name .. " - " .. place_of_employment .. " " ..  profession)
		if height then
			if width then
				self:SetSize(width, height)
			else
				self:SetSize(ScrW()-200,450)
			end
		else
			self:SetSize(ScrW()-200,450)
		end
		self:Center()
		self:MakePopup()
		self:ShowCloseButton(true)

		self.scroll = vgui.Create("DScrollPanel", self)
		self.scroll:Dock(FILL)

		self.category = self.scroll:Add("DCollapsibleCategory")
		self.category:SetLabel(category_name)
		self.category:Dock(TOP)
		self.category:SetExpanded(1)
		self.category.Paint = function( self, w, h ) 
			self:SetBGColor(Color(0,0,0,1))
		end
	
		self.category.panel = vgui.Create("DPanel", self.category)
		self.category.panel:Dock(FILL)

		self.category.list = vgui.Create("DListLayout", self.category.panel)
		self.category.list:Dock(FILL)
		self.category.list:DockPadding(3, 3, 3, 3)

		self.category:SetContents(self.category.list)

		self.scroll:AddItem(self.category)
	end

	function nitoria.shopitem(uniqueID, cansell, bulk, sellonly, onaction, newprice)
		local itemTable = nut.item.list[uniqueID]
		local itemPrice = itemTable.price
		if newprice then
			itemPrice = newprice
		end

		self.item = self.category.list:Add("DPanel")
		self.item:SetTall(70)

		self.spawnIcon = vgui.Create("nutSpawnIcon", self.item)
		self.spawnIcon:Dock(LEFT)
		self.spawnIcon:SetSize(48, 48)
		self.spawnIcon:SetModel(itemTable.model)

		self.name = vgui.Create("DLabel", self.item)
		self.name:SetPos(56, 4)
		self.name:SetFont("Item_Font")
		self.name:SetText(itemTable.name)
		--self.name:SetTextColor(Color(100, 100, 100, 255))
		--self.name:SetExpensiveShadow(1, Color(255, 255, 255, 255))
		self.name:SizeToContents()

		self.description = vgui.Create("DLabel", self.item)
		self.description:SetPos(56, 25)
		self.description:SetText(itemTable.desc or "No description available.")
		self.description:SetTextColor( Color(125, 125, 125, 225) )
		self.description:SizeToContents()

		self.buyBox = vgui.Create("DPanel", self.item)
		self.buyBox:Dock(RIGHT)
		self.buyBox:DockMargin(1, 1, 1, 1)
		self.buyBox:SetWide(90)
		self.buyBox:SetDrawBackground(false)
		
		self.price = vgui.Create("DButton", self.buyBox)
		self.price:Dock(TOP)
		self.price:SetText("$" .. (itemPrice or 50))
		self.price:SetTooltip( nut.config.get("salesTax")*100 .. "% Sales Tax")
		self.price:SetTextColor( Color(125, 125, 125, 225) )
		self.price:DockMargin(0, 4, 5, 0)
		self.price:SetDrawBackground(false)

		if sellonly then
			self.sell = vgui.Create("DButton", self.buyBox)
			self.sell:Dock(BOTTOM)
			self.sell:DockMargin(0, 0, 5, 3)
			self.sell:SetSize(140, 20)
			self.sell:SetText("Sell")
			self.sell.DoClick = function()
				net.Start("sell_func")
					net.WriteString(uniqueID)
				net.SendToServer()
				if onaction then
					onaction(uniqueID, false)
				end
			end	
		else
			self.buy = vgui.Create("DButton", self.buyBox)
			self.buy:Dock(BOTTOM)
			self.buy:DockMargin(0, 0, 5, 3)
			self.buy:SetSize(140, 20)
			self.buy:SetText("Buy")
			self.buy.DoClick = function()
				net.Start("purchase_function")
					net.WriteString(uniqueID)
					net.WriteInt(1, 6)
				net.SendToServer()
				if onaction then
					onaction(uniqueID, true)
				end
			end
		end

		if cansell then
			self.sell = vgui.Create("DButton", self.buyBox)
			self.sell:Dock(BOTTOM)
			self.sell:DockMargin(0, 0, 5, 3)
			self.sell:SetSize(140, 20)
			self.sell:SetText("Sell")
			self.sell.DoClick = function()
				net.Start("sell_func")
					net.WriteString(uniqueID)
				net.SendToServer()
				if onaction then
					onaction(uniqueID, false)
				end
			end
		end

		if !cansell and bulk != 0 then
			self.buy = vgui.Create("DButton", self.buyBox)
			self.buy:Dock(BOTTOM)
			self.buy:DockMargin(0, 0, 5, 3)
			self.buy:SetSize(140, 20)
			self.buy:SetText("Buy x" .. bulk .. " ($" .. itemPrice*bulk .. ")")
			self.buy.DoClick = function()
				net.Start("purchase_function")
					net.WriteString(uniqueID)
					net.WriteInt(bulk, 6)
				net.SendToServer()
				if onaction then
					onaction(uniqueID, false, bulk)
				end
			end
		end
	end	 

	function nitoria.npctext(name, desc)
		local TEXT_OFFSET = Vector(0, 0, 20)
		local toScreen = FindMetaTable("Vector").ToScreen
		local colorAlpha = ColorAlpha
		local drawText = nut.util.drawText
		local configGet = nut.config.get
		
		ENT.DrawEntityInfo = true

		function ENT:onDrawEntityInfo(alpha)
			local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
			local x, y = position.x, position.y

			drawText(name, x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
			
			drawText(desc, x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
		end
	end
end
