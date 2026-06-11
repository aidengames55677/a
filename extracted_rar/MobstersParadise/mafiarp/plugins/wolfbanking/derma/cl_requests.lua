netstream.Hook("BankUpdateAccount.Request", function(banker, atype)
  local URA = BANKCONF.premiumSettings.upRunAmount
  if atype == PREM_ACC then
    nut.util.notifQuery("Would you want to take out a premium account? (" .. nut.currency.get(URA) .. "/day)", "Yes", "No", true, NOT_CORRECT, function(code)
      netstream.Start("BankUpdateAccount.Return", banker, atype, (code==1))
    end)
  elseif atype == REG_ACC then
    nut.util.notifQuery("Would you want to downgrade your bank account to regular? (You will lose all your benefits)", "Yes", "No", true, NOT_CORRECT, function(code)
      netstream.Start("BankUpdateAccount.Return", banker, atype, (code==1))
    end)
  end
end)

netstream.Hook("BankerCreateLoan.Request",  function(banker, amount)
  nut.util.notifQuery(banker:Nick() .. " is giving you a " .. nut.currency.get(amount) .. " loan. Do you want to accept it?", "Accept", "Refuse", true, NOT_CORRECT,
  function(code)
    netstream.Start("BankerCreateLoan.Return", banker, amount, (code == 1))
  end)
end)
