-------------------------------------------------------------------------------------------
resource.AddWorkshop("675824914")
-------------------------------------------------------------------------------------------
function PLUGIN:SaveData()
    local data = {}
    for k, v in ipairs(ents.FindByClass("*_tree")) do
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
function TreeSpawn(ent, ply, enttype, pos)
    timer.Simple(
        nut.config.get("TreeRespawnDelay"),
        function()
            local newent = ents.Create(enttype)
            newent:SetPos(pos)
            newent:SetNoDraw(false)
            newent:Spawn()
        end
    )
end

-------------------------------------------------------------------------------------------
function TreeBreak(ent, ply)
    local entType = ent:GetClass()
    local chance = math.random(0, 100)
    local position = ply:getItemDropPos()
    if nut.config.TreeTable[entType] and chance <= nut.config.TreeTable[entType].chanceofdrop then
        local droppedItem = nil
        local woodData
        for woodType, data in pairs(nut.config.TreeTable) do
            woodData = data
            local woodChance = woodData.chanceofdrop
            if chance <= woodChance then
                droppedItem = woodData.item
                break
            else
                chance = chance - woodChance
            end
        end

        if droppedItem then
            if ply:getChar():getInv():add(droppedItem):catch(function(error)
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
            end) then
                ply:notify("You have harvested some " .. woodData.name .. "!")
            end
        end
    end
end
-------------------------------------------------------------------------------------------