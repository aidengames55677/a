net.Receive("OpenExam", function()
    local exam = net.ReadTable()

    local frame = vgui.Create("DFrame")
    frame:SetSize(500, 500)
    frame:Center()
    frame:MakePopup()

    local answers = {}

    for i, questionText in ipairs(exam) do
        local question = vgui.Create("DLabel", frame)
        question:SetText(questionText)
        question:SetPos(25, 25 + (i - 1) * 50)
        question:SizeToContents()

        local answer = vgui.Create("DTextEntry", frame)
        answer:SetPos(25, 50 + (i - 1) * 50)
        answer:SetSize(450, 20)
        answers[i] = answer
    end

    local submit = vgui.Create("DButton", frame)
    submit:SetText("Submit")
    submit:SetPos(25, 50 + #exam * 50)
    submit:SetSize(450, 20)
    submit.DoClick = function()
        for i, answer in ipairs(answers) do
            -- Check the answer and provide feedback
            print("Answer to question " .. i .. ": " .. answer:GetValue())
        end
    end
end)
