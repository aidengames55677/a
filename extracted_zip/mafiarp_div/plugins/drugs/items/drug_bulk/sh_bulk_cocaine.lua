-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\drug_bulk\\sh_bulk_cocaine.lua"

ITEM.name = "Cocaine Brick"
ITEM.desc = "A large amount of cocaine pressed into a brick."
ITEM.category = "Drugs"
ITEM.model = "models/srcocainelab/cocainebrick.mdl"
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