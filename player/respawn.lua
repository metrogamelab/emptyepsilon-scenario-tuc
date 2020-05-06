--- player ships with jump drive or a second shield draw more energy from the reactor by default
--- we try to offset this, so every ship has the same energy regeneration

local respawnDelays = {}
local respawnTimes = {}
local respawnCrons = {}

My.EventHandler:register("onPlayerSpawn", function(_, playerInfo)
    local id = playerInfo:getId()
    respawnDelays[id] = respawnDelays[id] or GameConfig.respawnDelayInitial
    respawnTimes[id] = respawnTimes[id] or 0

    if respawnCrons[id] then
        Cron.abort(respawnCrons[id])
    end
    respawnTimes[id] = respawnTimes[id] + 1

end)
My.EventHandler:register("onPlayerDestruction", function(_, playerInfo)
    local id = playerInfo:getId()
    local delay = 2
    if My.Stage:isRunning() then
        logInfo("Player " .. playerInfo:getCallSign() .. " was destroyed. Respawning in " .. respawnDelays[id] .. " seconds.")
        delay = respawnDelays[id]

        respawnDelays[id] = respawnDelays[id] + GameConfig.respawnDelayIncrease
    else
        logDebug("Player " .. playerInfo:getCallSign() .. " was destroyed out of battle. Take better care next time.")
    end
    respawnCrons[id] = Cron.once(function()
        playerInfo:spawnPlayerShip()
    end, delay)
end)

My.EventHandler:register("onStageFinished", function()
    for _, playerInfo in pairs(My.Players) do
        if not playerInfo:isSpawned() then
            logDebug("Spawning " .. playerInfo:getCallSign() .. " for end of the stage")
            playerInfo:spawnPlayerShip()
        end
        -- reload the player ship to repair, restock, etc.
        -- as nobody is attacking during the break it is just annoying if players need to do that themselves
        playerInfo:reloadPlayerShip()
    end
end)
My.EventHandler:register("onStageStart", function()
    for _, playerInfo in pairs(My.Players) do
        if not playerInfo:isSpawned() then
            logDebug("Spawning " .. playerInfo:getCallSign() .. " for beginning of the stage")
            playerInfo:spawnPlayerShip()
        end
        -- reload the player ship to repair, restock, etc.
        -- as nobody is attacking during the break it is just annoying if players need to do that themselves
        playerInfo:reloadPlayerShip()
    end
end)
