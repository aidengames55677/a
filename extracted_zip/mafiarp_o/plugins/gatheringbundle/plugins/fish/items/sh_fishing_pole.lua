--------------------------------------------------------------------------------------------------------
ITEM.name = "Fishing Pole"
--------------------------------------------------------------------------------------------------------
ITEM.desc = "A pole with a line and a reel attached to it."
--------------------------------------------------------------------------------------------------------
ITEM.model = "models/props_junk/harpoon002a.mdl"
--------------------------------------------------------------------------------------------------------
ITEM.uniqueID = "fishing_pole"
--------------------------------------------------------------------------------------------------------
ITEM.category = "Fishing"
--------------------------------------------------------------------------------------------------------
ITEM.width = 3
--------------------------------------------------------------------------------------------------------
ITEM.price = 600
--------------------------------------------------------------------------------------------------------
ITEM.color = Color(50, 50, 255)
--------------------------------------------------------------------------------------------------------
ITEM.data = {
    producing2 = 0
}
--------------------------------------------------------------------------------------------------------
ITEM.functions.FishBait = {
    name = "Fishing",
    icon = "icon16/anchor.png",
    sound = "ambient/machines/spinup.wav",
    onRun = function(item)
        local client = item.player
        if IsValid(client.FishingHook) then
            client:notify("You've already cast a hook!")

            return false
        end

        local hook = ents.Create("prop_physics")
        hook:SetPos(client:GetPos() + Vector(0, 0, 50))
        hook:SetModel("models/props_junk/meathook001a.mdl")
        hook:Spawn()
        client.FishingHook = hook
        local phys = hook:GetPhysicsObject()
        if phys:IsValid() then
            local ang = client:EyeAngles()
            phys:SetVelocityInstantaneous(ang:Forward() * math.random(300, 350))
        end

        timer.Simple(
            2,
            function()
                if hook:WaterLevel() > 0 then
                    local inventory = client:getChar():getInv()
                    local bait = inventory:hasItem("fishing_bait")
                    local char = client:getChar()
                    --nut.chat.send(client, "it", "The hook is cast into the water.")		
                    item:setData("producing2", CurTime())
                    local oldPos = client:GetPos()
                    client:setAction(
                        "Fishing...",
                        5,
                        function()
                            local position = client:getItemDropPos()
                            item:setData("producing2", 0)
                            if item ~= nil and client:GetPos():Distance(oldPos) <= 500 and bait then
                                local char = client:getChar()
                                local inventory = char:getInv()
                                local position = client:getItemDropPos()
                                local randnum = math.random(0, 130)
                                if randnum <= 20 and randnum > 21 then
                                    client:notify("You found a(n) " .. "Lake Trout" .. "!")
                                    if not inventory:add("Lake Trout", 1) then
                                        nut.item.spawn("Lake Trout", position)
                                    end
                                elseif randnum <= 40 and randnum > 20 then
                                    client:notify("You found a(n) " .. "Bull Trout" .. "!")
                                    if not inventory:add("Bull Trout", 1) then
                                        nut.item.spawn("Bull Trout", position)
                                    end
                                elseif randnum <= 90 and randnum > 40 then
                                    client:notify("You found a(n) " .. "Brown Trout" .. "!")
                                    if not inventory:add("Brown Trout", 1) then
                                        nut.item.spawn("Brown Trout", position)
                                    end
                                elseif randnum <= 110 and randnum > 90 then
                                    client:notify("You found a(n) " .. "Brook Trout" .. "!")
                                    if not inventory:add("Brook Trout", 1) then
                                        nut.item.spawn("Brook Trout", position)
                                    end
                                elseif randnum <= 120 and randnum > 110 then
                                    client:notify("You found a(n) " .. "Tiger Trout" .. "!")
                                    if not inventory:add("Tiger Trout", 1) then
                                        nut.item.spawn("Tiger Trout", position)
                                    end
                                elseif randnum <= 130 and randnum > 120 then
                                    client:notify("You found a(n) " .. "Rainbow Trout" .. "!")
                                    if not inventory:add("Rainbow Trout", 1) then
                                        nut.item.spawn("Rainbow Trout", position)
                                    end
                                end
                            end

                            if math.random(0, 100) < 45 then
                                client:notify("Your bait was lost.")
                                client:getChar():getInv():remove("fishing_bait")
                            end

                            hook:Remove()
                        end
                    )
                else
                    hook:Remove()
                    client:notify("Your hook needs to be in the water!")
                end
            end
        )

        return false
    end,
    onCanRun = function(item)
        if IsValid(item.entity) then return false end
        local endTime = item:getData("producing2", 0) + 5
        local player = item.player or item:getOwner()
        if not player:getChar():getInv():hasItem("fishing_bait") then return false end
        if CurTime() > endTime or item:getData("producing2", 0) > CurTime() or item:getData("producing2", 0) == 0 then
            return true
        else
            return false
        end
    end
}
--------------------------------------------------------------------------------------------------------