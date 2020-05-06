weapons = ScienceDatabase():setName('Weapons')
item = weapons:addEntry('Homing missile')
item:addKeyValue('Range', '5.4u')
item:addKeyValue('Damage', '35')
item:setLongDescription([[This target-seeking missile is the workhorse of many space combat arsenals. It's compact enough to be fitted on frigates, and packs enough punch to be used on larger ships, though usually in more than a single missile tube.]])

item = weapons:addEntry('Nuke')
item:addKeyValue('Range', '5.4u')
item:addKeyValue('Blast radius', '1u')
item:addKeyValue('Damage at center', '160')
item:addKeyValue('Damage at edge', '30')
item:setLongDescription([[A nuclear missile is similar to a homing missile in that it can seek a target, but it moves and turns more slowly and explodes a greatly increased payload. Its nuclear explosion spans 1U of space and can take out multiple ships in a single shot.

Some captains oppose the use of nuclear weapons because their large explosions can lead to 'fragging', or unintentional friendly fire. Shields should protect crews from harmful radiation, but because these weapons are often used in the thick of battle, there's no way of knowing if hull plating or shields can provide enough protection.]])

item = weapons:addEntry('Mine')
item:addKeyValue('Drop distance', '1.2u')
item:addKeyValue('Trigger distance', '0.6u')
item:addKeyValue('Blast radius', '1u')
item:addKeyValue('Damage at center', '160')
item:addKeyValue('Damage at edge', '30')
item:setLongDescription([[Mines are often placed in defensive perimeters around stations. There are also old minefields scattered around the galaxy from older wars.

Some fearless captains use mines as offensive weapons, but their delayed detonation and blast radius make this use risky at best.]])

item = weapons:addEntry('EMP')
item:addKeyValue('Range', '5.4u')
item:addKeyValue('Blast radius', '1u')
item:addKeyValue('Damage at center', '160')
item:addKeyValue('Damage at edge', '30')
item:setLongDescription([[The electromagnetic pulse missile (EMP) reproduces the disruptive effects of a nuclear explosion, but without the destructive properties. This causes it to only affect shields within its blast radius, leaving their hulls intact. The EMP missile is also smaller and easier to store than heavy nukes. Many captains (and pirates) prefer EMPs over nukes for these reasons, and use them to knock out targets' shields before closing to disable them with focused beam fire.]])

item = weapons:addEntry('HVLI')
item:addKeyValue('Range', '5.4u')
item:addKeyValue('Damage', '7 each, 35 total')
item:addKeyValue('Burst', '5')
item:setLongDescription([[A high-velocity lead impactor (HVLI) fires a simple slug of lead at a high velocity. This weapon is usually found in simpler ships since it does not require guidance computers. This also means its projectiles fly in a straight line from its tube and can't pursue a target.

Each shot from an HVLI fires a burst of 5 projectiles, which increases the chance to hit but requires precision aiming to be effective.]])

require("config/players.lua")
require("config/updates.lua")
require("config/skills.lua")

local classDescriptions = {
    Scout = "The scouts are light and agile fighters that prefer to approach from a distance. They are fast, so they are fit to do reconnaissance missions or quickly support weak points in our defense.\n\nThey are the only class that can use scan probes and come with combat maneuver thrusters by default.",
    Fighter = "Fighters are the backbone of all of our fleets. They are versatile and not bad at everything - but they are not exceptional at anything either. They carry the strongest shields and engage enemies up close with their lasers and mines.\n\nFighters are the only ships with access to mines.",
    Bomber = "There is nothing better than a Bomber when facing enemy Corvettes or Dreadnoughts as they can deal heavy damage from a distance with their missiles. On the downside they are rather slow and not particularly good against fighters, so they should be accompanied by ships that can deal with those.\n\nBombers are the only class that can utilize nukes.",
}
local classes = ScienceDatabase():setName('Classes')
for _, class in pairs({"Scout", "Fighter", "Bomber"}) do
    local item = classes:addEntry(class)
    if classDescriptions[class] then
        item:setLongDescription(classDescriptions[class])
    end
    for _, ship in pairs(PlayerShipTemplates) do
        if ship.class == class and ship.subclass == nil then
            item:addKeyValue("Initial Ship", ship.name)
        end
    end
    local i = 1
    for _, ship in pairs(PlayerShipTemplates) do
        if ship.class == class and ship.subclass ~= nil then
            item:addKeyValue("Specialization " .. i, ship.name)
            i = i + 1
        end
    end

    local i = 1
    for _, skill in pairs(PlayerShipSkills) do
        if skill.requiredClass == class then
            item:addKeyValue("Skill Option " .. i, skill.name)
            i = i + 1
        end
    end

    local i = 1
    for _, update in pairs(PlayerShipUpdates) do
        if update.requiredClass == class then
            item:addKeyValue("Exclusive Update " .. i, update.name)
            i = i + 1
        end
    end
end



local updates = ScienceDatabase():setName('Updates')
updates:setLongDescription("Your ship gets updates after Stage 1 and 4.\n\nMost of them are available for all ship classes, but some have limitations. If you select your specialization later on, your upgrade will also be applied on your new ship.")
for _, update in pairs(PlayerShipUpdates) do
    local item = updates:addEntry(update.name)
    if update.description then
        item:setLongDescription(update.description)
    end
    local available = "all"
    if update.requiredClass then
        available = update.requiredClass
    end
    item:addKeyValue("available to", available)
end


local skills = ScienceDatabase():setName('Skills')
skills:setLongDescription("You acquire a skill for your ship after Stage 2.\n\nEach of them has a passive ability and an ultimate, that you can activate once per Stage.\n\nSkills are class specific and you can only choose one. So select your class wisely, if you want to acquire a specific skill.")
for _, skill in pairs(_G.PlayerShipSkills) do
    local item = skills:addEntry(skill.name)
    if skill.description then
        item:setLongDescription(skill.description)
    end
    item:addKeyValue("Class", skill.requiredClass)
    for _, entry in pairs(skill.database or {}) do
        local key, value = table.unpack(entry)
        item:addKeyValue(key, value)
    end
end
