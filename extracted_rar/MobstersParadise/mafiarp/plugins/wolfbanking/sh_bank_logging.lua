banklist = banklist or {}
banklist.list = banklist.list or {}

--ENUMS
DEPOSIT = 1
WITHDRAW = 2
CHECKDEPO = 3
REPAYLOAN = 4

if SERVER then
  function banklist:Init()
    --Creating db table
    local query = [[CREATE TABLE IF NOT EXISTS `nut_bank_logs` (
      `id`	INTEGER NOT NULL AUTO_INCREMENT,
      `action`	INTEGER NOT NULL,
      `steamid`	TEXT NOT NULL,
      `info`	TEXT,
      PRIMARY KEY (`id`)
    );]]
    nut.db.query(query)

    nut.db.query("SELECT * FROM nut_bank_logs", function(data)
      if not data then return end

      MsgC(Color(0,255,0), "Gathering all banking logs (" .. #data .. " entries)\n")
      local logs = {}
      local logMax = 30

      --Reorganizing data
      local idata = {}
      for k,v in pairs(data) do
        idata[v.steamid] = idata[v.steamid] or {}
        idata[v.steamid][#idata[v.steamid]+1] = v
      end

      banklist.list = idata
    end)
  end

  netstream.Hook("GetBankLogs", function(ply)
    netstream.Start(ply, "ReceiveBankLogs", banklist.list)
  end)

  --Funcs
  function banklist.Add(ply, action, info)
    print("Added log")
    banklist.list[ply:SteamID64()] = banklist.list[ply:SteamID64()] or {}
    banklist.list[ply:SteamID64()][#banklist.list[ply:SteamID64()]+1] = {
      action = action,
      info = info
    }
  end

  function banklist.Get()
    return banklist.list
  end

  --Bank logs saving
  timer.Create("BankingLogsSync", 900, 0, function()
    local count = 0
    local isqlt = {}

    --Checking for unsaved entries
    for sid,logs in pairs(banklist.list) do
      for k,entry in pairs(logs) do
        if entry.id != nil then continue end

        banklist.list[sid][k].id = 0 --Marks as saved

        local info = util.TableToJSON(entry.info)
        isqlt[#isqlt+1] = "('" .. entry.action .. "','" .. sid .. "','" .. info .. "')"

        count = count + 1
      end
    end

    if #isqlt > 0 then
      local q = table.concat(isqlt, ",")
      local query = "INSERT INTO `nut_bank_logs` (action, steamid, info) VALUES " .. q
      nut.db.query(query)
    end

    MsgC(Color(0,255,0), "Syncing " .. count .. " bank logs entries to db\n")
  end)
  
  --DEBUG COMMANDS
  -- concommand.Add("blget", function()
  --   nut.db.query("SELECT * FROM nut_bank_logs", function(data)
  --     if not data then return end

  --     MsgC(Color(0,255,0), "Gathering all banking logs (" .. #data .. " entries)\n")
  --     local logs = {}
  --     local logMax = 30

  --     --Reorganizing data
  --     local idata = {}
  --     for k,v in pairs(data) do
  --       idata[v.steamid] = idata[v.steamid] or {}
  --       idata[v.steamid][#idata[v.steamid]+1] = v
  --     end

  --     banklist.list = idata
  --   end)
  -- end)
  -- concommand.Add("blsim", function()
  --   local pls = player.GetAll()

  --   for k,v in pairs(pls) do
  --     for i=1,150 do
  --       banklist.Add(v, math.random(1, 4), {
  --         amount = math.random(100, 10000000),
  --         time = os.time() - math.random(0, 60)
  --       })
  --     end
  --   end
  -- end)

  -- concommand.Add("blsave", function(ply)
  --   local count = 0
  --   local isqlt = {}

  --   --Checking for unsaved entries
  --   for sid,logs in pairs(banklist.list) do
  --     for k,entry in pairs(logs) do
  --       if entry.id != nil then continue end

  --       banklist.list[sid][k].id = 0 --Marks as saved

  --       local info = util.TableToJSON(entry.info)
  --       isqlt[#isqlt+1] = "('" .. entry.action .. "','" .. sid .. "','" .. info .. "')"

  --       count = count + 1
  --     end
  --   end

  --   if #isqlt > 0 then
  --     local q = table.concat(isqlt, ",")
  --     local query = "INSERT INTO `nut_bank_logs` (action, steamid, info) VALUES " .. q
  --     nut.db.query(query)
  --   end

  --   MsgC(Color(0,255,0), "Syncing " .. count .. " entries to db\n")
  -- end)

  -- concommand.Add("banklist", function()
  --   PrintTable(banklist.list)
  -- end)
end