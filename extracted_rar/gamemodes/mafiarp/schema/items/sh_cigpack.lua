ITEM.name = "Cigarette Pack"
ITEM.desc = "A pack of cigarettes."
ITEM.model = "models/mordeciga/mordes/pachkablat.mdl"
ITEM.price = 100
ITEM.PackNum = 10
ITEM.category = "Drugs"

ITEM.functions.TakeOutCig = {
	name = "Take out Cigarette",
	onRun = function(item)
		local client = item.player
		local inv = client:getChar():getInv()
		item.PackNum = item:getData("cigLeft")

		if (item.PackNum > 1) then
			item:setData("cigLeft", item.PackNum - 1)

			inv:add("cigarette")
		else
			inv:add("cigarette")
			item:remove()
		end

		return false
	end
}

function ITEM:getDesc()
	local cigLeft = self:getData("cigLeft") or 10
	local description = "A pack of "..cigLeft.." cigarettes."

	if (cigLeft == 1) then
		description = "A lone cigarette in a pack."
	end

	return description
end