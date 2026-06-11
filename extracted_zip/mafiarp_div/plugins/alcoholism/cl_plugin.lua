-- "gamemodes\\mafiarp\\plugins\\alcoholism\\cl_plugin.lua"

local PLUGIN = PLUGIN

function PLUGIN:HUDPaint()
	if LocalPlayer():GetNW2Int("nut_alcoholism_bac", 0) > 0 then
		
	end
end

function PLUGIN:RenderScreenspaceEffects()
	if LocalPlayer():GetNW2Int("nut_alcoholism_bac", 0) > 0 then
		DrawMotionBlur(nut.config.get("alcoholism_effect_addalpha", 0.03), LocalPlayer():GetNW2Int("nut_alcoholism_bac", 0)/100, nut.config.get("alcoholism_effect_delay", 0))
	end
end