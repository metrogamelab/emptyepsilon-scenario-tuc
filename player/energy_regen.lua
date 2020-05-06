--- player ships with jump drive or a second shield draw more energy from the reactor by default
--- we try to offset this, so every ship has the same energy regeneration

My.EventHandler:register("onPlayerTemplateSet", function(_, playerInfo)
    local cronId = playerInfo:getId().."_energy_regen"
    local energyPs = playerInfo:getEnergyRegenerationPerSecond()
    if not energyPs or energyPs == 0 then
        Cron.abort(cronId)
        return
    end

    Cron.regular(cronId, function(self, delta)
        if not playerInfo:isSpawned() then
            Cron.abort(self)
            return
        end
        local ship = playerInfo:getShipObject()
        ship:setEnergyLevel(math.min(ship:getEnergyLevel() + delta * energyPs, ship:getEnergyLevelMax()))
    end)
end)
