-- Name: The Unknown Conflict
-- Description: Listen up, Cadets! 
---     
--- The situation with The Unknown has escalated such that we need your help. It's time to take all that we've taught you and apply it in the field. 
---     
--- The Unknown have determined our Academy to be a threat to their primary objective and have targeted us for extermination. The Federation is enroute to assist us in our defense, but we need to hold off the Unknown long enough for them to arrive. Until then the only craft available to us are the star fighter class ships we have utilized in our training. 
---     
--- Good luck cadets! If we survive this, you will have earned your wings.
---     
--- This is a multiplayer scenario where everyone solo pilots a star fighter class ship. The default setting is for five players using three lanes. Use the variations to adapt it to a different player count.
---      
--- Please disable "Beam/Shield Frequencies" and "Per-System Damage".
-- Type: Mission
-- Variation[One]: One Player, One Lane
-- Variation[Two]: Two Players, One Lane
-- Variation[Three]: Three Players, Two Lanes
-- Variation[Four]: Four Players, Three Lanes
-- Variation[Five]: Five Players, Three Lanes
-- Variation[Six]: Six Players, Four Lanes
-- Variation[Seven]: Seven Players, Four Lanes

-- ----------------------------
--
-- GM: Configure your game here
--
-- ----------------------------

_G.LivelyEpsilonConfig = {
    useAnsi = true,
    logLevel = "DEBUG",
    logTime = true,
}

require "lively_epsilon/init.lua"

_G.GameConfig = {
    numberPlayers = 5,
    numberLanes = 3,
}

local storage = getScriptStorage()
if getScenarioVariation() == "One" then
    _G.GameConfig.numberPlayers = 1
    _G.GameConfig.numberLanes = 1
elseif getScenarioVariation() == "Two" then
    _G.GameConfig.numberPlayers = 2
    _G.GameConfig.numberLanes = 1
elseif getScenarioVariation() == "Three" then
    _G.GameConfig.numberPlayers = 3
    _G.GameConfig.numberLanes = 2
elseif getScenarioVariation() == "Four" then
    _G.GameConfig.numberPlayers = 4
    _G.GameConfig.numberLanes = 3
elseif getScenarioVariation() == "Five" then
    _G.GameConfig.numberPlayers = 5
    _G.GameConfig.numberLanes = 3
elseif getScenarioVariation() == "Six" then
    _G.GameConfig.numberPlayers = 6
    _G.GameConfig.numberLanes = 4
elseif getScenarioVariation() == "Seven" then
    _G.GameConfig.numberPlayers = 7
    _G.GameConfig.numberLanes = 4
else
    local nrPlayers = storage:get('tuc.number_players')
    if nrPlayers and tonumber(nrPlayers) then
        _G.GameConfig.numberPlayers = tonumber(nrPlayers)
    end
    local nrLanes = storage:get('tuc.number_lanes')
    if nrLanes and tonumber(nrLanes) then
        _G.GameConfig.numberLanes = tonumber(nrLanes)
    end
end

storage:set('tuc.number_players', tostring(_G.GameConfig.numberPlayers))
storage:set('tuc.number_lanes', tostring(_G.GameConfig.numberLanes))

_G.GameConfig = Util.mergeTables(_G.GameConfig, {
    -- players will respawn when they are killed, but the times get longer and longer
    -- how long the first respawn takes (seconds)
    respawnDelayInitial = 30,
    -- how much the respawn delay increases with each death (seconds)
    respawnDelayIncrease = 10,

    -- these are magical numbers. It determines how many and what enemies are spawned.
    -- the higher the value the more enemies will spawn. You will need to figure out with your crew what works for you.
    -- If the value is too low, stages tend to be too short that players don't even need to fly back to a station to
    -- restock. If it is too high stages take longer to finish
    -- 1 is the danger of a small scout. Your initial players ship should be around a 2.

    -- danger of the first stage
    initialDanger = 12 * _G.GameConfig.numberLanes,
    -- how much the danger increases each stage
    increaseDanger = 6 * _G.GameConfig.numberLanes,

    -- The damage settings are used to determine how soon the next wave of the attack should be sent in.
    -- The ideal balance that you want to achieve is to have a constant flow of enemies where there are always
    -- at least two waves active, but the players are not overrun by a wall of enemies
    -- Set the values higher if the players regularily "clear" the battlefield. Set it lower if ship waves
    -- start to ramp up too much. Set both values to 0 to disable the time-based spawn and only send the next wave
    -- when the whole current wave was defeated (this gives the players more time to react, for kids, etc)

    -- how much you expect each player can deal damage per minute
    initialDamage = 135,
    -- how much you expect the damage of each player to increase with each stage
    increaseDamage = 15,

    -- do your players prefer personalized ship names? Enter them here.
    shipNames = {
        "Rampage",
        "Joust",
        "Galaga",
        "Gauntlet",
        "Centipede",
        "Frogger",
        "Defender",
    },

    laneNames = {
        "Atari Way",
        "Coleco Channel",
        "Sega Lane",
        "Nes Warp",
    },

    stationNames = {
        "Academy",
        "Archive",
        "Dormitory",
    }
})

_G.My = {}

require "init.lua"

function init()
    My.EventHandler:fire("onWorldCreation")
end

function update(delta)
    Cron.tick(delta)
end
