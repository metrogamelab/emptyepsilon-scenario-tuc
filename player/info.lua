local f = string.format

My = My or {}

-- holds information on the player ships aside from the SpaceObject.
My.PlayerInfo = function(idx, class, color)
    local id = Util.randomUuid()
    class = class or PlayerShipTemplates[1].class
    color = color or PlayerShipColors[1]
    local callSign = GameConfig.shipNames[idx] or ("Player" .. idx)

    local shipObject
    local update1
    local update2
    local skill
    local ultimateAvailable = true
    local skillCronId = id .. "_skill"
    local subClass
    local energyRegeneration = 0

    return {
        getCallSign = function() return callSign end,
        getId = function() return id end,
        getClass = function() return class end,
        setClass = function(self, newClass)
            if newClass ~= class then
                class = newClass
                subClass = nil
                if update1 ~= nil and update1.requiredClass and update1.requiredClass ~= class then
                    update1 = nil
                end
                if update2 ~= nil and update2.requiredClass and update2.requiredClass ~= class then
                    update2 = nil
                end
                if skill ~= nil and skill.requiredClass and skill.requiredClass ~= class then
                    skill = nil
                end
                if self:isSpawned() then
                    self:reloadPlayerShip()
                end
            end
        end,
        hasSubClass = function() return subClass ~= nil end,
        getSubClass = function() return subClass end,
        setSubClass = function(self, newSubClass)
            if newSubClass ~= subClass then
                subClass = newSubClass
                if self:isSpawned() then
                    self:reloadPlayerShip()
                end
            end
        end,
        hasUpdate1 = function() return update1 ~= nil end,
        getUpdate1 = function() return update1 end,
        setUpdate1 = function(self, newUpdate1)
            if newUpdate1 ~= update1 then
                update1 = newUpdate1
                if self:isSpawned() then
                    self:reloadPlayerShip()
                end
            end
        end,
        hasUpdate2 = function() return update2 ~= nil end,
        getUpdate2 = function() return update2 end,
        setUpdate2 = function(self, newUpdate2)
            if newUpdate2 ~= update2 then
                update2 = newUpdate2
                if self:isSpawned() then
                    self:reloadPlayerShip()
                end
            end
        end,
        hasSkill = function() return skill ~= nil end,
        getSkill = function() return skill end,
        setSkill = function(self, newSkill)
            if newSkill ~= skill then
                skill = newSkill
                if self:isSpawned() then
                    self:reloadPlayerShip()
                end
            end
        end,
        hasUltimate = function()
            return skill ~= nil and skill.ultimate ~= nil
        end,
        isUltimateAvailable = function() return ultimateAvailable end,
        enableUltimate = function() ultimateAvailable = true end,
        disableUltimate = function() ultimateAvailable = false end,
        triggerUltimate = function(self)
            if self:hasUltimate() then
                skill:ultimate(self)
            end
        end,
        getColor = function() return color end,
        setColor = function(self, newColor)
            if newColor ~= color then
                color = newColor
                if self:isSpawned() then
                    self:reloadPlayerShip()
                end
            end
        end,
        reloadPlayerShip = function(self)
            if not self:isSpawned() then
                logWarning("not reloading ship, because it is not spawned")
                return
            end

            local templateName = subClass or class
            if color ~= PlayerShipColors[1] then
                templateName = templateName .. " " .. color
            end

            local config = self:getConfig()

            shipObject:setCallSign(callSign)
            shipObject:setFaction("Player")
            shipObject:setTemplate(templateName)
            shipObject:setMaxCoolant(99)
            shipObject:setAutoCoolant(true)
            shipObject:commandSetAutoRepair(true)
            shipObject:setMaxScanProbeCount(config.probes or 0)
            shipObject:setScanProbeCount(config.probes or 0)
            energyRegeneration = config.energyPs or 0

            for i, _ in pairs(config.beams) do
                shipObject:setBeamWeaponTexture(i-1, "beam_blue.png")
            end

            if update1 then
                update1:install(self)
            end
            if update2 then
                update2:install(self)
            end
            if skill then
                skill:install(self, skillCronId)
            else
                Cron.abort(skillCronId)
            end

            My.EventHandler:fire("onPlayerTemplateSet", self)

            return shipObject
        end,
        isSpawned = function() return isEePlayer(shipObject) and shipObject:isValid() end,
        spawnPlayerShip = function(self)
            if self:isSpawned() then
                logWarning("not spawning player, because it is already spawned")
                return
            end
            shipObject = PlayerSpaceship()
            Player:withMenu(shipObject)
            self:reloadPlayerShip()

            local y
            if idx % 2 == 0 then
                y = (idx/2) * 1000
            else
                y = (idx-1)/2 * -1000
            end
            shipObject:setPosition(-5000, y)


            My.EventHandler:fire("onPlayerSpawn", self)

            Cron.regular(function(cronId)
                if isEePlayer(shipObject) and not shipObject:isValid() then
                    My.EventHandler:fire("onPlayerDestruction", self)
                    shipObject = nil
                    Cron.abort(cronId)
                end
            end)

            return shipObject
        end,
        getShipObject = function(self) return shipObject end,
        getConfig = function(self) return PlayerShipTemplates:getByName(subClass or class) end,
        getAutoScannerRange = function(self)
            local config = self:getConfig()
            return config.scanner * config.autoScannerRange
        end,
        getEnergyRegenerationPerSecond = function()
            return energyRegeneration
        end,
        setEnergyRegenerationPerSecond = function(_, energyRegen)
            energyRegeneration = energyRegen
        end,
    }
end