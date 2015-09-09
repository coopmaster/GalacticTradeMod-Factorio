require "defines"
require("prototypes.scripts.trading-chest")
require 'config'
--require "luasocket"

--game.getplayer(index or name) for multiplayer support

function comma_value(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
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

local function load_values(player_index)
	global.gt_total_items = global.gt_total_items or 0

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

	global.gt_time_value = global.gt_time_value or 2
	global.gt_smelting_value = global.gt_smelting_value or 15
	global.gt_credits = global.gt_credits or {}
	global.gt_credits[player_index] = global.gt_credits[player_index] or global.gt_starting_credits
	global.trader_cut_percentage = global.trader_cut_percentage or 0.15 --15% 
	global.gt_clipboard_buy = global.gt_clipboard_buy or {}
	global.gt_clipboard_buy[player_index] = global.gt_clipboard_buy[player_index] or {}

	if global.gt_reload_item_values_on_load then
		global.gt_base_values = {}
		global.gt_blacklist = {}
		global.gt_smelted_items = {}
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

	global.gt_smelted_items = global.gt_smelted_items or {}
	
	global.gt_smelted_items["iron-plate"] = true
	global.gt_smelted_items["copper-plate"] = true
	global.gt_smelted_items["steel-plate"] = true
	global.gt_smelted_items["stone-brick"] = true

	for name, amount in pairs(global.gt_extra_smelted_items) do 
		global.gt_smelted_items[name] = value
	end

	global.gt_supply = global.gt_supply or {}
	global.gt_demand = global.gt_demand or {}

	for name, value in pairs(global.gt_base_values) do--add initial supply to items
		global.gt_supply[name] = global.gt_supply[name] or math.ceil((math.sqrt(global.gt_initial_supply_modifier)*-value)+global.gt_initial_supply_modifier)
	end

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

	if game.get_player(player_index).gui.top.gt_money ~= nil then
		game.get_player(player_index).gui.top.gt_money.destroy()
		game.get_player(player_index).gui.top.gt_info_button.destroy()
	end
	if game.get_player(player_index).gui.top.gt_info_frame then
		game.get_player(player_index).gui.top.gt_info_frame.destroy()
	end

end

local function create_gui(player_index)
	remove_gui(player_index)
	if game.get_player(player_index).gui.top.gt_money == nil then
		game.get_player(player_index).gui.top.add{type="frame", name="gt_money", caption = '', style='frame_style', direction='vertical'}
		game.get_player(player_index).gui.top.gt_money.add{type="label", name="gt_credits", caption="0 credits"}
		game.get_player(player_index).gui.top.add{type="button",name="gt_info_button",caption="Transactions"}
	end

end

game.on_init(function()
	for i in pairs(game.players) do
		load_values(i)
	end
end)

game.on_load(function()

end)

game.on_save(function()
	--remove_gui()
end)

local tmp_values = {}
function gt_get_item_value(item, num)
	local value = 0
	if global.gt_base_values[item] == nil then
		if game.get_player(1).force.recipes[item] == nil then -- don't care if blacklisted because we still want the value to be saved if it can be found
			global.gt_base_values[item] = 0
			return 0
		else
			for i, a in pairs(game.get_player(1).force.recipes[item].ingredients) do
				if tmp_values[a.name] == -1 then
					global.gt_base_values[item] = 0
					return 0
				end
				tmp_values[a.name] = -1
				sub_value = gt_get_item_value(a.name, a.amount)
				tmp_values[a.name] = 0
				if sub_value == 0 then
					global.gt_base_values[item] = 0
					return 0
				else
					value = value + sub_value
				end
			end
			result_num = 1
			for _, b in pairs(game.get_player(1).force.recipes[item].products) do
				if b.name == item then
					result_num = b.amount
				end
			end
			value = math.ceil(value / result_num)
			value = value + math.floor(game.get_player(1).force.recipes[item].energy) --adds value for crafting time
			if global.gt_smelted_items[item] ~= nil and global.gt_smelted_items[item] ~= false then
				value = value + global.gt_smelting_value
			end
			global.gt_base_values[item] = value
			value = value * num
		end
	else
		value = global.gt_base_values[item] * num
		return value
	end
	return value
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
	p = game.get_player(player_index)
	p.gui.center.add{type="frame", name="item_value_loading_frame", caption = 'Loading Item Values for Galactic Trade...', style='frame_style', direction='vertical'}
	p.gui.center.item_value_loading_frame.add{name="item_value_loading_table", type="table", colspan=1}
	p.gui.center.item_value_loading_frame.item_value_loading_table.add{name="item_value_loading_progress", type="progressbar", size=global.gt_total_items_unfiltered, value = 0}
	p.gui.center.item_value_loading_frame.item_value_loading_table.add{name="item_value_loading_label", type="label", caption = "0/"..global.gt_total_items_unfiltered}
end

function message_all_players(message)
	for i in pairs(game.players) do
		game.get_player(i).print(message)
	end
end

function get_selling_price(item,amount)
	if item ~= "coin" then
		price = gt_get_item_value(item,amount)-(gt_get_item_value(item,amount) * global.trader_cut_percentage)
	else
		price = gt_get_item_value(item,amount)
	end
end

function get_buying_price(item,amount) --not much yet
	return gt_get_item_value(item,amount)
end

function sell_resources_from_chest(chest)

end

game.on_event(defines.events.on_player_created, function(event)
	load_values(event.player_index)
	create_gui(event.player_index)
	if event.player_index == 1 then
		initiate_reload_item_values()
	end
end)

game.on_event(defines.events.on_tick, function(event)

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
			if value ~= 0 then
				global.gt_base_values[current_item.name] = value
				global.gt_total_items = global.gt_total_items + 1
			else
				if game.get_player(1).force.recipes[current_item.name]==nil and (global.gt_blacklist[current_item.name]==nil or global.gt_blacklist[current_item.name]== false) then
					in_list = false
					for a, b in pairs(global.gt_items_without_cost) do
						if b == current_item.name then
							in_list	= true
						end
					end
					if not(in_list) then
						table.insert(global.gt_items_without_cost,current_item.name)
						global.gt_blacklist[current_item.name] = true
					end
					global.gt_blacklist[current_item.name] = true
				end
			end
		else
			if current_item ~= nil and global.gt_base_values[current_item.name] ~= 0 then
				global.gt_total_items = global.gt_total_items + 1
			end
		end
		if global.gt_show_loading_gui then
			game.get_player(1).gui.center.item_value_loading_frame.item_value_loading_table.item_value_loading_progress.value = game.get_player(1).gui.center.item_value_loading_frame.item_value_loading_table.item_value_loading_progress.value + (1/global.gt_total_items_unfiltered)
			game.get_player(1).gui.center.item_value_loading_frame.item_value_loading_table.item_value_loading_label.caption = global.gt_loading_index.."/"..global.gt_total_items_unfiltered
		end
		global.gt_loading_index = global.gt_loading_index + 1
	else 
		if #game.players >0 and game.tick > 2 and not(global.gt_loading_done) then
			global.gt_loading_index = 0
			global.gt_loading_done = true
			if game.get_player(1).gui.center.item_value_loading_frame ~= nil then
				game.get_player(1).gui.center.item_value_loading_frame.destroy()
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
				game.makefile("GalacticTrade/TroubleItems.txt",s)
				game.get_player(1).print("There are "..#global.gt_items_without_cost.." base resoureces (items without recipies) without cost (listed above)")
				game.get_player(1).print("Go to your factorio directory, inside of the \"script-output\\GalacticTrade\\TroubleItems.txt\" file for more information.")
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
			game.makefile("GalacticTrade/ItemValues.txt",output)
		end
	end

	for index in pairs(game.players) do
		if game.get_player(index).gui.top.gt_money ~= nil then
			if not(global.gt_shared_wallet) then
	  			game.get_player(index).gui.top.gt_money.gt_credits.caption = "credits: "..comma_value(math.floor(global.gt_credits[index]))
	  		else
	  			game.get_player(index).gui.top.gt_money.gt_credits.caption = "credits: "..comma_value(math.floor(global.gt_credits[1]))
	  		end
	  	else
	  		create_gui(index)
		end
		p = game.get_player(index)
		if p.opened ~= nil and p.opened.valid then

			if (p.opened.name == "trading-chest-buy" or p.opened.name == "logistic-trading-chest-buy") and p.gui.left.tradingchest_buy == nil then --buying chest gui

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
					p.gui.left.tradingchest_buy.item_view_table.add{type="label",name="owner_label",caption="Owner: "..game.get_player(global.buyingtradingchests.player_id[item_index]).name}
				end
				p.gui.left.tradingchest_buy.item_view_table.add{type="checkbox",name="buyingchest_enabled_checkbox",state=global.buyingtradingchests.enabled[item_index], caption="Enabled"}
				if global.buyingtradingchests.item_selected[item_index] ~= "blank" then
					p.gui.left.tradingchest_buy.item_view_table.add{type="label",name="item_label",caption=game.get_localised_item_name(global.buyingtradingchests.item_selected[item_index])}
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
				p.gui.left.tradingchest_buy.gt_buttons.add{type="button", name="amount_update_button", style="button_style",caption="Update Amount"}
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
				p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="button",name="gt_search_bar_button",caption="search"}
				p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="label",name="item_selection_label", caption = "Choose an item to buy"}
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
					if gt_get_item_value(item.name, 1) ~= 0 and (global.gt_blacklist[item.name]==nil or global.gt_blacklist[item.name]==false) then
						if current_item >= (global.gt_current_buying_trading_page[index]*global.gt_items_per_row[index]*global.gt_items_per_collum[index])+1 and (global.gt_current_search_term[index] == "" or string.match(item.name,global.gt_current_search_term[index])) then
							p.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name=item.name.."_selection_button",state = false, style = item.name.."_gt_button_style"}
							items = items + 1
							if items >= global.gt_items_per_row[index]*global.gt_items_per_collum[index] then
								break
							end
						end
						current_item = current_item + 1
					end
				end
			end

			if (p.opened.name == "trading-chest-sell" or p.opened.name == "logistic-trading-chest-sell") and p.gui.left.tradingchest_sell == nil then --selling chest gui
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
					p.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="label",name="owner_label",caption="Owner: "..game.get_player(global.buyingtradingchests.player_id[item_index]).name}
				end

				p.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="checkbox",name="sellingchest_enabled_checkbox",state=global.sellingtradingchests.enabled[item_index], caption="Enabled"}

				p.gui.left.tradingchest_sell.tradingchest_sell_table.add{name="merch_info_table", type="table", colspan=3} --table of labels that tells merchant cut
				p.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_info_label_constant_1", caption="Merchant Cut: "}
				p.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_cut_label", caption=global.trader_cut_percentage*100}
				p.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_info_label_constant_2", caption="%"}

				p.gui.left.tradingchest_sell.tradingchest_sell_table.add{name="chest_value_table", type="table", colspan=3}
				p.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.add{type="label", name="chest_value_label_constant_1", caption="Value of items in chest: "}
				chest_value = 0
				for a, b in pairs(global.sellingtradingchests.chest) do
					if b ~= nil then
						if b.position.x == p.opened.position.x and b.position.y == p.opened.position.y then
							for item, z in pairs(b.get_inventory(1).get_contents()) do
								if gt_get_item_value(item,1) ~= 0 then
									if item ~= "coin" then
										chest_value = chest_value + (gt_get_item_value(item,z)-(gt_get_item_value(item,z)*global.trader_cut_percentage))
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
				p.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="button",name="update_chest_value_button",caption="Update"}
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



	local time = game.daytime

	if 0.0 <= time and time <=0.01 and not global.gt_traded_today and #game.players > 0 then
		for i in pairs(global.buyingtradingchests.chest) do 
			if global.gt_enable_trade_alert[i] and (#global.buyingtradingchests.chest > 0 or #global.sellingtradingchests.chest > 0) then
				game.get_player(i).print("The trade ship is here to trade resources")
			end
		end

		global.gt_traded_today = true
		
		total_sellingprice = {}
		total_sellingprice[1] = 0
		if global.sellingtradingchests.chest ~= nil then --daily selling resources
			for i in pairs(global.sellingtradingchests.chest) do
				if global.sellingtradingchests.enabled[i] then
					contents = global.sellingtradingchests.chest[i].get_inventory(1).get_contents()
					for a, b in pairs(contents) do
						if gt_get_item_value(a,1) ~= 0 then
							if a ~= "coin" then
								sellingprice = gt_get_item_value(a,b)-(gt_get_item_value(a,b) * global.trader_cut_percentage)
							else
								sellingprice = gt_get_item_value(a,b)
							end
							sellingprice = math.floor(sellingprice)
							if not(global.gt_shared_wallet) then
								global.gt_credits[global.sellingtradingchests.player_id[i]] = global.gt_credits[global.sellingtradingchests.player_id[i]] + sellingprice
								total_sellingprice[global.sellingtradingchests.player_id[i]] = total_sellingprice[global.sellingtradingchests.player_id[i]] or 0
								total_sellingprice[global.sellingtradingchests.player_id[i]] = total_sellingprice[global.sellingtradingchests.player_id[i]] + sellingprice
							else
								global.gt_credits[1] = global.gt_credits[1] + sellingprice
								total_sellingprice[1] = total_sellingprice[1] + sellingprice
							end
							global.sellingtradingchests.chest[i].get_inventory(1).remove({name = a, count = b})
						else
							message_all_players(a .. " has no value on the galactic market")
						end
					end
				end
			end
		end
		total_buyingprice = {}
		total_buyingprice[1] = 0
		if global.buyingtradingchests.chest ~= nil then --daily buying resources
			for i in pairs(global.buyingtradingchests.chest) do
				if global.buyingtradingchests.enabled[i] and global.buyingtradingchests.item_selected[i] ~= "blank" and tonumber(global.buyingtradingchests.item_amount[i]) > 0 then
					item_count = global.buyingtradingchests.chest[i].get_inventory(1).get_item_count(global.buyingtradingchests.item_selected[i])
					if item_count < tonumber(global.buyingtradingchests.item_amount[i]) then
						credit_cost = 0
						if global.buyingtradingchests.item_selected[i] ~= "blank" then
							item_difference = tonumber(global.buyingtradingchests.item_amount[i]) - item_count
							available_space = 0
							contents = global.buyingtradingchests.chest[i].get_inventory(1).get_contents()
							global.buyingtradingchests.chest[i].get_inventory(1).clear()
							slots_available = global.buyingtradingchests.chest[i].get_inventory(1).getbar()
							for name, amount in pairs(contents) do
								global.buyingtradingchests.chest[i].get_inventory(1).insert({name = name, count = amount})
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

						if not(global.gt_shared_wallet) then
							if credit_cost>global.gt_credits[global.buyingtradingchests.player_id[i]] and gt_get_item_value(global.buyingtradingchests.item_selected[i],1) <= global.gt_credits[global.buyingtradingchests.player_id[i]] then
								item_difference = math.floor(global.gt_credits[global.buyingtradingchests.player_id[i]]/get_item_value(global.buyingtradingchests.item_selected[i],1))
								credit_cost = gt_get_item_value(global.buyingtradingchests.item_selected[i],item_difference)
							end
						else
							if credit_cost>global.gt_credits[1] and gt_get_item_value(global.buyingtradingchests.item_selected[i],1) <= global.gt_credits[1] then
								item_difference = math.floor(global.gt_credits[1]/get_item_value(global.buyingtradingchests.item_selected[i],1))
								credit_cost = gt_get_item_value(global.buyingtradingchests.item_selected[i],item_difference)
							end
						end

						if item_difference < 0 then
							item_difference = 0
						end

						if not(global.gt_shared_wallet) then
							if global.gt_credits[global.buyingtradingchests.player_id[i]] - credit_cost >= 0 and global.buyingtradingchests.item_selected[i] ~= "blank"  then
								if item_difference > 0 then
									global.buyingtradingchests.chest[i].insert({name = global.buyingtradingchests.item_selected[i], count = item_difference})
									global.gt_credits[global.buyingtradingchests.player_id[i]] = global.gt_credits[global.buyingtradingchests.player_id[i]] - credit_cost
									total_buyingprice[global.buyingtradingchests.player_id[i]] = total_buyingprice[global.buyingtradingchests.player_id[i]] or 0
									total_buyingprice[global.buyingtradingchests.player_id[i]] = total_buyingprice[global.buyingtradingchests.player_id[i]] + credit_cost
								end
							else
								message_all_players("Unable to complete one or more of your orders")
							end
						else
							if global.gt_credits[1] - credit_cost >= 0 and global.buyingtradingchests.item_selected[i] ~= "blank"  then
								if item_difference > 0 then
									global.buyingtradingchests.chest[i].insert({name = global.buyingtradingchests.item_selected[i], count = item_difference})
									global.gt_credits[1] = global.gt_credits[1] - credit_cost
									total_buyingprice[1] = total_buyingprice[1] + credit_cost
								end
							else
								message_all_players("Unable to complete one or more of your orders")
							end
						end
					end
				end
			end
		end
		if not(global.gt_shared_wallet) then
			for i in ipairs(global.gt_transaction_history) do
				if total_sellingprice[i] ~= nil and total_buyingprice[i] ~= nil then
					h = {}
					h.profit = total_sellingprice[i]
					h.expenses = total_buyingprice[i]
					h.total = total_sellingprice[i]-total_buyingprice[i]
					if h.profit ~= 0 or h.expenses ~= 0 then
						table.insert(global.gt_transaction_history[i],h)
					end
				end
			end
		else
			h = {}
			h.profit = total_sellingprice[1]
			h.expenses = total_buyingprice[1]
			h.total = total_sellingprice[1]-total_buyingprice[1]
			if h.profit ~= 0 or h.expenses ~= 0 then
				table.insert(global.gt_transaction_history[1],h)
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
		pt_table.add{type="label",name="gt_info_current_showing_player",caption=game.get_player(transaction_id).name}
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
				v = (gt_get_item_value(item,z))-(gt_get_item_value(item,z) * global.trader_cut_percentage)
				v = math.floor(v)
				if v ~= 0 then
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
		if global.gt_transaction_history[transaction_id][global.gt_history_day].total > 0 then
			gt_sign = "+ "
		elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total == 0 then
			gt_sign = "  "
		elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total<0 then
			gt_sign = " "
		end
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_static_label_17",caption="Total: "}
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.add{type="label",name="gt_info_transaction_history_total",caption=gt_sign..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].total).." credits"}
	end

end

game.on_event(defines.events.on_gui_click, function(event)
	p = game.get_player(event.player_index)
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
			if global.gt_transaction_history[transaction_id][global.gt_history_day].total > 0 then
				gt_sign = "+ "
			elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total == 0 then
				gt_sign = "  "
			elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total<0 then
				gt_sign = " "
			end
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].total).." credits"
		end
	elseif event.element.name == "gt_next_transaction" then
		if global.gt_history_day < #global.gt_transaction_history[transaction_id] then
			global.gt_history_day =global.gt_history_day + 1
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.gt_transaction_history_day.caption = "Transaction: "..global.gt_history_day
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_expenses.caption = "- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_profit.caption = "+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"
			gt_sign = ""
			if global.gt_transaction_history[transaction_id][global.gt_history_day].total > 0 then
				gt_sign = "+ "
			elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total == 0 then
				gt_sign = "  "
			elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total<0 then
				gt_sign = " "
			end
			p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].total).." credits"
		end
	elseif event.element.name == "gt_first_transaction" then
		global.gt_history_day = 1
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.gt_transaction_history_day.caption = "Transaction: "..global.gt_history_day
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_expenses.caption = "- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_profit.caption = "+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"
		gt_sign = ""
		if global.gt_transaction_history[transaction_id][global.gt_history_day].total > 0 then
			gt_sign = "+ "
		elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total == 0 then
			gt_sign = "  "
		elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total<0 then
			gt_sign = " "
		end
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(global.gt_transaction_history[global.gt_history_day].total).." credits"
	elseif event.element.name == "gt_last_transaction" then
		global.gt_history_day = #global.gt_transaction_history[transaction_id]
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_table.gt_transaction_history_day.caption = "Transaction: "..global.gt_history_day
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_expenses.caption = "- "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].expenses).." credits"
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_profit.caption = "+ "..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].profit).." credits"
		gt_sign = ""
		if global.gt_transaction_history[transaction_id][global.gt_history_day].total > 0 then
			gt_sign = "+ "
		elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total == 0 then
			gt_sign = "  "
		elseif global.gt_transaction_history[transaction_id][global.gt_history_day].total<0 then
			gt_sign = " "
		end
		p.gui.top.gt_info_frame.gt_info_transaction_values_table.gt_info_transaction_history_total.caption = gt_sign..comma_value(global.gt_transaction_history[transaction_id][global.gt_history_day].total).." credits"
	elseif event.element.name == "gt_recalc_values_button" then
		initiate_reload_item_values()
	elseif event.element.name == "gt_reload_config" then
		load_config(event.player_index)
	else
		gt_trading_chest_button_click(event)
	end
end)