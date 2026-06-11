-- "gamemodes\\mafiarp\\plugins\\bonemerge\\entities\\entities\\clothing_vendor_pendretti\\cl_init.lua"

include( "shared.lua" )

local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
    
ENT.DrawEntityInfo = true
ENT.Pendretti = true
ENT.VIP = false

function ENT:onDrawEntityInfo(alpha)
    local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
    local x, y = position.x, position.y

    drawText("Steven Pendretti", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
    drawText("Buy Clothes (Press E)", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end