local function openBankingManager()
  if not LocalPlayer():getChar():getFlags():find("b") then --Check if player has 'b' flag
    nut.util.notify("You cannot access this menu", NOT_CANCELLED)
    return
  end

  local frame = vgui.Create("WolfFrame")
  frame:SetSize(750,500)
  frame:SetTitle("Bank Manager")
  frame:MakePopup()
  frame:Center()

  local wp = frame:GetWorkPanel()
  function wp:ClearChildren(callback)
    for k,v in pairs(self:GetChildren()) do
      if v == wp.tabsScroll or v == wp.tabsList then continue end
      v:AlphaTo(0, 0.2, 0)
    end

    timer.Simple(0.2, function() if callback then callback() end end)
  end

  wp.tabsScroll = wp:Add("DScrollPanel")
  wp.tabsScroll:SetSize(wp:GetWide(), 30)
  wp.tabsList = wp.tabsScroll:Add("DIconLayout")
  wp.tabsList:SetSize(wp.tabsScroll:GetSize())

  local function createIWP()
    local iwp = wp:Add("DPanel")
    iwp:SetSize(wp:GetWide(), wp:GetTall()-wp.tabsScroll:GetTall())
    iwp:SetPos(0,wp.tabsScroll:GetTall())
    iwp.Paint = nil

    function iwp:PlayerSearchTE(te, callback)
      te.player = nil --Reset player
      function te:OnEnter()
        self:RequestFocus()
        local val = self:GetText():lower()
        for k,v in pairs(player.GetAll()) do
          local pn = v:Nick():lower() --Player Name
          if pn:find(val) or val == pn then
            self:SetText(v:Nick())
            self.player = v --Ez access to the desired player
          end
        end

        if callback then callback() end
      end
    end

    return iwp
  end
  local iwp = createIWP()

  function iwp:section(panel, hint)
    local s = panel:Add("DPanel")
    s:SetSize(panel:GetWide(),panel:GetTall()*0.35)
    function s:Paint(w,h)
      surface.SetDrawColor(Color(40,40,40))
      surface.DrawRect(0, 0, w, h)
    end

    s.hint = s:Add("DLabel")
    s.hint:SetText(hint)
    s.hint:SetFont("WB_Small")
    s.hint:SetColor(color_white)
    s.hint:SetSize(s:GetWide(), 25)
    s.hint:SetContentAlignment(5)
    function s.hint:Paint(w,h)
      draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30))
    end

    return s
  end

  --BGF Summary
  local g = group()
  g.title = iwp:Add("DLabel")
  g.title:SetText("General Bank funds & stats")
  g.title:SetFont("WB_Large")
  g.title:SizeToContents()
  g.title:SetPos(0,5)
  g.title:CenterHorizontal()

  local function addStat(title, val, horizontalFrac, verticalFrac)
    horizontalFrac = horizontalFrac or 0.5
    verticalFrac = verticalFrac or 0.5
    
    g[title.."title"] = iwp:Add("DLabel")
    local statTitle = g[title.."title"]
    statTitle:SetText(title)
    statTitle:SetFont("WB_Medium")
    statTitle:SizeToContents()
    statTitle:CenterHorizontal(horizontalFrac)
    statTitle:CenterVertical(verticalFrac)

    g[title .. "val"] = iwp:Add("DLabel")
    local statVal = g[title .. "val"]
    statVal:SetText(val)
    statVal:SetFont("WB_Enormous")
    statVal:SizeToContents()
    follow(statVal, statTitle, BOTTOM)
    statVal:SetPos(statVal:GetX()+statTitle:GetWide()/2-statVal:GetWide()/2, statVal:GetY())

    return statTitle, statVal
  end

  local t,v = addStat("Funds left for investments/loans", nut.currency.get(BGF:GetFunds()), 0.5, 0.25)
  v:SetColor(Color(75,225,75))

  BGF:CalculateStats(function(data)
    local totAcc = data.totalAccounts
    local premAcc = data.totalPremium
    
    --Adding stats to menu
    addStat("Total Bank Accounts", data.totalAccounts, 0.20)
    addStat("Total Premium Accounts", data.totalPremium, 0.80)

    --Calculating what pourcentage of accounts are premium
    local pourc = math.ceil((premAcc*100)/totAcc)
    addStat("Percentage of premium accounts", pourc .. "%")

    --Calculating revenue/hr
    local accPremFees = BANKCONF.premiumSettings.upRunAmount
    local rev = math.Round(premAcc * accPremFees, 2)
    local t,v = addStat("Revenue per day", nut.currency.get(rev) .. "/day", 0.5, 0.75)
    v:SetColor(Color(75,225,75))
  end)

  local tabs = {
    ["Accounts"] = banksubm.accounts,
    ["Loans"] = banksubm.loans
    -- ["Logs"] = banksubm.logs
  }

  local activeTab
  for title,open in pairs(tabs) do
    local t = wp.tabsList:Add("DButton")
    t:SetText(title)
    t:SetFont("WB_Small")
    t:SetColor(color_white)
    t:SetSize(wp.tabsList:GetWide()/table.Count(tabs), 30)
    t:SetColorAcc(Color(60,60,75))
    t:SetupHover(Color(70,70,85))
    function t:Paint(w,h)
      draw.RoundedBox(0, 0, 0, w, h, self.color)
      if self == activeTab then
        surface.SetDrawColor(BC_NEUTRAL)
        surface.DrawRect(0, h-1, w, 1)
      end
    end
    function t:DoClick()
      activeTab = self
      iwp:Clear()
      open(iwp)
    end

    -- --Auto Select first tab
    -- if title == "Accounts" then
    --   t:DoClick()
    -- end
  end
end

netstream.Hook("OpenBankingManageMenu", openBankingManager)
