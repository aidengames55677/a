-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\drug_bulk\\sh_bulk_heroin.lua"

ITEM.name = "Heroin Brick"
ITEM.desc = "A large amount of heroin pressed into a brick."
ITEM.category = "Drugs"
ITEM.model = "models/gdrugs/cocaine/cocaine.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.logCity = true

function ITEM:getDesc()
	if self:getData("shippedMiami") then
		return self.desc.."\n\nOriginated in: UnionCity"
	elseif self:getData("shippedNewYork") then
		return self.desc.."\n\nOriginated in: SouthSide"
	else
		return self.desc.."\n\nOriginated in: Unknown"
	end
end