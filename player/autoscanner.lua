--- automatically full scan close enemies

My.EventHandler:register("onPlayerSpawn", function(_, playerInfo)
    Cron.regular(function(self)
        if not playerInfo:isSpawned() then
            Cron.abort(self)
            return
        end
        local player = playerInfo:getShipObject()
        local range = playerInfo:getAutoScannerRange()
        for _, thing in pairs(player:getObjectsInRange(range)) do
            if isEeShip(thing) and player:isEnemy(thing) then
                thing:setScanState("full")
            end
        end
    end)
end)


