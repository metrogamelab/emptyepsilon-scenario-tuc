--- use the call sign as some kind of health bar ;)

local segments = 7
local nonPrintable = "\255"

local updateCallSign = function(ship)
    local foo = print -- prevent "Upvalue 1 of function is not a table..." error
    local callSign = ship.callSignBase or ""

    local hull = ship:getHull()
    local hullMax = ship:getHullMax()
    callSign = callSign .. nonPrintable
    for i=1,7 do
        if hull >= (hullMax / segments * i) then
            callSign = callSign .. nonPrintable
        end
    end

    ship:setCallSign(callSign)
end

My.EventHandler:register("onEnemySpawn", function(_, enemyInfo)
    local callSignBase = string.sub(enemyInfo:getConfig().name, 1, 1) .. " "
    local ship = enemyInfo:getShipObject()
    ship.callSignBase = callSignBase

    updateCallSign(ship)
    ship:onTakingDamage(updateCallSign)

    -- there is damage over time or healing that could not trigger onTakingDamage
    Cron.regular(function(self)
        if not ship:isValid() then
            Cron.abort(self)
        else
            updateCallSign(ship)
        end
    end, 5)
end)