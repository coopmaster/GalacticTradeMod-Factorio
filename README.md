# GalacticTradeMod-Factorio

This mod adds the ability to buy and sell items in the game at market prices. You unlock the chest by researching market trading which comes after electronics. This mod adds two items (shown below) the buying trading chest (left) and the selling trading chest (right).

![img](https://i.imgur.com/Ot9TUrL.jpg?1)

The selling trading chest adds a gui on the top left of the screen (shown below) which shows you information about the sale of the contents. It also has a checkbox that allows you to disable that chest from selling its contents to the market.

![img](https://i.imgur.com/Vt2hRGc.jpg?1)

The buying trading chest also gives an additional gui that allows the sale of items. It shows the info about the sale and by clicking on any of the buttons with item icons, it switches the sale to that item. The textbox is where you enter the amount you want to have in the box, make sure you press the update button to update the information. Also like the selling trading box, it has a checkbox which allows the ability to disable that chest from buying things off the market. The copy and paste buttons allow you to copy trading chest values over to other trading chests. The current amount text shows how much it would cost to get the currently requested items, so if you already have 50 iron in the chest and request 100, it shows the price for 50 iron. There are multiple pages of items (which the size of a page can be changed in the config), clicking the left or right arrows will take you to different pages.

![img](https://i.imgur.com/Dg2NVg2.jpg?1)

Once a day, at noon (in game time of day value of 0) , everything in the selling trading chest is sold for credits with a 15% cut of the buying price. In the buying trading chest, whatever item is sold is bought at the amount requested. Credits are in the top left of the screen (see below). 

![img](https://i.imgur.com/iA9Ehnb.jpg?1)

If you don't have enough credits to complete the purchase, currently you won't buy anything for that order (each chest has its own order it request). The price of each item is determined by the resources it takes to craft them, any item that can be crafted in the game can be bought. The price is also determined by the crafting time (2 credits for each resource item (recursive)) and if it was smelted (additional 15 credits). Items that have no crafting recipe have a value set manually, so might need balancing. You don't need any research to buy or sell items, you just need the appropriate chests.

###Video Spotlights

- [https://youtu.be/TtKj1XPknTc]


[Examples of How to use Galactic Trade](https://imgur.com/a/EYi8M)

##Add compatibility with other mods

1. go to galactic trade mod folder
2. copy styles.lua
3. go to mod you want to add support with (if it has extra items)
4. paste the styles.lua file
5. edit data.lua with a text editor
6. add [code]require("styles")[/code] to the[size=150] [u][b]end[/b][/u][/size] of the file
7. if it has any raw resources (resources that don't have crafting recipes, but are available) go back to galactic trade mod folder (otherwise you are done!)
8. make sure the mod isn't already supported (look below)
8. edit the config.lua file with a text editor
9. look for the line "--add raw resource values here (items which don't have crafting recipes) with their values, see examples below"
10. look at examples and make sure you know what the item name is inside the mod's files, it would look something like "iron-plate"
(there are also some mods which already have support, all you need to do is remove the --[[ and --]] that surrounds the mod you want support for)
11. put the new line in and if it is smelted then also look slightly lower down (it also has instructions)
12. if you have done all of those steps then the items from the mod should show up in the buying trading chest with the correct credit values
13. if you want to help others not do steps 7-12, post to the forum thread and tell me the mod it was, and the lines you added to the files.

This mod is very much in a early stage and might make the save file incompatible with future versions of the mod, there could also be bugs which make the save file unplayable. From testing so far it seems stable, but it is possible I missed something somewhere. There will be more updates to the mod in the future that will improve stability and improve things. A list of planned features are below. For now, if you are upgrading from 0.1.x to 0.2.x it is stable.

##Planned Features
-[done] GUI for selling chest which will tell the value of items in the chest currently
-slider in buying gui instead of textbox (there isn't slider element yet, as far as I know)
-[done] checkbox for buying and selling chest (to enable and disable trading in that chest)
-chest types that hook to logistics network
-shift+right click and shift+left click copy settings (don't know if possible yet, but have copy and paste buttons for now)
-dynamic economy with simulated factories (maybe)
-better graphics for chests
-a thing that gives info on the market
-multiplayer support


##Changelog
**0.1.0**

 -Initial release
 
**0.1.1**

 -fixed selling values when selling items
 
 -fixed all buying chest buying amounts set to 0 when another buying chest is destroyed
 
 -added gui for selling chest which shows the value of the items in the chest
 
**0.1.2**

 -selling trading chest gui now shows value it will sell for on the market with merchant cut
 
**0.2.0**

 -fixed all buying chest buying amounts set to 0 when another buying chest is destroyed (instead of being mined)
 
 -added checkbox for enabling/disabling the trading for a specific chest
 
 -most items are now available on the market at the price of their recipes resource values
 
 -support for other mods with a little bit of work required on the user's end
 
**0.2.1**

 -fixed when a trading chest is mined or placed by a robot, it would cause a crash (after trying opening another chest or buying or selling)
 
 -if trading chest has more of an item than what you entered to buy, it now shows 0 instead of a negative number
 
 -update button in buying trading chest now doesn't set the amount to 0 if a valid number isn't entered
 
 -added copy and paste button for buying trading chest
 
 -buying trading chest no longer request more items than it can accept
 
 -added background for credits amount to make easier to see
 
**0.2.2**

 -base resources that don't have values now are shown when values are shown
 
 -added values for NEAR mod (uncomment in control.lua) credit to Syriusz
 
 -added config.lua and moved loading values for mods there
 
 -fixed where modded smelted items didn't have extra value added
 
 -added pages for item list and you can now change the size of the item list in the config.lua
 
 -now reloads all values when mod loads (in case you want to change it in a map you already started)
 
 -fixed some mods causing a loop when finding values
 
 -added option in config to reload values on load
 
 -added a way to blacklist modded items in config
 
**0.2.3**

 -fixed a bug where there wouldn't be more than one page after loading a save with the trading chest[/spoiler]
 

 [Archive of older versions](https://drive.google.com/folderview?id=0B-yFva9bu-RVfmFVdV9UU3c2bzlDMnJPWW9SX3psVEs2TUdiOElUWGVTaVZ4SDYxY2pQNlk&usp=sharing)

I hope you guys like this mod and give some feedback on balancing and design choices. I also don't know even if there is a trading mod out there, I just decided to make this and there could possibly be a mod out there that is better.
