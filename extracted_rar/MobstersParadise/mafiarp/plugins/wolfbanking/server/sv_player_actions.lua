--Deposit/Withdraw
netstream.Hook("playerBankDeposit", function(ply, amount)
  local char = ply:getChar()
  local bal = ply:BankBal()

  if char:hasMoney(amount) then
    char:takeMoney(amount)
    ply:SetBankBal(bal + amount)
    ply:notify(amount .. nut.currency.symbol .. " was deposited into your account.", NOT_CORRECT)
  else
    ply:notify("Something went wrong when depositing the money (Err: NEF)", NOT_CANCELLED)
  end

  --Log
  banklist.Add(ply, DEPOSIT, {
    amount = amount,
    time = os.time()
  })
end)

netstream.Hook("playerBankWithdraw", function(ply, amount)
  local char = ply:getChar()
  local bal = ply:BankBal()
  
  if bal >= amount then
    char:giveMoney(amount)
    ply:SetBankBal(bal - amount)
    ply:notify(amount .. nut.currency.symbol .. " was withdrawn", NOT_CORRECT)
  else
    ply:notify("Something went wrong while withdrawing the money (Err: NEF2)", NOT_CANCELLED)
  end

  --Log
  banklist.Add(ply, WITHDRAW, {
    amount = amount,
    time = os.time()
  })
end)

--Deposit Check
netstream.Hook("PlayerDepositCheck", function(ply, check)
  check = ply:getChar():getInv():getItemByID(check.itemData.id)
  print(check:getData("amount"))
  if check:getData("target", nil) == ply:SteamID64() then
    local cAmount = tonumber(check:getData("amount"))
    local tx = BANKCONF.checkTaxes --The deposit tax
    local dAmount = cAmount - (cAmount*tx)

    ply:SetBankBal(ply:BankBal() + dAmount)
    ply:notify("Your check was successfuly deposited! (" .. dAmount .. nut.currency.symbol .. ")", NOT_CORRECT)

    BGF:AddFunds(cAmount * tx) --Add tax to BGF

    check:remove()
    
    --Log
    banklist.Add(ply, CHECKDEPO, {
      amount = dAmount,
      tax = cAmount*tx,
      time = os.time()
    })
  end
end)

--Repay Loan
netstream.Hook("PlayerRepayLoan", function(ply, amount)
  if not ply:HasLoan() then return end
  
  --Moving money
  ply:SetBankBal(ply:BankBal() - amount)
  ply:SetLoan(ply:LoanAmount() - amount)

  --Regiving money to BGF
  BGF:AddFunds(amount)
  
  --Loan Finish!
  if ply:LoanAmount() <= 0 then
    ply:SetLoan(0)

    ply:notify("You have payed the remaining of your loan!", NOT_CORRECT)
  end

  ply:notify("You repayed " .. nut.currency.get(amount) .. " off of your loan")

  --Log
  banklist.Add(ply, REPAYLOAN, {
    amount = amount,
    time = os.time()
  })
end)

--Player Writes Check
netstream.Hook("PlayerWritesCheck", function(ply, item, target, amount)
  amount = tonumber(amount)
  local char = ply:getChar()
  local bBal = ply:BankBal()

  if not bBal >= amount then return end
  ply:SetBankBal(bBal - amount)

  for k,v in pairs(char:getInv():getItems()) do
    if v.id == item.id then
      v:setData("writer", ply:SteamID64())
      v:setData("targetName",  target:Nick())
      v:setData("target", target:SteamID64())
      v:setData("amount", amount)
      break
    end
  end
end)

--Player open item bank
netstream.Hook("PlayerOpenItemBank", function(ply)
  local char = ply:getChar()
  local ibInvID = char:getData("itemBankInvID", nil)
  
  local isVIP = false
  for _,g in pairs(BANKCONF.vipGroups) do
    if ply:IsUserGroup(g) then
      isVIP = true
    end
  end

  if not ibInvID then --Inventory has not been created yet
    local invType --Determinating inventory category
    if isVIP then
      invType = "itemBankInventoryVIP"
    else
      invType = "itemBankInventory" 
    end

    --Creating inventory
    nut.item.newInv(char:getID(), invType, function(inventory) --Creating ivnentory if not exist
      char:setData("itemBankInvID", inventory:getID())
      ibInvID = inventory:getID()
      ply:getCha():setData("itemBankInvID", ibInvID) --Saving Inventory ID
    end)
  else --Possible problems trying to get solved.
    local inv = nut.item.inventories[ibInvID]
    local w,h = inv:getSize()
    local regInvType = nut.item.inventoryTypes["itemBankInventory"]

    if isVIP and w == regInvType.w and h == regInvType.h then --VIP has Regular Inventory

      print(" -> Converting Regular Item bank to VIP Item bank (" .. ply:Nick() .. ") <-")

      nut.item.newInv(char:getID(), "itemBankInventoryVIP", function(inventory)
        for _,i in pairs(inv:getItems()) do --Transfering items to new inventory
          i:transfer(inventory:getID())
        end

        ibInvID = inventory:getID()
        char:setData("itemBankInvID", ibInvID) --Saving Inventory ID
      end)

    elseif not isVIP and w ~= regInvType.w and h ~= regInvType.h then --Regular has VIP Inventory

      print(" -> Converting VIP Item bank to Regular Item bank (" .. ply:Nick() .. ") <-")

      nut.item.newInv(char:getID(), "itemBankInventory", function(inventory)
        for _,i in pairs(inv:getItems()) do --Transfering items to new inventory
          i:transfer(inventory:getID())
        end

        ibInvID = inventory:getID()
        char:setData("itemBankInvID", ibInvID) --Saving Inventory ID
      end)
    end
  end

  netstream.Start(ply, "OpenItemBank", ibInvID)
end)