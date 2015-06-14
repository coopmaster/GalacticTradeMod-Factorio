require "defines"

local tmp_values = {}
local function get_item_value(item, num)
	local value = 0
	if glob.gt_values[item] == nil then
		if game.player.force.recipes[item] == nil then -- don't care if blacklisted because we still want the value to be saved if it can be found
			return 0
		else

			for i, a in pairs(game.player.force.recipes[item].ingredients) do
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
			for _, b in pairs(game.player.force.recipes[item].products) do
				if b.name == item then
					result_num = b.amount
				end
			end
			value = math.ceil(value / result_num)
			value = value + glob.gt_time_value --adds value for crafting time
			if glob.gt_smelted_items[item] ~= nil and glob.gt_smelted_items[item] ~= false then
				value = value + glob.gt_smelting_value
			end
			value = value * num
		end
	else
		value = glob.gt_values[item] * num
		return value
	end
	return value
end

local function get_opened_buyingchest_index()
	index = 0
	for i, a in ipairs(glob.buyingtradingchests) do --this gets the trading chest based off of the position of the one clicked on and based on what we have listed
		if a ~= nil then
			if a.position.x == game.player.opened.position.x and a.position.y == game.player.opened.position.y then
				index = i
				break
			end
		end
	end
	return index
end

game.onevent(defines.events.onbuiltentity, function(event)
	if event.createdentity.name == "trading-chest-buy" then
		table.insert(glob.buyingtradingchests, event.createdentity)
		table.insert(glob.buyingtradingchests_itemselected, "blank")
		table.insert(glob.buyingtradingchests_itemamount, 0)
		table.insert(glob.buyingtradingchests_enabled, true)
	end
	if event.createdentity.name == "trading-chest-sell" then
		table.insert(glob.sellingtradingchests, event.createdentity)
		table.insert(glob.sellingtradingchests_enabled, true)
	end
 end)

game.onevent(defines.events.onrobotbuiltentity, function(event)
	if event.createdentity.name == "trading-chest-buy" then
		table.insert(glob.buyingtradingchests, event.createdentity)
		table.insert(glob.buyingtradingchests_itemselected, "blank")
		table.insert(glob.buyingtradingchests_itemamount, 0)
		table.insert(glob.buyingtradingchests_enabled, true)
	end
	if event.createdentity.name == "trading-chest-sell" then
		table.insert(glob.sellingtradingchests, event.createdentity)
		table.insert(glob.sellingtradingchests_enabled, true)
	end
 end)

game.onevent(defines.events.onpreplayermineditem, function(event)
	if event.entity.name == "trading-chest-buy" and glob.buyingtradingchests ~= nil then
		temp = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_tmp = {}
		for i, a in ipairs(glob.buyingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(item_tmp, glob.buyingtradingchests_itemselected[i])
					table.insert(amount_tmp, glob.buyingtradingchests_itemamount[i])
					table.insert(enabled_tmp, glob.buyingtradingchests_enabled[i])
				end
			end
		end
		glob.buyingtradingchests = temp
		glob.buyingtradingchests_itemselected = item_tmp
		glob.buyingtradingchests_itemamount = amount_tmp
	end
	if event.entity.name == "trading-chest-sell" and glob.sellingtradingchests ~= nil then
		temp = {}
		enabled_tmp = {}
		for i, a in ipairs(glob.sellingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(enabled_tmp, glob.sellingtradingchests_enabled[i])
				end
			end
		end
		glob.sellingtradingchests = temp
	end
end)

game.onevent(defines.events.onentitydied, function(event)
	if event.entity.name == "trading-chest-buy" and glob.buyingtradingchests ~= nil then
		temp = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_tmp = {}
		for i, a in ipairs(glob.buyingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(item_tmp, glob.buyingtradingchests_itemselected[i])
					table.insert(amount_tmp, glob.buyingtradingchests_itemamount[i])
					table.insert(enabled_tmp, glob.buyingtradingchests_enabled[i])
				end
			end
		end
		glob.buyingtradingchests = temp
		glob.buyingtradingchests_itemselected = item_tmp
		glob.buyingtradingchests_itemamount = amount_tmp
	end
	if event.entity.name == "trading-chest-sell" and glob.sellingtradingchests ~= nil then
		temp = {}
		enabled_tmp = {}
		for i, a in ipairs(glob.sellingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(enabled_tmp, glob.sellingtradingchests_enabled[i])
				end
			end
		end
		glob.sellingtradingchests = temp
	end
end)

game.onevent(defines.events.onrobotpremined, function(event)
	if event.entity.name == "trading-chest-buy" and glob.buyingtradingchests ~= nil then
		temp = {}
		item_tmp = {}
		amount_tmp = {}
		enabled_tmp = {}
		for i, a in ipairs(glob.buyingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(item_tmp, glob.buyingtradingchests_itemselected[i])
					table.insert(amount_tmp, glob.buyingtradingchests_itemamount[i])
					table.insert(enabled_tmp, glob.buyingtradingchests_enabled[i])
				end
			end
		end
		glob.buyingtradingchests = temp
		glob.buyingtradingchests_itemselected = item_tmp
		glob.buyingtradingchests_itemamount = amount_tmp
	end
	if event.entity.name == "trading-chest-sell" and glob.sellingtradingchests ~= nil then
		temp = {}
		enabled_tmp = {}
		for i, a in ipairs(glob.sellingtradingchests) do
			if event.entity.valid and a.valid then
				if not(a.position.x == event.entity.position.x and a.position.y == event.entity.position.y) then
					table.insert(temp, a)
					table.insert(enabled_tmp, glob.sellingtradingchests_enabled[i])
				end
			end
		end
		glob.sellingtradingchests = temp
	end
end)

game.onevent(defines.events.onguiclick, function(event)
	if event.element.name == "amount_update_button" then
		item_index = get_opened_buyingchest_index()
		n = tonumber(game.player.gui.left.tradingchest_buy.item_view_table.item_amount_field.text)
		if n == nil then
			n = 0
			game.player.print("Please enter a valid number") --do not delete
		else
			glob.buyingtradingchests_itemamount[item_index] = n
		end

		if glob.buyingtradingchests_itemselected[item_index] ~= "blank" and game.player.opened.getinventory(1).getbar() * game.itemprototypes[glob.buyingtradingchests_itemselected[item_index]].stacksize < glob.buyingtradingchests_itemamount[item_index] then
			glob.buyingtradingchests_itemamount[item_index] = game.player.opened.getinventory(1).getbar() * game.itemprototypes[glob.buyingtradingchests_itemselected[item_index]].stacksize
		end

		game.player.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption = glob.buyingtradingchests_itemamount[item_index]
		
		credit_cost = 0
		if glob.buyingtradingchests_itemselected[item_index] ~= "blank" then
			item_count = game.player.opened.getinventory(1).getitemcount(glob.buyingtradingchests_itemselected[item_index])
			item_difference = tonumber(game.player.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption) - item_count
			tmp_values = {}
			credit_cost = item_difference * get_item_value(glob.buyingtradingchests_itemselected[item_index],1)
		else
			credit_cost = 0
		end
		if credit_cost < 0 then
			credit_cost = 0
		end
		game.player.gui.left.tradingchest_buy.item_view_table.current_cost_table.item_cost_label_constant.caption = credit_cost

		return
	end

	if event.element.name == "blank".."_selection_button" then
		glob.buyingtradingchests_itemselected[item_index] = "blank"

		game.player.gui.left.tradingchest_buy.item_view_table.item_label.caption = "blank"
		game.player.gui.left.tradingchest_buy.item_view_table.current_item_button.style = "blank".."_gt_button_style"

		game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=0
		return
	end

	if event.element.name == "instant_buy_button" then 
		chest_index = get_opened_buyingchest_index()

		if glob.buyingtradingchests_enabled[chest_index] and glob.buyingtradingchests_itemselected[chest_index] ~= "blank" and tonumber(glob.buyingtradingchests_itemamount[chest_index]) > 0 then
			item_count = game.player.opened.getinventory(1).getitemcount(glob.buyingtradingchests_itemselected[chest_index])
			if item_count < tonumber(glob.buyingtradingchests_itemamount[chest_index]) then
				credit_cost = 0
				if glob.buyingtradingchests_itemselected[chest_index] ~= "blank" then
					item_difference = tonumber(glob.buyingtradingchests_itemamount[chest_index]) - item_count
					available_space = 0
					contents = game.player.opened.getinventory(1).getcontents()
					game.player.opened.getinventory(1).clear()
					slots_available = game.player.opened.getinventory(1).getbar()
					for name, amount in pairs(contents) do
						game.player.opened.getinventory(1).insert({name = name, count = amount})
						if name ~= glob.buyingtradingchests_itemselected[chest_index] then
							slots_available = slots_available - math.ceil(amount/game.itemprototypes[glob.buyingtradingchests_itemselected[chest_index]].stacksize)
						end
					end

					if slots_available>0 then
						max_buy_amount = (slots_available * game.itemprototypes[glob.buyingtradingchests_itemselected[chest_index]].stacksize) - item_count
						if item_difference > max_buy_amount then
							item_difference = max_buy_amount
						end
					else
						slots_available = 0
					end


					credit_cost = get_item_value(glob.buyingtradingchests_itemselected[chest_index],item_difference)
				else
					credit_cost = 0
				end
				if item_difference < 0 then
					item_difference = 0
				end
				if glob.credits - credit_cost >= 0 and glob.buyingtradingchests_itemselected[chest_index] ~= "blank"  then
					if item_difference > 0 then
						game.player.opened.insert({name = glob.buyingtradingchests_itemselected[chest_index], count = item_difference})
						glob.credits = glob.credits - credit_cost
					end
				else

					game.player.print("Unable to complete one of your orders")
				end
			end
		end


		return
	end

	if event.element.name == "update_chest_value_button" then
		chest_value = 0
		for a, b in pairs(glob.sellingtradingchests) do
			if b~=nil and b.position.x == game.player.opened.position.x and b.position.y == game.player.opened.position.y then
				for item, z in pairs(b.getinventory(1).getcontents()) do
					tmp_values = {}
					if get_item_value(item,1) ~= 0 then
						tmp_values = {}
						chest_value = chest_value + get_item_value(item,z)
					end
				end
				break
			end
		end
		chest_value = chest_value - (chest_value * glob.trader_cut_percentage)
		chest_value = math.floor(chest_value)
		game.player.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.chest_value_label.caption = chest_value
		return
	end

	if event.element.name == "buyingchest_enabled_checkbox" then
		for a, b in pairs(glob.buyingtradingchests) do
			if b~=nil and b.position.x == game.player.opened.position.x and b.position.y == game.player.opened.position.y then
				glob.buyingtradingchests_enabled[a] = game.player.gui.left.tradingchest_buy.buyingchest_enabled_checkbox.state
				break
			end
		end
		return
	end
	if event.element.name == "sellingchest_enabled_checkbox" then
		for a, b in pairs(glob.sellingtradingchests) do
			if b~=nil and b.position.x == game.player.opened.position.x and b.position.y == game.player.opened.position.y then
				glob.sellingtradingchests_enabled[a] = game.player.gui.left.tradingchest_sell.tradingchest_sell_table.sellingchest_enabled_checkbox.state
				break
			end
		end
		return
	end

	if event.element.name == "buying_chest_copy" then
		chest_index = get_opened_buyingchest_index()
		glob.gt_clipboard_buy.item = glob.buyingtradingchests_itemselected[chest_index]
		glob.gt_clipboard_buy.amount = glob.buyingtradingchests_itemamount[chest_index]
		glob.gt_clipboard_buy.enabled = glob.buyingtradingchests_enabled[chest_index]
		return
	end

	if event.element.name == "buying_chest_paste" then
		if glob.gt_clipboard_buy.item ~= nil then
			chest_index = get_opened_buyingchest_index()
			glob.buyingtradingchests_itemselected[chest_index] = glob.gt_clipboard_buy.item
			glob.buyingtradingchests_itemamount[chest_index] = glob.gt_clipboard_buy.amount
			glob.buyingtradingchests_enabled[chest_index] = glob.gt_clipboard_buy.enabled

			credit_cost = 0
			if glob.buyingtradingchests_itemselected[chest_index] ~= "blank" then
				item_count = game.player.opened.getinventory(1).getitemcount(glob.buyingtradingchests_itemselected[chest_index])
				item_difference = tonumber(glob.buyingtradingchests_itemamount[chest_index]) - item_count
				tmp_values = {}
				credit_cost = item_difference * get_item_value(glob.buyingtradingchests_itemselected[chest_index],1)
			else
				credit_cost = 0
			end
			if credit_cost < 0 then
				credit_cost = 0
			end

			--update gui
			game.player.gui.left.tradingchest_buy.item_view_table.item_label.caption = glob.buyingtradingchests_itemselected[chest_index]
			game.player.gui.left.tradingchest_buy.item_view_table.current_item_button.style = glob.buyingtradingchests_itemselected[chest_index].."_gt_button_style"
			tmp_values = {}
			game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=get_item_value(glob.buyingtradingchests_itemselected[chest_index],1)
			game.player.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption = glob.buyingtradingchests_itemamount[chest_index]
			game.player.gui.left.tradingchest_buy.item_view_table.current_cost_table.item_cost_label_constant.caption = credit_cost
			game.player.gui.left.tradingchest_buy.buyingchest_enabled_checkbox.state = glob.buyingtradingchests_enabled[chest_index]
		end
		return
	end

	local function update_item_selector_gui()

		game.player.gui.left.item_selection.destroy()

		game.player.gui.left.add{type="frame", name="item_selection", style='frame_style', direction='horizontal'}
		game.player.gui.left.item_selection.add{name="gt_selection_table", type="table", colspan=3}
		game.player.gui.left.item_selection.gt_selection_table.add{type="label",name="blank_label", caption = ""}
		game.player.gui.left.item_selection.gt_selection_table.add{type="label",name="item_selection_label", caption = "Choose an item to buy"}
		game.player.gui.left.item_selection.gt_selection_table.add{type="label",name="item_selection_page_num_label", caption = "page "..glob.gt_current_buying_trading_page+1}
		game.player.gui.left.item_selection.gt_selection_table.add{type="button", name="gt_page_left_button", style="button_style",caption="<<"}

		game.player.gui.left.item_selection.gt_selection_table.add{name="item_table", type="table", colspan=glob.gt_items_per_row}

		game.player.gui.left.item_selection.gt_selection_table.add{type="button", name="gt_page_right_button", style="button_style",caption=">>"}


		items = 0
		if glob.gt_current_buying_trading_page == 0 then
			game.player.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name="blank".."_selection_button",state = false, style = "blank".."_gt_button_style"} --makes it to where is an option to buy nothing
			items = items + 1 --adds one for the "blank" item
		end
		current_item = 0
		for s, item in pairs(game.itemprototypes) do
			tmp_values = {}
			if get_item_value(item.name, 1) ~= 0 and glob.gt_blacklist[item.name]==nil then
				if current_item >= (glob.gt_current_buying_trading_page*glob.gt_items_per_row*glob.gt_items_per_collum)+1 then--add one for the blank option 
					game.player.gui.left.item_selection.gt_selection_table.item_table.add{type="checkbox",name=item.name.."_selection_button",state = false, style = item.name.."_gt_button_style"}
					items = items + 1
					if items >= glob.gt_items_per_row*glob.gt_items_per_collum then
						break
					end
				end
				current_item = current_item + 1
			end
		end
	end

	if event.element.name == "gt_page_right_button" then
		if glob.gt_current_buying_trading_page < math.ceil(glob.gt_total_items/(glob.gt_items_per_row*glob.gt_items_per_collum))-1 then
			glob.gt_current_buying_trading_page = glob.gt_current_buying_trading_page + 1
			update_item_selector_gui()
		end
		return
	end

	if event.element.name == "gt_page_left_button" then
		if glob.gt_current_buying_trading_page > 0 then
			glob.gt_current_buying_trading_page = glob.gt_current_buying_trading_page - 1
			update_item_selector_gui()
		end
		return
	end

	--get the button that is clicked and make that item show up on the other gui, and set it as the item which gets bought
	for s, item in pairs(game.itemprototypes) do
		if event.element.name == item.name.."_selection_button" then

			item_index = get_opened_buyingchest_index()

			glob.buyingtradingchests_itemselected[item_index] = item.name

			game.player.gui.left.tradingchest_buy.item_view_table.item_label.caption = item.name
			game.player.gui.left.tradingchest_buy.item_view_table.current_item_button.style = item.name.."_gt_button_style"
			tmp_values = {}
			game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=get_item_value(item.name,1)
			break
		end
	end
end)