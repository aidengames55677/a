PLUGIN.name = "Ent Count"
PLUGIN.desc = "asdf"
PLUGIN.author = ""

if SERVER then
  concommand.Add("countent", function()
    local cent = {}

    local ae = ents.GetAll()
    for k,v in pairs(ae) do
      local class = v:GetClass()
      if not cent[class] then
        cent[class] = 1
      else
        cent[class] = cent[class] + 1
      end
    end

    PrintTable(cent)
    print(#ae)
  end)

  concommand.Add("phonerem", function (ply)
    if ply then return end
    local totrem = 0

    for k,v in pairs(ents.FindByClass("phone_public")) do
      v:Remove()
      totrem = totrem + 1
    end

    for k,v in pairs(ents.FindByClass("phone_private_1")) do
      v:Remove()
      totrem = totrem + 1
    end

    print("Removed " .. totrem .. " phones")
  end)
end