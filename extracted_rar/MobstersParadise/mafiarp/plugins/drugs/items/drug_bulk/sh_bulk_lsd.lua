-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\drug_bulk\\sh_bulk_lsd.lua"

ITEM.name = "Lysergic Acid Container"
ITEM.desc = "A large barrel of lysergic acid."
ITEM.category = "Drugs"
ITEM.model = "models/props_c17/oildrum001.mdl"
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