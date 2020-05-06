--- remove leftovers from the world. Mines, Probes, WarpJammers, etc should all be removed

local cleanup = function()
    for _, thing in pairs(getAllObjects()) do
        if isEeMine(thing) or isEeScanProbe(thing) or isEeWarpJammer(thing) or isEeNebula(thing) then
            -- mostly for fun and to prevent bursting speakers: let all the things explode
            local delay = math.random() * 10
            for _, lane in pairs(My.World.lanes) do
                local wormX, wormY = lane:getWormHolePosition()
                if distance(thing, wormX, wormY) < 10000 then
                    delay = 0
                    thing:destroy()
                end
            end

            if delay > 0 then
                Cron.once(function()
                    if thing:isValid() then
                        local x, y = thing:getPosition()
                        ExplosionEffect():setPosition(x, y):setSize(isEeMine(thing) and 600 or 200)
                        thing:destroy()
                    end
                end, delay)
            end
        end
    end

    -- @TODO: repair, restock players
end

My.EventHandler:register("onStageStart", cleanup)
My.EventHandler:register("onStageFinished", cleanup)