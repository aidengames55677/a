-- "gamemodes\\mafiarp\\plugins\\pager\\cl_plugin.lua"


local PLUGIN = PLUGIN

PagerPanel = nil

function PLUGIN:OpenPager( readOnly, messages, contacts, discordToken )
    if not PagerPanel then
        PagerPanel = vgui.Create( "Pager" )
        PagerPanel:InitializeInfo( readOnly )
    end

    if not messages then
        messages = {
            Sent = {},
            Received = {}
        }
    end

    if not contacts then
        contacts = {}
    end

    PagerPanel:InitializeContacts( contacts )
    PagerPanel:InitializeMessages( messages )
    PagerPanel.DiscordToken = discordToken
end

function PLUGIN:ClosePager()
    if PagerPanel then
        PagerPanel:Close()
    end
end

nut.command.add( "adminpagersearch", {
    syntax = "[charid]",
    onRun = function() end
} )