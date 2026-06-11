-- "gamemodes\\mafiarp\\plugins\\bank\\entities\\entities\\atm\\cl_init.lua"


include( "shared.lua" )


local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get

ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo(alpha)
    local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
    local x, y = position.x, position.y
    local desc = self.getNetVar(self, "desc")

    drawText("Automated Teller Machine", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
end