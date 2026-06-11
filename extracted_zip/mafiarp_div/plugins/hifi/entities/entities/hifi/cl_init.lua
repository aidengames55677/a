-- "gamemodes\\mafiarp\\plugins\\hifi\\entities\\entities\\hifi\\cl_init.lua"

include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

local TEXT_OFFSET = Vector(0, 0, 0)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get

ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo(alpha)
	local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
	local x, y = position.x, position.y
	drawText("Hi-Fi", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
end