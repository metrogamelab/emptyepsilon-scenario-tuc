local Speed = {
    name = "+20% Speed",
    description = "Increases the impulse speed (not warp!) by 20% to give you the edge against your enemies.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()
        ship:setImpulseMaxSpeed(config.speed * 1.2)
        --ship:setWarpSpeed(config.warp * 1.2) -- only EE>2020.03
    end
}

local Maneuver = {
    name = "+20% Maneuver",
    description = "Adding a nitro injector into the steering thrusters makes you better in dog fights and when dodging missiles.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()
        ship:setRotationMaxSpeed(config.maneuver * 1.2)
    end
}

local Energy = {
    name = "+20% Energy",
    description = "Stay longer in battle by increasing your energy stores.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()
        ship:setMaxEnergy(config.energy * 1.2)
        ship:setEnergy(config.energy * 1.2)
    end
}

local LaserDamage = {
    name = "+20% Laser Damage",
    description = "Improve your laser damage by 20% without reducing the fire rate.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()
        for i, beamConfig in pairs(config.beams) do
            ship:setBeamWeapon(i-1, beamConfig.arc, beamConfig.direction, beamConfig.range, beamConfig.cycleTime, beamConfig.damage * 1.2)
        end
    end
}
local MissileAmount = {
    name = "+30% Light Missiles",
    description = "Add more Homing missiles and HVLIs into your arsenal. Fractions will be rounded up for your benefit.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()
        for _, missile in pairs({"hvli", "homing"}) do
            ship:setWeaponStorageMax(missile, math.ceil(config[missile] * 1.33))
            ship:setWeaponStorage(missile, math.ceil(config[missile] * 1.33))
        end
    end
}

local Shield = {
    name = "+20% Shields",
    description = "Increase the capacity of your shields to survive longer in battle",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()
        if isNumber(config.shields) then
            ship:setShieldsMax(config.shields * 1.2)
            ship:setShields(config.shields * 1.2)
        elseif isTable(config.shields) then
            ship:setShieldsMax(table.unpack(Util.map(config.shields, function(s) return s * 1.2 end)))
            ship:setShields(table.unpack(Util.map(config.shields, function(s) return s * 1.2 end)))
        end
    end
}
local Probes = {
    name = "+50% Probes",
    description = "Add half as much scan probes to your arsenal than you already have.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()

        ship:setMaxScanProbeCount(config.probes * 1.5)
        ship:setScanProbeCount(config.probes * 1.5)
    end,
    requiredClass = "Scout"
}
local CombatManeuver = {
    name = "Combat Maneuver",
    description = "Installs the same thrusters that the Scout has to your ship. It allows you to do dodge maneuvers in battle.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        ship:setCombatManeuver(200, 150)
    end,
    requiredClass = "Fighter"
}

local Jump = {
    name = "Short Jump Drive",
    description = "Adds a short range jump drive to your ship. It ranges between 2 and 10u.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        ship:setJumpDrive(true)
        ship:setJumpDriveRange(2000, 10000)

        -- compensate that the jump drive needs additional energy even when it is not used
        playerInfo:setEnergyRegenerationPerSecond(playerInfo:getEnergyRegenerationPerSecond() + 5 * 0.08)
    end,
    requiredClass = "Fighter"
}
local NukeAmount = {
    name = "+30% Nukes",
    description = "Increase the number of nukes in your storage by 30%.",
    install = function(_, playerInfo)
        local ship = playerInfo:getShipObject()
        local config = playerInfo:getConfig()
        ship:setWeaponStorageMax("nuke", math.ceil(config.nuke * 1.33))
        ship:setWeaponStorage("nuke", math.ceil(config.nuke * 1.33))
    end,
    requiredClass = "Bomber"
}

_G.PlayerShipUpdates = {
    Speed,
    Maneuver,
    Energy,
    LaserDamage,
    MissileAmount,
    Shield,
    Probes,
    CombatManeuver,
    Jump,
    NukeAmount,
}