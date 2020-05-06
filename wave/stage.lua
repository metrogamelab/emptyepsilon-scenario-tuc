local currentStage = 0
local currentWave = 0
local cronIdTime = "stage_generator_time"
local cronIdDestruction = "stage_generator_destruction"

local waves = {}
local currentValidEnemies = {}

My.EventHandler:register("onEnemySpawn", function(_, enemyInfo)
    table.insert(currentValidEnemies, enemyInfo)
end)

My.Stage = {
    getCurrentStage = function()
        return currentStage
    end,
    getCurrentWave = function()
        return currentWave
    end,
    isRunning = function()
        return Util.size(currentValidEnemies) > 0
    end,
    start = function(self)
        currentValidEnemies = {}
        currentStage = currentStage + 1

        -- @TODO: calculate difficulty better
        local difficulty = GameConfig.initialDanger + GameConfig.increaseDanger * (currentStage - 1)

        waves = My.StageGenerator:generate(difficulty, Util.size(My.World.lanes), currentStage)
        logInfo(string.format("Stage %d: %d waves with a total danger of %0.1f.", currentStage, Util.size(waves), waves:getTotalDifficulty()))

        currentWave = 0
        My.EventHandler:fire("onStageStart", currentStage)
        self:sendNextWave()
    end,
    stop = function(self)
        Cron.abort(cronIdTime)
        if Util.size(currentValidEnemies) == 0 then
            Cron.abort(cronIdDestruction)
            My.EventHandler:fire("onStageFinished", currentStage)
        end
    end,
    sendNextWave = function(self)
        if Util.size(waves) == 0 then
            return self:stop()
        end

        Cron.abort(cronIdTime)
        Cron.abort(cronIdDestruction)
        currentWave = currentWave + 1

        local wave = waves[1]
        table.remove(waves, 1)

        self:spawnWave(wave)

        -- @TODO: Is that about right?
        local theoreticalDamagePerShipPerMinute = _G.GameConfig.initialDamage + (currentStage - 1) * _G.GameConfig.increaseDamage
        local timeToNextWave
        if theoreticalDamagePerShipPerMinute > 0 then
            timeToNextWave = wave:getTotalStatHp() / theoreticalDamagePerShipPerMinute / 1.5 / Util.size(My.Players)
        end
        -- give time to scout
        timeToNextWave = timeToNextWave + 0.5

        -- send the next wave when all ships have been destroyed
        Cron.regular(cronIdDestruction, function()
            for i=Util.size(currentValidEnemies),1, -1 do
                local shipInfo = currentValidEnemies[i]
                -- remove all ships that were destroyed
                if not shipInfo:isSpawned() then
                    My.EventHandler:fire("onEnemyDestruction", shipInfo)
                    table.remove(currentValidEnemies, i)
                end
            end
            -- if there is none left call the next wave
            if Util.size(currentValidEnemies) == 0 then
                if Util.size(waves) ~= 0 then
                    logDebug("Sending next wave in early, because all enemies were destroyed")
                end
                My.Stage:sendNextWave()
            end
        end, 1)

        logInfo(string.format(
            "Stage %d, Wave %d: %d ships with %0.1f danger.",
            currentStage,
            currentWave,
            wave:getShipCount(),
            wave:getTotalDifficulty()
        ))

        if Util.size(waves) == 0 then
            logInfo("This is the last wave of this stage.")
        elseif timeToNextWave ~= nil then
            logInfo(string.format("Next wave will be spawned automatically in %0.2f minutes.", timeToNextWave))
            -- a timer that sends the next wave after a certain time
            Cron.once(cronIdTime, function()
                My.Stage:sendNextWave()
            end, timeToNextWave * 60)
        else
            logInfo("Next wave will spawn when all enemies of the current wave are defeated.")
        end

        My.EventHandler:fire("onWaveStart", currentStage, currentWave)
    end,
    spawnWave = function(self, wave)
        for i, lane in ipairs(My.World.lanes) do
            local encounter = wave[i]
            self:spawn(encounter, lane)
        end
    end,
    spawn = function(self, encounter, lane)
        if not encounter then return end
        local ships = {}
        for i, enemyConfig in pairs(encounter:getEnemyConfigs()) do
            local info = My.EnemyInfo(enemyConfig.name)
            ships[i] = info:spawnEnemyShip()
        end

        local fleet = Fleet:new(ships)
        lane:spawn(fleet)
        Fleet:withOrderQueue(fleet)

        if lane:isStation1Valid() then
            if encounter:isDetermined() then
                fleet:addOrder(Order:attack(lane:getStation1()))
            else
                local x, y = lane:getStation1():getPosition()
                fleet:addOrder(Order:flyTo(x, y, {minDistance = 5000}))
                fleet:addOrder(Order:defend(x, y, {range = 5000}))
            end
        end
        if lane:isStation2Valid() then
            if encounter:isDetermined() then
                fleet:addOrder(Order:attack(lane:getStation2()))
            else
                local x, y = lane:getStation2():getPosition()
                fleet:addOrder(Order:flyTo(x, y, {minDistance = 5000}))
                fleet:addOrder(Order:defend(x, y, {range = 5000}))
            end
        end
        if lane:isStation3Valid() then
            if encounter:isDetermined() then
                fleet:addOrder(Order:attack(lane:getStation3()))
            else
                local x, y = lane:getStation3():getPosition()
                fleet:addOrder(Order:flyTo(x, y, {minDistance = 5000}))
                fleet:addOrder(Order:defend(x, y, {range = 5000}))
            end
        end
        if My.World.hqStation:isValid() then
            if encounter:isDetermined() then
                fleet:addOrder(Order:attack(My.World.hqStation))
            else
                local x, y = My.World.hqStation:getPosition()
                fleet:addOrder(Order:flyTo(x, y, {minDistance = 5000}))
                fleet:addOrder(Order:defend(x, y, {range = 5000}))
            end
        end
    end,
}