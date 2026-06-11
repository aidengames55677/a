PLUGIN.name = "Loyalism"
PLUGIN.author = "Chancer (fixed by JayyKashtaCodes)"
PLUGIN.desc = "System for loyalist points."
 
 
if (SERVER) then
    function PLUGIN:PlayerLoadedChar(client)
        --this just makes sure everything is properly networked to clients.
        --kind of annoying and gross, but won't work otherwise.
        for k, v in pairs(player.GetAll()) do
            local char = v:getChar()
            if(char) then
                local point = char:getData("loyalPoint", 0)
                char:setData("loyalPoint", point, false, player.GetAll())
            end
        end
    end
end
   
--main command for loyalist points
nut.command.add("pointupdate", {
    onCheckAccess = function(client) return client:getChar():hasFlags("L") or client:IsAdmin() end,
    syntax = "<string name> <string number>",
    onRun = function(client, arguments)
        local char = client:getChar()
        local fact = false
        local name = false
       
 
        local target = nut.command.findPlayer(client, arguments[1])
        if(!target) then
            client:notify("Invalid target.")
            return
        end
       
        local tChar = target:getChar()
       
        if(tChar) then
            if(tChar:getFaction() == FACTION_CITIZEN ) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            elseif(tChar:getFaction() == FACTION_CPSU ) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            elseif(tChar:getFaction() == FACTION_UGOTSU ) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            elseif(tChar:getFaction() == FACTION_RKKA ) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            elseif(tChar:getFaction() == FACTION_NKVD ) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            elseif(tChar:getFaction() == FACTION_SM ) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            elseif(tChar:getFaction() == FACTION_SPR ) then
                tChar:setData("loyalPoint", tChar:getData("loyalPoint", 0) + tonumber(arguments[2]), false, player.GetAll())
           
                client:notify("You have updated ".. target:Name() .. "'s loyalist points, they now have " .. tChar:getData("loyalPoint", 0) .. " loyalist points.")
       
                if(tonumber(arguments[2]) > 0) then --for
                    target:notify("You have received ".. arguments[2] .. " loyalist points from " .. client:Name() .. ".")
                else
                    target:notify(client:Name().. " has removed " .. arguments[2] .. " of your loyalist points.")
                end
            else
                client:notify("Target is not a member of the right faction.")
            end
        end
    end
})
 
if(CLIENT) then
    local COLOR_LEVEL = Color(204, 0, 0)
 
    function PLUGIN:DrawCharInfo(client, character, info)
        local level = math.Round(character:getData("loyalPoint", 0) / 1)
       
        level = math.Clamp(level, 0, 10)
       
        if(level > 0) then
            info[#info + 1] = {"Tier " .. level .. " Party Member.", COLOR_LEVEL}
        end
    end
end