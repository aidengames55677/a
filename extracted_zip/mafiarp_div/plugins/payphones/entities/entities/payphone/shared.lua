-- "gamemodes\\mafiarp\\plugins\\payphones\\entities\\entities\\payphone\\shared.lua"

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Payphone" 
ENT.Author	= "rusty"
ENT.Category = "Diverge Entities"

ENT.Spawnable	= true
ENT.AdminOnly	= true
ENT.Editable	= true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "ActiveUser")
	self:NetworkVar("Bool", 1, "BeingUsed")
	self:NetworkVar("Int", 2, "ActiveCall")
	self:NetworkVar("String", 3, "PhoneNumber", {
		KeyName = "phonenumber",	
		Edit = { 
			type = "Generic",		
			order = 1,
		} 
	})
end