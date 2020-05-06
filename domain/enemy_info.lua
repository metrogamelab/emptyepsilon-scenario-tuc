My = My or {}

My.EnemyInfo = function(name)
    local config = EnemyShipTemplates:getByName(name)
    local shipObject

    return {
        getName = function() return name end,
        getConfig = function() return config end,
        isSpawned = function() return isEeShip(shipObject) and shipObject:isValid() end,
        spawnEnemyShip = function(self)
            if self:isSpawned() then
                logWarning("not spawning enemy, because it is already spawned")
                return
            end

            shipObject = CpuShip():
            setTemplate(config.name):
            setFaction("Unknown"):
            setScanState("simple"):
            setSystemCoolant("maneuver", 0.5):
            setSystemCoolant("impulse", 0.5)

            for i, _ in pairs(config.beams) do
                shipObject:setBeamWeaponTexture(i-1, "beam_orange.png")
            end

            My.EventHandler:fire("onEnemySpawn", self)

            return shipObject
        end,
        getShipObject = function() return shipObject end,
    }

end