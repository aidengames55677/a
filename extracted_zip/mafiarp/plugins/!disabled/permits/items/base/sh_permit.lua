ITEM.name = "Permit Base"
ITEM.model = "models/lordtrilobite/starwars/props/imp_datatape.mdl"
ITEM.desc = "Allows you to buy stuff from the business menu."
ITEM.flag = "b"
ITEM.price = 500
ITEM.category = "Permits"

ITEM.functions.Claim = {
	name = "Claim Permit",
	icon = "icon16/page_white_paintbrush.png",
	onRun = function(item)
		local client = item.player
		item:setData("owner", client:getChar():getID())

		return false
	end,
	onCanRun = function(item)
		if(item:getData("owner")) then
			return false
		end
	end
}