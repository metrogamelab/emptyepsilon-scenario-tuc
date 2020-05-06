local f = string.format

local encounterDifficultyMin = nil
local encounterDifficultyMax = nil

local Dreadnought = "Dreadnought"
local Corvette = "Corvette"
local Fighter = "Fighter"

local fighterEncounters = {}
local corvetteEncounters = {}
local dreadnoughtEncounters = {}

local totalFighterDanger = 0
local totalCorvetteDanger = 0
local totalDreadnoughtDanger = 0

for _, encounter in pairs(My.Encounters) do
    local diff = encounter:getDifficulty()
    if encounterDifficultyMin == nil or diff < encounterDifficultyMin then
        encounterDifficultyMin = diff
    end
    if encounterDifficultyMax == nil or diff > encounterDifficultyMax then
        encounterDifficultyMax = diff
    end
    local encounterClass = encounter:getHighestClass()
    if encounterClass == Dreadnought then
        table.insert(dreadnoughtEncounters, encounter)
    elseif encounterClass == Corvette then
        table.insert(corvetteEncounters, encounter)
    elseif encounterClass == Fighter then
        table.insert(fighterEncounters, encounter)
    else
        error("Unkown class " .. encounterClass)
    end
end

local waveMetatable = {
    __index = {
        getShipCount = function(self)
            local total = 0
            for _, encounter in pairs(self) do
                total = total + encounter:getShipCount()
            end
            return total
        end,
        getTotalDifficulty = function(self)
            local total = 0
            for _, encounter in pairs(self) do
                total = total + encounter:getDifficulty()
            end
            return total
        end,
        getTotalStatHp = function(self)
            local total = 0
            for _, encounter in pairs(self) do
                total = total + encounter:getTotalStatHp()
            end
            return total
        end
    }
}
local Wave = function(laneEncounters)
    setmetatable(laneEncounters, waveMetatable)
    return laneEncounters
end
local stageMetatable = {
    __index = {
        getShipCount = function(self)
            local total = 0
            for _, wave in pairs(self) do
                total = total + wave:getShipCount()
            end
            return total
        end,
        getTotalDifficulty = function(self)
            local total = 0
            for _, wave in pairs(self) do
                total = total + wave:getTotalDifficulty()
            end
            return total
        end,
        getTotalStatHp = function(self)
            local total = 0
            for _, wave in pairs(self) do
                total = total + wave:getTotalStatHp()
            end
            return total
        end
    }
}
local Stage = function(waves)
    setmetatable(waves, stageMetatable)
    return waves
end

My.StageGenerator = {
    randomEncounter = function(self, maxDifficulty, stage)
        -- filter that tries to prevent trash waves
        local filterHighDifficulty = function(_,encounter)
            return encounter:getDifficulty() <= math.max(maxDifficulty, encounterDifficultyMin * 2) and encounter:getDifficulty() >= math.min(maxDifficulty / 2, encounterDifficultyMax / 2)
        end
        local filterDifficulty = function(_,encounter)
            return encounter:getDifficulty() <= math.max(maxDifficulty, encounterDifficultyMin * 2)
        end

        local foo = {
            {Fighter, totalFighterDanger},
            {Corvette, totalCorvetteDanger},
            {Dreadnought, totalDreadnoughtDanger},
        }
        -- sort the class that had the least enemies first
        table.sort(foo, function(a, b) return a[2] < b[2] end)

        for _, bar in pairs(foo) do
            if bar[1] == Fighter then
                local encounter = Util.random(fighterEncounters, filterHighDifficulty)
                if encounter then return encounter end
                encounter = Util.random(fighterEncounters, filterDifficulty)
                if encounter then return encounter end
            elseif bar[1] == Corvette and (stage ~= 1 or totalCorvetteDanger == 0) then
                local encounter = Util.random(corvetteEncounters, filterHighDifficulty)
                if encounter then return encounter end
                encounter = Util.random(corvetteEncounters, filterDifficulty)
                if encounter then return encounter end
            elseif bar[1] == Dreadnought and stage > 3 and (stage ~= 4 or totalDreadnoughtDanger == 0) then
                local encounter = Util.random(dreadnoughtEncounters, filterHighDifficulty)
                if encounter then return encounter end
                encounter = Util.random(dreadnoughtEncounters, filterDifficulty)
                if encounter then return encounter end
            end
        end

        return Util.random(Encounters)
    end,
    generateWave = function(self, maxDifficulty, lanes, stage)
        local wave = {}
        local generationOrder = {} -- lets try to fill the lanes in a random order
        for i=1,lanes do
            generationOrder[i] = i
        end
        generationOrder = Util.randomSort(generationOrder)

        local remainingDifficulty = maxDifficulty
        for n, laneId in ipairs(generationOrder) do
            local maxDiffForLane
            local skip = false
            if n == lanes then
                maxDiffForLane = remainingDifficulty
            else
                if math.random(1, lanes) == 1 then
                    skip = true
                end
                maxDiffForLane = remainingDifficulty / 2
            end

            local encounter
            if not skip then
                encounter = self:randomEncounter(maxDiffForLane, stage)
            end
            if encounter ~= nil then
                remainingDifficulty = remainingDifficulty - encounter:getDifficulty()
                for _, enemyConfig in pairs(encounter:getEnemyConfigs()) do
                    if enemyConfig.class == Fighter then
                        totalFighterDanger = totalFighterDanger + enemyConfig:dangerRating()
                    elseif enemyConfig.class == Corvette then
                        totalCorvetteDanger = totalCorvetteDanger + enemyConfig:dangerRating()
                    elseif enemyConfig.class == Dreadnought then
                        totalDreadnoughtDanger = totalDreadnoughtDanger + enemyConfig:dangerRating()
                    end
                end
            end
            wave[laneId] = encounter
        end

        return Wave(wave), maxDifficulty - remainingDifficulty
    end,
    generate = function(self, difficulty, lanes, stage)
        if stage == 2 then
            totalCorvetteDanger = math.max(totalCorvetteDanger, totalFighterDanger)
        elseif stage == 5 then
            totalDreadnoughtDanger = math.max(totalDreadnoughtDanger, math.min(totalFighterDanger, totalCorvetteDanger))
        end

        local remainingDifficulty = difficulty
        local waves = {}
        local wave, diff = self:generateWave(remainingDifficulty / 2, lanes, stage)
        table.insert(waves, wave)
        remainingDifficulty = remainingDifficulty - diff
        wave, diff = self:generateWave(remainingDifficulty / 2, lanes, stage)
        table.insert(waves, wave)
        remainingDifficulty = remainingDifficulty - diff

        while remainingDifficulty > encounterDifficultyMin * (lanes) do
            wave, diff = self:generateWave(remainingDifficulty, lanes, stage)
            table.insert(waves, wave)
            if diff == 0 then
                error("Could not find a suitable configuration for the wave.")
            end
            remainingDifficulty = remainingDifficulty - diff
        end

        -- if there are 4 or more waves they tend to be come anti-climactic and trashy
        -- so sort by difficulty
        table.sort(waves, function(waveA, waveB)
            return waveA:getTotalDifficulty() < waveB:getTotalDifficulty()
        end)

        return Stage(waves)
    end,
}