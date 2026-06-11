-- This is sv_plugin.lua
local PLUGIN = PLUGIN

-- Server-side logic for the "nutEquipToSlot" network message.
util.AddNetworkString("nutEquipToSlot")

net.Receive("nutEquipToSlot", function(len, client)
	local itemID = net.ReadUInt(32)
	local item = nut.item.instances[itemID]

	if not item then return end
	if not item.usesEquipSlot then return end

	-- You can add your server-side logic here. For example:
	item:setData("equip", true)
end)

-- Server-side logic for the "invAct" network message.
util.AddNetworkString("invAct")

net.Receive("invAct", function(len, client)
	local action = net.ReadString()
	local itemID = net.ReadUInt(32)
	local invID = net.ReadUInt(32)
	local item = nut.item.instances[itemID]

	if not item then return end
	if action == "Unequip" then
		-- You can add your server-side logic here. For example:
		item:setData("equip", false)
	end
end)
