function load_config()
	if global.gt_extra_item_values == nil then
		global.gt_extra_item_values = {}
	end
	if global.gt_extra_smelted_items == nil then
		global.gt_extra_smelted_items = {}
	end
	if global.gt_extra_blacklist == nil then
		global.gt_extra_blacklist = {}
	end

	-- You shouldn't touch anything above this line --

	global.gt_initial_supply_modifier = global.gt_initial_supply_modifier or 1000 --determines how much supply there is with items (based on this number and value)
	global.gt_items_per_row = 20 --items per row in buying trading chest gui, if there are more than 20 rows, there will be a new page
	global.gt_items_per_collum = 5 --items per row in buying trading chest gui
	global.gt_reload_item_values_on_load = false --only do this if you want to change item values, makes load times longer if left on. Eventually there will be a button for it
	global.gt_instant_buy_button_enabled = false
	global.gt_starting_credits = 0 --gives you some starting credits
	global.gt_max_factory_initial_size = 50
	global.gt_enable_trade_alert = true
	--Dynamic economies aren't ready yet
	--global.gt_dynamic_economy = true --enables the economy to be dependent on factories and consumers that provide a supply and demand
	global.gt_previous_version_support = true --possible that it conflicts with other mods
	global.gt_transaction_history_limit = 100 -- higher the number the more RAM it uses (and larger save file size)
	global.gt_forget_search_term = false --after closing a chest the search term in the buying trading chest is forgotten

	--mod support, change to true for any mods you want support for
	gt_NEARMod_values_support = false
	gt_DytechMod_values_support = false --WARNING these values may not be balanced and may need to be modified
	gt_torchlight_support = false --just removes the torchlights that aren't used with the torchlight mod

	--add raw resource values here (items which don't have crafting recipies) with their values, see examples below

	--global.gt_extra_item_values["gold-ore"] = 100 -- this is an example for gold ore (make sure you put the item's name that is shown in the lua files, not from in-game, it could be different)


	--global.gt_extra_smelted_items["gold-plate"] = true --this says that gold plate is smelted, which adds a little value to it for the fuel cost (the true is just to make my life a little easier)

	--global.gt_extra_blacklist["gold-plate"] = true -- this is if you don't want an item you can buy or sell, this example says that gold plate wont be able to be bought or sold

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
end