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

-- enemies rely on hull rather than shields
local fighterHull = 150
local corvetteHull = fighterHull * 3
local dreadnoughtHull = corvetteHull * 3
local baseShields = 30
local baseSpeed = 75
local baseManeuver = 15
local baseAcceleration = 10
local baseEnergy = 1000
local baseLaserDps = 0.65
local baseLaserRange = 700
local baseLoadTime = 30

local Drone = {
  name = "Drone",
  class = "Other",
  model = "Drone",
  description = "Small unmanned ships of the enemy which are when weak when encountered alone, but are strong in numbers.",
  radius = 50,
  radarTrace = "radar_fighter.png", -- @TODO
  hull = fighterHull / 3,
  shields = 0,
  speed = baseSpeed * 1.5,
  maneuver = baseManeuver * 1.5,
  acceleration = baseAcceleration,
  energy = baseEnergy,
  ai = "fighter",
  beams = {
    {
      direction = 0,
      arc = 60,
      range = baseLaserRange * 1.1,
      damage = 3,
      cycleTime = 3 / baseLaserDps,
    },
    {
      direction = 0,
      arc = 60,
      range = baseLaserRange * 1.2,
      damage = 3,
      cycleTime = 3 / baseLaserDps,
    },
  },
  hvli = false,
  homing = false,
  mine = false,
  emp = false,
  nuke = false,
}

local Falcon = {
  name = "Falcon",
  class = "Fighter",
  description = "The enemy interceptor ship class. With it's speed, it preys on slower, weaker ships.\n\nOnly a few of the academy ships are faster than them. Avoid engagement.",
  model = "Stinger",
  danger = 1,
  radius = 60,
  danger = 1,
  radarTrace = "radar_fighter.png",
  hull = fighterHull * 0.8,
  speed = baseSpeed * 2,
  maneuver = baseManeuver * 1.6,
  acceleration = baseAcceleration * 1.4,
  energy = baseEnergy,
  ai = "fighter",
  beams = {
    {
      direction = 0,
      arc = 60,
      range = baseLaserRange * 1.5,
      damage = 9,
      cycleTime = 9 / baseLaserDps,
    },
    {
      direction = -180,
      arc = 40,
      range = baseLaserRange,
      damage = 3,
      cycleTime = 3 / baseLaserDps,
    },
  },
  tubes = {
    {
      type = "hvli",
      direction = 0,
      loadTime = baseLoadTime * 0.6,
      size = "small",
    }
  },
  hvli = true,
  homing = false,
  mine = false,
  emp = false,
  nuke = false,
}
local Owl = {
  name = "Owl",
  class = "Fighter",
  model = "Owl",
  danger = 1.5,
  radius = 80,
  description = "The enemy support ship class. These ships limit the range of operation of star fighters by placing Warp Jammers.",
  radarTrace = "radar_cruiser.png",
  hull = fighterHull * 0.8,
  speed = baseSpeed * 1.2,
  maneuver = baseManeuver * 0.8,
  acceleration = baseAcceleration,
  energy = baseEnergy,
  ai = "fighter",
  jammers = 2,
  beams = {
    {
      direction = 0,
      arc = 100,
      range = baseLaserRange * 1.4,
      damage = 3 * 2,
      cycleTime = 3 / baseLaserDps,
    },
  },
  tubes = {
    {
      direction = 0,
      loadTime = baseLoadTime,
      size = "small",
    }
  },
  hvli = false,
  homing = true,
  mine = false,
  emp = false,
  nuke = false,
}
local Eagle = {
  name = "Eagle",
  class = "Fighter",
  model = "Eagle",
  radius = 80,
  danger = 1.5,
  description = "The dog fighter of the enemy fleet equipped with heavy lasers.\n\nEngage from a distance and avoid combat within beam range.",
  radarTrace = "radar_striker.png",
  hull = fighterHull * 0.8,
  speed = baseSpeed * 1.2,
  maneuver = baseManeuver * 1.2,
  acceleration = baseAcceleration * 1.2,
  energy = baseEnergy,
  beams = {
    {
      direction = -20,
      arc = 90,
      range = baseLaserRange * 1.2,
      damage = 3,
      cycleTime = 3 / baseLaserDps,
    },
    {
      direction = 20,
      arc = 90,
      range = baseLaserRange * 1.2,
      damage = 3,
      cycleTime = 3 / baseLaserDps,
    }
  },
  tubes = {
    {
      direction = 0,
      loadTime = baseLoadTime,
      size = "small",
    }
  },
  hvli = false,
  homing = true,
  mine = false,
  emp = false,
  nuke = false,
}

local Rhino = {
  name = "Rhino",
  class = "Corvette",
  model = "Perisher",
  danger = 3,
  radius = 150,
  description = "Rhinos are the heavily armored ship class. They avoid combat with star fighters and focus their attack on nearby stations, causing significant damage in a short time frame.\n\nEngage and destroy upon sight.",
  radarTrace = "radar_ktlitan_destroyer.png",
  hull = corvetteHull * 1.5,
  shields = baseShields * 0.5,
  speed = baseSpeed * 0.7,
  maneuver = baseManeuver * 0.5,
  acceleration = baseAcceleration * 0.5,
  energy = baseEnergy,
  ai = "determined",
  tubes = {
    {
      direction = -60,
      loadTime = baseLoadTime * 0.8,
    },
    {
      direction = 60,
      loadTime = baseLoadTime * 0.8,
    },
    {
      direction = -90,
      loadTime = baseLoadTime * 0.8,
    },
    {
      direction = 90,
      loadTime = baseLoadTime * 0.8,
    },
    {
      direction = -120,
      loadTime = baseLoadTime * 0.8,
    },
    {
      direction = 120,
      loadTime = baseLoadTime * 0.8,
    },
  },
  hvli = false,
  homing = true,
  mine = false,
  emp = false,
  nuke = false,
}

local Boomalope = {
  name = "Boomalope",
  class = "Corvette",
  model = "Boomalope",
  danger = 3,
  radius = 150,
  description = "A kamakize bomber ship. The Boomalope will recklessly charges its enemies with nukes and detonate upon reaching it's target.\n\nEngage from a distance as blast radius upon it's destruction will damage all nearby ships and structures. Their recklessness and blast radius can also used to your advantage.",
  radarTrace = "radar_battleship.png",
  hull = corvetteHull,
  shields = baseShields * 1.5,
  speed = baseSpeed * 0.7,
  maneuver = baseManeuver * 0.2,
  acceleration = baseAcceleration * 0.2,
  energy = baseEnergy,
  explodes = {
    radius = 1000,
    maxDamage = 160,
    minDamage = 30,
  },
  beams = {
    {
      direction = 0,
      arc = 40,
      range = baseLaserRange * 1.5,
      damage = 3,
      cycleTime = 6 / baseLaserDps,
    }
  },
  tubes = {
    {
      direction = -60,
      loadTime = baseLoadTime,
      type = "nuke",
      size = "small",
    },
    {
      direction = 60,
      loadTime = baseLoadTime,
      type = "nuke",
      size = "small",
    },
  },
  hvli = false,
  homing = false,
  mine = false,
  emp = false,
  nuke = true,
}

local Croco = {
  name = "Croco",
  class = "Corvette",
  model = "Croco",
  danger = 4,
  radius = 180,
  description = "The Croco is a support ship of the enemy that repairs the hull of nearby enemy. It is only lightly weaponized.\n\nFortunately our enemies did not ratify the Geneva Conventions - so go ahead, and destroy these ships, or they might turn out problematic when they bunch with other ships.",
  radarTrace = "radar_crocodile.png",
  hull = corvetteHull * 0.8,
  speed = baseSpeed * 0.8,
  maneuver = baseManeuver * 0.8,
  acceleration = baseAcceleration * 0.4,
  energy = baseEnergy,
  repair = {
    radius = 1500,
    rate = fighterHull / 600,
  },
  beams = {
    {
      direction = 0,
      arc = 220,
      range = baseLaserRange * 1.2,
      damage = 6,
      cycleTime = 6 / baseLaserDps,
    }
  },
  hvli = false,
  homing = false,
  mine = false,
  emp = false,
  nuke = false,
}

local Lion = {
  name = "Lion",
  class = "Corvette",
  model = "Lion",
  danger = 4,
  radius = 100,
  description = "A fighter corvette of the enemy. Even our hardy fighter ships can't stand to long in its laser range.\n\nWe advise team tactics to take it out as the weak points of its defense are on its sides and backs.",
  radarTrace = "radar_ktlitan_drone.png",
  hull = corvetteHull,
  speed = baseSpeed ,
  maneuver = baseManeuver * 0.6,
  acceleration = baseAcceleration,
  energy = baseEnergy,
  beams = {
    {
      direction = 0,
      arc = 60,
      range = baseLaserRange * 2,
      damage = 6,
      cycleTime = 6 / baseLaserDps,
    },
    {
      direction = -30,
      arc = 80,
      range = baseLaserRange * 1.5,
      damage = 6 * 1.2,
      cycleTime = 6 / baseLaserDps,
    },
    {
      direction = 30,
      arc = 80,
      range = baseLaserRange * 1.5,
      damage = 6 * 1.2,
      cycleTime = 6 / baseLaserDps,
    },
    {
      direction = -120,
      arc = 40,
      range = baseLaserRange * 1.1,
      damage = 3 * 1.2,
      cycleTime = 6 / baseLaserDps,
    },
    {
      direction = 120,
      arc = 40,
      range = baseLaserRange * 1.1,
      damage = 3 * 1.2,
      cycleTime = 6 / baseLaserDps,
    },
  },
  tubes = {
    {
      type = "homing",
      direction = 0,
      loadTime = baseLoadTime,
    }
  },
  hvli = false,
  homing = true,
  mine = false,
  emp = false,
  nuke = false,
}

local Porcupine = {
  name = "Porcupine",
  class = "Corvette",
  model = "Porcupine",
  danger = 3.5,
  radius = 150,
  description = "You could call it a missile corvette, but our pilots gave it the nickname \"Porcupine\" because of its habit to shoot HVLIs in all directions.\n\nIf you can't dodge its attacks, come close. HVLIs don't do as much damage on short range.",
  radarTrace = "radar_porcupine.png",
  hull = corvetteHull * 1.1,
  shields = baseShields * 1.5,
  speed = baseSpeed * 1.2,
  -- scout should outmaneuver them
  maneuver = baseManeuver * 0.4,
  acceleration = baseAcceleration * 0.6,
  energy = baseEnergy,
  tubes = {
    {
      type = "hvli",
      direction = 0,
      loadTime = baseLoadTime * 0.3,
      size = "small",
    },
    {
      type = "hvli",
      direction = -40,
      loadTime = baseLoadTime * 0.3,
      size = "small",
    },
    {
      type = "hvli",
      direction = 40,
      loadTime = baseLoadTime * 0.3,
      size = "small",
    },
    {
      type = "hvli",
      direction = -80,
      loadTime = baseLoadTime * 0.3,
      size = "small",
    },
    {
      type = "hvli",
      direction = 80,
      loadTime = baseLoadTime * 0.3,
      size = "small",
    },
  },
  hvli = true,
  homing = false,
  mine = false,
  emp = false,
  nuke = false,
}

local Shark = {
  name = "Shark",
  class = "Dreadnought",
  model = "Shark",
  danger = 10,
  radius = 300,
  description = "The Shark is a predator in its own ways. It has amazingly strong lasers at the front, but is weaker at the rear.\n\nWe advise team tactics and avoiding its laser range to take it down.",
  radarTrace = "radar_dread.png", -- @TODO
  hull = dreadnoughtHull,
  shields = {baseShields, baseShields},
  speed = baseSpeed ,
  maneuver = baseManeuver * 0.3,
  acceleration = baseAcceleration,
  energy = baseEnergy,
  beams = {
    {
      direction = -10,
      arc = 60,
      range = baseLaserRange * 1.3,
      damage = 12,
      cycleTime = 3,
    },
    {
      direction = 10,
      arc = 60,
      range = baseLaserRange * 1.3,
      damage = 12,
      cycleTime = 3,
    },
    {
      direction = -40,
      arc = 120,
      range = baseLaserRange * 1.2,
      damage = 3,
      cycleTime = 6,
    },
    {
      direction = 40,
      arc = 120,
      range = baseLaserRange * 1.2,
      damage = 3,
      cycleTime = 6,
    },
  },
  tubes = {
    {
      type = "homing",
      direction = 0,
      loadTime = baseLoadTime * 0.6,
    }
  },
  hvli = false,
  homing = true,
  mine = false,
  emp = false,
  nuke = false,
}

local Kraken = {
  name = "Kraken",
  class = "Dreadnought",
  model = "Kraken",
  description = "The Kraken is flying fortress. We could only make out a few small weak points in its defense.\n\nWe advise engaging it only in a coordinated attack.",
  danger = 12,
  radius = 300,
  radarTrace = "radar_blockade.png",
  hull = dreadnoughtHull * 0.8,
  shields = baseShields,
  speed = baseSpeed / 2,
  maneuver = baseManeuver * 0.2,
  acceleration = baseAcceleration,
  energy = baseEnergy,
  beams = {
    {
      direction = -30,
      arc = 60,
      range = baseLaserRange * 3,
      damage = 9,
      cycleTime = 6,
    },
    {
      direction = 30,
      arc = 60,
      range = baseLaserRange * 3,
      damage = 9,
      cycleTime = 6,
    },
    {
      direction = -90,
      arc = 60,
      range = baseLaserRange * 3,
      damage = 9,
      cycleTime = 6,
    },
    {
      direction = 90,
      arc = 60,
      range = baseLaserRange * 3,
      damage = 9,
      cycleTime = 6,
    },
    {
      direction = -150,
      arc = 60,
      range = baseLaserRange * 3,
      damage = 9,
      cycleTime = 6,
    },
    {
      direction = 150,
      arc = 60,
      range = baseLaserRange * 3,
      damage = 9,
      cycleTime = 6,
    },
  },
  hvli = false,
  homing = false,
  mine = false,
  emp = false,
  nuke = false,
}


local Tuna = {
  name = "Tuna",
  class = "Dreadnought",
  model = "Tuna",
  description = "The Tuna is the enemies carrier. To compensate for its inferior fire power it spawns new drones regularly to protect it. If you leave it unattended its drones could become a problem for you.",
  danger = 11,
  radius = 300,
  radarTrace = "radar_transport.png", -- @TODO
  hull = dreadnoughtHull * 0.5,
  shields = baseShields,
  speed = baseSpeed * 0.6,
  maneuver = baseManeuver * 0.5,
  acceleration = baseAcceleration,
  energy = baseEnergy,
  beams = {
    {
      direction = -60,
      arc = 150,
      range = baseLaserRange * 1.2,
      damage = 9,
      cycleTime = 6,
    },
    {
      direction = 60,
      arc = 150,
      range = baseLaserRange * 1.2,
      damage = 9,
      cycleTime = 6,
    },
  },
  escort = {
    template = Drone,
    max = 5,
    interval = 60,
  },
  hvli = false,
  homing = false,
  mine = false,
  emp = false,
  nuke = false,
}

_G.EnemyShipTemplates = {
  Drone,
  -- Fighter
  Falcon,
  Eagle,
  Owl,
  -- Corvette
  Rhino,
  Boomalope,
  Croco,
  Porcupine,
  Lion,
  -- Dreadnought
  Shark,
  Kraken,
  Tuna,
}
setmetatable(EnemyShipTemplates, {
  __index = {
    getByName = function(self, name)
      for _, config in pairs(self) do
        if config.name == name then return config end
      end
      error("Enemy ship with name " .. name .. " does not exist", 2)
    end,
    getByClass = function(self, class)
      local result = {}
      for _, config in pairs(self) do
        if config.class == class then
          table.insert(result, config)
        end
      end
      if #result == 0 then
        error("No enemy ships with class " .. class .. " exist")
      end
      return result
    end,
  }
})

for _, config in pairs(EnemyShipTemplates) do
  config.beams = config.beams or {}
  config.tubes = config.tubes or {}

  -- @TODO: improve
  config.dangerRating = function()
    return config.danger
    --return config:statHitPoints() * (1 + config:getShieldRechargePerSecond() / 150 * 60) / 100
  end

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
    return config:bareLaserDamagePerMinute() + config:bareHomingDamagePerMinute() + config:hvliDamageAtBeamRangePerMinute() + config:bareMineDamagePerMinute() + config:bareNukeDamagePerMinute()
  end
  config.damageAgainstDreadnoughts = function()
    return config:bareLaserDamagePerMinute() / 2 + config:bareHomingDamagePerMinute() + config:bareHvliDamagePerMinute() + config:bareMineDamagePerMinute() / 2 + config:bareNukeDamagePerMinute()
  end

  config.statHitPoints = function()
    local totalHitPoints = config.hull

    if type(config.shields) == "table" then
      totalHitPoints = totalHitPoints + config.shields[1]
      -- a second shield might not be as helpful as a total shield increase of the same value
      totalHitPoints = totalHitPoints + config.shields[2] / 2
    elseif type(config.shields) == "number" then
      totalHitPoints = totalHitPoints + config.shields
    end

    return totalHitPoints
  end
  config.getShieldRechargePerSecond = function()
    local rps = 0
    if type(config.shields) == "table" then
      rps = rps + 0.3 * 1.5
    elseif config.shields ~= nil then
      rps = rps + 0.3
    end
    if config.repair then
      rps = rps + config.repair.rate
    end
    if config.escort then
      rps = rps + EnemyShipTemplates:getByName(config.escort.template:statHitPoints()) / config.escort.interval
    end

    return rps
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

  -- seconds until all homings and hvlis are fired
  config.timeToEmptyHoming = function()
    local nrTubes = 0
    local totalLoadTime = 0
    for _, tube in pairs(config.tubes) do
      if tube.type == nil then
        nrTubes = nrTubes + 1
        totalLoadTime = totalLoadTime + tube.loadTime
      end
    end

    if nrTubes == 0 then
      return nil
    end
    if config.homing + config.hvli == 0 then
      return nil
    end

    local avg = totalLoadTime / nrTubes

    return avg * (config.homing + config.hvli) / nrTubes
  end
  -- seconds until all mines are set
  config.timeToEmptyMine = function()
    local nrTubes = 0
    local totalLoadTime = 0
    for _, tube in pairs(config.tubes) do
      if tube.type == "mine" then
        nrTubes = nrTubes + 1
        totalLoadTime = totalLoadTime + tube.loadTime
      end
    end

    if nrTubes == 0 then
      return nil
    end
    if config.mine == 0 then
      return nil
    end

    local avg = totalLoadTime / nrTubes

    return avg * config.mine / nrTubes
  end
  -- seconds until all nukes are set
  config.timeToEmptyNuke = function()
    local nrTubes = 0
    local totalLoadTime = 0
    for _, tube in pairs(config.tubes) do
      if tube.type == "nuke" then
        nrTubes = nrTubes + 1
        totalLoadTime = totalLoadTime + tube.loadTime
      end
    end

    if nrTubes == 0 then
      return nil
    end
    if config.nuke == 0 then
      return nil
    end

    local avg = totalLoadTime / nrTubes

    return avg * config.nuke / nrTubes
  end

  config.missileHitChance = function(_, targetSize)
    targetSize = targetSize or "normal"
    local tubeSize = config.tubeSize or "normal"

    local hitChance
    if tubeSize == "large" and targetSize == "small" then
      hitChance = 0.2
    elseif (tubeSize == "large" and targetSize == "normal") or (tubeSize == "normal" and targetSize == "small") then
      hitChance = 0.3
    elseif tubeSize == targetSize then
      hitChance = 0.4
    elseif targetSize == "normal" and tubeSize == "small" then
      hitChance = 0.5
    end

    return hitChance
  end

  -- fast moving targets
  config.statDamageAgainstFighters = function()
    local totalDps = 0
    if config.speed < 80 then
      totalDps = totalDps + config:statLaserDps() * 0.8
    else
      totalDps = totalDps + config:statLaserDps()
    end

    totalDps = totalDps + config:statMissileDps("small")

    return totalDps
  end

  config.statMissileDps = function(_, targetSize)
    -- enemies have unlimited missiles
    local homingDamage = 35

    local totalDamagePerSecond = 0

    for _, tube in pairs(config.tubes) do
      if tube.type == nil then
        totalDamagePerSecond = totalDamagePerSecond + homingDamage / tube.loadTime
      end
    end

    if config.tubeSize == "small" then
      totalDamagePerSecond = totalDamagePerSecond / 2
    elseif config.tubeSize == "large" then
      totalDamagePerSecond = totalDamagePerSecond * 2
    end

    return totalDamagePerSecond * config:missileHitChance(targetSize)
  end
  config.statNukeDps = function()
    -- enemies have unlimited nukes
    local nukeDamage = 160 * 1.5

    local totalDamagePerSecond = 0

    for _, tube in pairs(config.tubes) do
      if tube.type == "nuke" then
        totalDamagePerSecond = totalDamagePerSecond + nukeDamage / tube.loadTime
      end
    end

    local hitChance
    if config.tubeSize == "small" then
      totalDamagePerSecond = totalDamagePerSecond / 2
      hitChance = 0.7
    else
      hitChance = 0.5
    end

    return totalDamagePerSecond * hitChance
  end
end
