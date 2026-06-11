-- oink.industries
-- lua source: gamemodes/1942rp/plugins/stocks/cl_plugin.lua
net.Receive("stocks_menu_popup", function()
    vgui.Create("stocks_vgui_port")
end)
