-- "gamemodes\\mafiarp\\plugins\\payphones\\entities\\entities\\payphone\\cl_init.lua"

include("shared.lua")

/*
	Networking
*/

net.Receive("Payphone_Activate", function(len)
	local payphoneEnt = net.ReadEntity()

	local pnl = vgui.Create("nutPhoneDialer")
	pnl:SetEntity(payphoneEnt)
end)