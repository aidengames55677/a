/*
	Networking:
*/

net.Receive("DAfk", function()
	local bool = net.ReadBool()
	if (!bool) then
		Derma_Query("You are about to be kicked for being AFK!", "AFK Redirection", "Stop! I'm not AFK!", function()
			net.Start("DAfk")
			net.SendToServer()
		end)
	else
		print('Kicked for being AFK.')
		RunConsoleCommand('disconnect')
	end
end)