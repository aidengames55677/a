-- "gamemodes\\mafiarp\\plugins\\typewriter\\derma\\cl_paper.lua"

local PANEL = {}

function PANEL:Init()
	self:SetTitle("Document")
	--self.lblTitle:SetTextColor(color_white)
	self:SetSize(ScrW() * 0.6, ScrH() * 0.95)
	self:Center()
	self:MakePopup()
end

function PANEL:SetDocument(item)
	self:SetTitle(item:getData("documentName", item.name))

	local body = item:getData("documentBody", "INVALID")

	self.document = self:Add("DHTML")
	self.document:SetZPos(1)
	self.document:Dock(FILL)
	if body:find("https://docs.google.com/") then
		local exploded = string.Explode("/", body, false)
		exploded[#exploded] = "preview"

		self.document:OpenURL(string.Implode("/", exploded))
	else
		self.document:SetHTML(body)
	end
end

vgui.Register("nutDocument", PANEL, "DFrame")