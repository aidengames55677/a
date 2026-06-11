-- "gamemodes\\mafiarp\\schema\\items\\sh_cigarbox.lua"

ITEM.name = "Cigar Box"
ITEM.desc = "A box of finely rolled cigars."
ITEM.model = "models/polievka/cigarbox.mdl"
ITEM.price = 2500
ITEM.PackNum = 16
ITEM.category = "Drugs"

ITEM.functions.TakeOutCigar = {
	name = "Take out Cigar",
	onRun = function(item)
		local client = item.player
		local inv = client:getChar():getInv()
		item.PackNum = item:getData("cigarLeft")

		if (item.PackNum > 1) then
			item:setData("cigarLeft", item.PackNum - 1)

			inv:add("cigar")
		else
			inv:add("cigar")
			item:remove()
		end

		return false
	end
}

function ITEM:getDesc()
	local cigarLeft = self:getData("cigarLeft") or 16
	local description = "A box of "..cigarLeft.." finely rolled cigars."

	if (cigarLeft == 1) then
		description = "A lone cigar in a box."
	end

	return description
end