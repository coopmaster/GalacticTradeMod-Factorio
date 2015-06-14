function load_config()
	if glob.gt_extra_item_values == nil then
		glob.gt_extra_item_values = {}
	end
	if glob.gt_extra_smelted_items == nil then
		glob.gt_extra_smelted_items = {}
	end
	if glob.gt_extra_blacklist == nil then
		glob.gt_extra_blacklist = {}
	end

	-- You shouldn't touch anything above this line --

	glob.gt_initial_supply_modifier = 1000 --determines how much supply there is with items (based on this number and value)
	glob.gt_items_per_row = 20 --items per row in buying trading chest gui, if there are more than 20 rows, there will be a new page
	glob.gt_items_per_collum = 5 --items per row in buying trading chest gui
	glob.gt_reload_item_values_on_load = false --only do this if you want to change item values, makes load times longer if left on. Eventually there will be a button for it
	glob.gt_instant_buy_button_enabled = false
	glob.gt_starting_credits = 0

	--add raw resource values here (items which don't have crafting recipies) with their values, see examples below

	--glob.gt_extra_item_values["gold-ore"] = 100 -- this is an example for gold ore (make sure you put the item's name that is shown in the lua files, not from in-game, it could be different)


	--glob.gt_extra_smelted_items["gold-plate"] = true --this says that gold plate is smelted, which adds a little value to it for the fuel cost (the true is just to make my life a little easier)

	--glob.gt_extra_blacklist["gold-plate"] = true -- this is if you don't want an item you can buy or sell, this example says that gold plate wont be able to be bought or sold


		--uncomment below lines for support for the NEAR mod
		--credit to Syriusz on the forums for suport for NEAR mod
		--[[
		glob.gt_extra_item_values["gold-ore"] = 100
		glob.gt_extra_item_values["lead-ore"] = 30
		glob.gt_extra_item_values["tungsten-ore"] = 70
		glob.gt_extra_item_values["zinc-ore"] = 50
		glob.gt_extra_item_values["tin-ore"] = 50
		glob.gt_extra_item_values["bauxite-ore"] = 15
		glob.gt_extra_item_values["rutile-ore"] = 200
		glob.gt_extra_item_values["nitrogen-gas"] = 1
		glob.gt_extra_item_values["oxygen-gas"] = 5
		glob.gt_extra_item_values["argon-gas"] = 50
		glob.gt_extra_item_values["co2-gas"] = 4   
		glob.gt_extra_item_values["hydrogen-gas"] = 15
		glob.gt_extra_item_values["sodium-hydroxide"] = 8
		glob.gt_extra_item_values["bromine"] = 8
		glob.gt_extra_item_values["ferric-chloride-solution"] = 15
		glob.gt_extra_item_values["chlorine"] = 7
		glob.gt_extra_item_values["cobalt-oxide"] = 70
		glob.gt_extra_item_values["gold-plate"] = 200
		glob.gt_extra_item_values["dry-ice"] = 1
		glob.gt_extra_item_values["quartz"] = 30
		glob.gt_extra_item_values["brine-water"] = 5

		glob.gt_extra_smelted_items["tin-plate"]=true
		glob.gt_extra_smelted_items["lead-plate"]=true
		glob.gt_extra_smelted_items["zinc-plate"]=true
		glob.gt_extra_smelted_items["titan-plate"]=true
		glob.gt_extra_smelted_items["copper-tungsten-plate"]=true
		glob.gt_extra_smelted_items["tungsten-carbide-plate"]=true
		glob.gt_extra_smelted_items["aluminium-plate"]=true
		glob.gt_extra_smelted_items["bronze-plate"]=true
		glob.gt_extra_smelted_items["gold-plate"] = true
		--]]

		--uncomment below lines for support for the DyTech Mod
		--WARNING these values may not be balanced and may need to be modified
		--[[
		glob.gt_extra_item_values["diamond-orex"] = 250
		glob.gt_extra_item_values["emerald-orex"] = 250
		glob.gt_extra_item_values["ruby-orex"] = 250
		glob.gt_extra_item_values["sapphire-orex"] = 250
		glob.gt_extra_item_values["topaz-orex"] = 250
		glob.gt_extra_item_values["diamond-ore"] = 200
		glob.gt_extra_item_values["emerald-ore"] = 200
		glob.gt_extra_item_values["ruby-ore"] = 200
		glob.gt_extra_item_values["sapphire-ore"] = 200
		glob.gt_extra_item_values["topaz-ore"] = 200
		glob.gt_extra_item_values["resin"] = 50
		glob.gt_extra_item_values["obsidian"] = 100
		glob.gt_extra_item_values["bone"] = 50
		glob.gt_extra_item_values["chitin"] = 50
		glob.gt_extra_item_values["ardite-ore"] = 75
		glob.gt_extra_item_values["cobalt-ore"] = 75
		glob.gt_extra_item_values["gold-ore"] = 250
		glob.gt_extra_item_values["lead-ore"] = 250
		glob.gt_extra_item_values["silver-ore"] = 105
		glob.gt_extra_item_values["tin-ore"] = 100
		glob.gt_extra_item_values["tungsten-ore"] = 100
		glob.gt_extra_item_values["zinc-ore"] = 100
		glob.gt_extra_item_values["brick"] = 100
		glob.gt_extra_item_values["carbon"] = 100
		glob.gt_extra_item_values["silicon"] = 50
		glob.gt_extra_item_values["sand"] = 10
		glob.gt_extra_item_values["sulfur-wood"] = 15
		glob.gt_extra_smelted_items["lead-plate"] = true
		glob.gt_extra_smelted_items["silver-plate"] = true
		glob.gt_extra_smelted_items["tin-plate"] = true
		glob.gt_extra_smelted_items["tungsten-plate"] = true
		glob.gt_extra_smelted_items["zinc-plate"] = true
		glob.gt_extra_smelted_items["brick"] = true
		glob.gt_extra_smelted_items["glass"] = true
		glob.gt_extra_smelted_items["ardite-plate"] = true
		glob.gt_extra_smelted_items["cobalt-plate"] = true
		glob.gt_extra_smelted_items["gold-plate"] = true
		--]]
end