-- "gamemodes\\mafiarp\\plugins\\casinonpc\\entities\\entities\\casinonpc\\cl_init.lua"


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

    -- Draw the name of the vendor.
    drawText(
        "Casino Manager",
        x, y,
        colorAlpha( configGet( "color" ), alpha ),
        1, 1,
        nil,
        alpha * 0.65
    )

    drawText(
        self:IsCasinoSetup() and self:GetCasinoName() or "This casino is not set up.",
        x, y + 16,
        colorAlpha( color_white, alpha ),
        1, 1,
        "nutSmallFont",
        alpha * 0.65
    )
end