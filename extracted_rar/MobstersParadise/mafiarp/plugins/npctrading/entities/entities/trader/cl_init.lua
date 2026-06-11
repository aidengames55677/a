-- "gamemodes\\mafiarp\\plugins\\npctrading\\entities\\entities\\trader\\cl_init.lua"

include( "shared.lua" )

local TEXT_OFFSET = Vector( 0, 0, 20 )
local toScreen = FindMetaTable( "Vector" ).ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get

ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo( alpha )
	local position = toScreen( self:LocalToWorld( self:OBBCenter() ) + TEXT_OFFSET )
	local x, y = position.x, position.y
	local desc = self:GetTraderDesc()

	-- Draw the name of the vendor.
	drawText(
		self:GetTraderName(),
		x, y,
		colorAlpha( configGet( "color" ), alpha ),
		1, 1,
		nil,
		alpha * 0.65
	)

	-- Draw the vendor's description below the name.
	if desc and desc ~= "" then
		drawText(
			desc,
			x, y + 16,
			colorAlpha( color_white, alpha ),
			1, 1,
			"nutSmallFont",
			alpha * 0.65
		)
	end
end