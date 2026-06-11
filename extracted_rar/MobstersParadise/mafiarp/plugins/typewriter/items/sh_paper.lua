-- "gamemodes\\mafiarp\\plugins\\typewriter\\items\\sh_paper.lua"

ITEM.name = "Document"
ITEM.desc = ""
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Documents"
ITEM.noBusiness = true

ITEM.functions.view = {
	name = "View",
	onClick = function(item)
		local document = vgui.Create("nutDocument")
		document:SetDocument(item)
	end,
	onRun = function(item) return false end,
	onCanRun = function(item)
		return !IsValid(item.entity) and item:getData("documentBody") and true or false
	end,
}

ITEM.functions.getCreator = {
	name = "Copy Creator SteamID",
	onRun = function(item)
		local ply = item.player
        ply:ChatPrint( "Creator of this document's SteamID has been copied to your clipboard." )
        ply:SendLua( [[SetClipboardText( "]] .. item:getData("creator") .. [[" )]] )
		return false 
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) and SCHEMA.RanksMod[item.player:GetUserGroup()]
	end,
}

function ITEM:getName()
	return self:getData("documentName", self.name)
end