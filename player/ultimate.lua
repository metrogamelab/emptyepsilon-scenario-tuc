--- Let the players trigger their ultimate once per stage
---
local buttonId = "ultimate"

local hideUltimateButton = function(playerInfo)
    if playerInfo:isSpawned() then
        local player = playerInfo:getShipObject()
        player:removeMenuItem("helms", buttonId, 0)
    end
end

local drawUltimateButton = function(playerInfo)
    if playerInfo:hasUltimate() and playerInfo:isSpawned() then
        local player = playerInfo:getShipObject()
        player:addMenuItem("helms", buttonId, Menu:newItem("Trigger Ultimate", function()
            if My.Stage.isRunning() then
                playerInfo:disableUltimate()
                player:removeMenuItem("helms", buttonId, 0)
            end
            playerInfo:triggerUltimate()
        end, 0))
    end
end

My.EventHandler:register("onStageStart", function()
    for _, playerInfo in pairs(My.Players) do
        playerInfo:enableUltimate()
        drawUltimateButton(playerInfo)
    end
end)
My.EventHandler:register("onStageFinished", function()
    for _, playerInfo in pairs(My.Players) do
        playerInfo:enableUltimate()
        drawUltimateButton(playerInfo)
    end
end)

My.EventHandler:register("onPlayerTemplateSet", function(_, playerInfo)
    if playerInfo:hasUltimate() and playerInfo:isUltimateAvailable() then
        drawUltimateButton(playerInfo)
    else
        hideUltimateButton(playerInfo)
    end
end)