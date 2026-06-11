PLUGIN.name = "Watermark"
PLUGIN.author = "Robert Bearson"
PLUGIN.desc = "Provides a watermark on top of screen"

SCHEMA.version = '1.1.0 (Base Switch)'

resource.AddFile("materials/artemis/mobparlogo.png")

if CLIENT then
	local agLogo = Material("artemis/mobparlogo.png")
	hook.Add("HUDPaint", "watermarkpaint", function()
		local w,h = 45,45

		surface.SetMaterial(agLogo)
		surface.SetDrawColor(255, 255, 255, 80)
		surface.DrawTexturedRect(5, ScrH()-h-5, w, h)
		
		surface.SetTextColor(255, 255, 255, 80)
		surface.SetFont("WB_Medium")
		local tw,th = surface.GetTextSize(SCHEMA.version)
		surface.SetTextPos(15 + w, ScrH()-5-h/2-th/2)
		surface.DrawText(SCHEMA.version)
	end)
end