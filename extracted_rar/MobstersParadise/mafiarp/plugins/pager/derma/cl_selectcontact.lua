-- "gamemodes\\mafiarp\\plugins\\pager\\derma\\cl_selectcontact.lua"


local PANEL = {}

function PANEL:Init()
    self:SetSize( 270, 190 )
    self:MakePopup()
    self:Center()
    self:SetDraggable( false )
    self:SetBackgroundBlur( true )
    self:SetDrawOnTop( true )
    self:DoModal()
    self:SetTitle( "Select Contact" )

    self.Contacts = vgui.Create( "DScrollPanel", self )
    self.Contacts:Dock( FILL )

    self:UpdateContacts()
end

function PANEL:UpdateContacts()
    if not PagerPanel then return end
    local contacts = PagerPanel.ContactsTable

    if self.ContactPanels then
        for _, v in ipairs( self.ContactPanels ) do
            v:Remove()
        end
    end

    self.ContactPanels = {}

    for k, v in pairs( contacts ) do
        local contact = vgui.Create( "DButton", self.Contacts )
        contact:Dock( TOP )
        contact:DockMargin( 5, 3, 5, 0 )
        contact:SetText( v .. " (" .. tostring( k ) .. ")" )
        contact:SetTall( 30 )
        contact.DoClick = function()
            if self.OnContactSelected then
                local existingContacts = self.Recipient.Value:GetText()
                if existingContacts ~= "" then
                    existingContacts = existingContacts .. ", "
                end
                self.Recipient.Value:SetText(existingContacts .. k)
            end
        end
        table.insert( self.ContactPanels, contact )
    end
end

vgui.Register( "Pager.SelectContact", PANEL, "DFrame" )