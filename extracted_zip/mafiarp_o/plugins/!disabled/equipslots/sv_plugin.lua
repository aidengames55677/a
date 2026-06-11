-- This is sv_plugin.lua
local PLUGIN = PLUGIN

-- Server-side logic for the "nutEquipToSlot" network message.
util.AddNetworkString("nutEquipToSlot")
-- Server-side logic for the "invAct" network message.
util.AddNetworkString("invAct")

net.Receive("nutEquipToSlot", function(len, client)
	local itemID = net.ReadUInt(32)
	local item = nut.item.instances[itemID]

	if not item or not item.isClothing then return end

	-- Equip the item.
	item:setData("equip", true)

	-- Call the onEquip function.
	item:onEquip(client)
end)

net.Receive("invAct", function(len, client)
	local action = net.ReadString()
	local itemID = net.ReadUInt(32)
	local invID = net.ReadUInt(32)
	local item = nut.item.instances[itemID]

	if not item or not item.isClothing then return end

	if action == "Unequip" then
		-- Unequip the item.
		item:setData("equip", false)

		-- Call the onUnequip function.
		item:onUnequip(client)
	end
end)
