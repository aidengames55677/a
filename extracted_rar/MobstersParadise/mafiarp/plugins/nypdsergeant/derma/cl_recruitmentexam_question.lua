-- "gamemodes\\mafiarp\\plugins\\nypdsergeant\\derma\\cl_recruitmentexam_question.lua"


local PANEL = {}

function PANEL:Init()
    self.Label = vgui.Create( "DLabel", self )
    self.Label:Dock( TOP )
    self.Label:SetText( "Unloaded question" )
    self.Label:DockMargin( 5, 0, 0, 0 )

    self.Options = {}
    self.MultipleChoice = false
end

function PANEL:GetSelectedOptions()
    local options = {}

    for k, v in pairs( self.Options ) do
        if v:GetChecked() then
            table.insert( options, v )
        end
    end

    return options
end

function PANEL:SetQuestionInfo( questionInfo )
    self.QuestionInfo = questionInfo

    self.Label:SetText( questionInfo.Description )

    for k, v in pairs( self.Options ) do
        v:Remove()
    end

    self.Options = {}

    for k, v in ipairs( questionInfo.Options ) do
        local option = vgui.Create( "DCheckBoxLabel", self )
        option:Dock( TOP )
        option:DockMargin( 5, 0, 0, 0 )
        option:SetText( v )
        option.Index = k
        option.OnChange = function( change )
            if change and not self.MultipleChoice then
                for _, selectedOption in pairs( self:GetSelectedOptions() ) do
                    if selectedOption == option then continue end
                    selectedOption:SetChecked( false )
                end
            end
        end

        self.Options[k] = option
    end

    self:UpdateHeight()
end

function PANEL:UpdateHeight()
    local height = 5

    height = height + self.Label:GetTall()

    for k, v in pairs( self.Options ) do
        height = height + v:GetTall()
    end

    self:SetTall( height )
end

function PANEL:IsAnswerCorrect()
    if not self.QuestionInfo then
        return false
    end

    local selections = self:GetSelectedOptions()

    if #selections < 1 then
        return false
    end

    for k, v in pairs( selections ) do
        selections[k] = v.Index
    end

    local answer = self.QuestionInfo.Answer

    if not istable( answer ) then
        return answer == selections[1]
    else
        return NYPDSergeant:TablesMatch( answer, selections )
    end
end

vgui.Register( "RecruitmentExam.Question", PANEL, "DPanel" )