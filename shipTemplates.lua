template = ShipTemplate():setName("Medium Station"):setLocaleName(_("Medium Station")):setModel("space_station_3"):setType("station")
template:setDescription("")
template:setHull(1000)
template:setShields()
template:setRadarTrace("radartrace_mediumstation.png")
template:setSpeed(0, 0, 0)
template:setSharesEnergyWithDocked(true)
template:setDockClasses("Academy")
template:setEnergyStorage(999999999)

template = ShipTemplate():setName("Large Station"):setLocaleName(_("Large Station")):setModel("space_station_2"):setType("station")
template:setDescription("")
template:setHull(2000)
template:setShields()
template:setRadarTrace("radartrace_largestation.png")
template:setSpeed(0, 0, 0)
template:setSharesEnergyWithDocked(true)
template:setDockClasses("Academy")
template:setEnergyStorage(999999999)

local PlayerTemplate = function()
    local template = ShipTemplate()
    template:setRepairCrewCount(0)
    template:addRoomSystem(0, 0, 1, 1, "Maneuver")
    template:addRoomSystem(1, 0, 1, 1, "BeamWeapons")
    template:addRoomSystem(2, 0, 1, 1, "RearShield")
    template:addRoomSystem(0, 1, 1, 1, "Reactor")
    template:addRoomSystem(1, 1, 1, 1, "Warp")
    template:addRoomSystem(2, 1, 1, 1, "JumpDrive")
    template:addRoomSystem(0, 2, 1, 1, "FrontShield")
    template:addRoomSystem(1, 2, 1, 1, "MissileSystem")
    template:addRoomSystem(2, 2, 1, 1, "Impulse")
    template:setJumpDrive(false)
    return template
end

require("config/players.lua")

for _, conf in pairs(PlayerShipTemplates) do
    for _, color in ipairs(PlayerShipColors) do
        local name = conf.name
        if color ~= PlayerShipColors[1] then
            name = name .. " " .. color
        end
        template = PlayerTemplate():setName(name):setClass("Academy", conf.class):setModel(conf.model..color)
        if color ~= PlayerShipColors[1] then
            -- playerships are hidden from the database. No need to have every color variation there.
            template:setType("playership")
        end
        template:setRadarTrace(conf.radarTrace)
        template:setDescription(conf.description)
        template:setHull(conf.hull)
        if type(conf.shields) == "number" then
            template:setShields(conf.shields)
        else
            template:setShields(table.unpack(conf.shields))
        end
        template:setSpeed(conf.speed, conf.maneuver, conf.acceleration)
        template:setWarpSpeed(conf.warp)
        if conf.combatStrafe ~= nil and conf.combatBoost ~= nil then
            template:setCombatManeuver(conf.combatBoost, conf.combatStrafe)
        else
            template:setCombatManeuver(0, 0)
        end

        for i, config in ipairs(conf.beams) do
            template:setBeamWeapon(i-1, config.arc, config.direction, config.range, config.cycleTime, config.damage)
            template:setBeamWeaponEnergyPerFire(i-1, 0)
            template:setBeamWeaponHeatPerFire(i-1, 0)
        end
        template:setEnergyStorage(conf.energy)
        template:setShortRangeRadarRange(conf.scanner)
        template:setTubes(#conf.tubes, 99)
        for i, tube in ipairs(conf.tubes) do
            template:setTubeDirection(i-1, tube.direction)
            template:setTubeLoadTime(i-1, tube.loadTime)
            if tube.type == "mine" then
                template:weaponTubeDisallowMissle(i-1, "HVLI")
                template:weaponTubeDisallowMissle(i-1, "Homing")
                template:weaponTubeAllowMissle(i-1, "Mine")
                template:weaponTubeDisallowMissle(i-1, "EMP")
                template:weaponTubeDisallowMissle(i-1, "Nuke")
            elseif tube.type == "nuke" then
                template:weaponTubeDisallowMissle(i-1, "HVLI")
                template:weaponTubeDisallowMissle(i-1, "Homing")
                template:weaponTubeDisallowMissle(i-1, "Mine")
                template:weaponTubeDisallowMissle(i-1, "EMP")
                template:weaponTubeAllowMissle(i-1, "Nuke")
            elseif tube.type == "hvli" then
                template:weaponTubeAllowMissle(i-1, "HVLI")
                template:weaponTubeDisallowMissle(i-1, "Homing")
                template:weaponTubeDisallowMissle(i-1, "Mine")
                template:weaponTubeDisallowMissle(i-1, "EMP")
                template:weaponTubeDisallowMissle(i-1, "Nuke")
            else
                template:weaponTubeDisallowMissle(i-1, "HVLI")
                template:weaponTubeAllowMissle(i-1, "Homing")
                template:weaponTubeDisallowMissle(i-1, "Mine")
                template:weaponTubeDisallowMissle(i-1, "EMP")
                template:weaponTubeDisallowMissle(i-1, "Nuke")

            end
            if tube.size then
                template:setTubeSize(i-1, tube.size)
            end
        end
        template:setWeaponStorage("HVLI", conf.hvli)
        template:setWeaponStorage("Homing", conf.homing)
        template:setWeaponStorage("Mine", conf.mine)
        template:setWeaponStorage("EMP", conf.emp)
        template:setWeaponStorage("Nuke", conf.nuke)
    end
end

local EnemyTemplate = function()
    local template = ShipTemplate()
    template:setJumpDrive(false)
    return template
end

require("config/enemies.lua")

for _, conf in pairs(EnemyShipTemplates) do
    template = EnemyTemplate():setName(conf.name):setClass("Unknown", conf.class):setModel(conf.model)
    template:setRadarTrace(conf.radarTrace)
    template:setDescription(conf.description)
    template:setHull(conf.hull)
    if type(conf.shields) == "number" then
        template:setShields(conf.shields)
    elseif type(conf.shields) == "table" then
        template:setShields(table.unpack(conf.shields))
    end
    template:setSpeed(conf.speed, conf.maneuver, conf.acceleration)
    if conf.jump then
        template:setJumpDrive(true)
        template:setJumpDriveRange(conf.jump / 2, conf.jump)
    end
    for i, config in ipairs(conf.beams) do
        template:setBeamWeapon(i-1, config.arc, config.direction, config.range, config.cycleTime, config.damage)
        template:setBeamWeaponEnergyPerFire(i-1, 0)
        template:setBeamWeaponHeatPerFire(i-1, 0)
    end
    template:setEnergyStorage(conf.energy)
    template:setTubes(#conf.tubes, 99)
    for i, tube in ipairs(conf.tubes) do
        template:setTubeDirection(i-1, tube.direction)
        template:setTubeLoadTime(i-1, tube.loadTime)
        if tube.type == "mine" then
            template:weaponTubeDisallowMissle(i-1, "HVLI")
            template:weaponTubeDisallowMissle(i-1, "Homing")
            template:weaponTubeAllowMissle(i-1, "Mine")
            template:weaponTubeDisallowMissle(i-1, "EMP")
            template:weaponTubeDisallowMissle(i-1, "Nuke")
        elseif tube.type == "nuke" then
            template:weaponTubeDisallowMissle(i-1, "HVLI")
            template:weaponTubeDisallowMissle(i-1, "Homing")
            template:weaponTubeDisallowMissle(i-1, "Mine")
            template:weaponTubeDisallowMissle(i-1, "EMP")
            template:weaponTubeAllowMissle(i-1, "Nuke")
        elseif tube.type == "hvli" then
            template:weaponTubeAllowMissle(i-1, "HVLI")
            template:weaponTubeDisallowMissle(i-1, "Homing")
            template:weaponTubeDisallowMissle(i-1, "Mine")
            template:weaponTubeDisallowMissle(i-1, "EMP")
            template:weaponTubeDisallowMissle(i-1, "Nuke")
        else
            template:weaponTubeDisallowMissle(i-1, "HVLI")
            template:weaponTubeAllowMissle(i-1, "Homing")
            template:weaponTubeDisallowMissle(i-1, "Mine")
            template:weaponTubeDisallowMissle(i-1, "EMP")
            template:weaponTubeDisallowMissle(i-1, "Nuke")
        end
        if tube.size then
            template:setTubeSize(i-1, tube.size)
        end
    end
    template:setWeaponStorage("HVLI", conf.hvli and 9999 or 0)
    template:setWeaponStorage("Homing", conf.homing and 9999 or 0)
    template:setWeaponStorage("Mine", conf.mine and 9999 or 0)
    template:setWeaponStorage("EMP", conf.emp and 9999 or 0)
    template:setWeaponStorage("Nuke", conf.nuke and 9999 or 0)
    if conf.ai == "fighter" then
        template:setDefaultAI("fighter")
    elseif conf.ai == "missilevolley" or conf.ai == "destroy_station" then
        template:setDefaultAI("missilevolley")
    end
end