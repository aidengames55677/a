-- "gamemodes\\mafiarp\\schema\\items\\base\\sh_ammo.lua"

ITEM.name = "Ammo"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isStackable = true
ITEM.maxQuantity = 50
ITEM.ammo = "pistol" -- type of the ammo
ITEM.desc = ""
ITEM.category = "Ammunition"

--[[function ITEM:getDesc()
	return Format(self.ammoDesc or self.desc, self:getQuantity())
end--]]

function ITEM:paintOver(item, w, h)
	local quantity = item:getQuantity()
	
	nut.util.drawText(quantity, 8, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, "nutChatFont")
end

local loadAmount = {
	1,
	5,
	10,
	15,
	20,
	30,
	40,
	50
}

ITEM.functions.use = { -- sorry, for name order.
	name = "Load",
	tip = "useTip",
	icon = "icon16/add.png",
    isMulti = true,
    multiOptions = function(item, client)
        local options = {}

		table.insert(options, {
            name = L("ammoLoadAll"),
            data = 0,
        })
		for _, amount in pairs(loadAmount) do
			if (amount <= item:getQuantity()) then
				table.insert(options, {
					name = L("ammoLoadAmount", amount),
					data = amount,
				})
			end
		end
		table.insert(options, {
            name = L("ammoLoadCustom"),
            data = -1,
        })

        return options
	end,
	onClick = function(item, data)
		if (data == -1) then

			return false
		end
	end,
	onRun = function(item, data)
		data = data or 0

		if (data > 0) then
			local num = tonumber(data)
			item:addQuantity(-num)

			if item.class then
				item.player:Give(item.class)
			end

			item.player:GiveAmmo(num, item.ammo)
			item.player:EmitSound(item.useSound or "items/ammo_pickup.wav", 110)
		elseif (data == 0) then

			if item.class then
				item.player:Give(item.class)
			end

			item.player:GiveAmmo(item:getQuantity(), item.ammo)
			item.player:EmitSound(item.useSound or "items/ammo_pickup.wav", 110)
			return true
		end
		return item:getQuantity() <= 0
	end,
}
