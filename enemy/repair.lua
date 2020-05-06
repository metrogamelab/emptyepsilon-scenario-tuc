--- enemy that explodes when it is killed

My.EventHandler:register("onEnemySpawn", function(_, enemyInfo)
    local repairConfig = enemyInfo:getConfig().repair
    if repairConfig == nil then return end

    local friends = {}

    -- the cron to find all friends in range. T
    -- this can run less often than the health replenishment to lower load.
    Cron.regular(function(self)
        if not enemyInfo:isSpawned() then
            Cron.abort(self)
            return
        end

        local ship = enemyInfo:getShipObject()
        friends = {}
        for _, thing in pairs(ship:getObjectsInRange(repairConfig.radius)) do
            if isEeShipTemplateBased(thing) and ship:isFriendly(thing) then
                table.insert(friends, thing)
            end
        end
    end, 1.5, 0)

    -- the cron to replenish hull on enemies
    Cron.regular(function(self, delta)
        if not enemyInfo:isSpawned() then
            Cron.abort(self)
            return
        end
        for _, friend in pairs(friends) do
            if friend:isValid() and friend:getHull() < friend:getHullMax() then
                friend:setHull(math.min(friend:getHull() + delta * repairConfig.rate, friend:getHullMax()))
            end
        end
    end)

end)