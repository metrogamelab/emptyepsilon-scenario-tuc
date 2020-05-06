--- The selection dialog for class, color, updates, etc

local classButtonId = "select_class"
local colorButtonId = "select_color"
local update1ButtonId = "select_update1"
local skillButtonId = "select_skill"
local specializationButtonId = "select_subclass"
local update2ButtonId = "select_update2"

local showUpgradeButtonsForPlayer = function(playerInfo)
    local player = playerInfo:getShipObject()

    local classSelection
    local colorSelection
    local update1Selection
    local skillSelection
    local specializationSelection
    local update2Selection
    local updateButtons

    classSelection = function()
        local menu = Menu:new()

        for i, config in ipairs(PlayerShipTemplates) do
            if config.subclass == nil then
                local label = config.name
                if config.class == playerInfo:getClass() then
                    label = "> " .. label .. " <"
                end
                menu:addItem(Menu:newItem(label, function()
                    playerInfo:setClass(config.class)
                    updateButtons()
                    return classSelection()
                end, i))
            end
        end
        return menu
    end

    colorSelection = function()
        local menu = Menu:new()

        for i, color in ipairs(PlayerShipColors) do
            local label = color
            if playerInfo:getColor() == color then
                label = "> " .. label .. " <"
            end
            menu:addItem(Menu:newItem(label, function()
                playerInfo:setColor(color)
                updateButtons()
                return colorSelection()
            end, i))
        end
        return menu
    end

    update1Selection = function()
        local menu = Menu:new()

        for i, update in ipairs(PlayerShipUpdates) do
            if update ~= playerInfo:getUpdate2() and (not update.requiredClass or update.requiredClass == playerInfo:getClass()) then
                local label = update.name
                if update == playerInfo:getUpdate1() then
                    label = "> " .. label .. " <"
                end
                menu:addItem(Menu:newItem(label, function()
                    playerInfo:setUpdate1(update)
                    updateButtons()
                    return update1Selection()
                end, i))
            end
        end
        return menu
    end

    skillSelection = function()
        local menu = Menu:new()

        for i, skill in ipairs(PlayerShipSkills) do
            if skill.requiredClass == playerInfo:getClass() then
                local label = skill.name
                if skill == playerInfo:getSkill() then
                    label = "> " .. label .. " <"
                end
                menu:addItem(Menu:newItem(label, function()
                    playerInfo:setSkill(skill)
                    updateButtons()
                    return skillSelection()
                end, i))
            end
        end
        return menu
    end

    specializationSelection = function()
        local menu = Menu:new()

        for i, config in ipairs(PlayerShipTemplates) do
            if config.subclass ~= nil and config.class == playerInfo:getClass() then
                local label = config.name
                if playerInfo:getSubClass() == config.subclass then
                    label = "> " .. label .. " <"
                end
                menu:addItem(Menu:newItem(label, function()
                    playerInfo:setSubClass(config.subclass)
                    updateButtons()
                    return specializationSelection()
                end, i))
            end
        end
        return menu
    end

    update2Selection = function()
        local menu = Menu:new()

        for i, update in ipairs(PlayerShipUpdates) do
            if update ~= playerInfo:getUpdate1() and (not update.requiredClass or update.requiredClass == playerInfo:getClass()) then
                local label = update.name
                if update == playerInfo:getUpdate2() then
                    label = "> " .. label .. " <"
                end
                menu:addItem(Menu:newItem(label, function()
                    playerInfo:setUpdate2(update)
                    updateButtons()
                    return update2Selection()
                end, i))
            end
        end
        return menu
    end

    updateButtons = function()
        if My.Stage.getCurrentStage() == 0 then
            player:addMenuItem("helms", classButtonId, Menu:newItem("Change Class", classSelection, 1))
            player:addMenuItem("helms", colorButtonId, Menu:newItem("Change Color", colorSelection, 2))
        end
        if My.Stage.getCurrentStage() == 1 then
            player:addMenuItem("helms", update1ButtonId, Menu:newItem((playerInfo:hasUpdate1() and "Change" or "Select") .. " Update", update1Selection , 3))
        end
        if My.Stage.getCurrentStage() == 2 then
            player:addMenuItem("helms", skillButtonId, Menu:newItem((playerInfo:hasSkill() and "Change" or "Select") .. " Skill", skillSelection , 4))
        end
        if My.Stage.getCurrentStage() == 3 then
            player:addMenuItem("helms", specializationButtonId, Menu:newItem((playerInfo:hasSubClass() and "Change" or "Select") .. " Specialization", specializationSelection, 5))
        end
        if My.Stage.getCurrentStage() == 4 then
            player:addMenuItem("helms", update2ButtonId, Menu:newItem((playerInfo:hasUpdate2() and "Change" or "Select") .. " Update #2", update2Selection, 6))
        end
    end

    updateButtons()
end
local showUpgradeButtons = function()
    for _, playerInfo in pairs(My.Players) do
        if playerInfo:isSpawned() then
            showUpgradeButtonsForPlayer(playerInfo)
        end
    end
end

local hideUpgradeButtons = function()
    for _, playerInfo in pairs(My.Players) do
        if playerInfo:isSpawned() then
            local player = playerInfo:getShipObject()
            player:removeMenuItem("helms", classButtonId, 1)
            player:removeMenuItem("helms", colorButtonId, 2)
            player:removeMenuItem("helms", update1ButtonId, 3)
            player:removeMenuItem("helms", skillButtonId, 4)
            player:removeMenuItem("helms", specializationButtonId, 5)
            player:removeMenuItem("helms", update2ButtonId, 6)
        end
    end
end

My.EventHandler:register("onStageStart", hideUpgradeButtons)
My.EventHandler:register("onStageFinished", showUpgradeButtons)
My.EventHandler:register("onPlayerSpawn", function(_, playerInfo)
    if not My.Stage:isRunning() then
        showUpgradeButtonsForPlayer(playerInfo)
    end
end)