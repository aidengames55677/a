-- "gamemodes\\mafiarp\\plugins\\modified_charcreation\\derma\\cl_charinfodisplay_police.lua"

local PANEL = {}
PANEL.material = Material("diverge/pdid.png", "noclamp smooth")

-- pinnacle of laziness...
surface.CreateFont("DeathStar1", {
	font = "GothamMedium_1",
	size = ScreenScale(7.5),
	weight = 500,
	antialias = true,
})

function PANEL:Init()
	self:SetTitle("")
	self:SetSize(ScrW() / 2.5, ScrH() / 2.5)
	self:ShowCloseButton(true)
	self:SetDraggable(false)
	self:SetSkin("Default")
	self:MakePopup()
	self:Center()
	
	self.model = self:Add("DModelPanel")
	self.model:SetSize(230,240)
    self.model:SetPos((self:GetWide()/2)/2.6-self.model:GetWide()/2, 130)
    self.model:SetModel(LocalPlayer():GetModel())
    self.model:SetFOV(20)
	local head = self.model.Entity:LookupBone("ValveBiped.Bip01_Head1") --Look at the model head
	if head and head >= 0 then
		self.model:SetLookAt(self.model.Entity:GetBonePosition(head))
	end
	function self.model:LayoutEntity(ent)
	ent:SetAngles(Angle(0,45,0))
	ent:ResetSequence(2)
	end
	
	if (self.model) then
		self.model:SetModel(LocalPlayer():GetModel())
		self.model.Entity:SetSkin(LocalPlayer():GetSkin())

		for k, v in ipairs(LocalPlayer():GetBodyGroups()) do
			self.model.Entity:SetBodygroup(v.id, LocalPlayer():GetBodygroup(v.id))
		end

		local ent = self.model.Entity
		if (ent and IsValid(ent)) then
			local mats = LocalPlayer():GetMaterials()
			for k, v in pairs(mats) do
				ent:SetSubMaterial(k - 1, LocalPlayer():GetSubMaterial(k - 1))
			end
		end
	end
end

function PANEL:setCharacter(player)
	local character = player:getChar()
	if !character then return end

	if (self.model) then
		self.model:SetModel(player:GetModel())
		self.model.Entity:SetSkin(player:GetSkin())

		for k, v in ipairs(player:GetBodyGroups()) do
			self.model.Entity:SetBodygroup(v.id, player:GetBodygroup(v.id))
		end

		local ent = self.model.Entity
		if (ent and IsValid(ent)) then
			local mats = player:GetMaterials()
			for k, v in pairs(mats) do
				ent:SetSubMaterial(k - 1, player:GetSubMaterial(k - 1))
			end
		end
	end
	
	local descgenerator = character:getDescgenerator()
	if isstring(descgenerator) then
		descgenerator = util.JSONToTable(descgenerator)
	end
	local gender = "Male"
	local mdl = character:getModel()
	if (string.lower(mdl):find("female", 1, true)) then
		gender = "Female"
	end
	
	self.name = character:getName()
	self.age = descgenerator["Age"] or "N/A"
	self.birth = descgenerator["Ethnicity"] or "N/A"
	self.gender = gender
	self.blood = descgenerator["Blood Type"] or "N/A"
	self.hair = descgenerator["Hair Color"] or "N/A"
	self.eye = descgenerator["Eye Color"] or "N/A"
	self.height = (descgenerator["Height - Feet"] or 0) .. "'".. (descgenerator["Height - Inches"] or 0)
	self.weight = (descgenerator["Weight - LBS"] or 0).." LBS"
	self.number = character:getID()
	self.id = "SS000"..character:getID()
end

PANEL.CharacterValues = {
	name = {
		x = 2.855,
		y = 2.495,
		font = "DeathStar1"
	},
	birth = {
		x = 2.855,
		y = 2.075,
		font = "DeathStar1"
	},
	age = {
		x = 2.855,
		y = 1.765,
		font = "DeathStar1"
	},
	gender = {
		x = 2.855,
		y = 1.55,
		font = "DeathStar1"
	},
	blood = {
		x = 2.35,
		y = 1.55,
		font = "DeathStar1"
	},
	eye = {
		x = 2.855,
		y = 1.37,
		font = "DeathStar1"
	},
	weight = {
		x = 2.1,
		y = 1.37,
		font = "DeathStar1"
	},
	height = {
		x = 1.720,
		y = 1.37,
		font = "DeathStar1"
	},
	number = {
		x = 2.855,
		y = 1.225,
		font = "DeathStar1"
	},
	id = {
		x = 2.855,
		y = 1,
		font = "DeathStar1"
	},
}

function PANEL:Paint(w,h)
	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(self.material)
	surface.DrawTexturedRect(0,0,w,h)
	
	for k,info in next, self.CharacterValues do
		surface.SetFont(info.font)
		surface.SetTextColor(10,57,96)
		surface.SetTextPos(w / info.x, h / info.y)
		surface.DrawText(self[k] or "N/A")
	end
end

vgui.Register("SWCharInfoDisplayPolice", PANEL, "DFrame") 