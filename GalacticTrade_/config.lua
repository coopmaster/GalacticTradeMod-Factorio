function load_config(player_index)

	global.gt_extra_item_values = global.gt_extra_item_values or {}
	global.gt_extra_smelted_items = global.gt_extra_smelted_items or {}
	global.gt_extra_blacklist = global.gt_extra_blacklist or {}

	global.gt_items_per_row = global.gt_items_per_row or {} 
	global.gt_items_per_collum = global.gt_items_per_collum or {}
	global.gt_enable_trade_alert = global.gt_enable_trade_alert or {}
	global.gt_forget_search_term = global.gt_forget_search_term or {}

	if type(global.gt_items_per_row) == 'number' then
		global.gt_items_per_row = {}
		global.gt_items_per_collum = {}
		global.gt_enable_trade_alert = {}
		global.gt_forget_search_term = {}
	end

	-- You shouldn't touch anything above this line --

	--**If you are trying to add item values to the game, go to the bottom of the file for instructions**
	--Some settings only can be changed by player 1 (who I call the host even though there isn't a host)

	if player_index == 1 then --settings only effecting the host
		global.gt_extra_item_values = {}
		global.gt_extra_smelted_items = {}
		global.gt_extra_blacklist = {}

		global.gt_starting_credits = 0 --gives you some starting credits
		global.gt_shared_wallet = true --in multiplayer, everyone shares the same credits and chests
		global.gt_tech_cost_modifier = 0.25 --affects how much of the tech cost goes into the item, 1 meaning full, 0.5 half, 0 none, 2 double, ect


		--mod support, change to true for any mods you want support for
		gt_alt_vanila_values = false
		gt_NEARMod_values_support = false
		gt_DytechMod_values_support = false --WARNING these values may not be balanced and may need to be modified
		gt_torchlight_support = false --just removes the torchlights that aren't used with the torchlight mod
		global.gt_instant_buy_button_enabled = true 
		global.gt_instant_sell_button_enabled = true


		--unused config options (for now)
		global.gt_dynamic_economy = true --there is a living and breathing economy and what you buy and sell affects it.
		global.gt_initial_supply_modifier = 1000000 --basically this number means that at 1000000 credit value, the initial supply will be 0

	end

	--all these other options only effect the client (don't move things around or there will be desync)

	global.gt_items_per_row[player_index] = 20 --items per row in buying trading chest gui, if there are more than 20 rows, there will be a new page
	global.gt_items_per_collum[player_index] = 5 --items per row in buying trading chest gui
	global.gt_enable_trade_alert[player_index] = true
	global.gt_forget_search_term[player_index] = false --after closing a chest the search term in the buying trading chest is forgotten


	--add raw resource values here (items which don't have crafting recipies) with their values, see examples below


	--global.gt_extra_item_values["gold-ore"] = 100 -- this is an example for gold ore (make sure you put the item's name that is shown in the lua files, not from in-game, it could be different)

	--global.gt_extra_smelted_items["gold-plate"] = true --this says that gold plate is smelted, which adds a little value to it for the fuel cost (the true is just to make my life a little easier)

	--global.gt_extra_blacklist["gold-plate"] = true -- this is if you don't want an item you can buy or sell, this example says that gold plate wont be able to be bought or sold



	if gt_alt_vanila_values then --use this if you want to edit a specific items value (could still affect other item's values), also be sure to enable it above.
		global.gt_extra_item_values["coal"] = 100
	end

	if gt_torchlight_support then
		global.gt_extra_blacklist["torchlight"] = true
		global.gt_extra_blacklist["torchpole"] = true
		global.gt_extra_blacklist["torchpower"] = true
	end

	if gt_NEARMod_values_support then
		
		global.gt_extra_item_values["gold-ore"] = 100
		global.gt_extra_item_values["lead-ore"] = 30
		global.gt_extra_item_values["tungsten-ore"] = 70
		global.gt_extra_item_values["zinc-ore"] = 50
		global.gt_extra_item_values["tin-ore"] = 50
		global.gt_extra_item_values["bauxite-ore"] = 15
		global.gt_extra_item_values["rutile-ore"] = 200
		global.gt_extra_item_values["nitrogen-gas"] = 1
		global.gt_extra_item_values["oxygen-gas"] = 5
		global.gt_extra_item_values["argon-gas"] = 50
		global.gt_extra_item_values["co2-gas"] = 4   
		global.gt_extra_item_values["hydrogen-gas"] = 15
		global.gt_extra_item_values["sodium-hydroxide"] = 8
		global.gt_extra_item_values["bromine"] = 8
		global.gt_extra_item_values["ferric-chloride-solution"] = 15
		global.gt_extra_item_values["chlorine"] = 7
		global.gt_extra_item_values["cobalt-oxide"] = 70
		global.gt_extra_item_values["gold-plate"] = 200
		global.gt_extra_item_values["dry-ice"] = 1
		global.gt_extra_item_values["quartz"] = 30
		global.gt_extra_item_values["brine-water"] = 5

		global.gt_extra_smelted_items["tin-plate"]=true
		global.gt_extra_smelted_items["lead-plate"]=true
		global.gt_extra_smelted_items["zinc-plate"]=true
		global.gt_extra_smelted_items["titan-plate"]=true
		global.gt_extra_smelted_items["copper-tungsten-plate"]=true
		global.gt_extra_smelted_items["tungsten-carbide-plate"]=true
		global.gt_extra_smelted_items["aluminium-plate"]=true
		global.gt_extra_smelted_items["bronze-plate"]=true
		global.gt_extra_smelted_items["gold-plate"] = true
		
	end

	if gt_DytechMod_values_support then
		--WARNING these values may not be balanced and may need to be modified
		
		global.gt_extra_item_values["diamond-orex"] = 250
		global.gt_extra_item_values["emerald-orex"] = 250
		global.gt_extra_item_values["ruby-orex"] = 250
		global.gt_extra_item_values["sapphire-orex"] = 250
		global.gt_extra_item_values["topaz-orex"] = 250
		global.gt_extra_item_values["diamond-ore"] = 200
		global.gt_extra_item_values["emerald-ore"] = 200
		global.gt_extra_item_values["ruby-ore"] = 200
		global.gt_extra_item_values["sapphire-ore"] = 200
		global.gt_extra_item_values["topaz-ore"] = 200
		global.gt_extra_item_values["resin"] = 50
		global.gt_extra_item_values["obsidian"] = 100
		global.gt_extra_item_values["bone"] = 50
		global.gt_extra_item_values["chitin"] = 50
		global.gt_extra_item_values["ardite-ore"] = 75
		global.gt_extra_item_values["cobalt-ore"] = 75
		global.gt_extra_item_values["gold-ore"] = 250
		global.gt_extra_item_values["lead-ore"] = 250
		global.gt_extra_item_values["silver-ore"] = 105
		global.gt_extra_item_values["tin-ore"] = 100
		global.gt_extra_item_values["tungsten-ore"] = 100
		global.gt_extra_item_values["zinc-ore"] = 100
		global.gt_extra_item_values["brick"] = 100
		global.gt_extra_item_values["carbon"] = 100
		global.gt_extra_item_values["silicon"] = 50
		global.gt_extra_item_values["sand"] = 10
		global.gt_extra_item_values["sulfur-wood"] = 15
		global.gt_extra_smelted_items["lead-plate"] = true
		global.gt_extra_smelted_items["silver-plate"] = true
		global.gt_extra_smelted_items["tin-plate"] = true
		global.gt_extra_smelted_items["tungsten-plate"] = true
		global.gt_extra_smelted_items["zinc-plate"] = true
		global.gt_extra_smelted_items["brick"] = true
		global.gt_extra_smelted_items["glass"] = true
		global.gt_extra_smelted_items["ardite-plate"] = true
		global.gt_extra_smelted_items["cobalt-plate"] = true
		global.gt_extra_smelted_items["gold-plate"] = true
	end
	--copy what you get from TroubleItems.txt below this line then edit the values after the lines that start with global.gt_extra_item_values, look above for examples.
end