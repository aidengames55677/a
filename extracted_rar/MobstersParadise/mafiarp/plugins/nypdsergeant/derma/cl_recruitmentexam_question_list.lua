-- "gamemodes\\mafiarp\\plugins\\nypdsergeant\\derma\\cl_recruitmentexam_question_list.lua"


local PANEL = {}

function PANEL:Init()
    self.Label = vgui.Create( "DLabel", self )
    self.Label:Dock( TOP )
    self.Label:SetText( "Unloaded question" )
    self.Label:DockMargin( 5, 0, 0, 0 )

    self.Options = {}
    self.Buttons = {}
end

function PANEL:SetQuestionInfo( questionInfo )
    self.QuestionInfo = questionInfo
    self.Label:SetText( questionInfo.Description )

    for k, v in pairs( self.Options ) do
        v:Remove()
    end

    self.Options = {}

    for k, v in pairs( questionInfo.Options ) do
        self.Options[k] = {
            Text = v,
            ID = k
        }
    end

    self:EnsureButtons()
    self:UpdateHeight()
end

function PANEL:MoveUp( i )
    if i <= 1 then return end
    self.Options[i], self.Options[i - 1] = self.Options[i - 1], self.Options[i]
    self:EnsureButtons()
end

function PANEL:MoveDown( i )
    if i >= #self.Options then return end
    self.Options[i], self.Options[i + 1] = self.Options[i + 1], self.Options[i]
    self:EnsureButtons()
end

function PANEL:EnsureButtons()
    for k, v in pairs( self.Buttons ) do
        v:Remove()
    end

    self.Buttons = {}

    for k, v in ipairs( self.Options ) do
        local btnPanel = vgui.Create( "DPanel", self )
        btnPanel:Dock( TOP )

        local displayButton = vgui.Create( "DButton", btnPanel )
        displayButton:Dock( FILL )
        displayButton:SetText( v.Text )

        local downButton = vgui.Create( "DButton", btnPanel )
        downButton:Dock( RIGHT )
        downButton:SetText( "↓" )
        downButton:SetWide( 30 )
        downButton.DoClick = function()
            self:MoveDown( k )
        end

        local upButton = vgui.Create( "DButton", btnPanel )
        upButton:Dock( RIGHT )
        upButton:SetText( "↑" )
        upButton:SetWide( 30 )
        upButton.DoClick = function()
            self:MoveUp( k )
        end

        self.Buttons[k] = btnPanel
    end

    self:UpdateHeight()
end

function PANEL:UpdateHeight()
    local height = 3

    height = height + self.Label:GetTall()

    for k, v in pairs( self.Buttons ) do
        height = height + v:GetTall()
    end

    self:SetTall( height )
end

function PANEL:IsAnswerCorrect()
    if not self.QuestionInfo then
        return false
    end

    local options = {}

    for k, v in ipairs( self.Options ) do
        table.insert( options, v.ID )
    end

    return table.concat( self.QuestionInfo.Answer ) == table.concat( options )
end

vgui.Register( "RecruitmentExam.Question.List", PANEL, "DPanel" )