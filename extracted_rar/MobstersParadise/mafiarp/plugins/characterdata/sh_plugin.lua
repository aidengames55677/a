PLUGIN.name = "Fix Character Data"
PLUGIN.author = "rusty"
PLUGIN.desc = "Convert character data to use its own DB table"

nut.util.include("sv_plugin.lua")

local CHARACTER = nut.meta.character

function CHARACTER:setData(key, value, noReplication, receiver)
	if !self.dataVars then
		self.dataVars = {}
	end

	local keysToNetwork = {}
	if istable(key) then
		self.dataVars = key
		keysToNetwork = table.GetKeys(self.dataVars)
	else
		self.dataVars[key] = value
		table.insert(keysToNetwork, key)
	end

	if SERVER then
		if !noReplication then
			net.Start("nutCharacterData")
				net.WriteUInt(self:getID(), 32)
				net.WriteUInt(#keysToNetwork, 32)

				for _,key in next, keysToNetwork do
					net.WriteString(key)
					net.WriteType(self.dataVars[key])
				end
			net.Send(receiver or self:getPlayer())
		end

		if value == nil then
			nut.db.delete(
				"chardata",
				"_charID = "..self:getID().." AND _key = '"..nut.db.escape(key).."'"
			)
		else
			nut.db.upsert(
				{_charID = self:getID(), _key = key, _value = pon.encode({value})},
				"chardata"
			)
		end
	end
end

function CHARACTER:getData(key, default)
	if !key then
		return self.dataVars
	end

	return self.dataVars and self.dataVars[key] or default
end

if SERVER then
	util.AddNetworkString("nutCharacterData")
else
	local function nutCharacterData(len)
		local character = nut.char.loaded[net.ReadUInt(32)]
		if !character then return end
		if !character.dataVars then
			character.dataVars = {}
		end

		local keyCount = net.ReadUInt(32)
		for i = 1, keyCount do
			character.dataVars[net.ReadString()] = net.ReadType()
		end
	end
	net.Receive("nutCharacterData", nutCharacterData)
end