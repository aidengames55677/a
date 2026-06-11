if SERVER then
	hook.Add("PlayerSpawn", "setMaxCharsPerPlayer", function(ply)
		local maxCharDonation = nut.data.get("charslotsteamids", {}, nil, true)
		if maxCharDonation[ply:SteamID()] then
			MsgC(Color(0,255,0), "Player " .. ply:Nick() .. " previously donated and has " .. maxCharDonation[ply:SteamID()] .. " slots\n")
			ply:setNetVar("overrideSlots", maxCharDonation[ply:SteamID()])
		end
	end)

	function setOverrideCharSlots(ply)
		for k,v in pairs(player.GetAll()) do
			if ply and v == ply then
				local contents = nut.data.get("charslotsteamids", {}, nil, true)

				if contents[v:SteamID()] then
					contents[v:SteamID()] = contents[v:SteamID()] + 1
				else
					contents[v:SteamID()] = nut.config.get("maxChars") + 1
				end

				nut.data.set("charslotsteamids", contents, nil, true)
				v:setNetVar("overrideSlots", contents[v:SteamID()])
			elseif v:SteamID() == Prometheus.Temp.SteamID then
				local contents = nut.data.get("charslotsteamids", {}, nil, true)

				if contents[v:SteamID()] then
					contents[v:SteamID()] = contents[v:SteamID()] + 1
				else
					contents[v:SteamID()] = nut.config.get("maxChars") + 1
				end

				v:setNetVar("overrideSlots", contents[v:SteamID()])
				nut.data.set("charslotsteamids", contents, nil, true)
			end
		end
	end
end
