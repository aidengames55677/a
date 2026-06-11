ITEM.name = "Weapon Oil"

ITEM.desc = "Oil used to clean a weapon."

ITEM.model = "models/nseven/bottle01.mdl"

ITEM.uniqueID = "repairkit"




ITEM.price = 45



ITEM.Uses = 8

ITEM.rechargeFee = 12

ITEM.healAmount = 25 -- Heals X Durability per Charge


onCanRun = function(item)

	local usesLeft = item:getData("Uses", item.Uses) or item.Uses



	return (!IsValid(item.entity) and item.player:getChar():hasFlags("W") and usesLeft < item.Uses)

end

------------------------------------------------------------------ Boring Shit



ITEM.functions._info = {

	name = "This item requires special flags to use!",

	tip = "",

	icon = "icon16/exclamation.png",

	onRun = function(item)

		local client = item.player



		client:notify("You do not have the required flags to use this item.")

		

	return false

end,

	onCanRun = function(item)

		return (!IsValid(item.entity) and (!item.player:getChar():hasFlags("W")))

	end

}



if (CLIENT) then

	function ITEM:paintOver(item, w, h)

		local usesLeft = item:getData("Uses", item.Amount) or item.Uses

	

		draw.SimpleText(usesLeft.."/"..item.Uses, "DermaDefault", 5, h-5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)

	end

end