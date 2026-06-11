-- "gamemodes\\mafiarp\\plugins\\bonemerge\\derma\\cl_vendorpanel_skin.lua"

local SKIN = {}

SKIN.fontFrame = "BudgetLabel"
SKIN.fontTab = "nutSmallFont"
SKIN.fontButton = "nutSmallFont"

SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)
SKIN.Colours.Window.TitleActive = Color(0, 0, 0)
SKIN.Colours.Window.TitleInactive = Color(255, 255, 255)

SKIN.Colours.Button.Normal = Color(255, 255, 255)
SKIN.Colours.Button.Hover = Color(0, 0, 0)
SKIN.Colours.Button.Down = Color(20, 20, 20)
SKIN.Colours.Button.Disabled = Color(0, 0, 0, 100)

function SKIN:PaintFrame(panel)
    surface.SetDrawColor(0, 0, 0, 180)
    surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
end

function SKIN:DrawGenericBackground(x, y, w, h)
    surface.SetDrawColor(45, 45, 45, 240)
    surface.DrawRect(x, y, w, h)

    surface.SetDrawColor(0, 0, 0, 180)
    surface.DrawOutlinedRect(x, y, w, h)

    surface.SetDrawColor(100, 100, 100, 25)
    surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2)
end

function SKIN:PaintPanel(panel)
    if (not panel.m_bBackground) then return end
    if (panel.GetPaintBackground and not panel:GetPaintBackground()) then
        return
    end

    local w, h = panel:GetWide(), panel:GetTall()

    surface.SetDrawColor(0, 0, 0, 100)
    surface.DrawRect(0, 0, w, h)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintButton(panel)
    if !panel.laidOut then
        if IsValid(panel.price) then
            panel.price:SetPos(panel:GetWide() - panel.price:GetWide(), 0)
        end

        panel.laidOut = true
    end

    if (not panel.m_bBackground) then return end
    if (panel.GetPaintBackground and not panel:GetPaintBackground()) then
        return
    end

    if IsValid(panel.price) then
        panel.price:SetTextColor(Color(255,255,255))
    end

    local w, h = panel:GetWide(), panel:GetTall()
    local alpha = 0

    if (panel:GetDisabled()) then
        alpha = 10
    elseif (panel.Depressed) then
        alpha = 160
        if IsValid(panel.price) then
            panel.price:SetTextColor(Color(0,0,0))
        end
    elseif (panel.Hovered) then
        alpha = 200
        if IsValid(panel.price) then
            panel.price:SetTextColor(Color(0,0,0))
        end
    end

    surface.SetDrawColor(255, 255, 255, alpha)
    surface.DrawRect(0, 0, w, h)
end

-- I don't think we gonna need minimize button and maximize button.
function SKIN:PaintWindowMinimizeButton(panel, w, h)
end

function SKIN:PaintWindowMaximizeButton(panel, w, h)
end

derma.DefineSkin("ClothingVendor", "The skin for bonemerge clothing vendors.", SKIN)
derma.RefreshSkins()