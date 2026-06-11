banksubm.loans = function(panel)
  local sc = panel:Add("DScrollPanel")
  sc:SetSize(panel:GetSize())

  --Panel Section
  local cr = panel:section(sc, "Create Loan")

  local wf = cr:Add("WolfForm") --Form
  wf:SetSize(cr:GetWide(), cr:GetTall()-30)

  --Form Entries
  local name = wf:AddTextEntry("Player Name")
  panel:PlayerSearchTE(name, function()
    if not name.player then return end
    if wf.amount:GetText() == nil or wf.amount:GetText() == "" then return end
    wf.amount:RequestFocus() --Focus on other TE

    local hint = cr:Add("DLabel")
    hint:SetFont("WB_Small")
    hint:SetColor(color_white)
    hint:SetAlpha(0)
    hint:SetContentAlignment(5)
    function hint:PerformLayout()
    end

    --Account Configs
    local p = BANKCONF.premiumSettings
    local r = BANKCONF.basicSettings

    function hint:Think()
      local amount = tonumber(wf.amount:GetText())
      if not amount then return end

      local inter
      if name.player:GetBankAccType() == PREM_ACC then
        inter = p.loanInter
      elseif name.player:GetBankAccType() == REG_ACC then
        inter = r.loanInter
      end

      hint:SetText([[
        Daily interests apply at a rate of: ]] .. inter .. [[%
        (+]] .. amount * inter .. nut.currency.symbol .. [[/day)
      ]])

      self:SetAlpha(255)
      self:SizeToContents()
      self:CenterHorizontal()
      self:CenterVertical(0.70)
    end
  end)
  wf.amount = wf:AddTextEntry("Amount")
  wf.amount:SetNumeric(true)

  --Done Button
  local done = cr:Add("DButton")
  done:SetText("Create Loan")
  done:SetFont("WB_Small")
  done:SetColor(color_white)
  done:SetSize(cr:GetWide(), 30)
  done:SetPos(0,cr:GetTall()-done:GetTall())
  done:SetColorAcc(BC_NEUTRAL)
  done:SetupHover(BC_NEUTRAL_HOV)
  function done:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, self.color)
  end
  function done:DoClick()
    if not wf.amount:GetText() or wf.amount:GetText() == "" then return end
    if not name.player or not IsValid(name.player) then return end
    local loanAmount = tonumber(wf.amount:GetText())

	if loanAmount > 10000 and not LocalPlayer():IsSuperAdmin() then
		nut.util.notify("You can only loan out a maximum of $10000", NOT_ERROR)
      	return
	end

    if loanAmount <= 0 then
      nut.util.notify("You trying to rob this player or what?", NOT_ERROR)
      return
    end

    if not name.player:HasBankAccount() then
      nut.util.notify("Player doesn't have a bank account!", NOT_ERROR)
      return
    end

    --Check BGF funds
    if loanAmount > BGF:GetFunds() then
      nut.util.notify("The bankers do not have funds to lend money at the moment", NOT_CANCELLED)
      return
    end

    local blur = CreateOverBlur(function(blur)
      local frame = vgui.Create("WolfFrame")
      frame:SetSize(500,200)
      frame:Center()
      frame:MakePopup()
      function frame:OnRemove()
        blur:SmoothClose()
      end

      local function createChoice(text, col)
        local b = frame:Add("DButton")
        b:SetText(text)
        b:SetColor(color_white)
        b:SetFont("WB_Small")
        b:SetSize(frame:GetWide()/2, 30)
        b:SetColorAcc(col)
        b:SetupHover(getHovCol(col))
        function b:Paint(w,h)
          draw.RoundedBox(0, 0, 0, w, h, self.color)
        end

        return b
      end

      --Choices
      local y = createChoice("Yes", BC_AGREE)
      y:SetPos(0, frame:GetTall()-y:GetTall())
      function y:DoClick()
        frame:Close()

        netstream.Start("BankerCreateLoan", name.player, loanAmount)
      end

      local n = createChoice("No", BC_CRITICAL)
      n:SetPos(y:GetWide(), frame:GetTall()-n:GetTall())
      function n:DoClick()
        frame:Close()
      end

      --What's the question?
      frame.hint = frame:Add("DLabel")
      frame.hint:SetText("Are you sure you want to create a loan for " .. name.player:Nick() .. "?")
      frame.hint:SetFont("WB_Small")
      frame.hint:SetColor(color_white)
      frame.hint:SizeToContents()
      frame.hint:SetPos(0, (frame:GetTall()-y:GetTall())/2 - frame.hint:GetTall()/2)
      frame.hint:CenterHorizontal()
    end)
  end

  local loanlist = panel:section(sc, "Loan List")
  loanlist:SetSize(panel:GetWide(), panel:GetTall()-cr:GetTall()-20)
  follow(loanlist, cr, BOTTOM)

  local lsc = loanlist:Add("WScrollList")
  lsc:SetSize(loanlist:GetWide(), loanlist:GetTall()-25)
  lsc:SetPos(0,25)
  local llist = lsc:GetList(2,2)

  local function addPlayerToList(ply)
    if not ply.getChar or not ply:getChar() then return end
    local loanAmt = ply:LoanAmount()

    local pp = llist:Add("DPanel")
    pp:SetSize(llist:GetWide(), 45)
    function pp:Paint(w,h)
      draw.RoundedBox(4,0,0,w,h,Color(35,35,35))
    end

    pp.name = pp:Add("DLabel")
    pp.name:SetText(ply:Nick())
    pp.name:SetFont("WB_Small")
    pp.name:SetColor(color_white)
    pp.name:SizeToContents()
    pp.name:CenterHorizontal(0.25)
    pp.name:CenterVertical()

    pp.amt = pp:Add("DLabel")
    pp.amt:SetText(nut.currency.get(loanAmt))
    pp.amt:SetColor(Color(255,0,0))
    pp.amt:SetFont("WB_Small")
    pp.amt:SizeToContents()
    pp.amt:CenterHorizontal(0.75)
    pp.amt:CenterVertical()
  end

  for _,ply in pairs(player.GetAll()) do
    cprint(ply)
    if ply.getChar and ply:getChar() then
      if ply:HasBankAccount() and ply:LoanAmount() > 0 then
        cprint("Add the player")
        addPlayerToList(ply)
      end
    end
  end
end
