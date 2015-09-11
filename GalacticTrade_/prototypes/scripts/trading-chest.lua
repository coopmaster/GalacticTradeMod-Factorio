require "defines"

function get_opened_buyingchest_index(player_index)
	index = 0
	for i in ipairs(global.buyingtradingchests.chest) do --this gets the trading chest based off of the position of the one clicked on and based on what we have listed
		if global.buyingtradingchests.chest[i] ~= nil then
			if global.buyingtradingchests.chest[i].position.x == game.get_player(player_index).opened.position.x and global.buyingtradingchests.chest[i].position.y == game.get_player(player_index).opened.position.y then
				index = i
				break
			end
		end
	end
	return index
end

function get_opened_sellingchest_index(player_index)
	index = 0
	for i in ipairs(global.sellingtradingchests.chest) do --this gets the trading chest based off of the position of the one clicked on and based on what we have listed
		if global.sellingtradingchests.chest[i] ~= nil then
			if global.sellingtradingchests.chest[i].position.x == game.get_player(player_index).opened.position.x and global.sellingtradingchests.chest[i].position.y == game.get_player(player_index).opened.position.y then
				index = i
				break
			end
		end
	end
	return index
end

game.on_event(defines.events.on_built_entity, function(event)
	if event.created_entity.name == "trading-chest-buy" or event.created_entity.name == "logistic-trading-chest-buy" then
		player_id = 1
		if not(global.gt_shared_wallet) then
			player_id = event.player_index
		end
		table.insert(global.buyingtradingchests.chest,event.created_entity)
		table.insert(global.buyingtradingchests.player_id, player_id)
		table.insert(global.buyingtradingchests.enabled, true)
		table.insert(global.buyingtradingchests.item_amount, 0)
		table.insert(global.buyingtradingchests.item_selected, "blank")
	end
	if event.created_entity.name == "trading-chest-sell" or event.created_entity.name == "logistic-trading-chest-sell" then
		player_id = 1
		if not(global.gt_shared_wallet) then
			player_id = event.player_index
		end
		table.insert(global.sellingtradingchests.chest, event.created_entity)
		table.insert(global.sellingtradingchests.player_id, player_id)
		table.insert(global.sellingtradingchests.enabled, true)
	end
 end)

game.on_event(defines.events.on_robot_built_entity, function(event)
	if event.created_entity.name == "trading-chest-buy" or event.created_entity.name == "logistic-trading-chest-buy" then
		player_id = 1
		table.insert(global.buyingtradingchests.chest,event.created_entity)
		table.insert(global.buyingtradingchests.player_id, player_id)
		table.insert(global.buyingtradingchests.enabled, true)
		table.insert(global.buyingtradingchests.item_amount, 0)
		table.insert(global.buyingtradingchests.item_selected, "blank")
	end
	if event.created_entity.name == "trading-chest-sell" or event.created_entity.name == "logistic-trading-chest-sell" then
		player_id = 1
		table.insert(global.sellingtradingchests.chest, event.created_entity)
		table.insert(global.sellingtradingchests.player_id, player_id)
		table.insert(global.sellingtradingchests.enabled, true)
	end
 end)

game.on_event(defines.events.on_preplayer_mined_item, function(event)
	if (event.entity.name == "trading-chest-buy" or event.entity.name == "logistic-trading-chest-buy") and global.buyingtradingchests ~= nil then
		temp = {}
		temp_id = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_temp = {}
		for i, a in ipairs(global.buyingtradingchests.chest) do
			if event.entity.valid and a.valid and not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
				table.insert(temp, global.buyingtradingchests.chest[i])
				table.insert(temp_id, global.buyingtradingchests.player_id[i])
				table.insert(item_tmp, global.buyingtradingchests.item_selected[i])
				table.insert(amount_tmp, global.buyingtradingchests.item_amount[i])
				table.insert(enabled_temp, global.buyingtradingchests.enabled[i])
			end
		end
		global.buyingtradingchests.chest = temp
		global.buyingtradingchests.player_id = temp_id
		global.buyingtradingchests.item_selected = item_tmp
		global.buyingtradingchests.item_amount = amount_tmp
		global.buyingtradingchests.enabled = enabled_temp
	end
	if (event.entity.name == "trading-chest-sell" or event.entity.name == "logistic-trading-chest-sell") and global.sellingtradingchests.chest ~= nil then
		temp = {}
		temp_id = {}
		enabled_temp = {}
		for i, a in ipairs(global.sellingtradingchests.chest) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, global.sellingtradingchests.chest[i])
					table.insert(temp_id, global.sellingtradingchests.player_id[i])
					table.insert(enabled_temp, global.sellingtradingchests.enabled[i])
				end
			end
		end
		global.sellingtradingchests.chest = temp
		global.sellingtradingchests.player_id = temp_id
		global.sellingtradingchests.enabled = enabled_temp
	end
end)

game.on_event(defines.events.on_entity_died, function(event)
	if (event.entity.name == "trading-chest-buy" or event.entity.name == "logistic-trading-chest-buy") and global.buyingtradingchests ~= nil then
		temp = {}
		temp_id = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_temp = {}
		for i, a in ipairs(global.buyingtradingchests.chest) do
			if event.entity.valid and a.valid and not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
				table.insert(temp, global.buyingtradingchests.chest[i])
				table.insert(temp_id, global.buyingtradingchests.player_id[i])
				table.insert(item_tmp, global.buyingtradingchests.item_selected[i])
				table.insert(amount_tmp, global.buyingtradingchests.item_amount[i])
				table.insert(enabled_temp, global.buyingtradingchests.enabled[i])
			end
		end
		global.buyingtradingchests.chest = temp
		global.buyingtradingchests.player_id = temp_id
		global.buyingtradingchests.item_selected = item_tmp
		global.buyingtradingchests.item_amount = amount_tmp
		global.buyingtradingchests.enabled = enabled_temp
	end
	if (event.entity.name == "trading-chest-sell" or event.entity.name == "logistic-trading-chest-sell") and global.sellingtradingchests.chest ~= nil then
		temp = {}
		temp_id = {}
		enabled_temp = {}
		for i, a in ipairs(global.sellingtradingchests.chest) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, global.sellingtradingchests.chest[i])
					table.insert(temp_id, global.sellingtradingchests.player_id[i])
					table.insert(enabled_temp, global.sellingtradingchests.enabled[i])
				end
			end
		end
		global.sellingtradingchests.chest = temp
		global.sellingtradingchests.player_id = temp_id
		global.sellingtradingchests.enabled = enabled_temp
	end
end)

game.on_event(defines.events.on_robot_pre_mined, function(event)
	if (event.entity.name == "trading-chest-buy" or event.entity.name == "logistic-trading-chest-buy") and global.buyingtradingchests ~= nil then
		temp = {}
		temp_id = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_temp = {}
		for i, a in ipairs(global.buyingtradingchests.chest) do
			if event.entity.valid and a.valid and not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
				table.insert(temp, global.buyingtradingchests.chest[i])
				table.insert(temp_id, global.buyingtradingchests.player_id[i])
				table.insert(item_tmp, global.buyingtradingchests.item_selected[i])
				table.insert(amount_tmp, global.buyingtradingchests.item_amount[i])
				table.insert(enabled_temp, global.buyingtradingchests.enabled[i])
			end
		end
		global.buyingtradingchests.chest = temp
		global.buyingtradingchests.player_id = temp_id
		global.buyingtradingchests.item_selected = item_tmp
		global.buyingtradingchests.item_amount = amount_tmp
		global.buyingtradingchests.enabled = enabled_temp
	end
	if (event.entity.name == "trading-chest-sell" or event.entity.name == "logistic-trading-chest-sell") and global.sellingtradingchests.chest ~= nil then
		temp = {}
		temp_id = {}
		enabled_temp = {}
		for i, a in ipairs(global.sellingtradingchests.chest) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, global.sellingtradingchests.chest[i])
					table.insert(temp_id, global.sellingtradingchests.player_id[i])
					table.insert(enabled_temp, global.sellingtradingchests.enabled[i])
				end
			end
		end
		global.sellingtradingchests.chest = temp
		global.sellingtradingchests.player_id = temp_id
		global.sellingtradingchests.enabled = enabled_temp
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

		return
	end

	if event.element.name == "blank".."_selection_button" then
		global.buyingtradingchests.item_selected[item_index] = "blank"

		p.gui.left.tradingchest_buy.item_view_table.item_label.caption = "blank"
		p.gui.left.tradingchest_buy.item_view_table.current_item_button.style = "blank".."_gt_button_style"

		p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=0
		return
	end

	if event.element.name == "instant_buy_button" then
		chest_index = get_opened_buyingchest_index(event.player_index)

		if global.buyingtradingchests.enabled[chest_index] and global.buyingtradingchests.item_selected[chest_index] ~= "blank" and tonumber(global.buyingtradingchests.item_amount[chest_index]) > 0 then
			item_count = p.opened.get_inventory(1).get_item_count(global.buyingtradingchests.item_selected[chest_index])
			if item_count < tonumber(global.buyingtradingchests.item_amount[chest_index]) then
				credit_cost = 0
				if global.buyingtradingchests.item_selected[chest_index] ~= "blank" then
					item_difference = tonumber(global.buyingtradingchests.item_amount[chest_index]) - item_count
					available_space = 0
					contents = p.opened.get_inventory(1).get_contents()
					p.opened.get_inventory(1).clear()
					slots_available = p.opened.get_inventory(1).getbar()
					for name, amount in pairs(contents) do
						p.opened.get_inventory(1).insert({name = name, count = amount})
						if name ~= global.buyingtradingchests.item_selected[chest_index] then
							slots_available = slots_available - math.ceil(amount/game.item_prototypes[global.buyingtradingchests.item_selected[chest_index]].stack_size)
						end
					end

					if slots_available>0 then
						max_buy_amount = (slots_available * game.item_prototypes[global.buyingtradingchests.item_selected[chest_index]].stack_size) - item_count
						if item_difference > max_buy_amount then
							item_difference = max_buy_amount
						end
					else
						slots_available = 0
					end


					credit_cost = gt_get_item_value(global.buyingtradingchests.item_selected[chest_index],item_difference)
				else
					credit_cost = 0
				end
				if item_difference < 0 then
					item_difference = 0
				end
				if not(global.gt_shared_wallet) then
					if global.gt_credits[global.sellingtradingchests.player_id[chest_index]] - credit_cost >= 0 and global.buyingtradingchests.item_selected[chest_index] ~= "blank"  then
						if item_difference > 0 then
							p.opened.insert({name = global.buyingtradingchests.item_selected[chest_index], count = item_difference})
							global.gt_credits[global.sellingtradingchests.player_id[chest_index]] = global.gt_credits[global.sellingtradingchests.player_id[chest_index]] - credit_cost
						end
					else
						p.print("Unable to complete one of your orders")
					end
				else
				end
			end
		end


		return
	end

	if event.element.name == "update_chest_value_button" then
		chest_value = 0
		for a, b in pairs(global.sellingtradingchests.chest) do
			if b~=nil and b.position.x == p.opened.position.x and b.position.y == p.opened.position.y then
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
		chest_value = math.floor(chest_value)
		p.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.chest_value_label.caption = comma_value(chest_value)
		return
	end

	if event.element.name == "buyingchest_enabled_checkbox" then
		for a, b in pairs(global.buyingtradingchests.chest) do
			if b~=nil and b.position.x == p.opened.position.x and b.position.y == p.opened.position.y then
				global.buyingtradingchests.enabled[a] = p.gui.left.tradingchest_buy.item_view_table.buyingchest_enabled_checkbox.state
				break
			end
		end
		return
	end
	if event.element.name == "sellingchest_enabled_checkbox" then
		for a, b in pairs(global.sellingtradingchests.chest) do
			if b~=nil and b.position.x == p.opened.position.x and b.position.y == p.opened.position.y and p.gui.left.tradingchest_sell.tradingchest_sell_table.sellingchest_enabled_checkbox then
				global.sellingtradingchests.enabled[a] = p.gui.left.tradingchest_sell.tradingchest_sell_table.sellingchest_enabled_checkbox.state
				break
			end
		end
		return
	end

	if event.element.name == "buying_chest_copy" then
		chest_index = get_opened_buyingchest_index(event.player_index)
		global.gt_clipboard_buy[event.player_index].item = global.buyingtradingchests.item_selected[chest_index]
		global.gt_clipboard_buy[event.player_index].amount = global.buyingtradingchests.item_amount[chest_index]
		global.gt_clipboard_buy[event.player_index].enabled = global.buyingtradingchests.enabled[chest_index]
		return
	end

	if event.element.name == "buying_chest_paste" then
		if global.gt_clipboard_buy[event.player_index].item ~= nil then
			chest_index = get_opened_buyingchest_index(event.player_index)
			global.buyingtradingchests.item_selected[chest_index] = global.gt_clipboard_buy[event.player_index].item
			global.buyingtradingchests.item_amount[chest_index] = global.gt_clipboard_buy[event.player_index].amount
			global.buyingtradingchests.enabled[chest_index] = global.gt_clipboard_buy[event.player_index].enabled

			credit_cost = 0
			if global.buyingtradingchests.item_selected[chest_index] ~= "blank" then
				item_count = p.opened.get_inventory(1).get_item_count(global.buyingtradingchests.item_selected[chest_index])
				item_difference = tonumber(global.buyingtradingchests.item_amount[chest_index]) - item_count
				tmp_values = {}
				credit_cost = item_difference * gt_get_item_value(global.buyingtradingchests.item_selected[chest_index],1)
			else
				credit_cost = 0
			end
			if credit_cost < 0 then
				credit_cost = 0
			end

			--update gui
			if global.buyingtradingchests.item_selected[chest_index] ~= "blank" then
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = game.get_localised_item_name(global.buyingtradingchests.item_selected[chest_index])
			else
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = "blank"
			end
			p.gui.left.tradingchest_buy.item_view_table.current_item_button.style = global.buyingtradingchests.item_selected[chest_index].."_gt_button_style"
			tmp_values = {}
			p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=comma_value(gt_get_item_value(global.buyingtradingchests.item_selected[chest_index],1))
			p.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption = comma_value(global.buyingtradingchests.item_amount[chest_index])
			p.gui.left.tradingchest_buy.item_view_table.current_cost_table.item_cost_label_constant.caption = comma_value(credit_cost)
			p.gui.left.tradingchest_buy.item_view_table.buyingchest_enabled_checkbox.state = global.buyingtradingchests.enabled[chest_index]
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

		p.gui.left.item_selection.gt_selection_table.add{name="item_table", type="table", colspan=global.gt_items_per_row[event.player_index]}

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
			if gt_get_item_value(item.name, 1) ~= 0 and (global.gt_blacklist[item.name]==nil or global.gt_blacklist[item.name]==false) then
				if current_item >= (global.gt_current_buying_trading_page[event.player_index]*global.gt_items_per_row[event.player_index]*global.gt_items_per_collum[event.player_index])+1 and (global.gt_current_search_term[event.player_index] == "" or string.match(item.name,global.gt_current_search_term[event.player_index])) then
					p.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name=item.name.."_selection_button",state = false, style = item.name.."_gt_button_style"}
					items = items + 1
					if items >= global.gt_items_per_row[event.player_index]*global.gt_items_per_collum[event.player_index] then
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

		if global.gt_current_buying_trading_page[event.player_index] < math.ceil(global.gt_current_filtered_items/(global.gt_items_per_row[event.player_index]*global.gt_items_per_collum[event.player_index]))-1 then
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
			if gt_get_item_value(item.name, 1) ~= 0 and (global.gt_blacklist[item.name]==nil or global.gt_blacklist[item.name]==false) and (global.gt_current_search_term[event.player_index] == "" or string.match(item.name,global.gt_current_search_term[event.player_index])) then
				global.gt_current_filtered_items = global.gt_current_filtered_items + 1
			end
		end
		return
	end

	--get the button that is clicked and make that item show up on the other gui, and set it as the item which gets bought
	for s, item in pairs(game.item_prototypes) do
		if event.element.name == item.name.."_selection_button" then

			item_index = get_opened_buyingchest_index(event.player_index)

			global.buyingtradingchests.item_selected[item_index] = item.name
			if item.name ~= "blank" then
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = game.get_localised_item_name(item.name)
			else
				p.gui.left.tradingchest_buy.item_view_table.item_label.caption = "blank"
			end
			p.gui.left.tradingchest_buy.item_view_table.current_item_button.style = item.name.."_gt_button_style"
			tmp_values = {}
			p.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=comma_value(gt_get_item_value(item.name,1))
			break
		end
	end
end