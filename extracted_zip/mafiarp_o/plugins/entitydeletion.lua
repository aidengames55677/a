local entityTypes = {"combine_mine", "nut_money"} // ignore the combine mine lol, for debugging.



local maxEntities = 5



local maxRadius = 1000 // source engine units



local checkInterval = 5 



if SERVER then

    local function DeleteExcessEntities()

        for _, entityType in ipairs(entityTypes) do

            local entities = ents.FindByClass(entityType)

    

            if #entities >= maxEntities then

                for _, entity in ipairs(entities) do



                    local entitiesWithinRadius = ents.FindInSphere(entity:GetPos(), maxRadius) // sphere

                    local countWithinRadius = 0

    

                    for _, nearbyEntity in ipairs(entitiesWithinRadius) do

                        if nearbyEntity:GetClass() == entityType then

                            countWithinRadius = countWithinRadius + 1

                        end

                    end

    

                    if countWithinRadius >= maxEntities then

                        SafeRemoveEntity(entity)

                    end

                end

            end

        end

    end

    timer.Create("DeleteExcessEntitiesTimer", checkInterval, 0, DeleteExcessEntities)

end




