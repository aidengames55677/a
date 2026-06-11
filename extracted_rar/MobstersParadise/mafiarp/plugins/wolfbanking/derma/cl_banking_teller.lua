local function bankingmenu()
  local frame = vgui.Create("WolfFrame")
  frame:SetSize(800,250)
  frame:Center()
  frame:MakePopup()
  frame:SetTitle("Bank Teller")

  local function wpTitle(wp, title)
    wp.title = wp:Add("DLabel")
    wp.title:SetText(title)
    wp.title:SetFont("WB_Small")
    wp.title:SetColor(color_white)
    wp.title:SetSize(wp:GetWide(), 25)
    wp.title:SetContentAlignment(5)
    function wp.title:Paint(w,h)
      draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,25))
    end
  end

  if LocalPlayer():HasBankAccount() then
    local wnd = frame:GetWorkPanel()
    wnd:SetWide(frame:GetWide()/2-4)
    wpTitle(wnd, "Deposits / Withdrawals")

    wnd.bal = wnd:Add("DLabel")
    wnd.bal:SetFont("WB_Medium")
    wnd.bal:SetColor(color_white)
    function wnd.bal:PerformLayout()
      self:SizeToContents()
      self:CenterHorizontal()
      self:CenterVertical(0.2)
    end
    function wnd.bal:Update()
      self:SetText("Balance: " .. LocalPlayer():BankBal() .. nut.currency.symbol)
    end
    wnd.bal:Update()

    local function actionButton(h)
      local ab = wnd:Add("WButton")
      ab:SetColor(color_white)
      ab:SetFont("WB_Small")
      ab:SetSize(150,35)
      ab:CenterHorizontal(h)
      ab:CenterVertical()
      ab:SetAccentColor(BC_NEUTRAL)
      function ab:Paint(w,h)
        draw.RoundedBox(4, 0, 0, w, h, self.color)
      end

      return ab
    end

    local function closeActions()
      if wnd.payLoan and IsValid(wnd.payLoan) then
        wnd.payLoan:AlphaTo(0,0.2,0)
      end

      wnd.withdraw:AlphaTo(0, 0.2, 0)
      wnd.deposit:AlphaTo(0, 0.2, 0, function()
        wnd.withdraw:Hide()
        wnd.deposit:Hide()
      end)

      --Hiding text
      wnd.bal:AlphaTo(0,0.2)
      if wnd.loan and IsValid(wnd.loan) then
        wnd.loan:AlphaTo(0,0.2)
      end
    end

    local function showEntryStage(hint, onComplete)
      local es = {}
      function es:Close()
        for k,v in pairs(self) do
          if isfunction(v) then continue end
          v:AlphaTo(0,0.2,0,function()
            v:Remove()
          end)
        end
      end

      es.hintp = wnd:Add("DLabel")
      es.hintp:SetFont("WB_Small")
      es.hintp:SetColor(Color(230,230,230))
      es.hintp:SetText(hint or "")
      es.hintp:SizeToContents()
      es.hintp:CenterHorizontal()
      es.hintp:CenterVertical(0.25)

      es.te = wnd:Add("DTextEntry")
      es.te:SetSize(150,30)
      es.te:Center()
      es.te:RequestFocus()
      es.te:SetNumeric(true)
      function es.te:Paint(w,h)
        draw.RoundedBox(4, 0, 0, w, h, Color(230,230,230))
        self:DrawTextEntryText(color_black, Color(100,100,100), color_black)
      end

      es.done = wnd:Add("WButton")
      es.done:SetSize(80,30)
      es.done:SetText("Done")
      es.done:SetFont("WB_Small")
      es.done:SetColor(color_white)
      es.done:SetAccentColor(BC_NEUTRAL)
      function es.done:PerformLayout(w, h)
        self:CenterHorizontal()
        self:CenterVertical(0.75)
      end
      function es.done:Paint(w,h)
        draw.RoundedBox(4, 0, 0, w, h, self.color)
      end
      function es.done:DoClick()
        local amount = tonumber(es.te:GetText())
        if not amount or amount == nil then
          es.done:Flash("Amount must be a number", BC_CRITICAL, 1)
          return
        end

        if amount <= 0 then
          es.done:Flash("You trying to rob this bank or what?", BC_CRITICAL, 1)
          return
        end

        onComplete(es)
      end

      --Fade-in children
      for k,v in pairs(es) do
        if isfunction(v) then continue end
        v:SetAlpha(0)
        v:AlphaTo(255,0.2,0)
      end
    end

    --Loan Display
    local actionFadeoutTime = 0.35
    if LocalPlayer():HasLoan() then
      wnd.loan = wnd:Add("DLabel")
      wnd.loan:SetText("Loan: " .. LocalPlayer():LoanAmount() .. nut.currency.symbol)
      wnd.loan:SetFont("WB_Medium")
      wnd.loan:SetColor(color_white)
      function wnd.loan:PerformLayout()
        self:SizeToContents()
        self:SetPos(0, wnd.bal:GetY()+wnd.bal:GetTall()+10)
        self:CenterHorizontal()
      end

      wnd.payLoan = actionButton(0.5)
      wnd.payLoan:SetText("Pay Loan")
      wnd.payLoan:CenterVertical(0.75)
      function wnd.payLoan:DoClick()
        self:GInflate(Color(215,215,215,50), true)

        closeActions()
        timer.Simple(actionFadeoutTime, function()
          showEntryStage("Enter the amount you would like to repay", function(es)
            local amount = tonumber(es.te:GetText())
            local loanAmount = LocalPlayer():LoanAmount()

            if amount > LocalPlayer():BankBal() then
              es.done:Flash("Not enough funds in bank account", BC_CRITICAL, 2)
              return
            end

            if amount > loanAmount then
              es.done:Flash("Amount entered is too high", BC_CRITICAL, 2)
              return
            end

            netstream.Start("PlayerRepayLoan", amount)
            frame:Close()
          end)
        end)
      end
    end

    --Item Bank
    local itemBank
    if wnd.payLoan and IsValid(wnd.payLoan) then
      wnd.payLoan:CenterHorizontal(0.75)
      itemBank = actionButton(0.25)
    else
      itemBank = actionButton(0.5)
    end

    itemBank:CenterVertical(0.75)
    itemBank:SetIcon("icon16/box.png")
    itemBank:SetText("Item Bank")
    function itemBank:DoClick()
      frame:Close()
      netstream.Start("PlayerOpenItemBank")
    end
    

    -- WITHDRAW
    wnd.withdraw = actionButton(0.25)
    wnd.withdraw:SetText("Withdraw")
    function wnd.withdraw:DoClick()
      self:GInflate(Color(215,215,215,50), true)

      closeActions()
      timer.Simple(actionFadeoutTime, function()
        showEntryStage("Enter the amount you would like to withdraw", function(es)
          local amount = tonumber(es.te:GetText())
          if LocalPlayer():BankBal() < amount then
            es.done:Flash("Not enough money in bank account", BC_CRITICAL, 2)
            return
          end

          netstream.Start("playerBankWithdraw", amount)
          LocalPlayer():EmitSound("artemis/signatureb.wav")
          frame:Close()
        end)
      end)
    end

    --DEPOSIT
    wnd.deposit = actionButton(0.75)
    wnd.deposit:SetText("Deposit")
    function wnd.deposit:DoClick()
      self:GInflate(Color(215,215,215,50), true)

      closeActions()
      timer.Simple(actionFadeoutTime, function()
        showEntryStage("Enter the amount you would like to deposit", function(es)
          --Check if the player has this amount of money
          local amount = tonumber(es.te:GetText())
          if not LocalPlayer():getChar():hasMoney(amount) then
            es.done:Flash("Insufficient Funds", BC_CRITICAL, 1)
            return
          end

          netstream.Start("playerBankDeposit", amount)
          LocalPlayer():EmitSound("artemis/signatureb.wav")
          frame:Close()
        end)
      end)
    end

    --Depositing Checks Part
    local cwp = frame:GetWorkPanel()
    cwp:SetWide(frame:GetWide()/2-4)
    cwp:SetPos(frame:GetWide()-cwp:GetWide(), cwp:GetY())
    wpTitle(cwp, "Deposit Checks")

    local tcb = {} --Temporary item ban, if a player has multiple checks they can't deposit the same one multiple times.

    cwp.hint = cwp:Add("DLabel")
    cwp.hint:SetFont("WB_Small")
    cwp.hint:SetColor(color_white)
    cwp.hint:SizeToContents()
    cwp.hint:SetText("")

    function cwp:DisplayDepoBtn()
      local inv = LocalPlayer():getChar():getInv()

      local checks = {}
      if inv then
        local items = inv:getItems()
        for k,v in pairs(inv:getItems()) do
          if v.uniqueID == "check" and v:getData("amount", nil) != nil then
            checks[#checks+1] = {
              id = v:getID(),
              itemData = v
            }
          end
        end
      end

      if #checks > 0 then
        cwp.hint:SetText("You have " .. #checks .. " check(s) available to deposit")
        cwp.hint:SizeToContents()
        cwp.hint:SetPos(0, cwp.title:GetTall() + 10)
        cwp.hint:CenterHorizontal()
      else
        cwp.hint:SetText("You do not have any checks to deposit.")
        cwp.hint:SizeToContents()
        cwp.hint:Center()
        return
      end

      cwp.dep = cwp:Add("WButton")
      cwp.dep:SetText("Deposit Check (" .. checks[1].itemData:getData("amount", nil) .. nut.currency.symbol .. ")")
      cwp.dep:SetColor(color_white)
      cwp.dep:SetFont("WB_Small")
      cwp.dep:SetSize(cwp:GetWide()*0.8, 30)
      cwp.dep:SetAccentColor(BC_NEUTRAL)
      cwp.dep:Center()
      function cwp.dep:Paint(w,h)
        if self:GetDisabled() then
          draw.RoundedBox(4, 0, 0, w, h, Color(140,140,140))
          return
        end
        draw.RoundedBox(4, 0, 0, w, h, self.color)
      end
      function cwp.dep:DoClick()
        self:SetDisabled(true)

        self:Flash("Please Wait...", BC_NEUTRAL, 2, true)
        netstream.Start("PlayerDepositCheck", checks[1])

        timer.Simple(2, function()
          -- tcb[check[1].id] = true

          wnd.bal:Update()
          cwp.dep:Remove()
          cwp.txHint:Remove()
          cwp:DisplayDepoBtn()
        end)
      end

      local cAmount = tonumber(checks[1].itemData:getData("amount", nil))
      local tx = BANKCONF.checkTaxes
      local symbol = nut.currency.symbol

      cwp.txHint = cwp:Add("DLabel")
      cwp.txHint:SetText([[
        Taxes will be deduced:
        ]] .. cAmount .. symbol .. [[ - ]] .. cAmount * tx .. symbol .. [[ (]] .. tx * 100 .. [[%)

        Total Deposited: ]] .. cAmount - (cAmount*tx) .. symbol .. [[
      ]])
      cwp.txHint:SetFont("WB_Small")
      cwp.txHint:SetColor(color_white)
      cwp.txHint:SizeToContents()
      cwp.txHint:CenterVertical(0.75)
      cwp.txHint:CenterHorizontal()
    end
    cwp:DisplayDepoBtn() --Initial call
  else --No Account Part
    local noacchint = frame:Add("DLabel")
    noacchint:SetText("You do not have a bank account, you can talk to a banker to open one.")
    noacchint:SetFont("WB_Small")
    noacchint:SetColor(color_white)
    noacchint:SizeToContents()
    noacchint:Center()
  end
end

netstream.Hook("OpenBankingTeller", bankingmenu)
