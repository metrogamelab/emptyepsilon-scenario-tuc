local deepCopy
deepCopy = function (orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepCopy(orig_key)] = deepCopy(orig_value)
    end
    setmetatable(copy, deepCopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

local baseHull = 20
local baseShields = 120
local baseSpeed = 80
local warpFactor = 3
local baseManeuver = 15
local baseAcceleration = 15
local baseEnergy = 400
local baseScannerRange = 5000
local baseLaserDps = 1
local baseLaserRange = 700
local baseLoadTime = 30

local Scout = {
  name = "Scout",
  description = "The scouts are light and agile fighters that prefer to approach from a distance. They are fast, so they are fit to do reconnaissance missions or quickly support weak points in our defense.\n\nThey are the only class that can use scan probes and come with combat maneuver thrusters by default.",
  class = "Scout",
  model = "WespeScout",
  radius = 60,
  radarTrace = "radar_fighter.png",
  hull = baseHull * 0.9,
  shields = baseShields,
  speed = baseSpeed * 1.2,
  maneuver = baseManeuver * 1.2,
  acceleration = baseAcceleration * 1.2,
  energy = baseEnergy * 1.1,
  energyPs = 5 * 0.08,
  probes = 4,
  scanner = baseScannerRange,
  autoScannerRange = 1,
  combatBoost = 300,
  combatStrafe = 225,
  beams = {
    {
      direction = 0,
      arc = 40,
      range = baseLaserRange * 1.7,
      damage = 12,
      cycleTime = 6,
    }
  },
  tubes = {
    {
      direction = 0,
      loadTime = math.max(baseLoadTime * 0.3 - 7.5, 0),
      type = "hvli",
    },
    {
      direction = 0,
      loadTime = baseLoadTime,
      type = "homing",
      size = "small",
    },
  },
  hvli = 26,
  homing = 3,
  mine = 0,
  emp = 0,
  nuke = 0,
}

local QuickScout = deepCopy(Scout)
QuickScout.name = "Quick Scout"
QuickScout.description = "The Quick Scout is by far the fastest ship in our fleet. It is stocked with a lot of probes to make it a perfect reconnaissance ship. Its impulse speed is almost on par with the Bombers Warp1 speed, but this comes at the price of not being very heavily armored. Its laser range compensates for that though."
QuickScout.subclass = "Quick Scout"
QuickScout.model = "LindwurmFighter"
QuickScout.shields = QuickScout.shields * 1.2
QuickScout.speed = QuickScout.speed * 1.8
QuickScout.maneuver = QuickScout.maneuver * 1.4
QuickScout.acceleration = QuickScout.acceleration * 1.2
QuickScout.combatBoost = QuickScout.combatBoost * 1.5
QuickScout.combatStrafe = QuickScout.combatStrafe * 1.5
QuickScout.energy = QuickScout.energy * 1.4
QuickScout.probes = QuickScout.probes * 2
--QuickScout.scanner = Scout.scanner * 1.5
QuickScout.tubes[2].loadTime = QuickScout.tubes[2].loadTime  * 0.8
QuickScout.beams[1].damage = QuickScout.beams[1].damage
QuickScout.beams[1].cycleTime = QuickScout.beams[1].cycleTime
QuickScout.beams[1].range = QuickScout.beams[1].range * 1.4
QuickScout.hvli = 32
QuickScout.homing = 6

local HeavyScout = deepCopy(Scout)
HeavyScout.name = "Heavy Scout"
HeavyScout.description = "The Heavy Scout is our best option when it comes to destroying light fighters of the enemy. It is fast enough to keep its distance from the enemy, has a powerful laser and lots of HVLIs and Homings. There is no better ship in our fleet to take out fighters quickly."
HeavyScout.subclass = "Heavy Scout"
HeavyScout.model = "AdlerLongRangeScout"
HeavyScout.shields = Scout.shields * 1.4
HeavyScout.speed = Scout.speed * 1.2
HeavyScout.maneuver = Scout.maneuver * 1.2
HeavyScout.energy = Scout.energy * 1.3
HeavyScout.probes = Scout.probes * 2
--HeavyScout.scanner = Scout.scanner * 1.2
HeavyScout.beams[1].damage = HeavyScout.beams[1].damage * 1.1
HeavyScout.beams[1].range = HeavyScout.beams[1].range * 1.2
HeavyScout.tubes[3] = deepCopy(HeavyScout.tubes[2])
HeavyScout.homing = 12
HeavyScout.hvli = 26

local Fighter = {
  name = "Fighter",
  description = "Fighters are the backbone of all of our fleets. They are versatile and not bad at everything - but they are not exceptional at anything either. They carry the strongest shields and engage enemies up close with their lasers and mines.\n\nFighters are the only ships with access to mines.",
  class = "Fighter",
  model = "MultiGunCorvette",
  radius = 80,
  radarTrace = "radar_cruiser.png",
  hull = baseHull,
  shields = baseShields * 1.4,
  speed = baseSpeed,
  maneuver = baseManeuver,
  acceleration = baseAcceleration,
  energy = baseEnergy * 1.2,
  scanner = baseScannerRange,
  autoScannerRange = 0.5,
  beams = {
    {
      direction = -20,
      arc = 90,
      range = baseLaserRange,
      damage = 3 * 1.1,
      cycleTime = 3 / baseLaserDps,
    },
    {
      direction = 20,
      arc = 90,
      range = baseLaserRange,
      damage = 3 * 1.1,
      cycleTime = 3 / baseLaserDps,
    }
  },
  tubes = {
    {
      direction = 0,
      loadTime = baseLoadTime,
    },
    {
      direction = 180,
      loadTime = baseLoadTime * 3.9,
      type = "mine",
    },
  },
  hvli = 0,
  homing = 8,
  mine = 1,
  emp = 0,
  nuke = 0,
}

local LaserShip = deepCopy(Fighter)
LaserShip.name = "Laser Ship"
LaserShip.description = "The Laser Ship carries the strongest lasers that we can fit on fighters and can stand a face to face fight with most corvettes at least for some time."
LaserShip.subclass = "Laser Ship"
LaserShip.model = "AtlasHeavyFighter"
LaserShip.hull = LaserShip.hull * 1.3
LaserShip.shields = {LaserShip.shields * 1.2, LaserShip.shields * 0.8}
LaserShip.speed = LaserShip.speed * 1.2
LaserShip.maneuver = LaserShip.maneuver * 1.1
LaserShip.acceleration = LaserShip.acceleration
LaserShip.energy = LaserShip.energy * 1.25
LaserShip.energyPs = 5 * 0.08 -- to compensate second shield
LaserShip.beams[1].cycleTime = LaserShip.beams[1].cycleTime * 0.7
LaserShip.beams[1].range = LaserShip.beams[1].range * 1.2
LaserShip.beams[2].cycleTime = LaserShip.beams[2].cycleTime * 0.7
LaserShip.beams[2].range = LaserShip.beams[2].range * 1.2
LaserShip.homing = 10
LaserShip.mine = 1

local MineLayer = deepCopy(Fighter)
MineLayer.name = "Mine Layer"
MineLayer.description = "The Mine Layer got outfitted with storage for additional mines. It prefers to engage the enemy head on with their lasers and place a mine right in the middle of them. We gave it the strongest shields to allow that tactic.\n\nFighters can usually evade the mines, so it is better fitted against corvettes."
MineLayer.subclass = "Mine Layer"
MineLayer.model = "MineLayerCorvette"
MineLayer.hull = MineLayer.hull * 1.2
MineLayer.shields = {MineLayer.shields * 1.1, MineLayer.shields * 1.1}
MineLayer.maneuver = MineLayer.maneuver
MineLayer.acceleration = MineLayer.acceleration
MineLayer.energy = MineLayer.energy * 1.3
MineLayer.energyPs = 5 * 0.08 -- to compensate second shield
MineLayer.beams[1].arc = MineLayer.beams[1].arc * 1.4
MineLayer.beams[1].direction = MineLayer.beams[1].direction * 1.2
MineLayer.beams[1].range = MineLayer.beams[1].range * 1.1
MineLayer.beams[2].arc = MineLayer.beams[2].arc * 1.4
MineLayer.beams[2].direction = MineLayer.beams[2].direction * 1.2
MineLayer.beams[2].range = MineLayer.beams[2].range * 1.1
MineLayer.beams[3] = {
  direction = 180,
  arc = 90,
  range = baseLaserRange * 1.2,
  damage = 6 * 0.8,
  cycleTime = 6 / baseLaserDps,
}
MineLayer.tubes[2].loadTime = MineLayer.tubes[2].loadTime * 0.65
MineLayer.homing = math.ceil(MineLayer.homing)
MineLayer.mine = 3

local Bomber = {
  name = "Bomber",
  description = "There is nothing better than a Bomber when facing enemy Corvettes or Dreadnoughts as they can deal heavy damage from a distance with their missiles. On the downside they are rather slow and not particularly good against fighters, so they should be accompanied by ships that can deal with those.\n\nBombers are the only class that can utilize nukes.",
  class = "Bomber",
  model = "LightCorvette",
  radius = 100,
  radarTrace = "radar_tug.png",
  hull = baseHull * 1.2,
  shields = baseShields * 0.8,
  speed = baseSpeed * 0.5,
  warp = baseSpeed * 3 * 0.8,
  maneuver = baseManeuver,
  acceleration = baseAcceleration,
  energy = baseEnergy * 1.2,
  scanner = baseScannerRange,
  autoScannerRange = 0.5,
  beams = {
    {
      direction = 0,
      arc = 360,
      range = baseLaserRange * 1.4,
      damage = 4,
      cycleTime = 6 / baseLaserDps,
    },
  },
  tubes = {
    {
      direction = 0,
      loadTime = baseLoadTime * 0.8,
    },
    {
      direction = 0,
      loadTime = baseLoadTime * 0.8,
    },
    {
      direction = 0,
      loadTime = baseLoadTime * 1.5,
      type = "nuke",
      size = "small",
    },
  },
  hvli = 0,
  homing = 22,
  mine = 0,
  emp = 0,
  nuke = 2,
}

local MissileCorvette = deepCopy(Bomber)
MissileCorvette.name = "Missile Corvette"
MissileCorvette.description = "The Missile Corvette was designed to fill space with homing missiles that find their targets and destroy them quickly. It usually targets larger and slower targets, but its quick reload cycle allows it to even target smaller close enemies."
MissileCorvette.subclass = "Missile Corvette"
MissileCorvette.model = "LaserCorvette"
MissileCorvette.hull = Bomber.hull * 1.2
MissileCorvette.shields = Bomber.shields * 1.2
MissileCorvette.speed = Bomber.speed * 1.2
MissileCorvette.warp = Bomber.warp * 1.2
MissileCorvette.maneuver = Bomber.maneuver * 1.2
MissileCorvette.energy = Bomber.energy * 1.1
MissileCorvette.tubes[1].loadTime = MissileCorvette.tubes[1].loadTime * 0.8
MissileCorvette.tubes[2].loadTime = MissileCorvette.tubes[2].loadTime * 0.8
MissileCorvette.homing = 34

local HeavyCorvette = deepCopy(Bomber)
HeavyCorvette.name = "Heavy Corvette"
HeavyCorvette.description = "The Heavy Corvette specialises in taking down Dreadnoughts and Corvettes.\n\nIt is the only ship in our fleet that uses large missiles and is stocked with more nukes. If you can get it close enough to a dreadnought and shield it from the enemies fighters, it can deal massive damage."
HeavyCorvette.subclass = "Heavy Corvette"
HeavyCorvette.model = "HeavyCorvette"
HeavyCorvette.shields = Bomber.shields * 1.4
HeavyCorvette.speed = Bomber.speed * 1.2
HeavyCorvette.warp = Bomber.warp * 1.2
HeavyCorvette.maneuver = Bomber.maneuver * 1.2
HeavyCorvette.energy = Bomber.energy * 1.1
HeavyCorvette.homing = 13
HeavyCorvette.nuke = 6

HeavyCorvette.tubes[1].size = "large"
HeavyCorvette.tubes[1].loadTime = HeavyCorvette.tubes[1].loadTime * 1.5
HeavyCorvette.tubes[2].size = "large"
HeavyCorvette.tubes[2].loadTime = HeavyCorvette.tubes[1].loadTime * 1.5
HeavyCorvette.tubes[3].loadTime = HeavyCorvette.tubes[3].loadTime * 0.7

_G.PlayerShipTemplates = {
  Scout,
  QuickScout,
  HeavyScout,
  Fighter,
  LaserShip,
  MineLayer,
  Bomber,
  MissileCorvette,
  HeavyCorvette,
}

setmetatable(PlayerShipTemplates, {
  __index = {
    getByName = function(self, name)
      for _, config in pairs(self) do
        if type(config) == "table" and config.name == name then
          return config
        end
      end
      error("Cadet ship with name " .. name .. " does not exist")
    end,
    getByClass = function(self, class)
      local result = {}
      for _, config in pairs(self) do
        if type(config) == "table" and config.class == class then
          table.insert(result, config)
        end
      end
      if #result == 0 then
        error("No Cadet ships with class " .. class .. " exist")
      end
      return result
    end,
  }
})

for _, config in pairs(PlayerShipTemplates) do
  config.description = config.description or ""
  config.warp = config.warp or (config.speed * warpFactor)
  config.beams = config.beams or {}
  config.tubes = config.tubes or {}

  config.bareLaserDamagePerMinute = function()
    local totalDpm = 0
    for _, beam in pairs(config.beams) do
      totalDpm = totalDpm + beam.damage / beam.cycleTime * 60
    end
    return totalDpm
  end


  config.homingsPerMinute = function()
    local hpm = 0
    for _, tube in pairs(config.tubes) do
      if tube.type == nil or tube.type == "homing" then
        local loadTime = tube.loadTime + 1 -- 1 is for clicking :D

        hpm = hpm + (60/loadTime)
      end
    end

    return hpm
  end

  config.bareHomingDamagePerMinute = function()
    local totalDpm = 0
    local defaultDmg = 35

    for _, tube in pairs(config.tubes) do
      if tube.type == nil or tube.type == "homing" then
        local dmg = defaultDmg
        if tube.size == "small" then dmg = dmg / 2 end
        if tube.size == "large" then dmg = dmg * 2 end
        local loadTime = tube.loadTime + 1 -- 1 is for clicking :D

        totalDpm = totalDpm + dmg * (60 / loadTime)
      end
    end

    return totalDpm
  end

  config.hvlisPerMinute = function()
    local hpm = 0
    for _, tube in pairs(config.tubes) do
      if tube.type == "hvli" then
        local loadTime = tube.loadTime + 1 + 7.5 -- 1 is for clicking / 7.5 for the waiting time while the weapon fires

        hpm = hpm + (60 / loadTime)
      end
    end

    return hpm
  end

  config.bareHvliDamagePerMinute = function()
    local totalDpm = 0
    local defaultDmg = 30

    for _, tube in pairs(config.tubes) do
      if tube.type == "hvli" then
        local dmg = defaultDmg
        if tube.size == "small" then dmg = dmg / 2 end
        if tube.size == "large" then dmg = dmg * 2 end
        local loadTime = tube.loadTime + 1 + 7.5 -- 1 is for clicking / 7.5 for the waiting time while the weapon fires

        totalDpm = totalDpm + dmg * (60 / loadTime)
      end
    end

    return totalDpm
  end

  config.hvliDamageAtBeamRangePerMinute = function(self)
    local minRange = nil
    for _, beam in pairs(config.beams) do
      if minRange == nil or beam.range < minRange then
        minRange = beam.range
      end
    end

    if minRange < 2000 then
      return minRange/2000 * self:bareHvliDamagePerMinute()
    else
      return self:bareHvliDamagePerMinute()
    end
  end

  config.minesPerMinute = function()
    local mpm = 0
    for _, tube in pairs(config.tubes) do
      if tube.type == "mine" then
        local loadTime = tube.loadTime + 1 -- 1 is for clicking :D

        mpm = mpm + (60/loadTime)
      end
    end

    return mpm
  end

  config.bareMineDamagePerMinute = function()
    local totalDpm = 0
    local defaultDmg = 160

    for _, tube in pairs(config.tubes) do
      if tube.type == "mine" then
        local dmg = defaultDmg
        local loadTime = tube.loadTime + 1 -- 1 is for clicking

        totalDpm = totalDpm + dmg * (60 / loadTime)
      end
    end

    return totalDpm
  end

  config.nukesPerMinute = function()
    local npm = 0
    for _, tube in pairs(config.tubes) do
      if tube.type == "nuke" then
        local loadTime = tube.loadTime + 1 -- 1 is for clicking :D

        npm = npm + (60/loadTime)
      end
    end

    return npm
  end

  config.bareNukeDamagePerMinute = function()
    local totalDpm = 0
    local defaultDmg = 160

    for _, tube in pairs(config.tubes) do
      if tube.type == "nuke" then
        local dmg = defaultDmg
        if tube.size == "small" then dmg = dmg / 2 end
        if tube.size == "large" then dmg = dmg * 2 end
        local loadTime = tube.loadTime + 1 -- 1 is for clicking

        totalDpm = totalDpm + dmg * (60 / loadTime)
      end
    end

    return totalDpm
  end

  config.damageAgainstFighters = function()
    return config:bareLaserDamagePerMinute() + config:bareHomingDamagePerMinute() + config:hvliDamageAtBeamRangePerMinute() + config:bareMineDamagePerMinute() / 2 + config:bareNukeDamagePerMinute() / 2
  end
  config.damageAgainstCorvettes = function()
    local dmg = 0
    if config.class ~= "Bomber" then
      -- bombers probably don't want to get too close
      dmg = dmg + config:bareLaserDamagePerMinute()
    end
    return dmg + config:bareHomingDamagePerMinute() + config:hvliDamageAtBeamRangePerMinute() / 2 + config:bareMineDamagePerMinute() + config:bareNukeDamagePerMinute()
  end
  config.damageAgainstDreadnoughts = function()
    local dmg = 0
    if config.class ~= "Bomber" then
      -- bombers probably don't want to get too close
      dmg = dmg + config:bareLaserDamagePerMinute() / 2
    end
    return dmg + config:bareHomingDamagePerMinute() + config:bareHvliDamagePerMinute() / 2 + config:bareMineDamagePerMinute() / 2 + config:bareNukeDamagePerMinute()
  end












  config.energyDrainPerMinuteAgainstFighters = function()
    local energy_shield_use_per_second = 1.5 -- @see PlayerSpaceship:energy_shield_use_per_second
    local drain = config.energyDrainPerSecond()
    if config.shields ~= nil then
      drain = drain + energy_shield_use_per_second
    end

    return drain * 60
  end

  config.timeToEmptyEnergyAgainstFighters = function()
    -- natural energy regeneration per Minute
    local regen = 0.08 * 5 * 60

    return config.energy / config:energyDrainPerMinuteAgainstFighters()
  end

  config.statLaserDps = function()
    local totalDps = 0
    for _, beam in pairs(config.beams) do
      local d = beam.damage / beam.cycleTime
      if beam.direction < -90 or beam.direction > 90 then
        -- back lasers are less likely to attack stuff
        d = d / 2
      end
      totalDps = totalDps + d
    end

    return totalDps
  end

  config.energyDrainPerSecond = function()
    local drain = -10 * 0.08 -- @see PlayerSpaceship:system_power_user_factor
    if type(config.shields) == "table" then
      drain = drain + 10 * 0.08 -- just because they exist
    elseif type(config.shields) == "number" then
      drain = drain + 5 * 0.08 -- just because it exists
    end
    if config.energyPs then
      drain = drain - config.energyPs
    end
    return drain
  end


  config.energyDrainPerSecondInWarp = function(_, warpLevel)
    local energy_warp_per_second = 1.0 -- @see PlayerSpaceship:energy_warp_per_second
    local drain = config.energyDrainPerSecond()

    drain = drain + energy_warp_per_second  * math.exp(math.log(warpLevel) * 1.2)

    return drain
  end

  config.energyDrainPerUInWarp = function(_, warpLevel)
    local ups = config.warp * warpLevel / 1000
    return config:energyDrainPerSecondInWarp(warpLevel) / ups
  end

  config.statHitPoints = function()
    local totalHitPoints = config.hull

    if type(config.shields) == "table" then
      totalHitPoints = totalHitPoints + config.shields[1]
      -- a second shield might not be as helpful as a total shield increase of the same value
      totalHitPoints = totalHitPoints + config.shields[2] / 2
    else
      totalHitPoints = totalHitPoints + config.shields
    end
    return totalHitPoints
  end

  config.getShieldRechargePerSecond = function()
    local rechargePerSecond = 0
    if type(config.shields) == "table" then
      rechargePerSecond = rechargePerSecond + 0.3 * 1.5
    elseif config.shields ~= nil then
      rechargePerSecond = rechargePerSecond + 0.3
    end
    return rechargePerSecond
  end
end

_G.PlayerShipColors = {"Yellow", "Blue", "Green", "Red", "Grey", "White"}