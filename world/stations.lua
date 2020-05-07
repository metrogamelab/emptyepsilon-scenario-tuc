local MyStation = function(templateName, x, y)
    -- needs to be a CpuShip to have beams
    local station = CpuShip():
    setTemplate(templateName):
    setFaction("Academy"):
    setPosition(x, y):
    setRotation(math.random(0,359)):
    setShieldsMax():
    setImpulseMaxSpeed(0):
    setRotationMaxSpeed(0):
    setBeamWeapon(0, 360, 0, 2500, 6, 6):
    setScanState("full")

    station:orderStandGround()

    Station:withComms(station, {
        hailText = function()
            local text = station:getCallSign() .. "\n\n"
            text = text .. string.format("Hull: %.0f/%.0f\n\n", station:getHull(), station:getHullMax())
            text = text .. "We offer repairs, restocks and recharges when no enemies are on our scanners."

            return text
        end
    })

    Cron.regular(function(self)
        -- station could be moved, because it is a "Ship"
        if not station:isValid() then
            Cron.abort(self)
        else
            station:setPosition(x, y)
        end
    end, 0.1)

    return station
end

My.EventHandler:register("onWorldCreation", function()
    local x, y = 0, 0

    local station = MyStation("Large Station", x, y)
    station:setCallSign("Academy")
    My.EventHandler:fire("onStationSpawn", station)

    Cron.regular(function()
        if not station:isValid() then
            victory("Unknown")
        end
    end, 1)

    local angles = {0}
    if _G.GameConfig.numberLanes == 2 then
        angles = {-40, 40}
    elseif _G.GameConfig.numberLanes == 3 then
        angles = {-60, 0, 60}
    elseif _G.GameConfig.numberLanes == 4 then
        angles = {-80, -40, 0, 40, 80}
    end

    for i, avgAngle in ipairs(angles) do
        local avgDistance = 12000
        local x1, y1 = Util.addVector(x, y, (math.random() * 20) - 10 + avgAngle, avgDistance)
        local station3 = MyStation("Medium Station", x1, y1)
        if GameConfig.laneNames[i] and GameConfig.stationNames[1] then station3:setCallSign(GameConfig.laneNames[i] .. " " .. GameConfig.stationNames[1]) end
        local x2, y2 = Util.addVector(x1, y1, (math.random() * 0.4 + 0.5) * avgAngle + math.random(-10, 10), avgDistance * (math.random() * 0.4 + 0.8))
        local station2 = MyStation("Medium Station", x2, y2)
        if GameConfig.laneNames[i] and GameConfig.stationNames[2] then station2:setCallSign(GameConfig.laneNames[i] .. " " .. GameConfig.stationNames[2]) end
        local x3, y3 = Util.addVector(x2, y2, (math.random() * 0.4 + 0.2) * avgAngle + math.random(-10, 10), avgDistance * (math.random() * 0.4 + 0.8))
        local station1 = MyStation("Medium Station", x3, y3)
        if GameConfig.laneNames[i] and GameConfig.stationNames[3] then station1:setCallSign(GameConfig.laneNames[i] .. " " .. GameConfig.stationNames[3]) end
        local x4, y4 = Util.addVector(x3, y3, (math.random() * 0.4 + 0.2) * avgAngle + math.random(-10, 10), avgDistance * (math.random() * 0.4 + 1.3))
        My.EventHandler:fire("onStationSpawn", station3)
        My.EventHandler:fire("onStationSpawn", station2)
        My.EventHandler:fire("onStationSpawn", station1)
        local jumpAngle = Util.angleFromVector(x3 - x4, y3 - y4)
        -- just in case someone gets sucked
        local jumpX, jumpY = Util.addVector(x4, y4, jumpAngle, 5000)
        WormHole():setPosition(x4, y4):setTargetPosition(jumpX, jumpY)

        local zone = (function()
            local angle1 = Util.angleFromVector(x1 - x, y1 - y)
            local firstX, firstY = Util.addVector(x1, y1, angle1 - 180, 2000)
            local angle2 = Util.angleFromVector(x2 - x, y2 - y)
            local angle3 = Util.angleFromVector(x3 - x1, y3 - y1)
            local angle4 = Util.angleFromVector(x4 - x2, y4 - y2)
            local angle5 = Util.angleFromVector(x4 - x3, y4 - y3)
            local lastX, lastY = Util.addVector(x3, y3, angle5, 5000)

            local points = {}
            local pointX, pointY = Util.addVector(firstX, firstY, angle2 - 180, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(firstX, firstY, angle2 - 135, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(firstX, firstY, angle2 - 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(x1, y1, angle2 - 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(x2, y2, angle3 - 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(x3, y3, angle4 - 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(lastX, lastY, angle4 - 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(lastX, lastY, angle4 - 45, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(lastX, lastY, angle4, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(lastX, lastY, angle4 + 45, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(lastX, lastY, angle4 + 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(x3, y3, angle4 + 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(x2, y2, angle3 + 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(x1, y1, angle2 + 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(firstX, firstY, angle2 + 90, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            pointX, pointY = Util.addVector(firstX, firstY, angle2 + 135, 5000)
            table.insert(points, pointX)
            table.insert(points, pointY)
            return Zone():setPoints(table.unpack(points))
        end)()

        zone:setFaction("Academy")
        zone:setColor(31,63,31)
        zone:setLabel(GameConfig.laneNames[i] or ("Campus" .. i))

        local spawnAngle = Util.angleFromVector(x3 - x4, y4 - y4)
        table.insert(My.World.lanes, {
            spawn = function(self, spaceObject)
                if Fleet:isFleet(spaceObject) then
                    for _, ship in pairs(spaceObject:getShips()) do
                        self:spawn(ship)
                    end
                else
                    spaceObject:setPosition(Util.addVector(x4, y4, spawnAngle + math.random(-45, 45), 3000))
                    spaceObject:setRotation(spawnAngle)
                end
            end,
            isStation1Valid = function() return station1:isValid() end,
            getStation1 = function() return station1 end,
            isStation2Valid = function() return station2:isValid() end,
            getStation2 = function() return station2 end,
            isStation3Valid = function() return station3:isValid() end,
            getStation3 = function() return station3 end,
            getWormHolePosition = function() return x4, y4 end,
        })
    end

    My.World.hqStation = station
end, -100)