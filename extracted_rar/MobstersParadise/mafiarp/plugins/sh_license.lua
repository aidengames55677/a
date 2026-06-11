PLUGIN.name = "Gun License"
PLUGIN.author = "CallowayIsWeird"
PLUGIN.desc = "Adds gun licenses for items"


local badItems = {
	["m1911colt"] = true,
	["luger"] = true,
	["coltpython"] = true,
	["sw686"] = true,
}

local heavyItems = {
	["mg42"] = true,
	["m1carbine"] = true,
	["m1a1"] = true,
	["mossberg500a"] = true,
	["m3smg"] = true
}

local licenseTbl = {
	["m1911colt"] = "permit_gun",
	["luger"] = "permit_gun",
	["coltpython"] = "permit_gun",
	["sw686"] = "permit_gun",
	
}


hook.Add("CanPlayerTradeWithVendor", "LicenseHook", function(client, ent, id, isSelling)
	if (isSelling) then
		return true
	end

	if (badItems[id]) then
		if (client:getChar():getInv():hasItem(licenseTbl[id])) then
			return true
		else
			client:notify("You do not have a gun license. Go to City Hall to retreive one.")
			return false
		end
	end

	if (heavyItems[id]) then
		if (client:getChar():getInv():hasItem(licenseTbl[id])) then
			return true
		else
			client:notify("You do not have a heavy weapons license.")
			return false
		end
	end
end)