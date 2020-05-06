My = My or {}

--- holds all fleet compositions that the player could encounter
My.Encounters = {}

-- fighters can occur in any composition
local fighterConfigs = EnemyShipTemplates:getByClass("Fighter")

local addAFighterAndCreateEncounter
addAFighterAndCreateEncounter = function(fighters, maxShips)
    maxShips = maxShips or 5
    for _, fighter in pairs(fighterConfigs) do
        local theFighters = Util.deepCopy(fighters) or {}
        table.insert(theFighters, fighter)
        table.insert(My.Encounters, My.Encounter(table.unpack(theFighters)))
        if theFighters[maxShips] == nil then
            addAFighterAndCreateEncounter(theFighters, maxShips)
        end
    end
end

addAFighterAndCreateEncounter(nil, 3)

-- Rhinos do not mix, because of their special order
local Rhino = EnemyShipTemplates:getByName("Rhino")
table.insert(My.Encounters, My.Encounter(Rhino))
table.insert(My.Encounters, My.Encounter(Rhino, Rhino))
table.insert(My.Encounters, My.Encounter(Rhino, Rhino, Rhino))

local Crocodile = EnemyShipTemplates:getByName("Croco")
local Eagle = EnemyShipTemplates:getByName("Eagle")
local Falcon = EnemyShipTemplates:getByName("Falcon")
local Boomalope = EnemyShipTemplates:getByName("Boomalope")
local Porcupine = EnemyShipTemplates:getByName("Porcupine")
local Lion = EnemyShipTemplates:getByName("Lion")
local Shark = EnemyShipTemplates:getByName("Shark")
local Kraken = EnemyShipTemplates:getByName("Kraken")
local Tuna = EnemyShipTemplates:getByName("Tuna")
table.insert(My.Encounters, My.Encounter(Crocodile, Eagle))
addAFighterAndCreateEncounter({Crocodile, Eagle}, 3)
table.insert(My.Encounters, My.Encounter(Crocodile, Boomalope))
addAFighterAndCreateEncounter({Crocodile, Boomalope}, 3)
table.insert(My.Encounters, My.Encounter(Crocodile, Porcupine))
addAFighterAndCreateEncounter({Crocodile, Porcupine}, 3)

table.insert(My.Encounters, My.Encounter(Boomalope))
table.insert(My.Encounters, My.Encounter(Boomalope, Boomalope))
table.insert(My.Encounters, My.Encounter(Boomalope, Boomalope, Boomalope))
table.insert(My.Encounters, My.Encounter(Porcupine))
table.insert(My.Encounters, My.Encounter(Porcupine, Porcupine))
table.insert(My.Encounters, My.Encounter(Porcupine, Porcupine, Porcupine))
table.insert(My.Encounters, My.Encounter(Lion))
table.insert(My.Encounters, My.Encounter(Lion, Lion))
table.insert(My.Encounters, My.Encounter(Lion, Lion, Lion))
table.insert(My.Encounters, My.Encounter(Lion, Eagle))
table.insert(My.Encounters, My.Encounter(Lion, Lion, Falcon))
table.insert(My.Encounters, My.Encounter(Lion, Lion, Lion))

table.insert(My.Encounters, My.Encounter(Shark))
table.insert(My.Encounters, My.Encounter(Kraken))
table.insert(My.Encounters, My.Encounter(Tuna))

-- remove duplicates
local knownEncounters = {}
for i=Util.size(My.Encounters),1,-1 do
    local encounter = My.Encounters[i]
    local id = string.format("%s", encounter)
    if knownEncounters[id] ~= nil then
        table.remove(My.Encounters, i)
    else
        knownEncounters[id] = true
    end
end

--for _, encounter in pairs(My.Encounters) do
--    logDebug(string.format("%s", encounter))
--end
--
--
local count = {}

for _, encounter in pairs(My.Encounters) do
    for _, config in pairs(encounter:getEnemyConfigs()) do
        count[config.class] = count[config.class] or {}
        count[config.class][config.name] = (count[config.class][config.name] or 0) + 1
    end
end

for class, names in pairs(count) do
    print(class)
    for name, count in pairs(names) do
        print(string.format("%20s: %d", name, count))
    end
end