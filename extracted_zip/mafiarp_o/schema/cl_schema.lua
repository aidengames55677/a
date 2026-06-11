net.Receive("DSendMessage", function()
	chat.AddText(Color(255, 255, 255), unpack(net.ReadTable()))
end)

hook.Add("InitPostEntity", "Notify32BitClients", function()
	if BRANCH != "x86-64" then
		timer.Simple(0, function()
			local pnl = Derma_Query(
				"Hey there, we noticed that you're running an older version of Garry's Mod. We highly recommend switch to the updated, more stable x64 branch of the game.\nSwitching comes with a ton of benefits, including less risk of crashing, increased performance, and more!", 
				"Garry's Mod 32-bit Client detected!", 
				"Okay", 
				function() 
					local f = vgui.Create("DFrame")
					f:SetSize(ScrW()*0.8, ScrH()*0.55)
					f:Center()
					f:MakePopup()
					local h = vgui.Create("DHTML", f)
					h:Dock(FILL)
					h:OpenURL("https://i.imgur.com/HHUeJnW.png")
				end
			)

			pnl:MakePopup()
		end)
	end
end)
--[[
	local helpMessages = {
        "Pressing F7 will make your character surrender.",
        "Your character needs to be fed often, purchase food from a hot dog vendor by pressing E on it, \nor by visiting a player-ran restaurant around the city.",
        "Need a job? Speak to the NPC in City Hall.",
        "This is a roleplay server, you should act seriously at all times and never break character. \nThis includes speaking about real life or Out Of Character (OOC) things In Character (IC).",
        "Note that any weapons will be lost if you die with them equipped.",
        "Press F1 to view your character, and check the contents of your inventory. \nNot working? Type into console: bind f1 gm_showhelp",
        "The map changes between day and night daily at 5AM EST and 5PM EST. Be ready for it.",
        "Staff are here to help, if you need assistance, please type into chat: @ followed by your message.",
        "Interested in supporting the server and receiving cool perks in the process? \nThis includes a cash boost, PET flags, extra character slots and much more. Type !donate in chat for more info.",
        "Type !discord in chat to join our Discord server!",
        "Press F4 to toggle third person.",
        "OOC chat should not be used for finding out In Character (IC) information. Make use of /advertisement for IC communication.",
        "Want to learn another language? Speak to the NPC in City Hall and learn it for a small fee.",
        "Right click with your hands equipped to pick up and carry things.",
    }
    timer.Simple(60, function()
            if LocalPlayer():sam_get_play_time() < 86400 then
                timer.Create("HelpInfo", 300, 0, function()
                    if LocalPlayer():getChar() then
                        local random = table.Random(helpMessages)
                        notification.AddLegacy("TIP: "..tostring(random), NOTIFY_HINT, 10)
                        surface.PlaySound("buttons/lightswitch2.wav")
                    end
                end)
            end
        end)
    end)
]]
hook.Add("InitPostEntity", "join_con_commands", function()
	RunConsoleCommand("mat_specular", "0")
	RunConsoleCommand("gmod_mcore_test", "1")
	RunConsoleCommand("r_shadows", "0")
	RunConsoleCommand("cl_detaildist", "0")
	RunConsoleCommand("cl_threaded_client_leaf_system", "1")
	RunConsoleCommand("cl_threaded_bone_setup", "2")
	RunConsoleCommand("r_threaded_renderables", "1")
	RunConsoleCommand("r_threaded_particles", "1")
	RunConsoleCommand("r_queued_ropes", "1")
	RunConsoleCommand("r_queued_decals", "1")
	RunConsoleCommand("r_queued_post_processing", "1")
	RunConsoleCommand("r_threaded_client_shadow_manager", "1")
	RunConsoleCommand("studio_queue_mode", "1")
	RunConsoleCommand("mat_queue_mode", "-2")
	RunConsoleCommand("cl_drawworldtooltips", "0")
	RunConsoleCommand("nut_cheapblur", "1")
	hook.Remove("RenderScene", "RenderSuperDoF")
	hook.Remove("RenderScene", "RenderStereoscopy")
	hook.Remove("Think", "DOFThink")
	hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
	hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
	hook.Remove("PreRender", "PreRenderFrameBlend")
	hook.Remove("PostRender", "RenderFrameBlend")
	hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
	hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
	hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
end)

hook.Add( "ChatText", "hide_joinleave", function( index, name, text, type )
	if ( type == "joinleave" ) then
		return true
	end
end )

function draw.ShadowTextDVN(text, font, x, y, color, talign_x, talign_y, shadowcolor, xoffset, yoffset)
	draw.SimpleText(text, font, x + (xoffset or 1), y + (yoffset or 1), shadowcolor or color_black, talign_x or TEXT_ALIGN_CENTER, talign_y or TEXT_ALIGN_TOP)
	draw.SimpleText(text, font, x, y, color or color_white, talign_x or TEXT_ALIGN_CENTER, talign_y or TEXT_ALIGN_TOP)
end