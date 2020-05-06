--- enemy that is accompanied by an escort

My.EventHandler:register("onEnemySpawn", function(_, enemyInfo)
    local escortConfig = enemyInfo:getConfig().escort
    if escortConfig == nil then return end

    local spawns = {}

    Cron.regular(function(self)
        if not enemyInfo:isSpawned() then
            Cron.abort(self)
        else
            for i, droneInfo in ipairs(spawns) do
                if not droneInfo:isSpawned() then
                    table.remove(spawns, i)
                end
            end

            if Util.size(spawns) < escortConfig.max then
                local droneInfo = My.EnemyInfo(escortConfig.template.name)
                local drone = droneInfo:spawnEnemyShip()
                local x, y = enemyInfo:getShipObject():getPosition()
                drone:setPosition(x, y)

                Ship:withOrderQueue(drone)
                drone:addOrder(Order:defend(enemyInfo:getShipObject(), {minDefendTime = 9999}))
                drone:addOrder(Order:roaming())

                table.insert(spawns, droneInfo)
            end
        end
    end, escortConfig.interval, escortConfig.interval / 2)
end)