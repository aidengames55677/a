-- "gamemodes\\mafiarp\\plugins\\rjobs\\sh_plugin.lua"

PLUGIN.name = "rJobs"
PLUGIN.author = "Recoded by rusty & Pendred"
PLUGIN.desc = "A jobs system with NPC dialogue, waypoints, and interactable tasks."

local PLAYER = FindMetaTable("Player")
function PLAYER:SetWeighPoint(name, vector, OnReach)
	local name2 = math.random(1000, 100000000)
	if name == "911 Call" then
		timer.Simple(30, function()
			hook.Remove("HUDPaint", "WeighPoint"..name2)
			if OnReach then
				OnReach()
			end
		end)
	end
	hook.Add("HUDPaint", "WeighPoint"..name2, function()
		local dist = self:GetPos():Distance(vector)
		local spos = vector:ToScreen()

		local howclose = math.Round(math.floor(dist) / 40)

		if !spos then return end

		surface.SetTextColor(128, 128, 128)

		if name == "911 Call" then
			surface.SetTextColor(54,127,255)
		end
		surface.SetFont("Trebuchet18")

		local tW, tH = surface.GetTextSize(name)
		surface.SetTextPos(spos.x - (tW / 2), spos.y)
		surface.DrawText(name)

		local distText = howclose .. " Meters"
		tW, tH = surface.GetTextSize(distText)
		surface.SetTextPos(spos.x - (tW / 2), spos.y + 16)
		surface.DrawText(distText)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("icon16/arrow_down.png"))
		surface.DrawTexturedRect(spos.x - 15, spos.y - 35, 32, 32)

		if howclose <= 3 then 
			hook.Remove("HUDPaint", "WeighPoint"..name2)
			if OnReach then
				OnReach()
			end
		end
	end)
end
