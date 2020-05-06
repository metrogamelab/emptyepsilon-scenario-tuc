--- enemy that explodes when it is killed

My.EventHandler:register("onEnemySpawn", function(_, enemyInfo)
    local explodeConfig = enemyInfo:getConfig().explodes
    if explodeConfig == nil then return end

    local lastX, lastY = 0, 0
    Cron.regular(function(self)
        if enemyInfo:isSpawned() then
            lastX, lastY = enemyInfo:getShipObject():getPosition()
        else
            local size = explodeConfig.radius
            local minDmg = explodeConfig.minDamage
            local maxDmg = explodeConfig.maxDamage
            ExplosionEffect():setPosition(lastX, lastY):setSize(size)

            for _, thing in pairs(getObjectsInRadius(lastX, lastY, size)) do
                if isEeObject(thing) and thing.getPosition and thing.takeDamage then
                    local d = distance(lastX, lastY, thing) / size
                    local damage = (1-d) * maxDmg + d * minDmg
                    thing:takeDamage(damage, "kinetic", lastX, lastY)
                end
            end

            Cron.abort(self)
        end
    end, 0.1)
end)