-- "gamemodes\\mafiarp\\plugins\\startinfo\\derma\\cl_startinfo_step.lua"


local PLUGIN = PLUGIN
local PANEL = {}

function PANEL:Init()
	self.title = self:addLabel("Setting")
	
	--[[
	self.list = self:Add("DScrollPanel")
	self.list:Dock(FILL)
	
	self.list:SetDrawBackground(false)
	--]]
	
	self.desc = self:Add("DTextEntry")--self:addLabel("")
	self.desc:DockMargin(0, 8, 0, 0)
	self.desc:SetSize(ScrW() * 0.35, ScrH() * 0.7)
	self.desc:SetPos(0, 50)
	self.desc:SetFont("nutCharSubTitleFont")
	self.desc:SetTextColor(Color(255,255,255))
	self.desc:SetPaintBackground(false)
	self.desc:SetWrap(true)
	self.desc:SetMultiline(true)
	--self.desc:SetAutoStretchVertical(true)
end

function PANEL:onDisplay()
	local setting = [[
		1980's American life in New York City. Organised crime is at an all time high, as quick as the police are to solve a murder 5 more are to happen. Create your character and your story, and venture out into the rough streets of New York. Be anything from a low paying city worker to a rich City Councilmember. Choose your path civilian, criminal, government, or law enforcement. It's your decision, your path, your character it's up to you what to make of it.

		The way you should look at creating your character is to imagine an individual or type of individual you’d like to roleplay as, selecting their First name and Last name, ethnicity, age and other physical attributes. All these factors combine and lend themselves to greater roleplay possibilities as you begin the story arc of that particular character.
		
		The main motivation of most will be the grab for cash, power and status. Making money through any means necessary, whether a legal job, government position, theft, drug cultivating or gun trafficking, the choice is yours. Each method and practice comes with its own risks and rewards. 
		
		To get started on this we recommend you speak with a few key NPCs at Town Hall after you finish creating your character. They’ll provide you with useful directions and other information on where to get some basic jobs for some starter cash, alternatively you can also roam the streets and seek to be employed or informed by other players.
		
		The first NPC being Sean Johnson, he will provide you directions to key landmarks, job sites and even some shady alleys.]]			

	self.desc:SetText(setting)
	self.desc.AllowInput = function()
		return true
	end
	self.desc:SetEnabled(false)
end

vgui.Register("nutStartInfo", PANEL, "nutCharacterCreateStep")