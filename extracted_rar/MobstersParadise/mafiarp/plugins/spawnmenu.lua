-- "gamemodes\\mafiarp\\plugins\\spawnmenu.lua"


local PLUGIN = PLUGIN

PLUGIN.name = "Spawnmenu Additions"
PLUGIN.author = "Diverge Networks"

if ( CLIENT ) then
	local models = {
		["Storage Containers (Staff)"] = {
			"models/props_junk/wood_crate001a.mdl",
			"models/props_c17/lockers001a.mdl",
			"models/props_wasteland/controlroom_storagecloset001a.mdl",
			"models/props_wasteland/controlroom_filecabinet002a.mdl",
			"models/props_c17/furniturefridge001a.mdl",
			"models/props_wasteland/kitchen_fridge001a.mdl",
			"models/props_junk/trashbin01a.mdl",
			"models/items/ammocrate_smg1.mdl",
		}
	}

	hook.Add( "PopulateContent", "ServerProps", function( pnlContent, tree )
		local RootNode = tree:AddNode( "Diverge Props", "icon16/box.png" )
		local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
		ViewPanel:SetVisible( false )
		
		RootNode.DoClick = function()
			ViewPanel:Clear( true)
			
			for name, tbl in SortedPairs( models ) do
				local label = vgui.Create( "ContentHeader", container )
				label:SetText( name )
				ViewPanel:Add( label )
	
				for _, v in ipairs( tbl ) do
					local mdlicon = spawnmenu.GetContentType( "model" )
					if mdlicon then
						mdlicon( ViewPanel, {model = v} )
					end
				end
			end
		
			pnlContent:SwitchPanel(ViewPanel)
		end
	end )
end
