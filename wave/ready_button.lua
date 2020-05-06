local onAllReady = nil

local isActive = false

local drawReadyButton
local hideReadyButton

local onChange = function()
    local numberOfReadyPlayers = 0
    local numberOfPlayers = Util.size(My.Players)
    for _, playerInfo in pairs(My.Players) do
        if playerInfo:isSpawned() and playerInfo.isReady == true then
            numberOfReadyPlayers = numberOfReadyPlayers + 1
        end
    end

    if numberOfReadyPlayers == numberOfPlayers then
        hideReadyButton()
        onAllReady()
    else
        drawReadyButton(numberOfReadyPlayers, numberOfPlayers)
    end
end

hideReadyButton = function()
    isActive = false
    for _, playerInfo in pairs(My.Players) do
        if playerInfo:isSpawned() then
            local ship = playerInfo:getShipObject()
            ship:removeMenuItem("helms", "ready")
        end
    end
end

drawReadyButton = function(readyPlayers, totalPlayers)
    for _, playerInfo in pairs(My.Players) do
        if playerInfo:isSpawned() then
            local ship = playerInfo:getShipObject()
            local label = string.format("Ready%s [%d/%d]", playerInfo.isReady and "!" or "?", readyPlayers, totalPlayers)

            local isItShown = true
            local currentStage = My.Stage.getCurrentStage()
            if currentStage >= 1 and not playerInfo:hasUpdate1() then
                isItShown = false
            end
            if currentStage >= 2 and not playerInfo:hasSkill() then
                isItShown = false
            end
            if currentStage >= 3 and not playerInfo:hasSubClass() then
                isItShown = false
            end
            if currentStage >= 4 and not playerInfo:hasUpdate2() then
                isItShown = false
            end

            if isItShown then
                ship:addMenuItem("helms", "ready", Menu:newItem(label, function()
                    playerInfo.isReady = not playerInfo.isReady
                    onChange()
                end, 999))
            end
        end
    end
end
local startReadyButton = function(onReady)
    onAllReady = onReady
    isActive = true

    for _, playerInfo in pairs(My.Players) do
        playerInfo.isReady = false
    end

    onChange()
end

My.EventHandler:register("onWorldCreation", function()
    startReadyButton(function()
        My.Stage:start()
    end)
end, 999)

My.EventHandler:register("onStageStart", function()
    -- not necessary, but just to be safe
    hideReadyButton()
end, 999)
My.EventHandler:register("onStageFinished", function()
    startReadyButton(function()
        My.Stage:start()
    end)
end, 999)
My.EventHandler:register("onPlayerSpawn", function(_, playerInfo)
    if isActive then
        onChange()
    end
end)
My.EventHandler:register("onPlayerTemplateSet", function(_, playerInfo)
    if isActive then
        onChange()
    end
end)