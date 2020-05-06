--- prevent player from docking attacked stations

My.EventHandler:register("onStationSpawn", function(_, station)
    station:setRestocksScanProbes(false)
    station:setRepairDocked(false)
    station:setSharesEnergyWithDocked(false)

    local dockedPlayers = {}

    Cron.regular(function(self)
        if not station:isValid() then
            Cron.abort(self)
        else
            dockedPlayers = {}
            local players = {}
            local hasEnemies = false
            for _, thing in pairs(station:getObjectsInRange(4500)) do
                if isEePlayer(thing) and distance(thing, station) < 2000 then
                    table.insert(players, thing)
                    if thing:isDocked(station) then
                        table.insert(dockedPlayers, thing)
                    end
                elseif isEeObject(thing) and isFunction(thing.isEnemy) and thing:isEnemy(station) then
                    hasEnemies = true
                end
            end
            --- prevent player from docking attacked stations
            if hasEnemies then
                for _, player in pairs(players) do
                    player:commandUndock()
                    player:commandAbortDock()
                end
            end
        end
    end, 0.5)

    local restockProgressPerPlayer = {}

    Cron.regular(function(self, delta)
        if not station:isValid() then
            Cron.abort(self)
        else
            for _, player in pairs(dockedPlayers) do
                -- restock players
                if player:isValid() and player:isDocked(station) then
                    restockProgressPerPlayer[player] = restockProgressPerPlayer[player] or {
                        missile = 0,
                        probe = 0,
                    }

                    --- restock missiles
                    local missingMissiles = {}
                    local totalMissiles = 0
                    for _, missile in pairs({"hvli", "homing", "mine", "nuke"}) do
                        totalMissiles = totalMissiles + player:getWeaponStorageMax(missile)
                        for _=player:getWeaponStorage(missile), player:getWeaponStorageMax(missile)-1 do
                            table.insert(missingMissiles, missile)
                        end
                    end
                    -- missiles per second
                    local speed = math.max(0.2, totalMissiles/45)
                    if Util.size(missingMissiles) > 0 then
                        restockProgressPerPlayer[player].missile = restockProgressPerPlayer[player].missile + speed * delta
                    end
                    if restockProgressPerPlayer[player].missile >= 1 then
                        local missile = Util.random(missingMissiles)
                        player:setWeaponStorage(missile, player:getWeaponStorage(missile) + 1)
                        restockProgressPerPlayer[player].missile = 0
                    end

                    --- restock probes
                    -- probes per second
                    speed = math.max(1/7, player:getMaxScanProbeCount()/30)
                    if player:getScanProbeCount() < player:getMaxScanProbeCount() then
                        restockProgressPerPlayer[player].probe = restockProgressPerPlayer[player].probe + speed * delta
                    end
                    if restockProgressPerPlayer[player].probe >= 1 then
                        player:setScanProbeCount(player:getScanProbeCount() + 1)
                        restockProgressPerPlayer[player].probe = 0
                    end

                    --- recharge shield
                    speed = math.max(1, player:getShieldMax(1) / 45)
                    player:setShields(
                        math.min(player:getShieldLevel(0) + speed * delta, player:getShieldMax(0)),
                        math.min(player:getShieldLevel(1) + speed * delta,  player:getShieldMax(1))
                    )

                    --- repair hull
                    speed = math.max(0.5, player:getHullMax() / 30)
                    player:setHull(math.min(player:getHull() + speed * delta, player:getHullMax()))

                    --- refill energy
                    speed = math.max(3, player:getEnergyLevelMax() / 45)
                    player:setEnergyLevel(math.min(player:getEnergyLevel() + speed * delta, player:getEnergyLevelMax()))
                end
            end
        end
    end)
end)


