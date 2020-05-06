--- sync the waypoints over all player ships

local lastWaypoints = {}

local areWaypointsDifferent = function(ship)
    if ship:getWaypointCount() ~= Util.size(lastWaypoints) then
        return true
    else
        -- @TODO: 1 or 0?
        for i=1, ship:getWaypointCount() do
            local x,y = ship:getWaypoint(i)
            if lastWaypoints[i][1] ~= x or lastWaypoints[i][2] ~= y then
                return true
            end
        end
    end
    return false
end

local setWaypointsOn = function(ship, newWaypoints)
    newWaypoints = newWaypoints or lastWaypoints

    -- remove all waypoints
    for i=ship:getWaypointCount(),1,-1 do
        ship:commandRemoveWaypoint(i-1)
    end
    -- set the new waypoints
    for _, waypoint in ipairs(newWaypoints) do
        ship:commandAddWaypoint(waypoint[1], waypoint[2])
    end
end

local broadcastNewWaypoints = function(ship)
    local newWaypoints = {}
    -- @TODO: 1 or 0?
    for i=1, ship:getWaypointCount() do
        local x,y = ship:getWaypoint(i)
        newWaypoints[i] = {x, y}
    end

    for _, otherPlayerInfo in pairs(My.Players) do
        if otherPlayerInfo:isSpawned() then
            local otherPlayer = otherPlayerInfo:getShipObject()
            setWaypointsOn(otherPlayer, newWaypoints)
        end
    end

    lastWaypoints = newWaypoints
end

My.EventHandler:register("onWorldCreation", function(_, playerInfo)
    -- check regularly if any ship has different waypoints then what we know
    Cron.regular(function()
        for _, playerInfo in pairs(My.Players) do
            if playerInfo:isSpawned() then
                local ship = playerInfo:getShipObject()
                if areWaypointsDifferent(ship) then
                    logDebug("broadcasting new waypoints from " .. ship:getCallSign())
                    broadcastNewWaypoints(ship)
                end
            end
        end
    end, 0.1)
end, 999)

My.EventHandler:register("onPlayerSpawn", function(_, playerInfo)
    local ship = playerInfo:getShipObject()
    setWaypointsOn(ship)
end)
