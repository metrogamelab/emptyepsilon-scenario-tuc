--- convenience

My.EventHandler:register("onPlayerSpawn", function(_, playerInfo)
    local player = playerInfo:getShipObject()
    Cron.regular(function(self)
        -- alert when hull is damaged
        if not player:isValid() then
            Cron.abort(self)
        else
            if player:getHull() < player:getHullMax() / 2 then
                player:commandSetAlertLevel("red")
            elseif player:getHull() < player:getHullMax() then
                player:commandSetAlertLevel("yellow")
            else
                player:commandSetAlertLevel("normal")
            end
        end
    end, 0.2)
    Cron.regular(function(self)
        -- remove the concept of "heat" from the game
        if not player:isValid() then
            Cron.abort(self)
        else
            for _, system in pairs({"reactor", "beamweapons", "missilesystem", "maneuver", "impulse", "warp", "jumpdrive", "frontshield", "rearshield"}) do
                player:setSystemHeat(system, 0)
                player:setSystemHealth(system, 1)
            end
        end
    end, 1)
end)


