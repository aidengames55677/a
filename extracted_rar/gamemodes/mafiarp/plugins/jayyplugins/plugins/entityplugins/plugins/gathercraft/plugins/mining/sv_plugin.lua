-------------------------------------------------------------------------------------------
resource.AddWorkshop("675824914")
resource.AddWorkshop("2871151593")
-------------------------------------------------------------------------------------------
function PLUGIN:SaveData()
    local data = {}
    for k, v in ipairs(ents.FindByClass("rock_*")) do
        data[#data + 1] = {
            pos = v:GetPos(),
            angles = v:GetAngles(),
            class = v:GetClass(),
        }
    end

    self:setData(data)
end

-------------------------------------------------------------------------------------------
function PLUGIN:LoadData()
    for k, v in ipairs(self:getData() or {}) do
        local entity = ents.Create(v.class)
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
    end
end

-------------------------------------------------------------------------------------------
function RockBreak(ent, ply)
    local entType = ent:GetClass()
    local chance = math.random(0, 100)
    local position = ply:getItemDropPos()
    if nut.config.rockTable[entType] and chance <= nut.config.rockTable[entType].chanceofdrop then
        local droppedItem = nil
        local oreData
    
        for oreType, data in pairs(nut.config.oreTable) do
            oreData = data
            local oreChance = oreData.chance
            if chance <= oreChance then
                droppedItem = oreType
                break
            else
                chance = chance - oreChance
            end
        end
        
        if droppedItem then
            ply:getChar():getInv():add(droppedItem):catch(function(error)
                if error == "noFit" then
                    --[[ If the "noFit" error occurred, spawn the item and notify the player
                    nut.item.spawn(droppedItem, position)
                    if oreData and oreData.notificaton then
                        ply:notify(oreData.notificaton)
                    end]]
                    ply:notify("You cannot carry anymore items...")
                else
                    -- If any other error occurred, notify the player
                    ply:notify("An error occurred:" .. error)
                end
                if oreData and oreData.notificaton then
                    ply:notify(oreData.notificaton)
                end
            end)           
        end        
    end
end

-------------------------------------------------------------------------------------------
function RockSpawn(ent, ply, enttype, pos)
    timer.Simple(
        nut.config.get("RockRespawnDelay"),
        function()
            local newent = ents.Create(enttype)
            newent:SetPos(pos)
            newent:SetNoDraw(false)
            newent:Spawn()
        end
    )
end
-------------------------------------------------------------------------------------------