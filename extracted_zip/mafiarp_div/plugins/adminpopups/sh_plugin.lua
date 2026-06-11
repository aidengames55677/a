-- "gamemodes\\mafiarp\\plugins\\adminpopups\\sh_plugin.lua"

local PLUGIN = PLUGIN
PLUGIN.name = "Adminpopups"
PLUGIN.author = "gmodstore, Pendred"
PLUGIN.desc = "Ticket system"

nut.util.include("sv_plugin.lua")

local cfg = cfg or {}

--[[
	Admin Popups by Jacob
	Support given at ScriptFodder or steam (www.steamcommunity.com/id/lostalien)
	Please use the config below or request support from me. I will not provide support if you modify the code
	Some clientside configuration can be done with cvars (cl_adminpopups_*)
]]

cfg.autoclose = 7200 -- the case will auto close after this amount of seconds
cfg.preventchat = false -- Prevents adminchat messages shown on popups
cfg.caseUpdateOnly = true -- Once a case is claimed, only the claimer sees further updates
cfg.debug = false -- Debug mode allows admins to send popups too and prints button commands
cfg.xpos = 20 -- X cordinate of the popup. Can be changed in case it blocks something important
cfg.ypos = 40 -- Y cordinate of the popup. Can be changed in case it blocks something important


if CLIENT then
	-- Clients are able to configure these ingame with console, however you can set the default here. Only change the first number after the convar name
	CreateClientConVar("cl_adminpopups_closeclaimed",0,true,false) -- This will autoclose cases claimed by others.
	-- 0 = Always show popups
	-- 1 = Show chat messages while on NOT duty
	-- 2 = Show console messages while NOT on duty
	-- 3 = Disable admin messages
end	


local function hasAccess(ply)
	return ply:HasPermission("see_admin_chat")
end
local function sendPopup(noob,message)
	--if not cfg.state then return end
	if cfg.caseUpdateOnly then
		if noob.CaseClaimed then
			if noob.CaseClaimed:IsValid() and noob.CaseClaimed:IsPlayer() then
				net.Start("ASayPopup")
					net.WriteEntity(noob)
					net.WriteString(message)
					net.WriteEntity(noob.CaseClaimed)
				net.Send(noob.CaseClaimed)
			end
		else
			for k,v in pairs(player.GetAll()) do
				if hasAccess(v) then
					net.Start("ASayPopup")
						net.WriteEntity(noob)
						net.WriteString(message)
						net.WriteEntity(noob.CaseClaimed)
					net.Send(v)
				end
			end
		end
	else
		for k,v in pairs(player.GetAll()) do
			if hasAccess(v) then
				net.Start("ASayPopup")
					net.WriteEntity(noob)
					net.WriteString(message)
					net.WriteEntity(noob.CaseClaimed)
				net.Send(v)
			end
		end
	end
	if noob:IsValid() and noob:IsPlayer() then
		timer.Destroy("adminpopup-"..noob:SteamID64())
		timer.Create("adminpopup-"..noob:SteamID64(),cfg.autoclose,1,function() if noob:IsValid() and noob:IsPlayer() then noob.CaseClaimed = nil end end)
	end
end

hook.Add("ReportCalled","CheckForASay",function(ply,args)
	if #args < 1 then return end
	
	if !openTickets[ply:SteamID()] && !ply:HasPermission("see_admin_chat") then
		openTickets[ply:SteamID()] = true
	end

	if ply:HasPermission("see_admin_chat") then
		if cfg.debug then
			sendPopup(ply,table.concat(args,""))
			return not cfg.preventchat
		end
	else
		sendPopup(ply,table.concat(args,""))
		return not cfg.preventchat
	end
end)


if CLIENT then
	
	local mat_lightning = mat_lightning or Material("icon16/lightning_go.png")
	local mat_bring = mat_bring or Material("icon16/arrow_down.png")
	local mat_arrow = mat_arrow or Material("icon16/arrow_left.png")
	local mat_link = mat_link or Material("icon16/link.png")
	local mat_eye = mat_eye or Material("icon16/eye.png")
	local mat_case = mat_case or Material("icon16/briefcase.png")
	local mat_page = mat_page or Material("icon16/page.png")
	
	local aframes = aframes or {}
	
	surface.CreateFont("adminpopup", {
		font = "Railway",
		size = 15,
		weight = 400
	})
	
	local function asayframe(noob,message,claimed)
		if not noob:IsValid() or not noob:IsPlayer() then return end
		for k,v in pairs(aframes) do
			if v.idiot == noob then
				local txt = v:GetChildren()[5]
				txt:AppendText("\n".. message)
				txt:GotoTextEnd()
				timer.Destroy("adminpopup-"..noob:SteamID64()) -- destroy so we can extend
				timer.Create("adminpopup-"..noob:SteamID64(),cfg.autoclose,1,function() if v:IsValid() then v:Remove() end end)
				surface.PlaySound("ui/hint.wav") -- just a headsup that it changed
				return
			end
		end
	
		local w,h = 400 - 85,140
		
		local frm = vgui.Create("DFrame")
		frm:SetSize(w,h)
		frm:SetPos(cfg.xpos,cfg.ypos)
		frm.idiot = noob
		frm.steamID = noob:SteamID()
		function frm:Paint(w,h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(35,35,35) )
		end
		frm.lblTitle:SetColor(Color(255,255,255))
		frm.lblTitle:SetFont("adminpopup")
		frm.lblTitle:SetContentAlignment(7)
		
		if claimed and claimed:IsValid() and claimed:IsPlayer() then
			frm:SetTitle(noob:Nick().." - Claimed by "..claimed:Nick())
			if claimed == LocalPlayer() then
				function frm:Paint(w,h)
					draw.RoundedBox( 0, 0, 0, w, h, Color(35,35,35) )
					draw.RoundedBox( 0, 2, 2, w-4, 16, Color(35,35,35) )
				end
			else
				function frm:Paint(w,h)
					draw.RoundedBox( 0, 0, 0, w, h, Color(35,35,35) )
					draw.RoundedBox( 0, 2, 2, w-4, 16, Color(35,35,35) )
				end	
			end
		else
			frm:SetTitle(noob:Nick())
		end

	

		
		local msg = vgui.Create("RichText",frm)
		msg:SetPos(10,30)
		msg:SetSize(205,h-35)
		msg:SetContentAlignment(7)
		msg:InsertColorChange( 255, 255, 255, 255 )
		msg:SetVerticalScrollbarEnabled(false)
		function msg:PerformLayout()
			self:SetFontInternal( "DermaDefault" )
		end
		msg:AppendText(message)
		
		--buttons
		
		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(230,20 * 1)
		cbu:SetSize(83,18)
		cbu:SetText("          Goto")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.DoClick = function()
			local toexec = [["sam goto ]]..noob:SteamID()..[["]]
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(138, 138, 138) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			end	
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(mat_lightning)
			surface.DrawTexturedRect(5, 1, 16, 16)
		end
		
		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(230,20 * 2)
		cbu:SetSize(83,18)
		cbu:SetText("          Bring")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.DoClick = function()
			local toexec = [["sam bring ]]..noob:SteamID()..[["]]
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(138, 138, 138) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			end	
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(mat_bring)
			surface.DrawTexturedRect(5, 1, 16, 16)
		end
		
		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(230,20 * 3)
		cbu:SetSize(83,18)
		cbu:SetText("          Return")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.should_unjail = false
		cbu.DoClick = function()
			local toexec = [["sam return ]]..noob:SteamID()..[["]]
			if serverguard then
				toexec = [["sg return"]]
			end			
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(138, 138, 138) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			end	
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(mat_arrow)
			surface.DrawTexturedRect(5, 1, 16, 16)
		end		
		
		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(230,20 * 4)
		cbu:SetSize(83,18)
		cbu:SetText("          Freeze")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.should_unfreeze = false
		cbu.DoClick = function()
			local toexec = [["sam freeze ]]..noob:SteamID()..[["]]
			if cbu.should_unfreeze then
				toexec = [["sam unfreeze ]]..noob:SteamID()..[["]]
			end			
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
				--
			end
			cbu.should_unfreeze = not cbu.should_unfreeze
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(138, 138, 138) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			end	
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(mat_link)
			surface.DrawTexturedRect(5, 1, 16, 16)
		end
		
		/*local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(230,20 * 5)
		cbu:SetSize(83,18)
		cbu:SetText("          Spectate")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.DoClick = function()
			local toexec = [["sam spectate ]]..noob:SteamID()..[["]]		
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(138, 138, 138) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			end	
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(mat_eye)
			surface.DrawTexturedRect(5, 1, 16, 16)
		end	*/

		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(230,20 * 6)
		cbu:SetSize(83,18)
		cbu:SetText("")
		cbu:SetColor(Color(255,255,255))
		cbu.shouldclose = false
		cbu.DoClick = function()
			SetClipboardText(noob:SteamID())
			chat.AddText(Color(255, 255, 255), "Copied " .. noob:SteamID() .. " to clipboard.")
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(138, 138, 138) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			end	
			
			local t_w, t_h = draw.SimpleText("SteamID", "DermaDefault", w/2 + 8, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(mat_page)
			surface.DrawTexturedRect(5, h/2 - 8, 16, 16)
		end
		
		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(230,20 * 5)
		cbu:SetSize(83,18)
		cbu:SetText("          Claim case")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.shouldclose = false
		cbu.DoClick = function()
			if not cbu.shouldclose then
				if frm.lblTitle:GetText():lower():find("claimed") then
					chat.AddText(Color(255,150,0),"[ERROR] Case has already been claimed")
					surface.PlaySound("common/wpn_denyselect.wav")
				else	
					net.Start("ASayPopupClaim")
						net.WriteEntity(noob)
						net.WriteString(tostring(message))
					net.SendToServer()
					cbu.shouldclose = true
					cbu:SetText("          Close case")

					-- for k, v in pairs(player.GetAll()) do
					-- 	if v ~= LocalPlayer() then continue end
						
					-- 	if IsValid(frm) then frm:Remove() end
					-- end
				end
			else
				net.Start("ASayPopupClose")
				net.WriteEntity(noob or nil)
				net.SendToServer()
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(138, 138, 138) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(128, 128, 128) )
			end	
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(mat_case)
			surface.DrawTexturedRect(5, 1, 16, 16)
		end
		frm.ClaimButton = cbu
		
		frm:ShowCloseButton(false) -- we have our close button, so we won't need it
			
		frm:SetPos(-w-30,cfg.ypos + (162 * #aframes)) -- move out of screen 
		frm:MoveTo(cfg.xpos,cfg.ypos + (162 * #aframes),0.2,0,1,function() -- move back in
			surface.PlaySound("garrysmod/balloon_pop_cute.wav")
		end)
		
		function frm:OnRemove() -- for animations when there are several panels
			table.RemoveByValue(aframes,frm)
			for k,v in pairs(aframes) do
				v:MoveTo(cfg.xpos,cfg.ypos + (162 *(k-1)),0.1,0,1,function() end)
			end
			if noob and noob:IsValid() and noob:IsPlayer() and timer.Exists("adminpopup-"..noob:SteamID64()) then
				timer.Destroy("adminpopup-"..noob:SteamID64())
			end
		end
		table.insert(aframes,frm)
		
		timer.Create("adminpopup-"..noob:SteamID64(),cfg.autoclose,1,function() if frm:IsValid() then frm:Remove() end end)	-- auto close
	end
	
	net.Receive("ASayPopup",function(len)
		local pl = net.ReadEntity()
		local msg = net.ReadString()
		local claimed = net.ReadEntity()
		
		asayframe(pl,msg,claimed)
		
	end)
	
	net.Receive("ASayPopupClose",function(len)
		local noob = net.ReadEntity()
		
		if not noob:IsValid() or not noob:IsPlayer() then return end
		
		for k,v in pairs(aframes) do
			if v.idiot == noob then
				v:Remove()
			end
		end
		if timer.Exists("adminpopup-"..noob:SteamID64()) then
			timer.Destroy("adminpopup-"..noob:SteamID64())
		end
				
	end)
	
	net.Receive("ASayPopupClaim",function(len)
		local pl = net.ReadEntity()
		local noob = net.ReadEntity()
		for k,v in pairs(aframes) do
			if v.idiot == noob then
				if cvars.Bool("cl_adminpopups_closeclaimed") and pl ~= LocalPlayer() then
					v:Remove()
				else
					local titl = v:GetChildren()[4]
					titl:SetText(titl:GetText() .. " - Claimed by "..pl:Nick())
					if pl == LocalPlayer() then
						function v:Paint(w,h)
							draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35) )
							draw.RoundedBox( 0, 2, 2, w-4, 16, Color(128, 128, 128) )
						end	
					else
						function v:Paint(w,h)
							draw.RoundedBox( 0, 0, 0, w, h, Color(35, 35, 35))
							draw.RoundedBox( 0, 2, 2, w-4, 16, Color(128, 128, 128))
						end	
					end
					local bu = v:GetChildren()[11]
					bu.DoClick = function()
						if LocalPlayer() == pl then
							net.Start("ASayPopupClose")
							net.WriteEntity(noob)
							net.SendToServer()
						else
							v:Close()
						end
					end
					
				end
			end
		end
	end)
	
	concommand.Add( "adminpopups_claimtop", function( ply, cmd, args )
		if #aframes > 0 then
			local button = aframes[1].ClaimButton or aframes[1]:GetChildren()[11] -- button we want is 10th child of frame #1
			button.DoClick() --no need to write it all again.
		end	
	end)

	gameevent.Listen( "player_disconnect" )
	hook.Add("player_disconnect", "RemoveAdminNotifications", function( data )
		local name = data.name			// Same as Player:Nick()
		local steamid = data.networkid		// Same as Player:SteamID()
		local id = data.userid			// Same as Player:UserID()
		local bot = data.bot			// Same as Player:IsBot()
		local reason = data.reason		// Text reason for disconnected such as "Kicked by console!", "Timed out!", etc...

		for _,panel in ipairs(aframes) do
			if panel.steamID == steamid then
				panel:Remove()
			end
		end
	end)
	
end

hook.Add( "ASayPopupClaim", "ClaimedNotification", function( admin, noob )
	if IsValid( noob ) && IsValid( admin ) then
		noob:notify( admin:Nick() .. " has taken your ticket and will assist you momentarily. If they do not, feel free to report them." )
	end
end)