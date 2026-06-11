function OpenBankingReviewMenu(ply)
  local blur = CreateOverBlur()

  local frame = vgui.Create("WolfFrame", blur)
  frame:SetSize(500,600)
  frame:MakePopup()
  frame:Center()
  function frame:OnClose()
    blur:SmoothClose()
  end

  local sup = frame:Add("DLabel")
  sup:SetText("Hello!")
  sup:SetFont("WB_Medium")
  sup:SetColor(color_white)
  sup:SizeToContents()
  sup:Center()
end