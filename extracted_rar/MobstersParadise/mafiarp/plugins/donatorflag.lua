local PLUGIN = PLUGIN
PLUGIN.name = "Donator Flags"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Flags for donators."

PLUGIN.donatorGroups = {
	["founder"] = "petrCzg",
	["superadmin"] = "petrCzg",
	["senioradmin"] = "petrCzg",
	["admin"] = "petrCzg",
	["moderator"] = "petrCzg",
	["diamond"] = "petCzg",
	["plat"] = "petCzg",
	["gold"] = "petCzg",
	["silver"] = "pet",
}

function PLUGIN:PlayerLoadedChar(client, char)
	local usergroup = client:GetUserGroup()

	local group = PLUGIN.donatorGroups[usergroup]
	if(group && !char:hasFlags(group)) then
		char:giveFlags(group)
	end
end

nut.command.add("plystripflags", {
	adminOnly = true,
	syntax = "<string target> <string flags>",
	onRun = function(client, arguments)
		local flags = arguments[2]
		
		if(!arguments[2]) then
			client:notify("Specify flags to remove.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		
		if(IsValid(target) and target:getChar()) then
			local charList = target.nutCharList
			
			for k, v in pairs(charList) do
				local char = nut.char.loaded[v]
				if(char) then
					char:takeFlags(arguments[2])
				end
			end
		end
	end
})