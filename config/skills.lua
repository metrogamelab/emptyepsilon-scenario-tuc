local Slowing = (function()
    local skillSlow = 0.2
    local skillRange = 3500
    local ultimateSlow = 1
    local ultimateRange = 3500

    return {
        name = "Slowing Presence",
        description = "Your presence makes enemies in your proximity slower which allows you and your team to easier avoid their strong points.\n\nOnce per stage you can bring the enemies around you to a full stop.",
        database = {
            {"Skill Slow", string.format("%0.0f%%", skillSlow * 100) },
            {"Skill Range", string.format("%0.1f u", skillRange / 1000) },
            {"Ultimate Slow", string.format("%0.0f%%", ultimateSlow * 100) },
            {"Ultimate Range", string.format("%0.1f u", ultimateRange / 1000) },
        },
        install = function(_, playerInfo, cronId)
            Cron.regular(cronId, function(self)
                if not playerInfo:isSpawned() then
                    Cron.abort(self)
                    return
                end
                local ship = playerInfo:getShipObject()
                for _, thing in pairs(ship:getObjectsInRange(skillRange)) do
                    if isEeShip(thing) and ship:isEnemy(thing) then
                        thing:setSystemHeat("maneuver", math.max(thing:getSystemHeat("maneuver"), skillSlow))
                        thing:setSystemHeat("impulse", math.max(thing:getSystemHeat("impulse"), skillSlow))
                    end
                end
            end, 0.2)
        end,
        ultimate = function(_, playerInfo)
            local ship = playerInfo:getShipObject()
            for _, thing in pairs(ship:getObjectsInRange(ultimateRange)) do
                if isEeShip(thing) and ship:isEnemy(thing) then
                    thing:setSystemHeat("maneuver", ultimateSlow)
                    thing:setSystemHeat("impulse", ultimateSlow)
                end
            end
        end,
        requiredClass = "Scout",
    }
end)()
local Repair = (function()
    local skillRps = 0.3
    local skillRange = 2000
    local ultimateDps = 0.5
    local ultimateRadius = 5000
    local ultimateLiveTimeInMin = 10

    return {
        name = "Hull Repair",
        description = "Small nanobots, circulating your ship, repair the hull of close friends.\n\nOnce per stage you can release toxic gases from your ship - insert fart joke here - that damages the enemies hull directly as long as they are in it.",
        database = {
            {"Repair Amount", string.format("%0.0f / min", skillRps * 60)},
            {"Repair Range", string.format("%0.1f u", skillRange / 1000)},
            {"Cloud Damage", string.format("%0.0f / min", ultimateDps * 60)},
            {"Cloud Radius", string.format("%0.1f u", ultimateRadius / 1000)},
            {"Cloud Live Time", string.format("%0.1f min", ultimateLiveTimeInMin)},
        },
        install = function(_, playerInfo, cronId)
            Cron.regular(cronId, function(self, delta)
                if not playerInfo:isSpawned() then
                    Cron.abort(self)
                    return
                end
                local ship = playerInfo:getShipObject()
                for _, thing in pairs(ship:getObjectsInRange(skillRange)) do
                    if isEePlayer(thing) and ship:isFriendly(thing) then
                        thing:setHull(math.min(
                            thing:getHull() + skillRps * delta,
                            thing:getHullMax()
                        ))
                    end
                end
            end, 0.2)
        end,
        ultimate = function(_, playerInfo)
            local player = playerInfo:getShipObject()
            local x, y = player:getPosition()
            local nebula = Nebula():setPosition(x, y):setFaction(player:getFaction())
            local enemies = {}
            Cron.regular(function(self)
                if not nebula:isValid() then
                    Cron.abort(self)
                else
                    enemies = {}
                    for _, thing in pairs(nebula:getObjectsInRange(ultimateRadius)) do
                        if isEeShipTemplateBased(thing) and nebula:isEnemy(thing) then
                            table.insert(enemies, thing)
                        end
                    end
                end
            end, 1)
            Cron.regular(function(self, delta)
                if not nebula:isValid() then
                    Cron.abort(self)
                else
                    for _, enemy in pairs(enemies) do
                        if enemy:isValid() then
                            enemy:setHull(enemy:getHull() - ultimateDps * delta)
                        end
                    end
                end
            end)
            Cron.once(function()
                if nebula:isValid() then
                    nebula:destroy()
                end
            end, ultimateLiveTimeInMin * 60)
        end,
        requiredClass = "Bomber",
    }
end)()

local Missile = (function()
    local skillDelay = 0.2
    local skillRange = 3500
    local ultimateDelay = 1
    local ultimateRange = 3500

    return {
        name = "Missile Jammer",
        description = "Your ship is jamming the enemies missile reload mechanisms. This makes them slower to fire missiles.\n\nOnce per round you can use this system to bring down the reload mechanisms for good, basically preventing the enemy from firing missiles.",
        database = {
            {"Skill Delay", string.format("%0.0f%%", skillDelay * 100) },
            {"Skill Range", string.format("%0.1f u", skillRange / 1000) },
            {"Ultimate Delay", string.format("%0.0f%%", ultimateDelay * 100) },
            {"Ultimate Range", string.format("%0.1f u", ultimateRange / 1000) },
        },
        install = function(_, playerInfo, cronId)
            Cron.regular(cronId, function(self)
                if not playerInfo:isSpawned() then
                    Cron.abort(self)
                    return
                end
                local ship = playerInfo:getShipObject()
                for _, thing in pairs(ship:getObjectsInRange(skillRange)) do
                    if isEeShip(thing) and ship:isEnemy(thing) then
                        thing:setSystemHeat("missilesystem", math.max(thing:getSystemHeat("missilesystem"), skillDelay))
                    end
                end
            end, 0.2)
        end,
        ultimate = function(_, playerInfo)
            local ship = playerInfo:getShipObject()
            for _, thing in pairs(ship:getObjectsInRange(ultimateRange)) do
                if isEeShip(thing) and ship:isEnemy(thing) then
                    thing:setSystemHeat("missilesystem", ultimateDelay)
                end
            end
        end,
        requiredClass = "Bomber",
    }
end)()

local Energy = (function()
    local skillEps = 0.4
    local skillRange = 2000
    local empRange = 1500
    local minDmg = 80
    local maxDmg = 160

    return {
        name = "Mobile Reactor",
        description = "You carry a small additional reactor that can recharge the energy of close friends. This goes a long way of helping \"stranded\" friends or keeping the energy consumption of Warp 3 or Warp 4 travel low for you and your team.\n\nOnce per Stage you can use that energy to fire an EMP that damages the shields of close enemies (see the database for which enemies have shields) and brings their recharge down for a short time. Stage a full attack in that period to damage their hull as much as possible.",
        database = {
            {"Recharge", string.format("%0.0f energy / min", skillEps * 100) },
            {"Recharge Range", string.format("%0.1f u", skillRange / 1000) },
            {"EMP Damage", string.format("%0.0f - %0.0f", minDmg, maxDmg) },
            {"EMP Range", string.format("%0.1f u", empRange / 1000) },
        },
        install = function(_, playerInfo, cronId)

            Cron.regular(cronId, function(self, delta)
                if not playerInfo:isSpawned() then
                    Cron.abort(self)
                    return
                end
                local ship = playerInfo:getShipObject()
                for _, thing in pairs(ship:getObjectsInRange(skillRange)) do
                    if isEePlayer(thing) and ship:isFriendly(thing) then
                        thing:setEnergy(math.min(
                            thing:getEnergy() + skillEps * delta,
                            thing:getMaxEnergy()
                        ))
                    end
                end
            end, 0.2)
        end,
        ultimate = function(_, playerInfo)
            local heat = 1
            local ship = playerInfo:getShipObject()
            local x, y = ship:getPosition()
            ElectricExplosionEffect():setPosition(x, y):setSize(empRange)
            for _, thing in pairs(ship:getObjectsInRange(empRange)) do
                if isEeShip(thing) and ship:isEnemy(thing) then
                    thing:setSystemHeat("frontshield", heat)
                    thing:setSystemHeat("rearshield", heat)
                    local d = distance(ship, thing) / empRange
                    local damage = (1-d) * maxDmg + d * minDmg
                    thing:takeDamage(damage, "emp", x, y)
                end
            end
        end,
        requiredClass = "Scout",
    }
end)()

local Hacking = (function()
    local skillHeat = 0.2
    local skillRange = 3500
    local ultimateHeat = 1
    local ultimateRange = 3500

    return {
        name = "Hacking Device",
        description = "The hacking device jams into the enemies laser recharge system and slows it down, which makes it easier to survive the enemies laser fire.\n\nOnce per Stage you can bring the recharging capacity of your enemy to a full stop. But you should be aware that the enemy can still fire already charged lasers.",
        database = {
            {"Laser Charge Delay", string.format("%0.0f%%", skillHeat * 100) },
            {"Hacking Range", string.format("%0.1f u", skillRange / 1000) },
            {"Ultimate Delay", string.format("%0.0f%%", ultimateHeat * 100) },
            {"Ultimate Range", string.format("%0.1f u", ultimateRange / 1000) },
        },
        install = function(_, playerInfo, cronId)

            Cron.regular(cronId, function(self)
                if not playerInfo:isSpawned() then
                    Cron.abort(self)
                    return
                end
                local ship = playerInfo:getShipObject()
                for _, thing in pairs(ship:getObjectsInRange(skillRange)) do
                    if isEeShip(thing) and ship:isEnemy(thing) then
                        thing:setSystemHeat("beamweapons", math.max(thing:getSystemHeat("beamweapons"), skillHeat))
                    end
                end
            end, 0.2)
        end,
        ultimate = function(_, playerInfo)
            local ship = playerInfo:getShipObject()
            for _, thing in pairs(ship:getObjectsInRange(ultimateRange)) do
                if isEeShip(thing) and ship:isEnemy(thing) then
                    thing:setSystemHeat("beamweapons", ultimateHeat)
                end
            end
        end,
        requiredClass = "Fighter",
    }
end)()

--local Shield = (function()
--    return {
--        name = "Shielding",
--        install = function(_, playerInfo, cronId)
--            local shieldPerSecond = 0.3
--            local range = 2000
--
--            Cron.regular(cronId, function(self, delta)
--                if not playerInfo:isSpawned() then
--                    Cron.abort(self)
--                    return
--                end
--                local ship = playerInfo:getShipObject()
--                for _, thing in pairs(ship:getObjectsInRange(range)) do
--                    if isEePlayer(thing) and ship:isFriendly(thing) then
--                        thing:setShields(
--                            math.min(thing:getShieldLevel(0) + shieldPerSecond * delta, thing:getShieldMax(0)),
--                            math.min(thing:getShieldLevel(1) + shieldPerSecond * delta,  thing:getShieldMax(1))
--                        )
--                    end
--                end
--            end, 0.2)
--        end,
--        requiredClass = "Fighter",
--    }
--end)()

local Boom = (function()
    local range = 1500
    local minDmg = 80
    local maxDmg = 160

    return {
        name = "Explosive Rigging",
        description = "Let's be honest: You, as a fighter pilot, have your spacecraft destroyed continuously. So why not consider this a feature? With the explosive rigging installed, you \"go down with a boom\": If you die you at least deal massive damage, similar to a nuke, to everything around you. We advise to warn your allies when you are on low health or you might trigger a chain-reaction.\n\nOnce per stage you can trigger the explosion voluntarily, without taking damage yourself. Your allies are also taking damage though, so please stick to the safety advices outlined above.",
        database = {
            {"Explosive Damage", string.format("%0.0f - %0.0f", minDmg, maxDmg) },
            {"Explosive Range", string.format("%0.1f u", range / 1000) },
        },
        install = function(_, playerInfo, cronId)

            local lastX, lastY = 0, 0
            Cron.regular(cronId, function(self)
                if playerInfo:isSpawned() then
                    lastX, lastY = playerInfo:getShipObject():getPosition()
                else
                    ExplosionEffect():setPosition(lastX, lastY):setSize(range)

                    for _, thing in pairs(getObjectsInRadius(lastX, lastY, range)) do
                        if isEeObject(thing) and thing.getPosition and thing.takeDamage then
                            local d = distance(lastX, lastY, thing) / range
                            local damage = (1-d) * maxDmg + d * minDmg
                            thing:takeDamage(damage, "kinetic", lastX, lastY)
                        end
                    end

                    Cron.abort(self)
                end
            end, 0.1)
        end,
        ultimate = function(_, playerInfo)
            local ship = playerInfo:getShipObject()
            local x, y = ship:getPosition()
            ExplosionEffect():setPosition(x, y):setSize(range)
            for _, thing in pairs(ship:getObjectsInRange(range)) do
                if isEeObject(thing) and thing.getPosition and thing.takeDamage and thing ~= ship then
                    local d = distance(ship, thing) / range
                    local damage = (1-d) * maxDmg + d * minDmg
                    thing:takeDamage(damage, "kinetic", x, y)
                end
            end
        end,
        requiredClass = "Fighter",
    }
end)()

_G.PlayerShipSkills = {
    Slowing,
    Repair,
    Energy,
    Hacking,
    --Shield,
    Missile,
    Boom,
}