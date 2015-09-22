# GalacticTradeMod-Factorio

Type: Mod
Name: Galactic Trade
Description: Adds the ability to buy and sell items.
License: [MIT](https://github.com/coopmaster/GalacticTradeMod-Factorio/blob/master/License)
Version: 0.6.5
Release: 2015-07-17
Tested-With-Factorio-Version: 0.12.5
Category: Gameplay Enhancement
Tags: Trading, Market
Download-Url: http://www.factorioforums.com/forum/viewtopic.php?f=93&t=13583&p=91665
Website: [archive of older versions (because I don't have a website yet)](https://drive.google.com/folderview?id=0B-yFva9bu-RVfmFVdV9UU3c2bzlDMnJPWW9SX3psVEs2TUdiOElUWGVTaVZ4SDYxY2pQNlk&usp=sharing)

##License

#####The MIT License (MIT)

Copyright (c) 2015 Cooper Mahring

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--------------------------------------------------------------------------------------------------------------------------

This license basically means that you can do whatever you want with the code, just make sure that you give proper credit to me.
You can use the code in your mod if you want. If you make a modpack with my mod in it, just let me know.
If I ever stop working on the mod, I will most likely edit the post to make sure that it is clear that it isn't being worked on anymore. If that ever does happen without me saying anything, the code can be used by anyone to make a similar mod.

##Long description

### Older versions usually wont work with newer ones, check the version history below for more details.

Have you ever forgotten to set a cap on that inserter chest and thought, "oh man now I just wasted a ton of iron and copper for nothing!". No longer! Now you can teleport your unwanted items directly to a merchant once a day to turn it into something useful! You can also make a living off of it! Design your factory around buying and selling items and become RICH! You can buy the rocket defense just from selling circuits, lots and lots of circuits!

This mod adds the ability to buy and sell items in the game at market prices. You unlock the chest by researching market trading which comes after electronics. This mod adds two items (shown below) the buying trading chest (top left), the selling trading chest (top right), the logistics buying trading chest (bottom left), and the logistics selling chest (bottom right).

![alt tag](http://i.imgur.com/PBIince.jpg?1)

The selling trading chest adds a gui on the top left of the screen (shown below) which shows you information about the sale of the contents. It also has a checkbox that allows you to disable that chest from selling its contents to the market.

![alt tag](https://i.imgur.com/Vt2hRGc.jpg?1)

The logistics selling chest is a chest that is a part of the logistics network that acts like a requester chest, just with the same functionality as a selling trading chest.

![alt tag](http://i.imgur.com/6KyDE9r.jpg?1)

The buying trading chest also gives an additional gui that allows the sale of items. It shows the info about the sale and by clicking on any of the buttons with item icons, it switches the sale to that item. The textbox is where you enter the amount you want to have in the box, make sure you press the update button to update the information. Also like the selling trading box, it has a checkbox which allows the ability to disable that chest from buying things off the market. The copy and paste buttons allow you to copy trading chest values over to other trading chests. The current amount text shows how much it would cost to get the currently requested items, so if you already have 50 iron in the chest and request 100, it shows the price for 50 iron. There are multiple pages of items (which the size of a page can be changed in the config), clicking the left or right arrows will take you to different pages. The logistics buying trading chest has the same gui, except it acts like a passive provider chest.

![alt tag](https://i.imgur.com/v1j4r1D.png?1)

Once a day, at noon (in game time of day value of 0) , everything in the selling trading chest is sold for credits with a 15% cut of the buying price. In the buying trading chest, whatever item is sold is bought at the amount requested. Credits are in the top left of the screen (see below). 

![alt tag](http://i.imgur.com/6P26IIO.jpg?1)

If you don't have enough credits to complete the purchase, currently you won't buy anything for that chest's order (each chest has its own order it request). The price of each item is determined by the resources it takes to craft them, any item that can be crafted in the game can be bought. The price is also determined by the crafting time (2 credits for each resource item (recursive)) and if it was smelted (additional 15 credits). Items that have no crafting recipe have a value set manually, so might need balancing. You don't need any research to buy or sell items, you just need the appropriate chests.

Next to the credits is a button that shows info of your current and previous transactions on the market. You can look at all the days where you had a transaction and how much you gained or lost. You can look through your transaction history with the arrow buttons (outer ones being first and last).

![alt tag](https://i.imgur.com/swtFFeP.png?1)


##Multiplayer
Use 0.6.0 for most stable multiplayer experience (0.6.2 needs more testing and 0.6.1 doesn't work with multiplayer)
There are two modes for multiplayer, shared and non-shared wallets. The non-shared wallet is more for pvp, but is good for those friends you can't trust! Shared wallet is simply that everyone shares the chests and money, if you decide later to change to non-shared then the current resources just go to player 1. Non-shared means that each individual player has a different credit amount and each has their own chests. Those chests aren't protected right now though, that is a planned feature. This is perfect for pvp since you can't effect anyone else's chests unless you have physical access, but you can see how much they have gained or spent in the transaction history! Give feedback if you encounter any bugs since I'm not easily able to test multiplayer with my bad laptop. Also let me know if you want more features for multiplayer!

##Pictures
[Examples on how to use the mod](https://imgur.com/a/EYi8M)

##Version history
Version# (Date): What has changed...


**0.1.0 (2015-05-25):**

 -Initial release
 
**0.1.1 (2015-05-25):**

 -fixed selling values when selling items
 
 -fixed all buying chest buying amounts set to 0 when another buying chest is destroyed
 
 -added gui for selling chest which shows the value of the items in the chest
 
**0.1.2 (2015-05-25):**

 -selling trading chest gui now shows value it will sell for on the market with merchant cut
 
**0.2.0 (2015-05-27):**

 -fixed all buying chest buying amounts set to 0 when another buying chest is destroyed (instead of being mined)
 
 -added checkbox for enabling/disabling the trading for a specific chest
 
 -most items are now available on the market at the price of their recipes resource values
 
 -support for other mods with a little bit of work required on the user's end
 
**0.2.1 (2015-06-02):**

 -fixed when a trading chest is mined or placed by a robot, it would cause a crash (after trying opening another chest or buying or selling)
 
 -if trading chest has more of an item than what you entered to buy, it now shows 0 instead of a negative number
 
 -update button in buying trading chest now doesn't set the amount to 0 if a valid number isn't entered
 
 -added copy and paste button for buying trading chest
 
 -buying trading chest no longer request more items than it can accept
 
 -added background for credits amount to make easier to see
 
**0.2.2 (2015-06-07):**

 -base resources that don't have values now are shown when values are shown
 
 -added values for NEAR mod (uncomment in control.lua) credit to Syriusz
 
 -added config.lua and moved loading values for mods there
 
 -fixed where modded smelted items didn't have extra value added
 
 -added pages for item list and you can now change the size of the item list in the config.lua
 
 -now reloads all values when mod loads (in case you want to change it in a map you already started)
 
 -fixed some mods causing a loop when finding values

 -added option in config to reload values on load

 -added a way to blacklist modded items in config

**0.2.3 (2015-06-10):**

 -fixed a bug where there wouldn't be more than one page after loading a save with the trading chest

**0.3.0 (2015-07-08):**

 -made trading chest show localised name of items

 -added loading bar to loading items

 -items without values are now put into a horizontal list that fits the screen if there are too many

 -you can now disable alerts for trader in config.lua

 -added a button in the top left that tells current and previous transactions

 -fixed a bug where new buying trading chests would not always be enabled by default

 -made credits easier to read (by adding commas)

 -no longer shows alert for trade merchant coming if you don't have any trading chests put down

 -expanded both trading chests by 2 stacks

**0.4.0 (2015-07-14):**

 -added logistic trading chests

 -fixed a bug where if you started a vanilla game and tried to load galactic trade, it would cause an error

 -added first and last buttons for transaction history

**0.4.1 (2015-07-17):**

 -fixed issue where disabling selling trading chest would crash the game

**0.5.0 (2015-07-17):**

 -Updated for 0.12.0 of factorio

 -item cost now reflect crafting times (may need balancing)

**0.5.1 (2015-07-25)**

 -made it to where you no longer need to edit other mods to have my mod work with them

**0.5.2 (2015-07-28)**

 -added support for 0.12.1

**0.5.3 (2015-08-03)**

 -transaction log now shows signs for positive and negitive for profit and expenses

 -buying trading chests will now buy as much as it can if you don't have enough money for the whole transaction

 -added a search field in buying trading chests

 -current transaction amount for buying trading chests now shows up in text field when opening it

 -the mod now makes two potential files, one where all items and values are listed. the other one is items which need to have values manually entered. (in the "script-output" directory)

 -added a new line in transaction log to show expected gross (how many credits you will have left afterwards) after the current transaction

**0.6.0 (2015-08-08)**

 -multiplayer support (possibly still buggy)

 -while making multiplayer support I changed a few small things

 -market values now don't recalculate every time the game is reloaded, there is a button that is temporarly located in the market transaction tab
 
**0.6.1 (2015-09-10)**

 -config is now cleaner and has different config options for clients and servers (both types are also for single player)
 
 -There is now an option to have every player have their own wallet with each trading chest being owned by the person who placed it.
 
 -coin now is tax exempt (merchant doesn't take any cut from it)
 
 -recalculate market values button now actually works
 
 -changed merchant cut to 10%
 
 -recalculate button actually works now
 
 -tech cost not affects market values, you can change how much so in the config
 
 -made it to where saves with older versions should work with this one (post if you get an error)
 
 -you can now change the individual prices of items by adding it to the config and reloading the config and recalculating the item values

**0.6.2 (2015-09-15)**

 -tech cost modifier is now 0.5 by default

 -fixed crash on buying from chest when you don't have enough money for whole order

 -added option for instant buy and instant sell buttons back in config

 -buying trading chest now updates cost of trade when typing in amount

**0.6.3 (2015-09-19)**

 -fixed not loading all recipies correctly

 -removed need for listing smelted items

 -fixed loading items freezing game with some mods

 -searching and selecting items now automatically updates info unless specified in config, also removed update buttons

 -added research for decreasing (now) trading efficiency

**0.6.4 (2015-09-20)**

 -fixed mod not loading because of typo

**0.6.5 (2015-09-22)**

 -fixed tech costs

 -fixed page numbers not updating for buying trading chests

 -fixed not reporting items without cost

 -added additional values for dytech mod values

 -fixed some mods causing the mod to get stuck in an infinite loop when loading values

 -fixed skipping the first item for the page


##Video Spotlights
https://youtu.be/TtKj1XPknTc

##Adding Support for Other Mods

###*Only for versions before 0.5.1*

If you get stuck with the steps, you can check out my video which shows you how to do it [here](https://www.youtube.com/watch?v=meOMdBYEU_g&feature=youtu.be)

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
13. if you want to help others not do steps 7-12, post to the forum thread and tell me the mod it was, and the lines you added to the files.[/spoiler]

##Planned Features
[done] -GUI for selling chest which will tell the value of items in the chest currently

-slider in buying gui instead of textbox (there isn't slider element yet, as far as I know)

[done] -checkbox for buying and selling chest (to enable and disable trading in that chest)

[done] -chest types that hook to logistics network

-shift+right click and shift+left click copy settings (don't know if possible yet, but have copy and paste buttons for now)

-dynamic economy with simulated factories (WIP)

-better graphics for chests

-a thing that gives info on the market

-multiplayer support

-better mod support for other mods (mostly done, just want to not have to do anything manually)

##Archive

[archive of older versions](https://drive.google.com/folderview?id=0B-yFva9bu-RVfmFVdV9UU3c2bzlDMnJPWW9SX3psVEs2TUdiOElUWGVTaVZ4SDYxY2pQNlk&usp=sharing)
versions 0.4.x and before are for factorio version 0.11.22, the thread for 0.11.22 can be found at http://www.factorioforums.com/forum/viewtopic.php?f=14&t=12496