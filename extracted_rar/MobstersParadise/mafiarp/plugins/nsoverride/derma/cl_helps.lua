-- "gamemodes\\mafiarp\\plugins\\nsoverride\\derma\\cl_helps.lua"

if (CLIENT) then
	local HELP_DEFAULT

	hook.Add("CreateMenuButtons", "nutHelpMenu", function(tabs)		
		HELP_DEFAULT = [[
			<div id="parent"><div id="child">
				<center>
				    <img src="https://bans.divergenet.works/assets/images/logo.png"></img>
					<br><font size=15>]] .. "Select a category on the left" .. [[</font>
				</center>
			</div></div>
		]]

		tabs["help"] = function(panel)
			local html
			local header = [[<html>
			<head>
				<style>
					@import url(http://fonts.googleapis.com/earlyaccess/jejugothic.css);

					#parent {
					    padding: 5% 0;
					}

					#child {
					    padding: 10% 0;
					}

					body {
						color: #FAFAFA;
						font-family: 'Jeju Gothic', serif;
						-webkit-font-smoothing: antialiased;
					}

					h2 {
						margin: 0;
					}
				</style>
			</head>
			<body>
			]]

			local tree = panel:Add("DTree")
			tree:SetPadding(5)
			tree:Dock(LEFT)
			tree:SetWide(180)
			tree:DockMargin(0, 0, 15, 0)
			tree.OnNodeSelected = function(this, node)
				if (node.onGetHTML) then
					html:SetHTML(header..node:onGetHTML().."</body></html>")
				end
			end

			html = panel:Add("DHTML")
			html:Dock(FILL)
			html:SetHTML(header..HELP_DEFAULT)

			local tabs = {}
			hook.Run("BuildHelpMenu", tabs)

			for k, v in SortedPairs(tabs) do
				if (type(v) != "function") then
					local source = v

					v = function() return tostring(source) end
				end

				tree:AddNode(L(k)).onGetHTML = v or function() return "" end
			end
		end
	end)
end

hook.Add("BuildHelpMenu", "nutBasicHelp", function(tabs)
	tabs["Rules"] = function(node)
		// Fucking piece of shit
		local body = [[ 
			<div id="parent"><div id="child">
				<center>
				    <img src="https://bans.divergenet.works/assets/images/logo.png"></img>
					<br><font size=15>]] .. "Select a category on the left" .. [[</font>
				</center>
			</div></div>
		]]
		local f = vgui.Create("DFrame")
		f:SetSize(ScrW()*0.8, ScrH()*0.8)
		f:SetTitle("Rules")
		f:Center()
		f:MakePopup()
		local h = vgui.Create("DHTML", f)
		h:Dock(FILL)
		h:OpenURL("https://divergenet.works/forums/forumdisplay.php?fid=34")
		return body
	end

	tabs["Guides"] = function(node)
		// Fucking piece of shit
		local body = [[ 
			<div id="parent"><div id="child">
				<center>
				    <img src="https://bans.divergenet.works/assets/images/logo.png"></img>
					<br><font size=15>]] .. "Select a category on the left" .. [[</font>
				</center>
			</div></div>
		]]
		local f = vgui.Create("DFrame")
		f:SetSize(ScrW()*0.8, ScrH()*0.8)
		f:SetTitle("Guides")
		f:Center()
		f:MakePopup()
		local h = vgui.Create("DHTML", f)
		h:Dock(FILL)
		h:OpenURL("https://divergenet.works/forums/forumdisplay.php?fid=26")
		return body
	end

	tabs["Map"] = function(node)
		local body = '<center><img src="https://imgur.com/Ps49A2Z.png"></img></center>'
		return body
	end

	tabs["City Penal Code"] = function(node)
		// Fucking piece of shit
		local body = [[ 
			<div id="parent"><div id="child">
				<center>
				    <img src="https://bans.divergenet.works/assets/images/logo.png"></img>
					<br><font size=15>]] .. "Select a category on the left" .. [[</font>
				</center>
			</div></div>
		]]
		local f = vgui.Create("DFrame")
		f:SetSize(ScrW()*0.8, ScrH()*0.8)
		f:SetTitle("Penal Code")
		f:Center()
		f:MakePopup()
		local h = vgui.Create("DHTML", f)
		h:Dock(FILL)
		h:OpenURL("https://docs.google.com/spreadsheets/d/1422VD5qQu4PRSfoOnJmfItYBbWPryMiHUweFv6DAGKI/edit#gid=89765877")
		return body
	end

	tabs["Federal Penal Code"] = function(node)
		// Fucking piece of shit
		local body = [[ 
			<div id="parent"><div id="child">
				<center>
				    <img src="https://bans.divergenet.works/assets/images/logo.png"></img>
					<br><font size=15>]] .. "Select a category on the left" .. [[</font>
				</center>
			</div></div>
		]]
		local f = vgui.Create("DFrame")
		f:SetSize(ScrW()*0.8, ScrH()*0.8)
		f:SetTitle("Penal Code")
		f:Center()
		f:MakePopup()
		local h = vgui.Create("DHTML", f)
		h:Dock(FILL)
		h:OpenURL("https://docs.google.com/spreadsheets/d/1wkJmyWdUdMEVaU9JTImcZL9z3ttb4dR2wjhTLl5vWQM/edit#gid=89765877")
		return body
	end
end)