-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_inbox.lua"


local PANEL = {}

function PANEL:Init()
    self.PropertySheet = vgui.Create( "DPropertySheet", self )
    self.PropertySheet:Dock( FILL )

    self.Overview = vgui.Create( "Pager.Inbox.Overview", self.PropertySheet )
    self.Overview:Dock( FILL )

    self.Sent = vgui.Create( "Pager.Inbox.Sent", self.PropertySheet )
    self.Sent:Dock( FILL )

    self.Trash = vgui.Create( "Pager.Inbox.Trash", self.PropertySheet )
    self.Trash:Dock( FILL )

    self.PropertySheet:AddSheet( "Inbox", self.Overview )
    self.PropertySheet:AddSheet( "Sent", self.Sent )
    self.PropertySheet:AddSheet( "Trash", self.Trash )
end

function PANEL:RefreshMessages( filter )
    if self.Overview.Messages then
        self.Overview:SetMessages( self.Overview.Messages, filter )
    end

    if self.Sent.Messages then
        self.Sent:SetMessages( self.Sent.Messages, filter )
    end

    if self.Trash.Messages then
        self.Trash:SetMessages( self.Trash.Messages, filter )
    end
end

function PANEL:Paint()

end

vgui.Register( "Pager.Inbox", PANEL, "DPanel" )