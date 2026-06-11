local PLUGIN = PLUGIN
PLUGIN.name = "NutScript Theme"
PLUGIN.author = "Cheesenut"
PLUGIN.desc = "Adds a dark Derma skin for NutScript."

if (CLIENT) then
	function PLUGIN:ForceDermaSkin()
		return "nutscript"
	end

	function PLUGIN:SpawnMenuOpen()
		timer.Simple(0, function()
			g_SpawnMenu:SetSkin("Default")
			g_SpawnMenu:GetToolMenu():SetSkin("Default")

			timer.Simple(0, function()
				derma.RefreshSkins()
			end)
		end)
	end

	function PLUGIN:OnContextMenuOpen()
		timer.Simple(0, function()
			g_ContextMenu:SetSkin("Default")

			timer.Simple(0, function()
				derma.RefreshSkins()
			end)
		end)
	end
	--[[if !EventServer then 
		PLUGIN.oldSetActiveControlPanel = PLUGIN.oldSetActiveControlPanel or spawnmenu.SetActiveControlPanel
		function spawnmenu.SetActiveControlPanel(pnl)
			pnl:SetSkin("Default")

			PLUGIN.oldSetActiveControlPanel(pnl)
		end
	end]]
end
