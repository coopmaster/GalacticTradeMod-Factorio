require "defines"

local tmp_values = {}
local function get_item_value(item, num)
	local value = 0
	if global.gt_values[item] == nil then
		if game.get_player(1).force.recipes[item] == nil then -- don't care if blacklisted because we still want the value to be saved if it can be found
			return 0
		else

			for i, a in pairs(game.get_player(1).force.recipes[item].ingredients) do
				if tmp_values[a.name] == -1 then
					return 0
				end
				tmp_values[a.name] = -1
				sub_value = get_item_value(a.name, a.amount)
				tmp_values[a.name] = 0
				if sub_value == 0 then
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
			value = value + global.gt_time_value --adds value for crafting time
			if global.gt_smelted_items[item] ~= nil and global.gt_smelted_items[item] ~= false then
				value = value + global.gt_smelting_value
			end
			value = value * num
		end
	else
		value = global.gt_values[item] * num
		return value
	end
	return value
end

local function get_opened_buyingchest_index(player_index)
	index = 0
	for i, a in ipairs(global.buyingtradingchests) do --this gets the trading chest based off of the position of the one clicked on and based on what we have listed
		if a ~= nil then
			if a.position.x == game.get_player(player_index).opened.position.x and a.position.y == game.get_player(player_index).opened.position.y then
				index = i
				break
			end
		end
	end
	return index
end

game.on_event(defines.events.on_built_entity, function(event)
	if event.created_entity.name == "trading-chest-buy" or event.created_entity.name == "logistic-trading-chest-buy" then
		table.insert(global.buyingtradingchests, event.created_entity)
		table.insert(global.buyingtradingchests_itemselected, "blank")
		table.insert(global.buyingtradingchests_itemamount, 0)
		table.insert(global.buyingtradingchests_enabled, true)
	end
	if event.created_entity.name == "trading-chest-sell" or event.created_entity.name == "logistic-trading-chest-sell" then
		table.insert(global.sellingtradingchests, event.created_entity)
		table.insert(global.sellingtradingchests_enabled, true)
	end
 end)

game.on_event(defines.events.on_robot_built_entity, function(event)
	if event.created_entity.name == "trading-chest-buy" or event.created_entity.name == "logistic-trading-chest-buy" then
		table.insert(global.buyingtradingchests, event.created_entity)
		table.insert(global.buyingtradingchests_itemselected, "blank")
		table.insert(global.buyingtradingchests_itemamount, 0)
		table.insert(global.buyingtradingchests_enabled, true)
	end
	if event.created_entity.name == "trading-chest-sell" or event.created_entity.name == "logistic-trading-chest-sell" then
		table.insert(global.sellingtradingchests, event.created_entity)
		table.insert(global.sellingtradingchests_enabled, true)
	end
 end)

game.on_event(defines.events.on_preplayer_mined_item, function(event)
	if (event.entity.name == "trading-chest-buy" or event.entity.name == "logistic-trading-chest-buy") and global.buyingtradingchests ~= nil then
		temp = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_tmp = {}
		for i, a in ipairs(global.buyingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(item_tmp, global.buyingtradingchests_itemselected[i])
					table.insert(amount_tmp, global.buyingtradingchests_itemamount[i])
					table.insert(enabled_tmp, global.buyingtradingchests_enabled[i])
				end
			end
		end
		global.buyingtradingchests = temp
		global.buyingtradingchests_itemselected = item_tmp
		global.buyingtradingchests_itemamount = amount_tmp
		global.buyingtradingchests_enabled = enabled_tmp
	end
	if (event.entity.name == "trading-chest-sell" or event.entity.name == "logistic-trading-chest-sell") and global.sellingtradingchests ~= nil then
		temp = {}
		enabled_tmp = {}
		for i, a in ipairs(global.sellingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(enabled_tmp, global.sellingtradingchests_enabled[i])
				end
			end
		end
		global.sellingtradingchests = temp
	end
end)

game.on_event(defines.events.on_entity_died, function(event)
	if (event.entity.name == "trading-chest-buy" or event.entity.name == "logistic-trading-chest-buy") and global.buyingtradingchests ~= nil then
		temp = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_tmp = {}
		for i, a in ipairs(global.buyingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(item_tmp, global.buyingtradingchests_itemselected[i])
					table.insert(amount_tmp, global.buyingtradingchests_itemamount[i])
					table.insert(enabled_tmp, global.buyingtradingchests_enabled[i])
				end
			end
		end
		global.buyingtradingchests = temp
		global.buyingtradingchests_itemselected = item_tmp
		global.buyingtradingchests_itemamount = amount_tmp
		global.buyingtradingchests_enabled = enabled_tmp
	end
	if (event.entity.name == "trading-chest-sell" or event.entity.name == "logistic-trading-chest-sell") and global.sellingtradingchests ~= nil then
		temp = {}
		enabled_tmp = {}
		for i, a in ipairs(global.sellingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(enabled_tmp, global.sellingtradingchests_enabled[i])
				end
			end
		end
		global.sellingtradingchests = temp
	end
end)

game.on_event(defines.events.on_robot_pre_mined, function(event)
	if (event.entity.name == "trading-chest-buy" or event.entity.name == "logistic-trading-chest-buy") and global.buyingtradingchests ~= nil then
		temp = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_tmp = {}
		for i, a in ipairs(global.buyingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(item_tmp, global.buyingtradingchests_itemselected[i])
					table.insert(amount_tmp, global.buyingtradingchests_itemamount[i])
					table.insert(enabled_tmp, global.buyingtradingchests_enabled[i])
				end
			end
		end
		global.buyingtradingchests = temp
		global.buyingtradingchests_itemselected = item_tmp
		global.buyingtradingchests_itemamount = amount_tmp
		global.buyingtradingchests_enabled = enabled_tmp
	end
	if (event.entity.name == "trading-chest-sell" or event.entity.name == "logistic-trading-chest-sell") and global.sellingtradingchests ~= nil then
		temp = {}
		enabled_tmp = {}
		for i, a in ipairs(global.sellingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(enabled_tmp, global.sellingtradingchests_enabled[i])
				end
			end
		end
		global.sellingtradingchests = temp
	end
end)

function gt_trading_chest_button_click(event)
	p = game.get_player(event.player_index)
	if event.element.name == "amount_update_button" then
		item_index = get_opened_buyingchest_index(event.player_index)
		n = tonumber(p.gui.left.tradingchest_buy.item_view_table.item_amount_field.text)
		if n == nil then
			n = 0
			p.print("Please enter a valid number") --do not delete
		else
			global.buyingtradingchests_itemamount[item_index] = n
		end

		if global.buyingtradingchests_itemselected[item_index] ~= "blank" and p.opened.get_inventory(1).getbar() * game.item_prototypes[global.buyingtradingchests_itemselected[item_index]].stack_size < global.buyingtradingchests_itemamount[item_index] then
			global.buyingtradingchests_itemamount[item_index] = p.opened.get_inventory(1).getbar() * game.item_prototypes[global.buyingtradingchests_itemselected[item_index]].stack_size
		end

		p.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption = comma_value(global.buyingtradingchests_itemamount[item_index])
		
		credit_cost = 0
		if global.buyingtradingchests_itemselected[item_index] ~= "blank" then
			item_count = p.opened.get_inventory(1).get_item_count(global.buyingtradingchests_itemselected[item_index])
			item_difference = global.buyingtradingchests_itemamount[item_index] - item_count
			tmp_values = {}
			credit_cost = item_difference * get_item_value(global.buyingtradingchests_itemselected[item_index],1)
		else
			credit_cost = 0
		end
		if credit_cost < 0 then
			credit_cost = 0
		end
		p.gui.left.tradingchest_buy.item_view_table.current_cost_table.item_cost_label_constant.caption = comma_value(credit_cost)

		return
	end

	if event.element.name == "blank".."_selection_button" then
		global.buyingtradingchests_itemselected[item_index] = "blank"

		p.gui.left.tradingchest_buy.item_view_table.item_label.caption = "blank"
		p.gui.left.tradingchest_buy.item_view_table.current_item_button.style = "blank".."_gt_button_style"

		p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=0
		return
	end

	if event.element.name == "instant_buy_button" then 
		chest_index = get_opened_buyingchest_index(event.player_index)

		if global.buyingtradingchests_enabled[chest_index] and global.buyingtradingchests_itemselected[chest_index] ~= "blank" and tonumber(global.buyingtradingchests_itemamount[chest_index]) > 0 then
			item_count = p.opened.get_inventory(1).get_item_count(global.buyingtradingchests_itemselected[chest_index])
			if item_count < tonumber(global.buyingtradingchests_itemamount[chest_index]) then
				credit_cost = 0
				if global.buyingtradingchests_itemselected[chest_index] ~= "blank" then
					item_difference = tonumber(global.buyingtradingchests_itemamount[chest_index]) - item_count
					available_space = 0
					contents = p.opened.get_inventory(1).get_contents()
					p.opened.get_inventory(1).clear()
					slots_available = p.opened.get_inventory(1).getbar()
					for name, amount in pairs(contents) do
						p.opened.get_inventory(1).insert({name = name, count = amount})
						if name ~= global.buyingtradingchests_itemselected[chest_index] then
							slots_available = slots_available - math.ceil(amount/game.item_prototypes[global.buyingtradingchests_itemselected[chest_index]].stack_size)
						end
					end

					if slots_available>0 then
						max_buy_amount = (slots_available * game.item_prototypes[global.buyingtradingchests_itemselected[chest_index]].stack_size) - item_count
						if item_difference > max_buy_amount then
							item_difference = max_buy_amount
						end
					else
						slots_available = 0
					end


					credit_cost = get_item_value(global.buyingtradingchests_itemselected[chest_index],item_difference)
				else
					credit_cost = 0
				end
				if item_difference < 0 then
					item_difference = 0
				end
				if global.gt_credits - credit_cost >= 0 and global.buyingtradingchests_itemselected[chest_index] ~= "blank"  then
					if item_difference > 0 then
						p.opened.insert({name = global.buyingtradingchests_itemselected[chest_index], count = item_difference})
						global.gt_credits = global.gt_credits - credit_cost
					end
				else

					p.print("Unable to complete one of your orders")
				end
			end
		end


		return
	end

	if event.element.name == "update_chest_value_button" then
		chest_value = 0
		for a, b in pairs(global.sellingtradingchests) do
			if b~=nil and b.position.x == p.opened.position.x and b.position.y == p.opened.position.y then
				for item, z in pairs(b.get_inventory(1).get_contents()) do
					tmp_values = {}
					if get_item_value(item,1) ~= 0 then
						tmp_values = {}
						chest_value = chest_value + get_item_value(item,z)
					end
				end
				break
			end
		end
		chest_value = chest_value - (chest_value * global.trader_cut_percentage)
		chest_value = math.floor(chest_value)
		p.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.chest_value_label.caption = comma_value(chest_value)
		return
	end

	if event.element.name == "buyingchest_enabled_checkbox" then
		for a, b in pairs(global.buyingtradingchests) do
			if b~=nil and b.position.x == p.opened.position.x and b.position.y == p.opened.position.y then
				global.buyingtradingchests_enabled[a] = p.gui.left.tradingchest_buy.buyingchest_enabled_checkbox.state
				break
			end
		end
		return
	end
	if event.element.name == "sellingchest_enabled_checkbox" then
		for a, b in pairs(global.sellingtradingchests) do
			if b~=nil and b.position.x == p.opened.position.x and b.position.y == p.opened.position.y and p.gui.left.tradingchest_sell.tradingchest_sell_table.sellingchest_enabled_checkbox then
				global.sellingtradingchests_enabled[a] = p.gui.left.tradingchest_sell.tradingchest_sell_table.sellingchest_enabled_checkbox.state
				break
			end
		end
		return
	end

	if event.element.name == "buying_chest_copy" then
		chest_index = get_opened_buyingchest_index(event.player_index)
		global.gt_clipboard_buy.item = global.buyingtradingchests_itemselected[chest_index]
		global.gt_clipboard_buy.amount = global.buyingtradingchests_itemamount[chest_index]
		global.gt_clipboard_buy.enabled = global.buyingtradingchests_enabled[chest_index]
		return
	end

	if event.element.name == "buying_chest_paste" then
		if global.gt_clipboard_buy.item ~= nil then
			chest_index = get_opened_buyingchest_index(event.player_index)
			global.buyingtradingchests_itemselected[chest_index] = global.gt_clipboard_buy.item
			global.buyingtradingchests_itemamount[chest_index] = global.gt_clipboard_buy.amount
			global.buyingtradingchests_enabled[chest_index] = global.gt_clipboard_buy.enabled

			credit_cost = 0
			if global.buyingtradingchests_itemselected[chest_index] ~= "blank" then
				item_count = p.opened.get_inventory(1).get_item_count(global.buyingtradingchests_itemselected[chest_index])
				item_difference = tonumber(global.buyingtradingchests_itemamount[chest_index]) - item_count
				tmp_values = {}
				credit_cost = item_difference * get_item_value(global.buyingtradingchests_itemselected[chest_index],1)
			else
				credit_cost = 0
			end
			if credit_cost < 0 then
				credit_cost = 0
			end

			--update gui
			if global.buyingtradingchests_itemselected[chest_index] ~= "blank" then
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = game.get_localised_item_name(global.buyingtradingchests_itemselected[chest_index])
			else
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = "blank"
			end
			p.gui.left.tradingchest_buy.item_view_table.current_item_button.style = global.buyingtradingchests_itemselected[chest_index].."_gt_button_style"
			tmp_values = {}
			p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=comma_value(get_item_value(global.buyingtradingchests_itemselected[chest_index],1))
			p.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption = comma_value(global.buyingtradingchests_itemamount[chest_index])
			p.gui.left.tradingchest_buy.item_view_table.current_cost_table.item_cost_label_constant.caption = comma_value(credit_cost)
			p.gui.left.tradingchest_buy.buyingchest_enabled_checkbox.state = global.buyingtradingchests_enabled[chest_index]
		end
		return
	end

	local function update_item_selector_gui()

		p.gui.left.item_selection.destroy()

		p.gui.left.add{type="frame", name="item_selection", style='frame_style', direction='horizontal'}
		p.gui.left.item_selection.add{name="gt_selection_table", type="table", colspan=3}
		p.gui.left.item_selection.gt_selection_table.add{type="label",name="blank_label", caption = ""}
		p.gui.left.item_selection.gt_selection_table.add{type="table",name="gt_selection_top_center_table", colspan=3}
		p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="textfield",name="gt_search_bar_textfield",text=global.gt_current_search_term[event.player_index]}
		p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="button",name="gt_search_bar_button",caption="search"}
		p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.add{type="label",name="item_selection_label", caption = "Choose an item to buy"}
		p.gui.left.item_selection.gt_selection_table.add{type="label",name="item_selection_page_num_label", caption = "page "..global.gt_current_buying_trading_page[event.player_index]+1}
		p.gui.left.item_selection.gt_selection_table.add{type="button", name="gt_page_left_button", style="button_style",caption="<<"}

		p.gui.left.item_selection.gt_selection_table.add{name="item_table", type="table", colspan=global.gt_items_per_row}

		p.gui.left.item_selection.gt_selection_table.add{type="button", name="gt_page_right_button", style="button_style",caption=">>"}

		p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.gt_search_bar_textfield.text=global.gt_current_search_term[event.player_index]

		items = 0
		if global.gt_current_buying_trading_page[event.player_index] == 0 then
			p.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name="blank".."_selection_button",state = false, style = "blank".."_gt_button_style"} --makes it to where is an option to buy nothing
			items = items + 1 --adds one for the "blank" item
		end
		current_item = 0
		for s, item in pairs(game.item_prototypes) do
			tmp_values = {}
			if get_item_value(item.name, 1) ~= 0 and (global.gt_blacklist[item.name]==nil or global.gt_blacklist[item.name]==false) then
				if current_item >= (global.gt_current_buying_trading_page[event.player_index]*global.gt_items_per_row*global.gt_items_per_collum)+1 and (global.gt_current_search_term[event.player_index] == "" or string.match(item.name,global.gt_current_search_term[event.player_index])) then
					p.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name=item.name.."_selection_button",state = false, style = item.name.."_gt_button_style"}
					items = items + 1
					if items >= global.gt_items_per_row*global.gt_items_per_collum then
						break
					end
				end
				current_item = current_item + 1
			end
		end
	end

	if event.element.name == "gt_page_right_button" then
		if p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.gt_search_bar_textfield.text == "" then
			global.gt_current_filtered_items = global.gt_total_items
		end

		if global.gt_current_buying_trading_page[event.player_index] < math.ceil(global.gt_current_filtered_items/(global.gt_items_per_row*global.gt_items_per_collum))-1 then
			global.gt_current_buying_trading_page[event.player_index] = global.gt_current_buying_trading_page[event.player_index] + 1
			update_item_selector_gui(global.gt_current_search_term[event.player_index])
		end
		return
	end

	if event.element.name == "gt_page_left_button" then
		if global.gt_current_buying_trading_page[event.player_index] > 0 then
			global.gt_current_buying_trading_page[event.player_index] = global.gt_current_buying_trading_page[event.player_index] - 1
			update_item_selector_gui(global.gt_current_search_term[event.player_index])
		end
		return
	end

	if event.element.name == "gt_search_bar_button" then
		global.gt_current_buying_trading_page[event.player_index] = 0
		global.gt_current_search_term[event.player_index] = p.gui.left.item_selection.gt_selection_table.gt_selection_top_center_table.gt_search_bar_textfield.text
		update_item_selector_gui()
		global.gt_current_filtered_items = 0
		for s, item in pairs(game.item_prototypes) do
			if get_item_value(item.name, 1) ~= 0 and (global.gt_blacklist[item.name]==nil or global.gt_blacklist[item.name]==false) and (global.gt_current_search_term[event.player_index] == "" or string.match(item.name,global.gt_current_search_term[event.player_index])) then
				global.gt_current_filtered_items = global.gt_current_filtered_items + 1
			end
		end
		return
	end

	--get the button that is clicked and make that item show up on the other gui, and set it as the item which gets bought
	for s, item in pairs(game.item_prototypes) do
		if event.element.name == item.name.."_selection_button" then

			item_index = get_opened_buyingchest_index(event.player_index)

			global.buyingtradingchests_itemselected[item_index] = item.name
			if item.name ~= "blank" then
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = game.get_localised_item_name(item.name)
			else
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = "blank"
			end
			p.gui.left.tradingchest_buy.item_view_table.current_item_button.style = item.name.."_gt_button_style"
			tmp_values = {}
			p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=comma_value(get_item_value(item.name,1))
			break
		end
	end
end