--require "defines"
require "prototypes.scripts.trading-chest"
require "config"
--require "luasocket"

--game.getplayer(index or name) for multiplayer support


function get_player(player_index)
	return game.players[player_index];
end

function comma_value(n) -- credit http://richard.warburton.it
	if n ~= nil then
		local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
		return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	end
	return nil
end

function gt_add_vanilla_base_values()

	global.gt_base_values["solid-fuel"] = global.gt_base_values["solid-fuel"] or 100 -- if you want to force the base cost of an item, just do it in the config like you are adding a mod item value
	global.gt_base_values["stone"] = global.gt_base_values["stone"] or 55
	global.gt_base_values["iron-ore"] = global.gt_base_values["iron-ore"] or 55
	global.gt_base_values["raw-fish"] = global.gt_base_values["raw-fish"] or 75
	global.gt_base_values["copper-ore"] = global.gt_base_values["copper-ore"] or 55
	global.gt_base_values["raw-wood"] = global.gt_base_values["raw-wood"] or 25
	global.gt_base_values["coal"] = global.gt_base_values["coal"] or 55
	global.gt_base_values["alien-artifact"] = global.gt_base_values["alien-artifact"] or 5000
	global.gt_base_values["crude-oil-barrel"] = global.gt_base_values["crude-oil-barrel"] or 1405
	global.gt_base_values["coin"] = global.gt_base_values["coin"] or 100
	global.gt_base_values["heavy-oil"] = global.gt_base_values["heavy-oil"] or 183
	global.gt_base_values["light-oil"] = global.gt_base_values["light-oil"] or 183
	global.gt_base_values["petroleum-gas"] = global.gt_base_values["petroleum-gas"] or 138
	global.gt_base_values["water"] = global.gt_base_values["water"] or 1
end

function gt_add_mod_base_values()
	for name, amount in pairs(global.gt_extra_item_values) do 
		global.gt_base_values[name] = amount
	end
end

function gt_previous_version_support()
	if global.gt_current_buying_trading_page ~= nil and type(global.gt_current_buying_trading_page) == 'number' then
		tmp = global.gt_current_buying_trading_page
		global.gt_current_buying_trading_page = {}
		global.gt_current_buying_trading_page[1] = tmp
	end
	if global.gt_current_search_term ~= nil and type(global.gt_current_search_term) == 'number' then
		tmp = global.gt_current_search_term
		global.gt_current_search_term = {}
		global.gt_current_search_term[1] = tmp
	end
	if global.gt_transaction_history ~= nil then
		for i in pairs(global.gt_transaction_history) do
			if type(i) == 'number' or i.profit ~= nil then
				tmp = global.gt_transaction_history
				global.gt_transaction_history = {}
				global.gt_transaction_history[1] = tmp
				break
			end 
		end
	end
	if global.gt_clipboard_buy ~= nil then
		for i in pairs(global.gt_clipboard_buy) do
			if i.item ~= nil then
				tmp = global.gt_clipboard_buy
				global.gt_clipboard_buy = {}
				global.gt_clipboard_buy[1] = tmp
				break
			end 
		end
	end
	if global.transaction_index ~= nil and type(global.transaction_index) == 'number' then
		tmp = global.transaction_index
		gglobal.transaction_index = {}
		global.transaction_index[1] = tmp
	end
	if global.credits ~= nil then
		tmp = global.credits
		global.credits = nil
		global.gt_credits = {}
		global.gt_credits[1] = tmp
	end


	if (global.gt_credits ~= nil and type(global.gt_credits) == 'number') then
		tmp = global.gt_credits
		global.gt_credits = {}
		global.gt_credits[1] = tmp
	end

	if global.buyingtradingchests ~= nil and global.buyingtradingchests.chest == nil then
		for _,c in ipairs(global.buyingtradingchests) do
			global.buyingtradingchests.chest = {}
			table.insert(global.buyingtradingchests.chest,c)
		end
	end

	if global.buyingtradingchests ~= nil and global.buyingtradingchests.player_id == nil then
		for _,c in ipairs(global.buyingtradingchests) do
			global.buyingtradingchests.player_id = {}
			table.insert(global.buyingtradingchests.player_id,1)
		end
	end

	if global.buyingtradingchests ~= nil and global.buyingtradingchests.enabled == nil then
		for _,c in ipairs(global.buyingtradingchests) do
			global.buyingtradingchests.enabled = {}
			table.insert(global.buyingtradingchests.enabled,true)
		end
	end
	if global.buyingtradingchests ~= nil and global.buyingtradingchests.item_amount == nil then
		for _,a in ipairs(global.buyingtradingchests_itemamount) do
			global.buyingtradingchests.item_amount = {}
			table.insert(global.buyingtradingchests.item_amount,a)
		end
	end
	if global.buyingtradingchests ~= nil and global.buyingtradingchests.item_selected == nil then
		for _,i in ipairs(global.buyingtradingchests_itemselected) do
			global.buyingtradingchests.item_selected = {}
			table.insert(global.buyingtradingchests.item_selected,i)
		end
	end
	if global.sellingtradingchests ~= nil and global.sellingtradingchests.chest == nil then
		for _,c in ipairs(global.sellingtradingchests) do
			global.sellingtradingchests.chest = {}
			table.insert(global.sellingtradingchests.chest,c)
		end
	end
	if global.sellingtradingchests ~= nil and global.sellingtradingchests.player_id == nil then
		for _,c in ipairs(global.sellingtradingchests) do
			global.sellingtradingchests.player_id = {}
			table.insert(global.sellingtradingchests.player_id,1)
		end
	end
	if global.sellingtradingchests ~= nil and global.sellingtradingchests.enabled == nil then
		for _,c in ipairs(global.sellingtradingchests) do
			global.sellingtradingchests.enabled = {}
			table.insert(global.sellingtradingchests.enabled,true)
		end
	end

end

local function load_values(player_index)

	global.gt_total_items = global.gt_total_items or 0

	if player_index == 1 then
		gt_previous_version_support()
	end

	global.gt_release_version = 0 --0.6.3
	global.gt_major_version = 6
	global.gt_minor_version = 3

	load_config(player_index)
	
	global.gt_total_items_unfiltered = global.gt_total_items_unfiltered or 0
	global.gt_history_day = global.gt_history_day or 1
	global.gt_transaction_history=global.gt_transaction_history or {}
	global.gt_transaction_history[player_index] = global.gt_transaction_history[player_index] or {}
	global.gt_traded_today = global.gt_traded_today or false
	global.gt_first_tick = global.gt_first_tick or true
	global.gt_show_loading_gui = global.gt_show_loading_gui or true
	global.gt_loading_index = global.gt_loading_index or 0 
	global.gt_loading_done = global.gt_loading_done or false 
	global.gt_items_without_cost = global.gt_items_without_cost or {}
	global.gt_current_filtered_items = global.gt_current_filtered_items or 0
	global.gt_current_viewing_player_transaction_info = global.gt_current_viewing_player_transaction_info or {}
	if not(global.gt_shared_wallet)then
		global.gt_current_viewing_player_transaction_info[player_index] = global.gt_current_viewing_player_transaction_info[player_index] or player_index
	else
		global.gt_current_viewing_player_transaction_info[player_index] = global.gt_current_viewing_player_transaction_info[player_index] or 1
	end

	global.buyingtradingchests = global.buyingtradingchests or {}
	global.buyingtradingchests.player_id = global.buyingtradingchests.player_id or {}
	global.buyingtradingchests.chest = global.buyingtradingchests.chest or {}
	global.buyingtradingchests.enabled = global.buyingtradingchests.enabled or {}
	global.buyingtradingchests.item_amount = global.buyingtradingchests.item_amount or {}
	global.buyingtradingchests.item_selected = global.buyingtradingchests.item_selected or {}

	global.sellingtradingchests = global.sellingtradingchests or {}
	global.sellingtradingchests.player_id = global.sellingtradingchests.player_id or {}
	global.sellingtradingchests.chest = global.sellingtradingchests.chest or {}
	global.sellingtradingchests.enabled = global.sellingtradingchests.enabled or {}
	global.transaction_index = global.transaction_index or {}
	global.transaction_index[player_index] = global.transaction_index[player_index] or 1

	global.gt_smelting_value = global.gt_smelting_value or 15
	global.gt_credits = global.gt_credits or {}
	global.gt_credits[player_index] = global.gt_credits[player_index] or global.gt_starting_credits
	global.gt_clipboard_buy = global.gt_clipboard_buy or {}
	global.gt_clipboard_buy[player_index] = global.gt_clipboard_buy[player_index] or {}

	if global.gt_reload_item_values_on_load then
		global.gt_base_values = {}
		global.gt_blacklist = {}
	end

	global.gt_base_values = global.gt_base_values or {}
	global.gt_market_values = global.gt_market_values or {}
	global.gt_market_supply = global.gt_market_supply or {}
	global.gt_market_demand = global.gt_market_demand or {}

	gt_add_vanilla_base_values()

	gt_add_mod_base_values()

	global.gt_blacklist = global.gt_blacklist or {}

	global.gt_blacklist["computer"] = true
	global.gt_blacklist["tank-cannon"] = true
	global.gt_blacklist["player-port"] = true
	global.gt_blacklist["small-plane"] = true
	global.gt_blacklist["basic-electric-discharge-defense-remote"] = true
	global.gt_blacklist["tank-machine-gun"] = true
	global.gt_blacklist["vehicle-machine-gun"] = true

	for name, amount in pairs(global.gt_extra_blacklist) do 
		global.gt_blacklist[name] = amount
	end

	global.gt_supply = global.gt_supply or {}
	global.gt_demand = global.gt_demand or {}

	-- for name, value in pairs(global.gt_base_values) do--add initial supply to items
	-- 	global.gt_supply[name] = global.gt_supply[name] or math.ceil((math.sqrt(global.gt_initial_supply_modifier)*-value)+global.gt_initial_supply_modifier)
	-- end

	global.gt_current_buying_trading_page = global.gt_current_buying_trading_page or {}
	for i in pairs(game.players) do
		global.gt_current_buying_trading_page[i] = global.gt_current_buying_trading_page[i] or 0
	end
	global.gt_current_search_term = global.gt_current_search_term or {}
	for i in pairs(game.players) do
		global.gt_current_search_term[i] = ""
	end
end

local function remove_gui(player_index)

	if get_player(player_index).gui.top.gt_money ~= nil then
		get_player(player_index).gui.top.gt_money.destroy()
		get_player(player_index).gui.top.gt_info_button.destroy()
	end
	if get_player(player_index).gui.top.gt_info_frame then
		get_player(player_index).gui.top.gt_info_frame.destroy()
	end

end

local function create_gui(player_index)
	remove_gui(player_index)
	if get_player(player_index).gui.top.gt_money == nil then
		get_player(player_index).gui.top.add{type="frame", name="gt_money", caption = '', style='frame_style', direction='vertical'}
		get_player(player_index).gui.top.gt_money.add{type="label", name="gt_credits", caption="0 credits"}
		get_player(player_index).gui.top.add{type="button",name="gt_info_button",caption="GT"}
	end

end

script.on_init(function()
	for i in pairs(game.players) do
		load_values(i)
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	load_values(event.player_index)
	create_gui(event.player_index)
	if event.player_index == 1 then
		initiate_reload_item_values()
	end
end)

function gt_get_trade_efficiency()
	if get_player(1).force.technologies["tradingefficiency3"].researched then
		return 0.01
	elseif get_player(1).force.technologies["tradingefficiency2"].researched then
		return 0.05
	elseif get_player(1).force.technologies["tradingefficiency1"].researched then
		return 0.10
	else
		return 0.15
	end
end


function gt_tech_value(item)
	value = 0
	for _,tech in pairs(get_player(1).force.technologies) do
		for i,eff in pairs(tech.effects) do
			if eff.recipe ~= nil and eff.recipe == item then
				for _,pre in ipairs(tech.prerequisites) do
					value = value + pre.research_unit_energy
				end
				value = value + tech.research_unit_energy
			end
		end
	end
	return value * global.gt_tech_cost_modifier
end

function gt_get_item_value(item, num)
	has_recipe = false
	value = 0

	if item == nil or num == nil then
		return nil
	end

	if global.gt_blacklist[item] ~= nil and global.gt_blacklist[item] == true then
		return 0
	end

	if global.gt_base_values[item] ~= nil then
		return global.gt_base_values[item] * num
	end

	if global.gt_base_values[item] == nil and not(global.gt_blacklist[item]) then
		for n,r in pairs(get_player(1).force.recipes) do
			if r ~= nil and not(r.hidden) then
				for _,product in pairs(r.products) do
					if product ~= nil and product.name == item and product.amount ~= nil and product.amount > 0 and #r.ingredients > 0 then
						has_recipe = true
						for _, a in pairs(r.ingredients) do
							global.gt_base_values[item] = 0
							sub_value = gt_get_item_value(a.name, a.amount)
							if sub_value == 0 then
								break
							end
							if sub_value < 1 then
								global.gt_base_values[item] = 0
								break
							else
								value = value + sub_value
							end
						end
						value = math.ceil(value / product.amount)
						value = value + math.floor(r.energy) --adds value for crafting time
						value = value + gt_tech_value(item) --adds value for technology it requires
						if value > 0 then
							global.gt_base_values[item] = value
							value = value * num
							return value
						end
					end
				end
			end
		end
		if not(has_recipe) then
			recipe_value = 0
			has_recipe = true
			for n,r in pairs(get_player(1).force.recipes) do
				if r ~= nil and not(r.hidden) then
					for _, ing in pairs(r.ingredients) do
						if ing.name == item then
							has_recipe = true
							break
						end
					end
					if has_recipe then
						for _,p in pairs(r.products) do
							if p ~= nil and p.name == item and p.amount ~= nil and p.amount > 0 and #r.ingredients > 0 then
								recipe_value = recipe_value + gt_get_item_value(p.name,p.amount)
							end
						end
						if recipe_value ~= 0 then
							for _,ing in pairs(r.ingredients) do
								if ing.name ~= item then
									recipe_value = recipe_value - gt_get_item_value(ing.name,ing.amount)
								end
							end
						end
					end
					if recipe_value < 1 then
						has_recipe = false
					else
						global.gt_base_values[item] = recipe_value
						return recipe_value
					end
				end
			end
		end
	else
		global.gt_base_values[item] = 0
		return 0
	end
	if has_recipe then
		global.gt_base_values[item] = 0
		return 0
	end

	global.gt_blacklist[item] = true
	global.gt_base_values[item] = 0
	return -1
end

function gt_get_item_market_value(item, num) --could cause a long pause during trading late game, need to check
	order_value = 0
	temp_supply = global.gt_supply[item] --don't actually want to commit to the market yet
	temp_demand = global.gt_demand[item]

	for i=1,num do 
		if item ~= "coin" then --coins are the exception, they don't have inflation or deflation. They represent one credit.
			order_value = order_value + ((temp_demand/temp_supply)*gt_get_item_value(item,1))
			temp_supply = temp_supply - 1
			temp_demand = temp_demand - 1 --demand is only set when you put in an order
		else
			order_value = order_value + gt_get_item_value(item,1)
		end
	end

	return order_value
end

function initiate_reload_item_values()
	global.gt_total_items_unfiltered = 0
	for c, item in pairs(game.item_prototypes) do 
		global.gt_total_items_unfiltered = global.gt_total_items_unfiltered + 1
	end

	global.gt_first_tick = false
	global.gt_items_without_cost = {}
	global.gt_loading_index = 0
	global.gt_loading_done = false
	create_loading_gui(1)

	global.gt_base_values = {}

	gt_add_vanilla_base_values()
	gt_add_mod_base_values()
end

function create_loading_gui(player_index)
	p = get_player(player_index)
	p.gui.center.add{type="frame", name="item_value_loading_frame", caption = 'Loading Item Values for Galactic Trade...', style='frame_style', direction='vertical'}
	p.gui.center.item_value_loading_frame.add{name="item_value_loading_table", type="table", colspan=1}
	p.gui.center.item_value_loading_frame.item_value_loading_table.add{name="item_value_loading_progress", type="progressbar", size=global.gt_total_items_unfiltered, value = 0}
	p.gui.center.item_value_loading_frame.item_value_loading_table.add{name="item_value_loading_label", type="label", caption = "0/"..global.gt_total_items_unfiltered}
end

function message_all_players(message)
	for i in pairs(game.players) do
		if global.gt_enable_trade_alert[i] then
			get_player(i).print(message)
		end
	end
end

function get_selling_price(item,amount)

	price = 0

	if item ~= "blank" then
		if item ~= "coin" then
			price = gt_get_item_value(item,amount)-(gt_get_item_value(item,amount) * gt_get_trade_efficiency())
		else
			price = gt_get_item_value(item,amount)
		end
	end

	return price
end

function get_buying_price(item,amount) --not much yet
	return gt_get_item_value(item,amount)
end

function sell_resources_from_chest(chest,items,amounts)--set items and amounts to nil for everything in the chest
	profit = 0
	chest_index = get_sellingchest_index(chest)

	for i,a in pairs(chest.get_inventory(1).get_contents()) do
		if i ~= nil then
			price = get_selling_price(i,a)
			if get_selling_price(i,a) > 0 and not(global.gt_blacklist[i]) then
				if items ~= nil and #items > 0 then
					for indx,name in ipairs(items) do
						if name == i then
							if amounts[indx] ~= nil then
								if a < amounts[indx] then
									profit = profit + get_selling_price(name,a)
									chest.get_inventory(1).remove({name = name,count = a})
								else
									profit = profit + get_selling_price(name,amounts[indx])
									chest.get_inventory(1).remove({name = name,count = amounts[indx]})
								end
							else
								profit = profit + get_selling_price(name,a)
								chest.get_inventory(1).remove({name = name,count = a})
							end
						end
					end
				else
					profit = profit + price
					chest.get_inventory(1).remove({name = i,count = a})
				end
			end
		end
	end
	if not global.gt_shared_wallet then
		if global.gt_transaction_history[chest_index][global.gt_history_day] == nil then
			global.gt_transaction_history[chest_index][global.gt_history_day] = {}
			global.gt_transaction_history[chest_index][global.gt_history_day].profit = 0
			global.gt_transaction_history[chest_index][global.gt_history_day].expenses = 0
		end

		if global.gt_transaction_history[chest_index][global.gt_history_day].profit == nil then
			global.gt_transaction_history[chest_index][global.gt_history_day].profit = 0
		end
		if global.gt_transaction_history[chest_index][global.gt_history_day].expenses == nil then
			global.gt_transaction_history[chest_index][global.gt_history_day].expenses = 0
		end

		global.gt_credits[chest_index] = global.gt_credits[chest_index] + profit

		global.gt_transaction_history[chest_index][global.gt_history_day].profit = global.gt_transaction_history[chest_index][global.gt_history_day].profit + profit
	else
		if global.gt_transaction_history[1][global.gt_history_day] == nil then
			global.gt_transaction_history[1][global.gt_history_day] = {}
			global.gt_transaction_history[1][global.gt_history_day].profit = 0
			global.gt_transaction_history[1][global.gt_history_day].expenses = 0
		end

		if global.gt_transaction_history[1][global.gt_history_day].profit == nil then
			global.gt_transaction_history[1][global.gt_history_day].profit = 0
		end
		if global.gt_transaction_history[1][global.gt_history_day].expenses == nil then
			global.gt_transaction_history[1][global.gt_history_day].expenses = 0
		end

		global.gt_credits[1] = global.gt_credits[1] + profit

		global.gt_transaction_history[1][global.gt_history_day].profit = global.gt_transaction_history[1][global.gt_history_day].profit + profit
	end
end

function buy_resources_from_chest(chest)--buy items and amounts to null for everything in the chest
	expenses = 0
	chest_index = get_buyingchest_index(chest)

	if chest == chest and global.buyingtradingchests.enabled[chest_index] and global.buyingtradingchests.item_selected[chest_index] ~= "blank" then
		item_count = chest.get_inventory(1).get_item_count(global.buyingtradingchests.item_selected[chest_index])
		if item_count < tonumber(global.buyingtradingchests.item_amount[chest_index]) then

			contents = global.buyingtradingchests.chest[chest_index].get_inventory(1).get_contents()
			global.buyingtradingchests.chest[chest_index].get_inventory(1).clear()
			slots_available = global.buyingtradingchests.chest[chest_index].get_inventory(1).getbar()
			for name, amount in pairs(contents) do
				global.buyingtradingchests.chest[chest_index].get_inventory(1).insert({name = name, count = amount})
				if name ~= global.buyingtradingchests.item_selected[chest_index] then
					slots_available = slots_available - math.ceil(amount/game.item_prototypes[global.buyingtradingchests.item_selected[chest_index]].stack_size)
				end
			end

			item_difference = global.buyingtradingchests.item_amount[chest_index] - item_count

			if slots_available>0 then
				max_buy_amount = (slots_available * game.item_prototypes[global.buyingtradingchests.item_selected[chest_index]].stack_size) - item_count
				if item_difference > max_buy_amount then
					item_difference = max_buy_amount
				end
			else
				slots_available = 0
			end

			expenses = get_buying_price(global.buyingtradingchests.item_selected[chest_index],item_difference)

			if not global.gt_shared_wallet then
				if expenses>global.gt_credits[global.buyingtradingchests.player_id[chest_index]] and get_buying_price(global.buyingtradingchests.item_selected[chest_index],1) <= global.gt_credits[global.buyingtradingchests.player_id[chest_index]] then
					item_difference = math.floor(global.gt_credits[global.buyingtradingchests.player_id[chest_index]]/gt_get_item_value(global.buyingtradingchests.item_selected[chest_index],1))
					expenses = get_buying_price(global.buyingtradingchests.item_selected[chest_index],item_difference)
				end
			else
				if expenses>global.gt_credits[1] and get_buying_price(global.buyingtradingchests.item_selected[chest_index],1) <= global.gt_credits[1] then
					item_difference = math.floor(global.gt_credits[1]/gt_get_item_value(global.buyingtradingchests.item_selected[chest_index],1))
					expenses = get_buying_price(global.buyingtradingchests.item_selected[chest_index],item_difference)
				end
			end

			if global.gt_credits[global.buyingtradingchests.player_id[chest_index]] - expenses >= 0 and global.buyingtradingchests.item_selected[chest_index] ~= "blank"  then
				if not global.gt_shared_wallet then
					if item_difference > 0 then
						global.buyingtradingchests.chest[chest_index].insert({name = global.buyingtradingchests.item_selected[chest_index], count = item_difference})
						global.gt_credits[global.buyingtradingchests.player_id[chest_index]] = global.gt_credits[global.buyingtradingchests.player_id[chest_index]] - expenses
					end

					if global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day] == nil then
						global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day] = {}
						global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].profit = 0
						global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].expenses = 0
					end

					if global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].profit == nil then
						global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].profit = 0
					end
					if global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].expenses == nil then
						global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].expenses = 0
					end

					global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].expenses = global.gt_transaction_history[global.buyingtradingchests.player_id[chest_index]][global.gt_history_day].expenses + expenses
				else
					if item_difference > 0 then
						global.buyingtradingchests.chest[chest_index].insert({name = global.buyingtradingchests.item_selected[chest_index], count = item_difference})
						global.gt_credits[1] = global.gt_credits[1] - expenses
					end

					if global.gt_transaction_history[1][global.gt_history_day] == nil then
						global.gt_transaction_history[1][global.gt_history_day] = {}
						global.gt_transaction_history[1][global.gt_history_day].profit = 0
						global.gt_transaction_history[1][global.gt_history_day].expenses = 0
					end

					if global.gt_transaction_history[1][global.gt_history_day].profit == nil then
						global.gt_transaction_history[1][global.gt_history_day].profit = 0
					end
					if global.gt_transaction_history[1][global.gt_history_day].expenses == nil then
						global.gt_transaction_history[1][global.gt_history_day].expenses = 0
					end

					global.gt_transaction_history[1][global.gt_history_day].expenses = global.gt_transaction_history[1][global.gt_history_day].expenses + expenses

				end

			else
				get_player(global.buyingtradingchests.player_id[chest_index]).print("Unable to complete your sale")
			end
		end
	end
end

function gt_update_opened_buying_chest_info(player_index)
	item_index = get_opened_buyingchest_index(player_index)
	n = tonumber(p.gui.left.tradingchest_buy.item_view_table.item_amount_field.text)
	if n == nil then
		n = 0
	end
	if n == nil then
		n = 0
		p.print("Please enter a valid number") --do not delete
	else
		global.buyingtradingchests.item_amount[item_index] = n
	end

	if global.buyingtradingchests.item_selected[item_index] ~= "blank" and p.opened.get_inventory(1).getbar() * game.item_prototypes[global.buyingtradingchests.item_selected[item_index]].stack_size < global.buyingtradingchests.item_amount[item_index] then
		global.buyingtradingchests.item_amount[item_index] = p.opened.get_inventory(1).getbar() * game.item_prototypes[global.buyingtradingchests.item_selected[item_index]].stack_size
	end

	p.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption = comma_value(global.buyingtradingchests.item_amount[item_index])
	
	credit_cost = 0
	if global.buyingtradingchests.item_selected[item_index] ~= "blank" then
		item_count = p.opened.get_inventory(1).get_item_count(global.buyingtradingchests.item_selected[item_index])
		item_difference = global.buyingtradingchests.item_amount[item_index] - item_count
		tmp_values = {}
		credit_cost = item_difference * gt_get_item_value(global.buyingtradingchests.item_selected[item_index],1)
	else
		credit_cost = 0
	end
	if credit_cost < 0 then
		credit_cost = 0
	end
	p.gui.left.tradingchest_buy.item_view_table.current_cost_table.item_cost_label_constant.caption = comma_value(credit_cost)
end

function gt_update_opened_selling_chest_info(player_index)
	chest_value = 0
	chest_index = get_opened_sellingchest_index(player_index)
	for item, amount in pairs(global.sellingtradingchests.chest[chest_index].get_inventory(1).get_contents()) do
		price = get_selling_price(item,amount)
		if price > 0 then
			chest_value = chest_value + price
		end
	end
	p.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.chest_value_label.caption = comma_value(chest_value)
end


script.on_event(defines.events.on_tick, function(event)

	if #game.players > 0 and game.tick >= 2 and global.gt_loading_index < global.gt_total_items_unfiltered and not(global.gt_loading_done) then
		current_item = nil

		i = 0
		for c, item in pairs(game.item_prototypes) do 
			if i == global.gt_loading_index then
				current_item = item
			end
			i = i + 1
		end
		if current_item ~= nil then
			value = gt_get_item_value(current_item.name, 1)
			if value > 0 then
				global.gt_base_values[current_item.name] = value
				global.gt_total_items = global.gt_total_items + 1
			elseif value == -1 then
				global.gt_blacklist[current_item.name] = true
				global.gt_base_values[current_item.name] = 0
				table.insert(global.gt_items_without_cost,current_item.name)
			end
		else
			if current_item ~= nil and global.gt_base_values[current_item.name] > 0 then
				global.gt_total_items = global.gt_total_items + 1
			end
		end
		if global.gt_show_loading_gui then
			get_player(1).gui.center.item_value_loading_frame.item_value_loading_table.item_value_loading_progress.value = get_player(1).gui.center.item_value_loading_frame.item_value_loading_table.item_value_loading_progress.value + (1/global.gt_total_items_unfiltered)
			get_player(1).gui.center.item_value_loading_frame.item_value_loading_table.item_value_loading_label.caption = global.gt_loading_index.."/"..global.gt_total_items_unfiltered
		end
		global.gt_loading_index = global.gt_loading_index + 1
	else 
		if #game.players >0 and game.tick > 2 and not(global.gt_loading_done) then
			for c, item in pairs(game.item_prototypes) do 
				if global.gt_base_values[item] == 0 then
					global.gt_base_values[item] = nil
					gt_get_item_value(item,1)
				end
			end
			global.gt_loading_index = 0
			global.gt_loading_done = true
			if get_player(1).gui.center.item_value_loading_frame ~= nil then
				get_player(1).gui.center.item_value_loading_frame.destroy()
			end
			if #global.gt_items_without_cost ~= 0 then
				s = "mod_name_here = true\nif mod_name_here then\n"
				for a, b in pairs(global.gt_items_without_cost) do
					if a ~= 1 then
						s = s .. "\n"
					end
					s = s .. "  global.gt_extra_item_values[\"" .. b .. "\"] = "
					s = s .. "\n  global.gt_extra_blacklist[\"" .. b .. "\"] = false"
				end
				s = s .. "\nend\n--copy and paste this into the bottom of the config.lua located inside of the galactic trade mod folder, make sure that it's just above the last \"end\".\n--You will want to add values to the end of the lines which might take some trial and error to make sure that they are correct.\n--There are other things you might want to do, check in the config.lua for instructions on how to do other things"
				
				game.write_file("GalacticTrade/TroubleItems.txt", s)

				get_player(1).print("There are "..#global.gt_items_without_cost.." base resoureces (items without recipies) without cost (listed above)")
				get_player(1).print("Go to your factorio directory, inside of the \"script-output\\GalacticTrade\\TroubleItems.txt\" file for more information.")
			end
			total_blacklisted = 0
			for a,b in pairs(global.gt_blacklist) do
				if a then
					total_blacklisted = total_blacklisted + 1
				end
			end
			output = "Out of "..global.gt_total_items_unfiltered.." there was "..global.gt_total_items.." which would be listed in the market. There was "..total_blacklisted.." blacklisted items and "..#global.gt_items_without_cost.." items which had a value of 0 credits.\n\n".."Below are listed the items and values for the last game session of Galactic Trade"
			for _, item in pairs(game.item_prototypes) do 
				output = output .. "\n" .. item.name .. " = " .. gt_get_item_value(item.name,1)
			end
			game.write_file("GalacticTrade/ItemValues.txt",output)
		end
	end

	for index in pairs(game.players) do
		if get_player(index).gui.top.gt_money ~= nil then
			if not(global.gt_shared_wallet) then
	  			get_player(index).gui.top.gt_money.gt_credits.caption = "credits: "..comma_value(math.floor(global.gt_credits[index]))
	  		else
	  			get_player(index).gui.top.gt_money.gt_credits.caption = "credits: "..comma_value(math.floor(global.gt_credits[1]))
	  		end
	  	else
	  		create_gui(index)
		end
		p = get_player(index)
		if p.opened ~= nil and p.opened.valid then

			if (p.opened.name == "trading-chest-buy" or p.opened.name == "logistic-trading-chest-buy") then --buying chest gui

				if p.gui.left.tradingchest_buy == nil then

					if global.gt_forget_search_term[index] then
						global.gt_current_search_term[index] = ""
					end

					p.gui.left.add{type="frame", name="tradingchest_buy", caption = 'Selected Item', style='frame_style', direction='vertical'}

					item_index = get_opened_buyingchest_index(index)

					if global.buyingtradingchests.enabled[item_index] == nil then
						if global.buyingtradingchests.enabled == nil then
							global.buyingtradingchests.enabled = {}
						end
						global.buyingtradingchests.enabled[item_index] = true
					end

					p.gui.left.tradingchest_buy.add{name="item_view_table", type="table", colspan=1}
					if not(global.gt_shared_wallet) and #game.players > 1 then
						p.gui.left.tradingchest_buy.item_view_table.add{type="label",name="owner_label",caption="Owner: "..get_player(global.buyingtradingchests.player_id[item_index]).name}
					end
					p.gui.left.tradingchest_buy.item_view_table.add{type="checkbox",name="buyingchest_enabled_checkbox",state=global.buyingtradingchests.enabled[item_index], caption="Enabled"}
					if global.buyingtradingchests.item_selected[item_index] ~= "blank" then
						p.gui.left.tradingchest_buy.item_view_table.add{type="label",name="item_label",caption=global.buyingtradingchests.item_selected[item_index].localised_name}
					else
						p.gui.left.tradingchest_buy.item_view_table.add{type="label",name="item_label",caption="blank"}
					end
					p.gui.left.tradingchest_buy.item_view_table.add{type="checkbox",name="current_item_button", state = false, style = global.buyingtradingchests.item_selected[item_index].."_gt_button_style"} --the style = item.name.."_gt_button_style" for now

					p.gui.left.tradingchest_buy.item_view_table.add{name="current_amount_table", type="table", colspan=2}
					p.gui.left.tradingchest_buy.item_view_table.current_amount_table.add{type="label",name="item_amount_label_constant",caption="Current amount: "}
					p.gui.left.tradingchest_buy.item_view_table.current_amount_table.add{type="label",name="item_amount_label",caption=comma_value(global.buyingtradingchests.item_amount[item_index])}

					p.gui.left.tradingchest_buy.item_view_table.add{name="current_ppu_table", type="table", colspan=3}
					p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.add{type="label",name="item_ppu_label_constant_1",caption="Current Price Per Unit (PPU): "}
					p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.add{type="label",name="item_ppu_label"}
					if global.buyingtradingchests.item_selected[item_index] ~= "blank" then
						p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=comma_value(gt_get_item_value(global.buyingtradingchests.item_selected[item_index],1))
					else
						p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=0
					end

					p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.add{type="label",name="item_ppu_label_constant_2",caption=" credits"}

					p.gui.left.tradingchest_buy.item_view_table.add{name="current_cost_table", type="table", colspan=3}
					p.gui.left.tradingchest_buy.item_view_table.current_cost_table.add{type="label",name="item_cost_label_constant_1",caption="Current cost: "}
					credit_cost = 0
					if global.buyingtradingchests.item_selected[item_index] ~= "blank" then
						item_count = p.opened.get_inventory(1).get_item_count(global.buyingtradingchests.item_selected[item_index])
						item_difference = global.buyingtradingchests.item_amount[item_index] - item_count
						credit_cost = gt_get_item_value(global.buyingtradingchests.item_selected[item_index],item_difference)
					else
						credit_cost = 0
					end
					if credit_cost < 0 then
						credit_cost = 0
					end
					p.gui.left.tradingchest_buy.item_view_table.current_cost_table.add{type="label",name="item_cost_label_constant",caption=comma_value(credit_cost)}
					p.gui.left.tradingchest_buy.item_view_table.current_cost_table.add{type="label",name="item_cost_label_constant_2",caption=" credits"}

					p.gui.left.tradingchest_buy.item_view_table.add{type="textfield",name="item_amount_field"}
					p.gui.left.tradingchest_buy.item_view_table.item_amount_field.text = global.buyingtradingchests.item_amount[item_index]

					p.gui.left.tradingchest_buy.add{name="gt_buttons", type="table", colspan=1}
					if not(global.gt_auto_update_info) then
						p.gui.left.tradingchest_buy.gt_buttons.add{type="button", name="amount_update_button", style="button_style",caption="Update Amount"}
					end
					p.gui.left.tradingchest_buy.gt_buttons.add{name="gt_cp_buttons_table", type="table", colspan=2}
					p.gui.left.tradingchest_buy.gt_buttons.gt_cp_buttons_table.add{type="button", name="buying_chest_copy", style="button_style",caption="Copy"}
					p.gui.left.tradingchest_buy.gt_buttons.gt_cp_buttons_table.add{type="button", name="buying_chest_paste", style="button_style",caption="Paste"}
					if global.gt_instant_buy_button_enabled then
						p.gui.left.tradingchest_buy.gt_buttons.add{type="button", name="instant_buy_button", style="button_style",caption="Instant Buy"} --only for testing
					end

					--gui which has all buyable items

					p.gui.left.add{type="frame", name="item_selection", style='frame_style', direction='horizontal'}

					p.gui.left.item_selection.add{name="gt_selection_table", type="table", colspan=3}
					p.gui.left.item_selection.gt_selection_table.add{type="label",name="gt_selection_top_center_label",caption=""}
					p.gui.left.item_selection.gt_selection_table.add{type="table",name="gt_selection_top_center_table", colspan=3}
					p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="textfield",name="gt_search_bar_textfield"}
					if not(global.gt_auto_update_info) then
						p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="button",name="gt_search_bar_button",caption="search"}
					else
						p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="label",name="gt_selection_top_center_label2",caption="     "}
					end
					p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="label",name="item_selection_label", caption = "Choose an item to buy below"}
					p.gui.left.item_selection.gt_selection_table.add{type="label",name="item_selection_page_num_label", caption = "page "..global.gt_current_buying_trading_page[index]+1}
					p.gui.left.item_selection.gt_selection_table.add{type="button", name="gt_page_left_button", style="button_style",caption="<<"}

					p.gui.left.item_selection.gt_selection_table.add{name="item_table", type="table", colspan=global.gt_items_per_row[index]}
					p.gui.left.item_selection.gt_selection_table.add{type="button", name="gt_page_right_button", style="button_style",caption=">>"}
					p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.gt_search_bar_textfield.text=global.gt_current_search_term[index]

					items = 0
					if global.gt_current_buying_trading_page[index] == 0 then
						p.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name="blank".."_selection_button",state = false, style = "blank".."_gt_button_style"} --makes it to where is an option to buy nothing
						items = items + 1 --adds one for the "blank" item
					end
					current_item = 0
					for s, item in pairs(game.item_prototypes) do
						if gt_get_item_value(item.name, 1) > 0 and not(global.gt_blacklist[item.name]) then
							if current_item >= (global.gt_current_buying_trading_page[index]*global.gt_items_per_row[index]*global.gt_items_per_collum[index]) and (global.gt_current_search_term[index] == "" or string.match(item.name,global.gt_current_search_term[index])) then
								p.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name=item.name.."_selection_button",state = false, style = item.name.."_gt_button_style"}
								items = items + 1
								if items >= global.gt_items_per_row[index]*global.gt_items_per_collum[index] then
									break
								end
							end
							current_item = current_item + 1
						end
					end
				else
					if global.gt_auto_update_info then
						gt_update_opened_buying_chest_info(index)
						gt_update_items_shown(index)
					end
				end
			end

			if p.opened.name == "trading-chest-sell" or p.opened.name == "logistic-trading-chest-sell" then
				if p.gui.left.tradingchest_sell == nil then --selling chest gui
					p.gui.left.add{type="frame", name="tradingchest_sell", caption = 'Selling Info', style='frame_style', direction='vertical'}

					item_index = get_opened_sellingchest_index(index)

					if global.sellingtradingchests.enabled[item_index] == nil then
						if global.sellingtradingchests.enabled == nil then
							global.sellingtradingchests.enabled = {}
						end
						global.sellingtradingchests.enabled[item_index] = true
					end

					p.gui.left.tradingchest_sell.add{type="table", name="tradingchest_sell_table",colspan=1}

					if not(global.gt_shared_wallet) and #game.players > 1 then
						p.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="label",name="owner_label",caption="Owner: "..get_player(global.buyingtradingchests.player_id[item_index]).name}
					end

					p.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="checkbox",name="sellingchest_enabled_checkbox",state=global.sellingtradingchests.enabled[item_index], caption="Enabled"}

					p.gui.left.tradingchest_sell.tradingchest_sell_table.add{name="merch_info_table", type="table", colspan=3} --table of labels that tells merchant cut
					p.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_info_label_constant_1", caption="Trade Efficiency: "}
					p.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_cut_label", caption=gt_get_trade_efficiency()*100}
					p.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_info_label_constant_2", caption="%"}

					p.gui.left.tradingchest_sell.tradingchest_sell_table.add{name="chest_value_table", type="table", colspan=3}
					p.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.add{type="label", name="chest_value_label_constant_1", caption="Value of items in chest: "}
					chest_value = 0
					for a, b in pairs(global.sellingtradingchests.chest) do
						if b ~= nil then
							if b.position.x == p.opened.position.x and b.position.y == p.opened.position.y then
								for item, z in pairs(b.get_inventory(1).get_contents()) do
									if gt_get_item_value(item,1) > 0 then
										if item ~= "coin" then
											chest_value = chest_value + (gt_get_item_value(item,z)-(gt_get_item_value(item,z)*gt_get_trade_efficiency()))
										else
											chest_value = chest_value + gt_get_item_value(item,z)
										end
									end
								end
								break
							end
						end
					end
					chest_value = math.floor(chest_value)
					p.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.add{type="label", name="chest_value_label", caption=comma_value(chest_value)}
					if not(global.gt_auto_update_info) then
						p.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="button",name="update_chest_value_button",caption="Update"}
					end
					if global.gt_instant_sell_button_enabled then
						p.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="button",name="instant_sell_button",caption="Instant Sell"}
					end
				else
					gt_update_opened_selling_chest_info(index)
				end
			end

		else
			if p.gui.left.tradingchest_buy ~= nil then
				p.gui.left.tradingchest_buy.destroy()
			end
			if p.gui.left.item_selection ~= nil then
				p.gui.left.item_selection.destroy()
			end
			if p.gui.left.tradingchest_sell ~= nil then
				p.gui.left.tradingchest_sell.destroy()
			end
		end
	end



	local time = event.tick

	if 0.0 <= time and time <=0.01 and not global.gt_traded_today and #game.players > 0 then
		if #global.buyingtradingchests >0 or #global.sellingtradingchests >0 then
			message_all_players("The trade ship is here to trade resources")
		end

		global.gt_traded_today = true
		
		if global.sellingtradingchests.chest ~= nil then --daily selling resources
			for i,c in pairs(global.sellingtradingchests.chest) do
				sell_resources_from_chest(c)
			end
		end
		if global.buyingtradingchests.chest ~= nil then --daily buying resources
			for i,c in pairs(global.buyingtradingchests.chest) do
				buy_resources_from_chest(c)
			end
		end
	end

	if 0.1<=time and time <=0.11 then
		global.gt_traded_today = false
	end
end)

function create_transaction_info_gui(player_index)
	if p.gui.top.gt_info_frame ~= nil then
		p.gui.top.gt_info_frame.destroy()
	end
	transaction_id = 1
	if not(global.gt_shared_wallet) then
		transaction_id = global.gt_current_viewing_player_transaction_info[player_index]
	end
	p.gui.top.add{type="frame",name="gt_info_frame", caption = "Galactic Trade Transactions", direction='vertical'}
	p.gui.top.gt_info_frame.add{type="table",name="gt_info_transaction_values_table",colspan=2}
	if player_index == 1 then
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="button",name="gt_recalc_values_button",caption="Recalculate Market Values"}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="button",name="gt_reload_config",caption="Reload Config"}
	end
	if not(global.gt_shared_wallet) and #game.players > 1 then
		pt_table = p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="table",name="gt_transaction_info_player_select_table",colspan=3}
		pt_table.add{type="button",name="gt_previous_player_info_button",caption="<"}
		pt_table.add{type="label",name="gt_info_current_showing_player",caption=get_player(transaction_id).name}
		pt_table.add{type="button",name="gt_next_player_info_button",caption=">"}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_blank_label_2",caption=""}
	end

	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_1",caption="Current Transaction Expenses: "}
	gt_expenses = 0

	for i, c in ipairs(global.buyingtradingchests.chest) do
		if transaction_id == global.buyingtradingchests.player_id[i] and global.buyingtradingchests.enabled[i] and global.buyingtradingchests.item_selected[i] ~= "blank" and tonumber(global.buyingtradingchests.item_amount[i]) > 0 then
			item_count = c.get_inventory(1).get_item_count(global.buyingtradingchests.item_selected[i])
			if item_count < tonumber(global.buyingtradingchests.item_amount[i]) then
				credit_cost = 0
				if global.buyingtradingchests.item_selected[i] ~= "blank" then
					item_difference = tonumber(global.buyingtradingchests.item_amount[i]) - item_count
					available_space = 0
					contents = c.get_inventory(1).get_contents()
					c.get_inventory(1).clear()
					slots_available = c.get_inventory(1).getbar()
					for name, amount in pairs(contents) do
						if name ~= global.buyingtradingchests.item_selected[i] then
							slots_available = slots_available - math.ceil(amount/game.item_prototypes[global.buyingtradingchests.item_selected[i]].stack_size)
						end
					end

					if slots_available>0 then
						max_buy_amount = (slots_available * game.item_prototypes[global.buyingtradingchests.item_selected[i]].stack_size) - item_count
						if item_difference > max_buy_amount then
							item_difference = max_buy_amount
						end
					else
						slots_available = 0
					end


					credit_cost = gt_get_item_value(global.buyingtradingchests.item_selected[i],item_difference)
				else
					credit_cost = 0
				end
				if item_difference < 0 then
					item_difference = 0
				end
				gt_expenses = gt_expenses + credit_cost
			end
		end
	end

	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_expenses",caption="- "..comma_value(gt_expenses).." credits"}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_2",caption="Current Transaction Profit: "}

	gt_profit = 0

	for i, c in ipairs(global.sellingtradingchests.chest) do
		for item, z in pairs(c.get_inventory(1).get_contents()) do
			if transaction_id == global.sellingtradingchests.player_id[i] then
				v = (gt_get_item_value(item,z))-(gt_get_item_value(item,z) * gt_get_trade_efficiency())
				v = math.floor(v)
				if v > 0 then
					gt_profit = gt_profit + v
				end
			end
		end
	end

	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_profit",caption="+ "..comma_value(gt_profit).." credits"}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_3",caption="Current Transaction Total: "}
	gt_total = gt_profit - gt_expenses
	gt_sign = ""
	if gt_total > 0 then
		gt_sign = "+ "
	elseif gt_total == 0 then
		gt_sign = "  "
	elseif gt_total<0 then
		gt_sign = " "
	end
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_total",caption=gt_sign..comma_value(gt_total).." credits"}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_4",caption="Expected Gross: "}
	gt_gross = global.gt_credits[transaction_id] + gt_total
	gt_sign = ""
	if gt_gross > 0 then
		gt_sign = "+ "
	elseif gt_gross == 0 then
		gt_sign = "  "
	elseif gt_gross<0 then
		gt_sign = " "
	end
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_expected_gross",caption=gt_sign..comma_value(gt_gross).." credits"}

	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_5",caption=""}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_6",caption=""}

	total_expenses = 0
	total_profit = 0

	for a, b in pairs(global.gt_transaction_history[transaction_id]) do
		total_expenses = total_expenses + b.expenses
		total_profit = total_profit + b.profit
	end

	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_7",caption="Total Expenses: "}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_total_expenses",caption="- "..comma_value(total_expenses).." credits"}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_8",caption="Total Profit: "}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_total_profit",caption="+ "..comma_value(total_profit).." credits"}
	gt_sign = ""
	if total_profit-total_expenses > 0 then
		gt_sign = "+ "
	elseif total_profit-total_expenses == 0 then
		gt_sign = "  "
	elseif total_profit-total_expenses<0 then
		gt_sign = " "
	end
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_9",caption="Net Total: "}
	p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_total_credits",caption=gt_sign..comma_value((total_profit-total_expenses)).." credits"}

	if #global.gt_transaction_history[transaction_id] > 0 then
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_10",caption=""}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_11",caption=""}

		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="table",name="gt_info_transaction_history_table",colspan=5}

		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.add{type="button",name="gt_first_transaction",caption="|<"}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.add{type="button",name="gt_previous_transaction",caption="<"}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.add{type="label",name="gt_transaction_history_day",caption="Transaction: "..global.gt_history_day}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.add{type="button",name="gt_next_transaction",caption=">"}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.add{type="button",name="gt_last_transaction",caption=">|"}

		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_12",caption=""}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_13",caption=""}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_14",caption=""}

		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_15",caption="Expenses: "}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_transaction_history_expenses",caption="- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_16",caption="Profit: "}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_transaction_history_profit",caption="+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"}
		gt_sign = ""
		hist_total = global.gt_transaction_history[transaction_id][global.gt_history_day].profit - global.gt_transaction_history[transaction_id][global.gt_history_day].expenses
		if hist_total > 0 then
			gt_sign = "+ "
		elseif hist_total == 0 then
			gt_sign = "  "
		elseif hist_total<0 then
			gt_sign = " "
		end
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_17",caption="Total: "}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_transaction_history_total",caption=gt_sign..comma_value(hist_total).." credits"}
	end

end

script.on_event(defines.events.on_gui_click, function(event)
	p = get_player(event.player_index)
	if event.element.name == "gt_info_button" then
		if p.gui.top.gt_info_frame ~= nil then
			p.gui.top.gt_info_frame.destroy()
		else
			create_transaction_info_gui(event.player_index)
		end
	elseif event.element.name == "gt_previous_player_info_button" then
		if global.gt_current_viewing_player_transaction_info[event.player_index] > 1 then
			global.gt_current_viewing_player_transaction_info[event.player_index] = global.gt_current_viewing_player_transaction_info[event.player_index] - 1
			create_transaction_info_gui(event.player_index)
		end
	elseif event.element.name == "gt_next_player_info_button" then
		if global.gt_current_viewing_player_transaction_info[event.player_index] < #game.players then
			global.gt_current_viewing_player_transaction_info[event.player_index] = global.gt_current_viewing_player_transaction_info[event.player_index] + 1
			create_transaction_info_gui(event.player_index)
		end
	elseif event.element.name == "gt_previous_transaction" then
		if global.gt_history_day > 1 then
			global.gt_history_day =global.gt_history_day - 1
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.gt_transaction_history_day.caption = "Transaction: "..global.gt_history_day
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_expenses.caption = "- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_profit.caption = "+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"
			gt_sign = ""
			hist_total = global.gt_transaction_history[transaction_id][global.gt_history_day].profit - global.gt_transaction_history[transaction_id][global.gt_history_day].expenses
			if hist_total > 0 then
				gt_sign = "+ "
			elseif hist_total == 0 then
				gt_sign = "  "
			elseif hist_total<0 then
				gt_sign = " "
			end
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(hist_total).." credits"
		end
	elseif event.element.name == "gt_next_transaction" then
		if global.gt_history_day < #global.gt_transaction_history[transaction_id] then
			global.gt_history_day =global.gt_history_day + 1
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.gt_transaction_history_day.caption = "Transaction: "..global.gt_history_day
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_expenses.caption = "- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_profit.caption = "+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"
			gt_sign = ""
			hist_total = global.gt_transaction_history[transaction_id][global.gt_history_day].profit - global.gt_transaction_history[transaction_id][global.gt_history_day].expenses
			if hist_total > 0 then
				gt_sign = "+ "
			elseif hist_total == 0 then
				gt_sign = "  "
			elseif hist_total<0 then
				gt_sign = " "
			end
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(hist_total).." credits"
		end
	elseif event.element.name == "gt_first_transaction" then
		global.gt_history_day = 1
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.gt_transaction_history_day.caption = "Transaction: "..global.gt_history_day
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_expenses.caption = "- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_profit.caption = "+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"
		gt_sign = ""
		hist_total = global.gt_transaction_history[transaction_id][global.gt_history_day].profit - global.gt_transaction_history[transaction_id][global.gt_history_day].expenses
		if hist_total > 0 then
			gt_sign = "+ "
		elseif hist_total == 0 then
			gt_sign = "  "
		elseif hist_total<0 then
			gt_sign = " "
		end
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(hist_total).." credits"
	elseif event.element.name == "gt_last_transaction" then
		global.gt_history_day = #global.gt_transaction_history[transaction_id]
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.gt_transaction_history_day.caption = "Transaction: "..global.gt_history_day
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_expenses.caption = "- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_profit.caption = "+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"
		gt_sign = ""
		hist_total = global.gt_transaction_history[transaction_id][global.gt_history_day].profit - global.gt_transaction_history[transaction_id][global.gt_history_day].expenses
		if hist_total > 0 then
			gt_sign = "+ "
		elseif hist_total == 0 then
			gt_sign = "  "
		elseif hist_total<0 then
			gt_sign = " "
		end
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(hist_total).." credits"
	elseif event.element.name == "gt_recalc_values_button" then
		initiate_reload_item_values()
	elseif event.element.name == "gt_reload_config" then
		load_config(event.player_index)
	else
		gt_trading_chest_button_click(event)
	end
end)