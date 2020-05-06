--- simulate auto coolant for enemies
--- because we use the feature to "sabotage" enemy systems by generating heat there.

local coolPerSecond = 1/60

My.EventHandler:register("onEnemySpawn", function(_, enemyInfo)
    Cron.regular(function(self, delta)
        if not enemyInfo:isSpawned() then
            Cron.abort(self)
        else
            local enemy = enemyInfo:getShipObject()
            for _, system in pairs({"reactor", "beamweapons", "missilesystem", "maneuver", "impulse", "frontshield", "rearshield"}) do
                enemy:setSystemHeat(system, math.max(enemy:getSystemHeat(system) - coolPerSecond * delta, 0))
            end
        end
    end, 0.1)
end)