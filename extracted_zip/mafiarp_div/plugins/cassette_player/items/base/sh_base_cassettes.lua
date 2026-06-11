-- "gamemodes\\mafiarp\\plugins\\cassette_player\\items\\base\\sh_base_cassettes.lua"

ITEM.name = "Cassette Base"
ITEM.desc = "A cassette that has a song on it..."
ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl"
ITEM.uniqueID = "base_cassettes"
ITEM.isCassette = true
ITEM.songFile = "mors/lifeformed_elvish_piper_academy.wav"

ITEM.functions.ViewAlbumCover = {
	name = "View Album Cover",
	icon = "icon16/application.png",
	onRun = function(item)
        local itemTable = nut.item.list[item.uniqueID]
		item.player:SendLua([[
			local f = vgui.Create("DFrame")
			f:SetSize(512, 512)
			f:SetTitle("Album Cover")
			f:Center()
			f:MakePopup()
			local h = vgui.Create("DHTML", f)
			h:Dock(FILL)
			h:OpenURL("]]..itemTable.albumCover..[[")
		]]);
		return false
	end,
	onCanRun = function(item)
		local itemTable = nut.item.list[item.uniqueID]
		return itemTable.albumCover
	end,
}