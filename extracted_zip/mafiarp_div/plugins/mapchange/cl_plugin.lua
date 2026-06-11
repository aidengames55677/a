-- "gamemodes\\mafiarp\\plugins\\mapchange\\cl_plugin.lua"

mapchangetimer = 0

net.Receive("MapCountdownTimer", function()
	mapchangetimer = CurTime()+tonumber(net.ReadString())
end)

hook.Add("HUDPaint","MapCountdown", function()
	if (CurTime()<mapchangetimer) then
		surface.SetFont("Trebuchet24")
        local timeleft = math.floor(mapchangetimer - CurTime())
		local text = "Changing maps in: " ..(timeleft>60 and math.floor(timeleft/60)..":"..math.floor(timeleft%60) or math.floor(timeleft).." seconds.")
		local w,h = surface.GetTextSize(text)
		draw.RoundedBox(5, ScrW() - 15 - w, 5, w + 10, h+10, Color(0, 0, 0, 200))
		draw.SimpleTextOutlined(text, "Trebuchet24", ScrW() - 10, 10, Color(128, 128, 128), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
	end
end)
