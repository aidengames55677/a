PLUGIN = PLUGIN or {}
PLUGIN.name = "Banking"
PLUGIN.desc = "The banking solution for 1942RP"
PLUGIN.author = "Robert Bearson"

BANKCONF = {}

--Enums
REG_ACC = 1
PREM_ACC = 2

--Settings
nut.util.include("sh_bank_gen_funds.lua") --Get the BGF vars before assigning them to the BANKCONF settings table
BANKCONF.secDay = 86400 --How many seconds in a (real time) day
BANKCONF.checkTaxes = 0.15 -- 15% Taxes on check deposit

BANKCONF.upRunInverval = 14400 --Interval of when players need to pay for their account
BANKCONF.loanInterestInverval = BANKCONF.secDay --Adds interests everyday
BANKCONF.premiumSettings = {
  upRunAmount = 50,
  loanInter = 1.5, -- premium account loan interest
  balInter = 0.5 --10% Balance Interest
}

BANKCONF.inventorySize = {
  default = {
    width = 10,
    height = 10
  }
}
nut.item.registerInv("itemBankInventory", 10, 10) --100 Slots
nut.item.registerInv("itemBankInventoryVIP", 12, 12) --144 Slots

BANKCONF.basicSettings = {
  loanInter = 1.5, -- regular account loan interest
}

BANKCONF.vipGroups = {
  "superadmin", 
  "vip"
}

BANKCONF.hint = "Enter part of or the full name of the player then press ENTER"

--Resources
resource.AddFile("sound/artemis/signatureb.wav")
nut.util.include("sh_meta.lua")
nut.util.include("server/sv_meta.lua")
nut.util.include("sh_bank_logging.lua")
nut.util.include("server/sv_player_actions.lua")
nut.util.include("server/sv_banker_actions.lua")
nut.util.include("server/sv_intervals.lua")
nut.util.include("subscriptions/sh_subscriptions.lua")
nut.util.include("subscriptions/sv_subscriptions.lua")

banksubm = {}
nut.util.include("derma/subm/cl_accounts.lua")
nut.util.include("derma/subm/cl_loans.lua")
nut.util.include("derma/subm/cl_logs.lua")

function PLUGIN:LoadData()
  -- REE
  banklist:Init()
end

-- This hook does not run....
hook.Add("PlayerLoadedChar", "CheckWhoHasBankAccount", function(ply, char, lastChar)
    ply:SetHasBank(char:getData("hasBankAcc", false))
    ply:SetBankBal(char:getData("bankBal", 0))
    ply:SetBankAccountType(char:getData("bankAccType", REG_ACC))
    ply:SetLoan(char:getData("bankLoanAmount", 0))
end)

--Adding banker flag
nut.flag.add("b", "Allows the access to the banker menu")

--Banker Manager Menu Command
nut.command.add("bank", {
  onRun = function(ply)
    netstream.Start(ply, "OpenBankingManageMenu")
  end
})

--Adding subscription
hook.Add("AddSubscription", "AddPremiumBankSubscription", function(subs)  
  subs["bankprem"] = {
    name = "Bank Premium Account",
    cost = BANKCONF.premiumSettings.upRunAmount,
    onRun = function(ply, sub, data)
      --Applying balance interest
      local bal = ply:BankBal()
      local interest = BANKCONF.premiumSettings.balInter

      local nbal = math.Round(bal * interest)
      ply:SetBankBal(math.Round(bal + nbal)) --Setting new balance
      ply:notify("You gained " .. nut.currency.get(nbal) .. " from your balance interest.")

      --Giving the cost of the premium bank fees to BGF
      BGF:AddFunds(sub.cost)
    end,
    onCancel = function(ply)
      ply:notify("You were stripped from your premium bank account!", NOT_ERROR)
      ply:SetBankAccountType(REG_ACC)
    end
  }
end)