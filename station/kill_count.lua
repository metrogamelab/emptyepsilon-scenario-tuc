local killsByName = {}
local killsByClass = {}

My.EventHandler:register("onEnemyDestruction", function(_, enemyInfo)
    local name = enemyInfo:getConfig().name
    killsByName[name] = (killsByName[name] or 0) + 1
    local class = enemyInfo:getConfig().class
    killsByClass[class] = (killsByClass[class] or 0) + 1
end)

My.EventHandler:register("onWorldCreation", function()
    local station = My.World.hqStation
    station:addComms(Comms:newReply("Kill Count", function()
        local screen = Comms:newScreen()
        if Util.size(killsByName) == 0 then
            screen:addText("You and your crew have not killed anything yet.\n\n")
            screen:addText("Let your pilots prepare their ships and click the 'Ready' button when they are done.")
        else
            screen:addText("You and your crew have destroyed ships from these classes:\n")
            for name, count in pairs(killsByClass) do
                screen:addText(string.format("    %d * %s\n", count, name))
            end

            screen:addText("\nThis can be broken down to these ships:\n")
            for name, count in pairs(killsByName) do
                screen:addText(string.format("    %d * %s\n", count, name))
            end
        end
        screen:addReply(Comms:newReply("Back"))
        return screen
    end))
end, 999)