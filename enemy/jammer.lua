--- enemy that spawns Warp Jammers when players are close

local minRangeToEnemy = 1000
local maxRangeToEnemy = 3000
local minDistanceToJammer = 1500
local jammerRange = 4500 -- it should be visible on short range radar
local cooldownAfterDeploy = 90

local createJammer = function(x, y)
    WarpJammer():
    setCallSign("Jammer"):
    setFaction("Unknown"):
    setPosition(x, y):
    setRange(jammerRange)
end

My.EventHandler:register("onEnemySpawn", function(_, enemyInfo)
    local nrOfJammers = enemyInfo:getConfig().jammers
    if nrOfJammers == nil then return end

    local cooldown = 0

    Cron.regular(function(self, delta)
        if not enemyInfo:isSpawned() then
            Cron.abort(self)
        elseif cooldown > 0 then
            cooldown = cooldown - delta
        else
            local ship = enemyInfo:getShipObject()
            local isEnemyInRange = false
            for _, thing in pairs(ship:getObjectsInRange(maxRangeToEnemy)) do
                if isEeShipTemplateBased(thing) and ship:isEnemy(thing) then
                    local d = distance(thing, ship)
                    if d < minRangeToEnemy then
                        -- enemy is too close
                        return
                    elseif thing:hasWarpDrive() or thing:hasJumpDrive() then
                        isEnemyInRange = true
                    end
                elseif isEeWarpJammer(thing) and ship:isFriendly(thing) and distance(thing, ship) < minDistanceToJammer then
                    -- there is another warp jammer close by
                    return
                end
            end
            if isEnemyInRange then
                -- deploy the jammer
                local x, y = Util.addVector(ship, ship:getRotation() - 180, 100)
                createJammer(x, y)
                nrOfJammers = nrOfJammers - 1
                if nrOfJammers == 0 then
                    Cron.abort(self)
                    return
                end
                cooldown = cooldownAfterDeploy
            end
        end
    end, 1)
end)