-- "gamemodes\\1942rp\\plugins\\savebodygroups.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLUGIN = PLUGIN

PLUGIN.name = "Save Bodygroups"
PLUGIN.desc = "Saves any set bodygroups."
PLUGIN.author = "Zoephix"

if (SERVER) then
	function PLUGIN:CharacterPreSave(character)
		/*local groups = character:getData("groups", {})

		for _, bodygroup in pairs(character:getPlayer():GetBodyGroups()) do
			groups[bodygroup.id] = bodygroup.num
		end

		character:setData("groups", groups)*/
	end
end
