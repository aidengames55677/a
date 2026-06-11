-- "gamemodes\\mafiarp\\plugins\\itemforge\\sh_plugin.lua"

PLUGIN.name = "Item Forge"
PLUGIN.author = "Killing Torcher, rusty"
PLUGIN.desc = "Allows creating custom items in-game"


--function nut.item.register(uniqueID, baseID, isBaseItem, path, luaGenerated)

KTItems = KTItems or {}
KTItems.List = KTItems.List or {}

nut.util.include("sv_plugin.lua", "server")
nut.util.include("cl_plugin.lua", "client")


function KTItems.RegisterCustomItem(id, itemData)

	if (!id) then return end
	
	local ITEM = nut.item.register(tostring(id), nil, false, nil, true)
	if (ITEM) then
	
		KTItems.List[id] = itemData
	
		for k,v in pairs(itemData) do
			ITEM[k] = v
		end		
	end
end


if (CLIENT) then
	netstream.Hook("KTItemsLoad", function(items)
		KTItems.List = items
		
		
		for uniqueID, itemData in pairs(KTItems.List) do
			KTItems.RegisterCustomItem(uniqueID, itemData)
		end
	end)
	
	netstream.Hook("KTItemsLoadSingle", function(id, itemData)
		
		KTItems.RegisterCustomItem(id, itemData)
	end)
	
	netstream.Hook("itemForgeGUI", function()
		local panel = vgui.Create("DFrame")
		panel:SetSize(500, 125)
		panel:SetTitle("Item Creator")
		panel:Center()
		panel:MakePopup()
		
		local size_offset = 0
			
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Name:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtName = vgui.Create("DTextEntry", panel)
		txtName:SetPos(105, 26 + size_offset - 25)
		txtName:SetSize(390, 20)
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Description:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtDesc = vgui.Create("DTextEntry", panel)
		txtDesc:SetPos(105, 26 + size_offset - 25)
		txtDesc:SetSize(390, 20)
		
		local label1 = vgui.Create("DLabel", panel)
		label1:SetPos(5, 30 + size_offset)
		label1:SetText("Item Model:")
		label1:SizeToContents()
		size_offset = size_offset + 25
		
		local txtModel = vgui.Create("DTextEntry", panel)
		txtModel:SetPos(105, 26 + size_offset - 25)
		txtModel:SetSize(390, 20)
			
		local submitButton = vgui.Create("DButton", panel)
		submitButton:SetPos(5, 26 + size_offset)
		submitButton:SetSize(490, 20)
		submitButton:SetText("Create Item")
		submitButton:SetSkin("Default")
		submitButton.DoClick = function()
			for k,v in pairs ({txtName, txtDesc, txtModel}) do
				if (!v:GetValue() || type(v:GetValue()) != "string" || v:GetValue() == "") then
					nut.util.notify("You have to specify a Name, Description and Model")
					return
				end
			end
			local itemData = {name = txtName:GetValue(), desc = txtDesc:GetValue(), model = txtModel:GetValue(), price = 0, category = "Generated Items", noBusiness = true}
			
			netstream.Start("itemForgeGUI", itemData)
			panel:Close()
		end
	end)
	
	netstream.Hook("itemForgeDetails", function(uniqueID, items)
		print("Item table for custom item " .. uniqueID)
		PrintTable(items)
		
		chat.AddText(color_white, "Details have been printed to your console.")
	end)
	
	netstream.Hook("itemForgeList", function(items)
		for k,v in pairs(items) do
			print(k .. " = " .. v.name)
		end
		
		chat.AddText(color_white, "A list of all custom item forge items has been printed to your console. Use /itemforgedetails <uniqueID> for details.")
	end)
end