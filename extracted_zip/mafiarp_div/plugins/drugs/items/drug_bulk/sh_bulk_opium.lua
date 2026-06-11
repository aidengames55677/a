-- "gamemodes\\mafiarp\\plugins\\drugs\\items\\drug_bulk\\sh_bulk_opium.lua"

ITEM.name = "Bulk Opium"
ITEM.desc = "A large box of freshly harvested opium poppy."
ITEM.category = "Drugs"
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
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