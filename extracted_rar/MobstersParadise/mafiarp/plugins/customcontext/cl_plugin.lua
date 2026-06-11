-- "gamemodes\\mafiarp\\plugins\\customcontext\\cl_plugin.lua"

local PLUGIN = PLUGIN

-- because i dont want to make a whole skin
local function PaintMenu( panel, w, h )
	local odd = true
	
	for i = 0, h, 22 do
		if odd then
			surface.SetDrawColor(40, 40, 40, 255)
			surface.DrawRect(0, i, w, 22)
		else
			surface.SetDrawColor(50, 50, 50, 255)
			surface.DrawRect(0, i, w, 22)
		end
		
		odd = !odd
	end
end

local function PaintMenuOption( panel, w, h )
	if !panel.LaidOut then
		panel.LaidOut = true
		panel:SetFont("Default")
		panel:SetTextColor(Color(200, 200, 200, 255))
	end
	
	if panel.m_bBackground and (panel.Hovered or panel.Highlight) then
		surface.SetDrawColor(70, 70, 70, 255)
		surface.DrawRect(0, 0, w, h)
	end

	local skin = derma.GetDefaultSkin()
	
	skin.MenuOptionOdd = !skin.MenuOptionOdd;
	
	if panel:GetChecked() then
		skin.tex.Menu_Check(5, h / 2 - 7, 15, 15)
	end
end

function PLUGIN:CreateCustomContext(ent)
	local menu = self.ContextMenu

	for key,data in next, self.ContextOptions do
		local canRun = data.canRun
		if canRun and !canRun(LocalPlayer(), ent) then
			continue
		end

		-- have to create a closure here and be jit noncompliant, lame!
		local option
		if !data.createOption then
			option = menu:AddOption(data.text, data.optionOverride or function()
				net.Start("nutRunContextFunction")
					net.WriteString(key)
					net.WriteEntity(ent)
				net.SendToServer()

				gui.EnableScreenClicker(false)
			end)
		else
			option = data.createOption(menu)
		end
		option.Panel = PaintMenuOption

		if data.icon then
			option:SetIcon(data.icon)
		end
	end
end

function PLUGIN:PlayerBindPress(ply, bind, down)
	if down and string.find(bind, "+menu_context") then
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() != "gmod_tool" then
			local trace = {}
			trace.start = LocalPlayer():GetShootPos()
			trace.endpos = trace.start + LocalPlayer():GetAimVector() * 32768
			trace.filter = LocalPlayer()
			local tr = util.TraceLine(trace)

			local entity = tr.Entity
			if !entity:IsWorld() then
				CloseDermaMenus()

				self.ContextMenu = DermaMenu()
				self.ContextMenu.Paint = PaintMenu
				self.ContextMenu.Entity = entity
					hook.Run("CreateCustomContext", entity)
					--gui.EnableScreenClicker(true)
				self.ContextMenu:Open(ScrW() / 2, ScrH() / 2)

				if self.ContextMenu:ChildCount() > 0 then
					return true
				end
			end
		elseif IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then
			hook.Run("OnContextMenuOpen")
			
			return true
		end
	end
	
	if !down and string.find(bind, "+menu_context") then
		--gui.EnableScreenClicker(false)
		
		if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() != "gmod_tool" then
			if IsValid(self.ContextMenu) and self.ContextMenu:ChildCount() > 0 then
				return true
			end
		elseif IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then
			hook.Run("OnContextMenuClose")
			return true
		end
	end
end