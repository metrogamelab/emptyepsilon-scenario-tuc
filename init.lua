_G.My = _G.My or {}

My.EventHandler = EventHandler:new({allowedEvents = {
    "onWorldCreation",
    "onStationSpawn",
    "onPlayerSpawn",
    "onPlayerTemplateSet",
    "onPlayerDestruction",
    "onEnemySpawn",
    "onEnemyDestruction",
    "onStageStart",
    "onStageFinished",
    "onWaveStart",
}, unique = false})

--My.Translator = Translator:new("en")
--My.Translator:useLocale("en")

local myPackages = {
--    "lang/en/init.lua",
    "config/players.lua",
    "config/enemies.lua",
    "config/skills.lua",
    "config/updates.lua",

--    "space_objects.lua",
    "domain/encounter.lua",
    "domain/enemy_info.lua",
    "enemy/auto_coolant.lua",
    "enemy/call_sign.lua",
    "enemy/escort.lua",
    "enemy/explodes.lua",
    "enemy/jammer.lua",
    "enemy/repair.lua",
    "player/alert.lua",
    "player/autoscanner.lua",
    "player/energy_regen.lua",
    "player/info.lua",
    "player/respawn.lua",
    "player/select.lua",
    "player/sync_waypoints.lua",
    "player/ultimate.lua",
    "station/docking.lua",
    "station/kill_count.lua",
    "wave/cleanup.lua",
    "wave/encounters.lua",
    "wave/ready_button.lua",
    "wave/stage.lua",
    "wave/stage_generator.lua",
    "world.lua",
    "world/players.lua",
    "world/stations.lua",
}

if package ~= nil and package.path ~= nil then
    local basePath = debug.getinfo(1).source
    if basePath:sub(1,1) == "@" then basePath = basePath:sub(2) end
    if basePath:sub(-8) == "init.lua" then basePath = basePath:sub(1, -9) end
    basePath = "./" .. basePath .. "/.."

    package.path = package.path .. ";" .. basePath .. "?.lua"

    for _, package in pairs(myPackages) do
        local name = package:match("^(.+).lua$")
        require(name)
    end
else
    -- within empty epsilon

    for _, package in pairs(myPackages) do
        require(package)
    end
end