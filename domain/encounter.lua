--- an encounter is a possible combination of ships that the player could be faced against
My = My or {}

My.Encounter = function(...)
    local enemyConfigs = {...}
    if Util.size(enemyConfigs) == 0 then error("expected at least one enemy config, but got none", 2) end

    table.sort(enemyConfigs, function(a, b)
        if a.speed ~= b.speed then
            return a.speed < b.speed
        elseif a.maneuver ~= b.maneuver then
            return a.maneuver < b.maneuver
        elseif a.acceleration ~= b.acceleration then
            return a.acceleration < b.acceleration
        else
            return a.name < b.name
        end
    end)

    local totalDanger = 0
    local totalStatHp = 0
    local count = 0
    local hasFighters = false
    local hasCorvettes = false
    local hasDreadnoughts = false
    local isDetermined = false
    for _, enemyConfig in pairs(enemyConfigs) do
        if not isTable(enemyConfig) then error("Expected enemy config to be table, but got " .. typeInspect(enemyConfig), 3) end
        if enemyConfig.class == "Fighter" then hasFighters = true end
        if enemyConfig.class == "Corvette" then hasCorvettes = true end
        if enemyConfig.class == "Dreadnought" then hasDreadnoughts = true end
        if enemyConfig.ai == "determined" then isDetermined = true end

        totalDanger = totalDanger + enemyConfig:dangerRating()
        totalStatHp = totalStatHp + enemyConfig:statHitPoints()
        count = count + 1
    end

    local encounter = {
        getDifficulty = function(self)
            return totalDanger
        end,
        getEnemyConfigs = function(self)
            return enemyConfigs
        end,
        getTotalStatHp = function(self)
            return totalStatHp
        end,
        getShipCount = function(self)
            return count
        end,
        getHighestClass = function(self)
            if hasDreadnoughts then
                return "Dreadnought"
            elseif hasCorvettes then
                return "Corvette"
            elseif hasFighters then
                return "Fighter"
            end
        end,
        isDetermined = function(self)
            return isDetermined
        end,
    }

    setmetatable(encounter, {
        __tostring = function()
            return string.format("(%.1f) ", encounter:getDifficulty()) .. Util.mkString(Util.map(enemyConfigs, function(enemyConfig) return enemyConfig.name end), ", ")
        end
    })

    return encounter
end