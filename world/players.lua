My = My or {}

My.Players = {}


--local playerShipTemplates = {}
--for i, config in ipairs(_G.PlayerShipTemplates) do
--    playerShipTemplates[i] = config.name
--end
--


--    Cron.regular(function(self)
--        -- alert when hull is damaged
--        if not player:isValid() then
--            Cron.abort(self)
--        else
--            if player:getHull() < player:getHullMax() / 2 then
--                player:commandSetAlertLevel("red")
--            elseif player:getHull() < player:getHullMax() then
--                player:commandSetAlertLevel("yellow")
--            else
--                player:commandSetAlertLevel("normal")
--            end
--        end
--    end, 0.2)
--
--    return player
--end


My.EventHandler:register("onWorldCreation", function()
    for idx=1,_G.GameConfig.numberPlayers do
        table.insert(My.Players, My.PlayerInfo(idx))
    end
end)

My.EventHandler:register("onWorldCreation", function()
    for _, playerInfo in pairs(My.Players) do
        playerInfo:spawnPlayerShip()
    end
end, 99)