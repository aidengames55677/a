function PLUGIN:HUDPaint()
	-- Draw the player's sub-faction on their HUD.
	local subFaction = self:getPlayerSubFaction(LocalPlayer())
	draw.SimpleText("Sub-Faction: "..subFaction, "Default", ScrW() / 2, ScrH() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
