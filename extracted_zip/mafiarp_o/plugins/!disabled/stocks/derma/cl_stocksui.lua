-- oink.industries
-- lua source: gamemodes/1942rp/plugins/stocks/derma/cl_stocksui.lua
local PANEL = {}

function PANEL:Init()
    local jailmenu = vgui.Create("DFrame")
    jailmenu:SetSize(1000, 1020)
    jailmenu:SetPos(450, 0)
    jailmenu:SetTitle("")
    jailmenu:MakePopup()
    jailmenu:ShowCloseButton(true)
    Program = vgui.Create("stockm_comp_stocks", jailmenu)
    Program.SoftID = "StockM"
    Program:SetSize(1000, 1000)
    Program:SetPos(0, 25)
end

vgui.Register("stocks_vgui_port", PANEL)
