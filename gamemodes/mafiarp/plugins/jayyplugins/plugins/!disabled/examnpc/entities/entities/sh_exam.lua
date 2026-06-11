ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Exam NPC"
ENT.Category = "RedDawn - MafiaRP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Exam = {"Question 1", "Question 2", "Question 3"} -- Default exam

if SERVER then
    util.AddNetworkString("OpenExam")

    function ENT:Initialize()
        self:SetModel("models/player/breen.mdl")
        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:DrawShadow(true)
        self:SetSolid(SOLID_OBB)
        self:PhysicsInit(SOLID_OBB)
        self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)
        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end
    end

    function ENT:SetExam(exam)
        self.Exam = exam
    end

    function ENT:AcceptInput(name, activator)
        if name == "Use" and IsValid(activator) and activator:IsPlayer() then
            if activator:IsAdmin() then
                net.Start("OpenExam")
                net.WriteTable(self.Exam)
                net.Send(activator)
            end
        end
    end    
end

if CLIENT then
    local questions = {
        {title = "Question 1", description = "Description 1", answer = "Answer 1"},
    }

    local function openMainScreen()
        local frame = vgui.Create("DFrame")
        frame:SetSize(500, 500)
        frame:SetTitle("Exam")
        frame:Center()
        frame:MakePopup()

        local editButton = vgui.Create("DButton", frame)
        editButton:SetText("Edit Questions")
        editButton:SetPos(25, 25)
        editButton:SetSize(100, 20)
        editButton.DoClick = function()
            frame:Close()
            openEditScreen()
        end

        local score = 0

        for i, question in ipairs(questions) do
            local label = vgui.Create("DLabel", frame)
            label:SetPos(25, 50 + (i - 1) * 50)
            label:SetText(question.title)
            label:SizeToContents()

            local textEntry = vgui.Create("DTextEntry", frame)
            textEntry:SetPos(25, 75 + (i - 1) * 50)
            textEntry:SetSize(450, 20)
            textEntry.OnEnter = function(self)
                if self:GetValue() == question.answer then
                    score = score + 1
                end

                if i == #questions then
                    local scoreLabel = vgui.Create("DLabel", frame)
                    scoreLabel:SetPos(25, 75 + #questions * 50)
                    scoreLabel:SetText("Score: " .. score .. "/" .. #questions)
                    scoreLabel:SizeToContents()
                end
            end
        end

        local function openEditScreen()
            local frame = vgui.Create("DFrame")
            frame:SetSize(500, 500)
            frame:Center()
            frame:SetTitle("Exam")
            frame:MakePopup()
        
            local list = vgui.Create("DListView", frame)
            list:SetSize(450, 450)
            list:SetPos(25, 25)
            list:AddColumn("Title")
            list:AddColumn("Description")
            list:AddColumn("Answer")
        
            for i, question in ipairs(questions) do
                local line = list:AddLine(question.title, question.description, question.answer)
                for j=1,3 do
                    local textEntry = vgui.Create("DTextEntry", line)
                    textEntry:Dock(FILL)
                    textEntry:SetText(line:GetValue(j))
                    textEntry.OnEnter = function(self)
                        line:SetValue(j, self:GetValue())
                        if j == 1 then
                            questions[i].title = self:GetValue()
                        elseif j == 2 then
                            questions[i].description = self:GetValue()
                        else
                            questions[i].answer = self:GetValue()
                        end
                    end
                    line:SetColumnText(j, textEntry)
                end
            end
    
            local addButton = vgui.Create("DButton", frame)
            addButton:SetText("Add Question")
            addButton:SetPos(25, 480)
            addButton:SetSize(100, 20)
            addButton.DoClick = function()
                table.insert(questions, {title = "New Question", description = "New Description", answer = "New Answer"})
                frame:Close()
                openEditScreen()
            end
    
            local removeButton = vgui.Create("DButton", frame)
            removeButton:SetText("Remove Question")
            removeButton:SetPos(130, 480)
            removeButton:SetSize(100, 20)
            removeButton.DoClick = function()
                local selected = list:GetSelectedLine()
                if selected then
                    table.remove(questions, selected)
                    frame:Close()
                    openEditScreen()
                end
            end
    
            local backButton = vgui.Create("DButton", frame)
            backButton:SetText("Back")
            backButton:SetPos(235, 480)
            backButton:SetSize(100, 20)
            backButton.DoClick = function()
                frame:Close()
                openMainScreen()
            end
        end
    end

    net.Receive("OpenExam", function()
        openMainScreen()
    end)
end
