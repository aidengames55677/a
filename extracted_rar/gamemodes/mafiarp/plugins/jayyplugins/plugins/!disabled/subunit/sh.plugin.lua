PLUGIN.name = "Units"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.description = "Adds a sub-faction system."

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")
nut.util.include("sh_commands.lua")

PLUGIN.units = PLUGIN.units or {}

function PLUGIN:loadUnits(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		UNIT = self.units[niceName] or {}

		-- Assign a unique index to the unit.
		UNIT.index = "UNIT_"..niceName:upper()

		nut.util.include(directory.."/"..v, "shared")

		if (!UNIT.name) then
			UNIT.name = "Unknown"
			ErrorNoHalt("Unit '"..niceName.."' is missing a name. You need to add a UNIT.name = \"Name\"\n")
		end

		if (!UNIT.desc) then
			UNIT.desc = "noDesc"
			ErrorNoHalt("Unit '"..niceName.."' is missing a description. You need to add a UNIT.desc = \"Description\"\n")
		end

		self.units[niceName] = UNIT
		UNIT = nil
	end
end

function PLUGIN:getUnit(identifier)
	return self.units[identifier]
end

function PLUGIN:setPlayerUnit(client, unitIndex)
	local unit = self:getUnit(unitIndex)

	if unit then
		if client:Team() == nut.faction.getIndex(unit.faction) then
			client:setNetVar("unit", unit.index)
		else
			ErrorNoHalt("Client is not in the correct faction for unit '"..unitIndex.."'.\n")
		end
	else
		ErrorNoHalt("Unit '"..unitIndex.."' does not exist.\n")
	end
end

function PLUGIN:getPlayerUnit(client)
	return client:getNetVar("unit")
end

function PLUGIN:removePlayerUnit(player)
	client:setNetVar("unit", nil)
end
