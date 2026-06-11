PLUGIN.name = "Multicore Rendering Setting"
PLUGIN.author = "Killing Torcher"
PLUGIN.desc = "Makes multicore rendering an option."

MULTICORE_CONVAR = "gmod_mcore_test"


if (SERVER) then
	util.AddNetworkString("Multicore::UpdateSetting")
	util.AddNetworkString("Multicore::SetConvar")
	util.AddNetworkString("Multicore::FirstTime")
	
	function PLUGIN:OnLoaded()
		local qr = sql.Query([[CREATE TABLE IF NOT EXISTS `multicore_settings` (
	`steamID` INTEGER,
	`use_multicore` TEXT
);
		]])
		if (qr == false) then
			print("[MulticoreSettings] Query returned an error (id=3)")
			return
		end
	end
	
	net.Receive("Multicore::UpdateSetting", function(len, ply)
		local value = sql.SQLStr(net.ReadString(), true)
		if (value != "1" && value != "0") then return end
		
		local data = sql.Query("SELECT * FROM multicore_settings WHERE steamID="..ply:SteamID64())
		if (data == false) then
			print("[MulticoreSettings] Query returned an error (id=1)")
			return
		end
		
		if (data == nil) then
			local ret = sql.Query("INSERT INTO multicore_settings (steamID, use_multicore) VALUES("..ply:SteamID64()..", '"..value.."')")
			
			if (ret == false) then
				print("[MulticoreSettings] Query returned an error (id=2)")
				return
			end
		else
			
			local ret = sql.Query("UPDATE multicore_settings SET use_multicore='"..value.."' WHERE steamID="..ply:SteamID64())
		end
	end)
	
		
	hook.Add("PlayerInitialSpawn", "Multicore::PlayerConnect", function(ply)
	
		local ret = sql.Query("SELECT * FROM multicore_settings WHERE steamID="..ply:SteamID64())
		if (ret == false) then
			print("[MulticoreSettings] Query returned an error (id=4)")
			return
		end
		
		if (ret == nil) then
			net.Start("Multicore::FirstTime")
			net.Send(ply)
			return
		end

		local wrtStr = ret[1].use_multicore
		if (wrtStr == "1" or wrtStr == "0") then
			net.Start("Multicore::SetConvar")
			net.WriteString(wrtStr)
			net.Send(ply)
		end
	end)
else

	function PLUGIN:SetupQuickMenu(menu)
		 local button = menu:addCheck("Multicore Rendering", function(panel, state)
			
		 	if (state) then
		 		RunConsoleCommand(MULTICORE_CONVAR, "1")
		 	else
		 		RunConsoleCommand(MULTICORE_CONVAR, "0")
		 	end
			
			net.Start("Multicore::UpdateSetting")
			if (state) then net.WriteString("1")
			else net.WriteString("0")
			end
			net.SendToServer()
			
		 end, GetConVar(MULTICORE_CONVAR):GetBool())
		

		
		 menu:addSpacer()
	end
	
	hook.Add("PlayerInitialSpawn", "Multicore::InitialSpawn", function(ply)
		if (ply == LocalPlayer()) then
			local set = GetConVar(MULTICORE_CONVAR):GetBool()
			if (set) then MULTICORE_PREJOIN_SETTING = "1"
			else MULTICORE_PREJOIN_SETTING = "0"
			end
		end
	end)
	
	net.Receive("Multicore::SetConvar", function()
		RunConsoleCommand(MULTICORE_CONVAR, net.ReadString())
	end)
	
	--[[net.Receive("Multicore::FirstTime", function()
		Derma_Query("Do you wish to enable Multicore Rendering?", "Multicore rendering", "Yes", function() 
			RunConsoleCommand(MULTICORE_CONVAR, "1")
			net.Start("Multicore::UpdateSetting")
			net.WriteString("1")
			net.SendToServer()
		end, "No", function()
			RunConsoleCommand(MULTICORE_CONVAR, "0")
			net.Start("Multicore::UpdateSetting")
			net.WriteString("0")
			net.SendToServer()
		end)
	end)]]
end
