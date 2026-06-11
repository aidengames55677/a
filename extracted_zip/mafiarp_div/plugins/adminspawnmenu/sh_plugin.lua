-- "gamemodes\\mafiarp\\plugins\\adminspawnmenu\\sh_plugin.lua"

PLUGIN.name = "Admin Spawn Menu"
PLUGIN.author = "Pilot"
PLUGIN.desc = "Allow admins to easily spawn items."

nut.util.include("sv_plugin.lua", "server")

nut.command.add("adminspawnmenu", {
	gameMaster = true,
    onRun = function(client, arguments)
		local uniqueID = client:GetUserGroup()
        net.Start("adminSpawnMenu")
        net.Send(client)
    end
})

if (CLIENT) then
    net.Receive("adminSpawnMenu",function()
        local background = vgui.Create("DFrame")
        background:SetSize(ScrW() / 2, ScrH() / 2)
        background:Center()
        background:SetTitle("Admin Spawn Menu")
        background:MakePopup()
        background:ShowCloseButton(true)

        scroll = background:Add("DScrollPanel")
        scroll:Dock(FILL)

        categoryPanels = {}

        for k, v in pairs(nut.item.list) do
            if (!categoryPanels[L(v.category)]) then
                categoryPanels[L(v.category)] = v.category
            end
        end
        
        for category, realName in SortedPairs(categoryPanels) do
            local collapsibleCategory = scroll:Add("DCollapsibleCategory")
            collapsibleCategory:SetTall(36)
            collapsibleCategory:SetLabel(category)
            collapsibleCategory:Dock(TOP)
            collapsibleCategory:SetExpanded(0)
            collapsibleCategory:DockMargin(5, 5, 5, 0)
            collapsibleCategory.category = realName

            for k, v in SortedPairsByMemberValue(nut.item.list, "name") do
                if v.category == collapsibleCategory.category then
                    local item = collapsibleCategory:Add("DButton")
                    item:SetText(v.name)
                    item:SizeToContents()
                    item.DoClick = function()
                        net.Start("adminSpawnItem")
                        net.WriteString(v.name)
                        net.SendToServer()
                        surface.PlaySound("buttons/button14.wav")
                    end
                end
            end

            categoryPanels[realName] = collapsibleCategory
        end
    end)
end
