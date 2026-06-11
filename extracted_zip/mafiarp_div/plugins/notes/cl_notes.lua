-- "gamemodes\\mafiarp\\plugins\\notes\\cl_notes.lua"

local globalRanks = {
    ["founder"] = true,
    ["communitymanager"] = true,
    ["servermanager"] = true,
    ["advisor"] = true,
    ["headadministrator"] = true,
    ["superadministrator"] = true,
    ["senioradministrator"] = true,
    ["seasonedadministrator"] = true,
    ["administrator"] = true,
    ["moderator"] = true,
	["eventmanager"] = true,
}

local sRanks = {
    ["founder"] = true,
    ["communitymanager"] = true,
    ["headadministrator"] = true,
    ["superadministrator"] = true,
	["senioradministrator"] = true,
}

nut.command.add("notes", {
	syntax = "<string player or steamid64>",
	onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
		if(!globalRanks[uniqueID]) then
			client:notify("Your rank is not high enough to use this command.")
			return false
		end
	end
})

netstream.Hook("showNotes", function(steamID, steamName, notes)
	if (!IsValid(KT_NOTES_GUI)) then
		local frame = vgui.Create("DFrame")
		local fr_w, fr_h = 800, 600
		frame:SetSize(fr_w, fr_h)
		frame:MakePopup()
		frame:Center()
		frame.SetData = function(mainPnl, steamID, steamName, notes)
			mainPnl:SetTitle("Showing notes for " .. steamName .. " (" .. tostring(steamID) .. ")")
			
			for k,v in pairs(mainPnl.Notes or {}) do
				if (IsValid(v)) then
					v:Remove()
				end
			end
			
			mainPnl.Notes = {}
			local compiledData = {}
			
			for k,v in pairs(notes.Notes) do
				v.dataType = 1
				v.noteTime = v._time
				table.insert(compiledData, v)
			end
			
			for k,v in pairs(notes.Bans) do
				v.dataType = 2
				v.noteTime = v.start_date
				table.insert(compiledData, v)
			end
			
			table.sort(compiledData, function(a, b)
				return a.noteTime > b.noteTime
			end)
			
			////////////////////
			// The Warp Drive
			////////////////////
			
			for k,v in pairs(compiledData) do
				local notePanel = vgui.Create("DPanel", mainPnl.ScrollPanel)
				notePanel:Dock(TOP)
				notePanel:DockMargin(5, 5, 5, 0)
				notePanel:DockPadding(1, 1, 1, 5)
				notePanel.Paint = function(pnl, w, h)
					//draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50))
					//draw.RoundedBox(5, 1, 1, w-2, h-2, Color(225, 225, 225))
					
					draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50))
					draw.RoundedBox(5, 1, 1, w-2, h-2, Color(255, 255, 255))
					
					if (notePanel.DrawText) then
						local y_buffer = 0
						for k,v in pairs(string.Explode('\n', notePanel.DrawText, false)) do
							draw.SimpleTextOutlined(v, "nutSmallFont", 5, 35 + y_buffer, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 150))
							y_buffer = y_buffer + 17
						end
					end
				end
				
				local notePanelHeader = vgui.Create("DPanel", notePanel)
				notePanelHeader:Dock(TOP)
				notePanelHeader:SetHeight(30)
				notePanelHeader.Paint = function(pnl, w, h)
					local note_color = v.dataType == 1 and Color(v._col_r, v._col_g, v._col_b) or Color(214, 48, 49, 200)
					local shadowSize = 1
					local shadowStrength = -100
					draw.RoundedBoxEx(5, 0, 0, w, h, Color(math.Clamp(note_color.r + shadowStrength, 0, 255), math.Clamp(note_color.g + shadowStrength, 0, 255), math.Clamp(note_color.b + shadowStrength, 0, 255)), false, false, true, true)
					draw.RoundedBoxEx(5, shadowSize, shadowSize, w-shadowSize*2, h-shadowSize*2, note_color, false, false, true, true)
					
					if (v.dataType == 2) then
						local banText = "Perma-Ban"
						if (v.end_time > 0 && v.end_time - v.start_time >= 0) then
							banText = "Ban"
						end
						//draw.SimpleText(banText .. " | " .. v.noteTime .. " | " .. v.admin, "nutSmallFont", 5, 14, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleTextOutlined(banText .. " | " .. os.date("%c", v.noteTime) .. " | " .. v.admin, "nutSmallFont", 6, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 150))
					else
						//draw.SimpleText("Note | " .. v.noteTime .. " | " .. v._adminname .. "(" .. util.SteamIDFrom64(v._adminsteamid) .. ")", "nutSmallFont", 5, 14, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleTextOutlined("Note | " .. os.date("%c", v.noteTime) .. " | " .. v._adminname .. "(" .. util.SteamIDFrom64(v._adminsteamid) .. ")", "nutSmallFont", 6, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 150))
					end
				end
				
				////////////////////
				// Helper Functions
				////////////////////
				
				local function charWrap(text, pxWidth)
					local total = 0

					text = text:gsub(".", function(char)
						total = total + surface.GetTextSize(char)

						-- Wrap around when the max width is reached
						if total >= pxWidth then
							total = 0
							return "\n" .. char
						end

						return char
					end)

					return text, total
				end
				
				local function drpWrap(text, font, pxWidth)
					local total = 0

					surface.SetFont(font)

					local spaceSize = surface.GetTextSize(' ')
					text = text:gsub("(%s?[%S]+)", function(word)
							local char = string.sub(word, 1, 1)
							if char == "\n" or char == "\t" then
								total = 0
							end

							local wordlen = surface.GetTextSize(word)
							total = total + wordlen

							-- Wrap around when the max width is reached
							if wordlen >= pxWidth then -- Split the word if the word is too big
								local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
								total = splitPoint
								return splitWord
							elseif total < pxWidth then
								return word
							end

							-- Split before the word
							if char == ' ' then
								total = wordlen - spaceSize
								return '\n' .. string.sub(word, 2)
							end

							total = wordlen
							return '\n' .. word
						end)

					return text
				end
				
				////////////////////
				// Utility Buttons
				////////////////////
				
				if (v.dataType == 2) then
					local banText = "Permanently Banned"
					if (v.end_time != 0 && v.end_time - v.start_time > 0) then

						banText = "Banned for " .. (math.floor((v.end_time - v.start_time)/60)) .. " minutes (" .. string.NiceTime(v.end_time - v.start_time) .. "). Expires " .. os.date("%d/%m/%Y %H:%M", v.end_time)
					end
					notePanel.DrawText = drpWrap(banText ..  "\n\t" .. (v.reason != "" and v.reason or "No reason specified"), "nutSmallFont", 740)
					
					local banText2 = "Perma-Ban"
					if (v.end_time > 0 && v.end_time - v.start_time >= 0) then
						banText2 = "Ban"
					end
					
					local printBtn = vgui.Create("DButton", notePanel)
					printBtn:SetText("Print")
					printBtn:SetPos(735-12, 5)
					printBtn:SetSize(35, 20)
					printBtn.PrintText = banText2 .. " | " .. v.noteTime .. " | " .. v.admin .. "\n" .. banText ..  "\n\t" .. (v.reason != "" and v.reason or "No reason specified")
					printBtn.DoClick = function(pnl)
						chat.AddText(" ")
						chat.AddText(Color(255, 255, 255), pnl.PrintText)
						chat.AddText(" ")
					end
					printBtn.Paint = function(pnl, w, h)
						surface.SetDrawColor(150, 150, 150)
						surface.DrawRect(0, 0, w, h)
						surface.SetDrawColor(225, 225, 225)
						surface.DrawRect(1, 1, w-2, h-2)
					end
				else
					notePanel.DrawText = drpWrap(v._note, "nutSmallFont", 740)
					local printBtn = vgui.Create("DButton", notePanel)
					printBtn:SetText("Print")
					printBtn:SetPos(735-12, 5)
					printBtn:SetSize(35, 20)
					printBtn.PrintText = "Note | " .. v.noteTime .. " | " .. v._adminname .. "(" .. util.SteamIDFrom64(v._adminsteamid) .. ")\n" .. v._note
					printBtn.DoClick = function(pnl)
						chat.AddText(" ")
						chat.AddText(Color(255, 255, 255), pnl.PrintText)
						chat.AddText(" ")
					end
					printBtn.Paint = function(pnl, w, h)
						surface.SetDrawColor(150, 150, 150)
						surface.DrawRect(0, 0, w, h)
						surface.SetDrawColor(225, 225, 225)
						surface.DrawRect(1, 1, w-2, h-2)
					end
					
						local uniqueID = LocalPlayer():GetUserGroup()
						if(sRanks[uniqueID]) then
						local delButton = vgui.Create("DButton", notePanel)
						delButton:SetText("Delete")
						delButton:SetPos(735-12-40, 5)
						delButton:SetSize(35, 20)
						delButton.PrintText = "Note | " .. v.noteTime .. " | " .. v._adminname .. "(" .. util.SteamIDFrom64(v._adminsteamid) .. ")\n" .. v._note
						delButton.DoClick = function(pnl)
							Derma_Query("Are you sure you wish to remove Note ID " .. v.id .. " (" .. v._note .. ")?", "Delete Note", "Yes", function()
								netstream.Start("deleteNote", v.id, steamID)
							end, "No")
						end
						
						delButton.Paint = function(pnl, w, h)
							surface.SetDrawColor(150, 150, 150)
							surface.DrawRect(0, 0, w, h)
							surface.SetDrawColor(225, 225, 225)
							surface.DrawRect(1, 1, w-2, h-2)
						end
						
						local editButton = vgui.Create("DButton", notePanel)
						editButton:SetText("Edit")
						editButton:SetPos(735-12-80, 5)
						editButton:SetSize(35, 20)
						editButton.PrintText = "Note | " .. v.noteTime .. " | " .. v._adminname .. "(" .. util.SteamIDFrom64(v._adminsteamid) .. ")\n" .. v._note
						editButton.DoClick = function(pnl)
							local newNoteFrame = vgui.Create("DFrame")
							newNoteFrame:SetTitle("Edit Note for " .. steamName .. " (" .. steamID .. ")")
							newNoteFrame:MakePopup()
							newNoteFrame:SetSize(400, 200)
							newNoteFrame:Center()

							local newNoteTx = vgui.Create("DTextEntry", newNoteFrame)
							newNoteTx:SetMultiline(true)
							newNoteTx:SetPos(5, 29)
							newNoteTx:SetSize(250 - 50, 131)
							newNoteTx:SetValue(v._note)
							
							local colorCombo = vgui.Create("DColorMixer", newNoteFrame)
							colorCombo:SetPos(260 - 50, 29)
							colorCombo:SetSize(400 - 260 - 5 + 50, 135 + 30)
							colorCombo:SetAlphaBar(false)
							colorCombo:SetColor(Color(v._col_r, v._col_g, v._col_b))
							
							local okButton = vgui.Create("DButton", newNoteFrame)
							okButton:SetText("Edit Note")
							okButton:SetPos(5, 29 + 135)
							okButton:SetSize(200, 30)
							okButton:SetSkin("Default")
							okButton.DoClick = function()
								if (newNoteTx:GetValue() != "") then
									newNoteFrame:Close()
									local col = colorCombo:GetColor()
									netstream.Start("editNote", v.id, newNoteTx:GetValue(), col.r, col.g, col.b, steamID)
								end
							end
						end
						editButton.Paint = function(pnl, w, h)
							surface.SetDrawColor(150, 150, 150)
							surface.DrawRect(0, 0, w, h)
							surface.SetDrawColor(225, 225, 225)
							surface.DrawRect(1, 1, w-2, h-2)
						end
					end
				end
				surface.SetFont("nutSmallFont")
				local s_w, s_h = surface.GetTextSize(notePanel.DrawText or "")
				notePanel:SetHeight(45 + s_h)
				table.insert(mainPnl.Notes, notePanel)
				
			end
		end
		
		local panel = vgui.Create("DScrollPanel", frame)
		panel:SetPos(5, 29)
		panel:SetSize(fr_w - 10, fr_h - 29 - 5 - 35)
		panel:DockPadding(5, 5, 5, 5)
		frame.ScrollPanel = panel
		
		local newNote = vgui.Create("DButton", frame)
		newNote:SetPos(1, 25 + fr_h - 34 - 29)
		newNote:SetSize(fr_w * 0.5, 34)
		newNote:SetText("")
		newNote.Paint = function(pnl, w, h)
			surface.SetDrawColor(50, 50, 50, 100)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(128, 128, 128)
			surface.DrawRect(1, 1, w-2, h-2)
			
			draw.SimpleText("New Note", "nutMediumFont", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("New Note", "nutMediumFont", w/2 - 1, h/2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		newNote.DoClick = function()
			local newNoteFrame = vgui.Create("DFrame")
			newNoteFrame:SetTitle("New Note for " .. steamName .. " (" .. steamID .. ")")
			newNoteFrame:MakePopup()
			newNoteFrame:SetSize(400, 200)
			newNoteFrame:Center()

			local newNoteTx = vgui.Create("DTextEntry", newNoteFrame)
			newNoteTx:SetMultiline(true)
			newNoteTx:SetPos(5, 29)
			newNoteTx:SetSize(250 - 50, 131)

			local colorCombo = vgui.Create("DColorMixer", newNoteFrame)
			colorCombo:SetPos(260 - 50, 29)
			colorCombo:SetSize(400 - 260 - 5 + 50, 135 + 30)
			colorCombo:SetAlphaBar(false)
			colorCombo:SetColor(Color(245, 158, 66))
			
			local okButton = vgui.Create("DButton", newNoteFrame)
			okButton:SetText("Add Note")
			okButton:SetPos(5, 29 + 135)
			okButton:SetSize(200, 30)
			okButton:SetSkin("Default")
			okButton.DoClick = function()
				if (newNoteTx:GetValue() != "") then
					newNoteFrame:Close()
					local col = colorCombo:GetColor()
					netstream.Start("addNote", steamID, newNoteTx:GetValue(), col.r, col.g, col.b)
					nut.util.notify("Note has been added!")
				end
				if IsValid(frame) then
					frame:Remove()
				end
			end
		end
		KT_NOTES_GUI = frame

		local bansButton = vgui.Create("DButton", frame)
		bansButton:SetPos(fr_h * 0.5 + 100, 25 + fr_h - 34 - 29)
		bansButton:SetSize(fr_w * 0.5, 34)
		bansButton:SetText("")
		bansButton.Paint = function(pnl, w, h)
			surface.SetDrawColor(50, 50, 50, 100)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(128, 128, 128)
			surface.DrawRect(1, 1, w-2, h-2)
			
			draw.SimpleText("Check Previous Bans", "nutMediumFont", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Check Previous Bans", "nutMediumFont", w/2 - 1, h/2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		bansButton.DoClick = function()
			local f = vgui.Create("DFrame")
			f:SetSize(ScrW()*0.5, ScrH()*0.5)
			f:Center()
			f:MakePopup()
			local h = vgui.Create("DHTML", f)
			h:Dock(FILL)
			h:OpenURL(string.format('https://bans.divergenet.works/?player=%s', util.SteamIDFrom64(steamID) or '000'))
		end
	end
	
	KT_NOTES_GUI:SetData(steamID, steamName, notes)
end)