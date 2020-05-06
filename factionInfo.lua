--
player = FactionInfo():setName("The Academy")
player:setGMColor(255, 255, 255)
player:setDescription("The Federation's Star Fleet Academy. After The Unknown appeared and attacked the Federation headquarters, the Academy was tasked with resupplying the fleet with piolts and commanders to fight back.")

enemies = FactionInfo():setName("The Unknown")
enemies:setGMColor(255, 0, 0)
enemies:setEnemy(player)
enemies:setDescription("They appeared from nowhere in the Zeta sector with the goal of conquering all life and the resources in our known universe. They first targeted Starfleet Headquaarters, destroying the front line of defense of the Federation.")
