-- "gamemodes\\mafiarp\\plugins\\adverts\\cl_plugin.lua"


local PLUGIN = PLUGIN

nut.command.add( "adblacklist", {
    syntax = "<string name>",
    onRun = function() end
} )

net.Receive( "Adverts.OpenAdvertList", function()
    local readOnly = net.ReadBool()
    local data = net.ReadTable()

    PLUGIN.Panel = vgui.Create( "AdvertList" )
    PLUGIN.Panel:InitializeInfo( data, readOnly )
end )

net.Receive( "Adverts.OpenAdvert", function()
    if PLUGIN.Panel then
        PLUGIN.Panel.Advert:SetAdvertInfo( net.ReadTable() )
    end
end )

function PLUGIN:OpenURL( url )
    if not self:IsValidURL( url ) then return end

    local window = vgui.Create( "DFrame" )
    if ScrW() > 640 then
        window:SetSize( ScrW() * 0.9, ScrH() * 0.9 )
    else
        window:SetSize( 640, 480 )
    end

    window:Center()
    window:SetTitle( "Advert Link" )
    window:SetVisible( true )
    window:MakePopup()

    local html = vgui.Create( "DHTML", window )

    local button = vgui.Create( "DButton", window )
    button:SetText( "Close" )
    button.DoClick = function() window:Close() end
    button:SetSize( 100, 40 )
    button:SetPos( ( window:GetWide() - button:GetWide() ) / 2, window:GetTall() - button:GetTall() - 10 )

    html:SetSize( window:GetWide() - 20, window:GetTall() - button:GetTall() - 50 )
    html:SetPos( 10, 30 )
    html:OpenURL( url )
end