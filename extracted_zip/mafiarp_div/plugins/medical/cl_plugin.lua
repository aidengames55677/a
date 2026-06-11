local PLUGIN = PLUGIN

/*
	Networking
*/

local function nutNetworkInjury(len)
	local injuryType = net.ReadString()
	local givenTaken = net.ReadBool()

	if givenTaken then
		LocalPlayer():getChar():giveInjury(injuryType)
	else
		LocalPlayer():getChar():takeInjury(injuryType)
	end
end
net.Receive("nutNetworkInjury", nutNetworkInjury)

/*
	Injuries
*/

-- this one is mostly serverside
nut.medical.createInjury("legShot", {
	hooks = {
		StartCommand = function(client, cmd)
			if !client:hasInjury("legShot") then return end

			if cmd:KeyDown(IN_JUMP) then
				cmd:RemoveKey(IN_JUMP)
			end

			if cmd:KeyDown(IN_SPEED) then
				cmd:RemoveKey(IN_SPEED)
			end
		end,
	}
})