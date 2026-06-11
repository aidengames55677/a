-- "gamemodes\\mafiarp\\schema\\items\\sh_briefcase.lua"

ITEM.name = "Briefcase"
ITEM.desc = "AHHHHHHHHHHHHHHHHHHHHH"
ITEM.model = "models/props_c17/briefcase001a.mdl"

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if newInventory and oldInventory != newInventory and !newInventory.data.char then
		return false
	end

	return true
end