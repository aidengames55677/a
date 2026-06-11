-- "gamemodes\\mafiarp\\plugins\\rjobs\\entities\\entities\\languages_npc\\cl_init.lua"

include( "shared.lua" )

local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
local PLUGIN = PLUGIN
	
ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo(alpha)
	local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
	local x, y = position.x, position.y

	drawText("Bruno Stevens", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	drawText("Want to learn a new language?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end

ENT.NPC_INFORMATION = {
	name = "Bruno Stevens",
	profession = "Language Teacher",
	model = "models/player/Suits/male_06_open_tie.mdl",
}

ENT.NPC_CONVERSATION = {
	opening = {
		response = "Hello, what can I do for you?",
		options = {
			"learnlanguage",
			"exit",
		},
	},
	learnlanguage = {
		dialog = "I would like to learn a new language",
		response = "Okay! What would you like to learn? Be aware you can only learn 1 language, or 2 if you are a Donator. Choose wisely!",
		callback = function(panel, key)
			local dialogData = panel.conversations[key]
			local plugin = nut.plugin.list.languages
			panel:ClearDialogOptions()

			panel:SetText((isfunction(dialogData.response) and dialogData.response(panel, key)) or dialogData.response or "")

			for i,data in next, plugin.Languages do
				if (LocalPlayer():getChar():knowsLanguage(i)) then continue end

				panel:AddDialogOption(data.name.." - ".. "$10,000", data.name, function(panel)
					panel:ClearDialogOptions()
					panel:BackToOpening()

					net.Start("learnalanguage")
						net.WriteUInt(i, 32)
					net.SendToServer()
				end)
			end
		end,
		options = {
			"nevermind",
		},
	},
	nevermind = {
		dialog = "Nevermind.",
		response = "No problem, let me know if you change your mind.",
	},		
	exit = {
		dialog = "Exit",
		callback = function(panel, key)
			panel:Close()
		end,
	},
}

net.Receive("ui_language_npc",function()
	local ent = net.ReadEntity()

	local dialog = vgui.Create("hdNPCDialog")
	dialog:SetTitle(ent.NPC_INFORMATION.name.." - "..ent.NPC_INFORMATION.profession)
	dialog:AddDialogOptions(ent.NPC_CONVERSATION)
	dialog:SetModel(ent.NPC_INFORMATION.model)
end)