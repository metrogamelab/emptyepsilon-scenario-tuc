# The Unknown Conflict

Listen up, Cadets! The situation with The Unknown has escalated such that we need your help. It's time to take all that we've taught you and apply it in the field. The Unknown have determined our Academy to be a threat to their primary objective and have targeted us for extermination. The Federation is enroute to assist us in our defense, but we need to hold off the Unknown long enough for them to arrive. The only craft available to us until then are with the light class ships we have utilized in our training.

Get your gear! \
Make sure your intercom is working! \
We urge you to pilot the craft you are strongest with as we need you at your best. \
Join your squad on the battle field! The enemies are numerous, but we are brave!
Remember to enable your shields before engaging the enemy!

Good luck cadet! If we survive this, you will have earned your wings.

### Installation

Installation has to be done on all stations.

0. Requires Empty Epsilon 2020.04.09
1. Locate EmptyEpsilon's directory of your installation. On Windows this is the directory the `EmptyEpsilon.exe`
file is located in. On Linux and Mac use `~/.emptyepsilon`.
2. This directory contains the `options.ini` file. Open it with any text editor, locate the line that starts with `mod=` and change it to `mod=tuc/`.
3. Close the file and make sure the `resources/mods` directory exists in the same directory. If not, just create it.
4. Inside the `resources/mods` directory create a directory called `tuc` and extract the archive there.
5. Start Empty Epsilon and you should be able to start a mission called `The Unknown Conflict`.
6. Be aware that none of the default scenarios will work with the mod enabled. They pop up on the mission selection still, but ignore these. To run EE's vanilla scenarios switch the line in `options.ini` back to `mod=`.

### Getting started

* Make sure the players can communicate.
* In the scenario selection disable "Beam/Shield Frequencies" and "Per-System Damage"
* Start the scenario and choose the variation that fits your player count.
* Let every player select the "Single Pilot" station, together with "Main Screen", "Strategic Map" and - if they like - "Database" and man their ship (one player per ship).
* Every player can change their class and color. Let them fly around and test the different classes. As long as they don't press the "Ready" button, the game won't start.
* Have a look at the database. It holds the documentation on the player classes, upgrades, skills and specialisations that you get access to later.
  If your players prefer a certain play style or fancy a special skill, they should start with the according class.
* Once every one pressed the "Ready" button, the first stage starts and the game begins. Good luck.

### Game mechanics

* The enemies spawn on the opposite of the green lanes you see on the Strategic Map and fly towards your HQ.
* If your HQ is destroyed, you loose.
* If you manage to survive 5 Stages (aka you see the "Ready" button for the 6th time) you can consider yourself a winner.
  Make sure to congratulate your players accordingly. The game does not end there just in case you want to go into Endless Mode. :)
* After every stage there is a break. The players get one option to improve their ship. When every one pressed the "Ready" Button, the next stage will start.
  * After 1st stage: select an update
  * After 2nd stage: select a skill
  * After 3rd stage: select a sub-class (new ship!)
  * After 4th stage: select a second update
* Every enemy you encounter has a useful database entry. You should know your enemies to know how to fight them best.
* Waypoints on the Strategic Map are synchronised over _all_ player ships. Use them to communicate.
* Players have big shields, but almost no hull. If their hull is damaged the Yellow Alert will be automatically turned on to notify them. The red alert comes up when the hull drops below 50%.
* Stations restock and recharge everything when the players dock. But they decline service when there are enemies within 5u.
* When a player ship is destroyed their ship will respawn after half a minute. But that time increases every time they die.
* The callsigns of the enemy will consist of the first letter of their type and blocks that indicate the health of their hull.
* Chat with HQ to see your teams kill count.
* There are some settings in the `scenario_01_tuc.lua` file that you can use to set player ship names and tweak the difficulty of the waves.