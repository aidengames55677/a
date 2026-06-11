-- "gamemodes\\mafiarp\\plugins\\nypdsergeant\\derma\\cl_recruitmentexam.lua"


local PANEL = {}

function PANEL:Init()
    self:SetSize( 820, 600 )
    self:SetTitle( "Pre-Recruitment Exam" )
    self:MakePopup()
    self:Center()

    self.Questions = vgui.Create( "DScrollPanel", self )
    self.Questions:Dock( FILL )

    self.QuestionPanels = {}

    for k, v in pairs( NYPDSergeant.Questions ) do
        local question = vgui.Create( v.Type == NYPDSergeant.QUESTION_TYPE.ORDERED_LIST and "RecruitmentExam.Question.List" or "RecruitmentExam.Question", self.Questions )
        question:Dock( TOP )
        question:DockMargin( 5, 5, 5, 0 )
        if v.Type == NYPDSergeant.QUESTION_TYPE.MULTIPLE_CHOICE then
            question.MultipleChoice = true
        end
        question:SetQuestionInfo( v )

        table.insert( self.QuestionPanels, question )
    end

    self.Buttons = vgui.Create( "DPanel", self )
    self.Buttons:Dock( BOTTOM )
    self.Buttons:SetTall( 44 )
    self.Buttons.Paint = function() end

    self.CancelButton = vgui.Create( "DButton", self.Buttons )
    self.CancelButton:SetText( "Cancel" )
    self.CancelButton:Dock( LEFT )
    self.CancelButton.DoClick = function()
        self:Close()
    end

    self.SubmitButton = vgui.Create( "DButton", self.Buttons )
    self.SubmitButton:SetText( "Submit" )
    self.SubmitButton:Dock( RIGHT )
    self.SubmitButton.DoClick = function()
        Derma_Query( "Are you sure you want to submit the test?", "Submit", "Yes", function()
            self:Submit()
        end, "No" )
    end

    self.Buttons.PerformLayout = function( _, w, h )
        self.SubmitButton:SetWide( w / 2 - 1 )
        self.CancelButton:SetWide( w / 2 - 1 )
    end
end

function PANEL:Submit()
    local score, scoreTotal = 0, 0

    for k, v in pairs( self.QuestionPanels ) do
        if not v.QuestionInfo then return end

        scoreTotal = scoreTotal + v.QuestionInfo.Score
        if v:IsAnswerCorrect() then
            score = score + v.QuestionInfo.Score
        end
    end

    local scorePercent = math.Clamp( math.Round( ( score / scoreTotal ) * 100 ), 0, 100 )
    local passed = scorePercent >= NYPDSergeant.ScoreNeeded

    net.Start( "NYPD.TestComplete" )
    net.WriteBool( passed )
    net.SendToServer()

    if passed then
        nut.util.notify( "You passed with " .. scorePercent .. "%" )
    else
        nut.util.notify( "You failed with " .. scorePercent .. "%" )
    end

    self:Close()
end

function PANEL:Think()
    if input.IsKeyDown( KEY_ESCAPE ) then
        RunConsoleCommand( "cancelselect" )
        self:Close()
    end
end

vgui.Register( "RecruitmentExam", PANEL, "DFrame" )