require "defines"
require("prototypes.scripts.item-credit-values")
require("prototypes.scripts.trading-chest")
require 'config'

--game.getplayer(index or name) for multiplayer support

local frame = nil
local credits = 0
local updated = false
local DEFAULT_CREDIT_VALUE = 10
local first_tick = true

local function load_values()

	load_config()

	if glob.gt_time_value == nil then
		glob.gt_time_value = 2
	end
	if glob.gt_smelting_value == nil then
		glob.gt_smelting_value = 15
	end

	if glob.credits ~= nil then
		credits = glob.credits
	else
		glob.credits = glob.gt_starting_credits
	end
	
	if glob.trader_cut_percentage == nil then
		glob.trader_cut_percentage = 0.15 --15% 
	end

	if glob.gt_clipboard_buy == nil then
		glob.gt_clipboard_buy = {}
	end

	if glob.buyingtradingchests_enabled == nil then
		if glob.buyingtradingchests ~= nil then
			glob.buyingtradingchests_enabled = {}
			for i, e in ipairs(glob.buyingtradingchests) do
				table.insert(glob.buyingtradingchests_enabled, true)
			end
		else
			glob.buyingtradingchests = {}
			glob.buyingtradingchests_enabled = {}
		end
	end
	if glob.sellingtradingchests_enabled == nil then
		if glob.sellingtradingchests ~= nil then
			glob.sellingtradingchests_enabled = {}
			for i, e in ipairs(glob.sellingtradingchests) do
				table.insert(glob.sellingtradingchests_enabled, true)
			end
		else
			glob.sellingtradingchests = {}
			glob.sellingtradingchests_enabled = {}
		end
	end

	if glob.gt_reload_item_values_on_load then
		glob.gt_values = {}
		glob.gt_blacklist = {}
		glob.gt_smelted_items = {}
	end

	if glob.gt_values == nil then
		glob.gt_values = {}
	end

	glob.gt_values["solid-fuel"] = 100
	glob.gt_values["stone"] = 55
	glob.gt_values["iron-ore"] = 55
	glob.gt_values["raw-fish"] = 75
	glob.gt_values["copper-ore"] = 55
	glob.gt_values["raw-wood"] = 25
	glob.gt_values["coal"] = 55
	glob.gt_values["alien-artifact"] = 5000
	glob.gt_values["crude-oil-barrel"] = 1405
	glob.gt_values["coin"] = 100
	glob.gt_values["heavy-oil"] = 183
	glob.gt_values["light-oil"] = 183
	glob.gt_values["petroleum-gas"] = 138
	glob.gt_values["water"] = 1

	for name, amount in pairs(glob.gt_extra_item_values) do --adds extra items (defined above) into the list
		glob.gt_values[name] = amount
	end

	if glob.gt_blacklist == nil then
		glob.gt_blacklist = {}
	end

	glob.gt_blacklist["computer"] = true
	glob.gt_blacklist["tank-cannon"] = true
	glob.gt_blacklist["player-port"] = true
	glob.gt_blacklist["small-plane"] = true
	glob.gt_blacklist["basic-electric-discharge-defense-remote"] = true

	for name, amount in pairs(glob.gt_extra_blacklist) do --adds extra items (defined above) into the list
			glob.gt_blacklist[name] = amount
	end

	if glob.gt_smelted_items == nil then
		glob.gt_smelted_items = {}
	end
	
	glob.gt_smelted_items["iron-plate"] = true
	glob.gt_smelted_items["copper-plate"] = true
	glob.gt_smelted_items["steel-plate"] = true
	glob.gt_smelted_items["stone-brick"] = true

	for name, amount in pairs(glob.gt_extra_smelted_items) do --adds extra items (defined above) into the list
		glob.gt_smelted_items[name] = value
	end

	if glob.gt_supply == nil then
		glob.gt_supply = {}
	end
	if glob.gt_demand == nil then
		glob.gt_demand = {}
	end

	if glob.sellingtradingchests_enabled == nil then
		glob.sellingtradingchests_enabled = {}
	end
	if glob.buyingtradingchests_itemselected == nil then
		glob.buyingtradingchests_itemselected = {}
	end
	if glob.buyingtradingchests_itemamount == nil then
		glob.buyingtradingchests_itemamount = {}
	end
	if glob.buyingtradingchests_enabled == nil then
		glob.buyingtradingchests_enabled = {}
	end

	for name, value in pairs(glob.gt_values) do--add initial supply to items
		if glob.gt_supply[name] == nil then
			glob.gt_supply[name] = math.ceil(glob.gt_initial_supply_modifier/value)
		end
	end

	glob.gt_current_buying_trading_page = 0

end

if glob.trader_cut_percentage == nil then
	glob.trader_cut_percentage = 0.15 --15% 
end

local function remove_gui()

	if game.player.gui.top.money ~= nil then
		game.player.gui.top.money.destroy()
	end
	frame = nil

end

local function create_gui()
	remove_gui()
	frame = game.player.gui.top.add{type="frame", name="money", caption = '', style='frame_style', direction='vertical'}
	frame.add{type="label", name="credits", caption="0"}

end


local function save_values()
	glob.credits = credits
end

game.oninit(function()
	load_values()
end)

game.onload(function()

	load_values()
	create_gui()

	if glob.sellingtradingchests == nil then
		glob.sellingtradingchests = {}
	end

	first_tick = true

end)

game.onsave(function()
	remove_gui()
end)

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

game.onevent(defines.events.ontick, function(event)
	if first_tick then
		first_tick = false
		items_without_cost = {}
		glob.gt_total_items = 0
		for c, item in pairs(game.itemprototypes) do 
			if glob.gt_values[item.name] == nil then
				value = get_item_value(item.name, 1)
				if value ~= 0 then
					glob.gt_values[item.name] = value
					glob.gt_total_items = glob.gt_total_items + 1
				else
					if game.player.force.recipes[item.name]==nil and glob.gt_blacklist[item.name]==nil then
						in_list = false
						for a, b in pairs(items_without_cost) do
							if b == item.name then
								in_list	= true
							end
						end
						if not(in_list) then
							table.insert(items_without_cost,item.name)
						end
						glob.gt_blacklist[item.name] = true
						game.player.print(item.name)
					end
				end
			else
				if glob.gt_values[item.name] ~= 0 then
					glob.gt_total_items = glob.gt_total_items + 1
				end
			end
		end
		if #items_without_cost ~= 0 then
			for a, b in pairs(items_without_cost) do
				game.player.print(b)
			end
			game.player.print("There are "..#items_without_cost.." base resoureces (items without recipies) without cost (listed above)")
			game.player.print("look on the mod page for instructions to add their values to the galactic trade mod (to be bought and sold)")
		end
	end

	if frame ~= nil then
		if glob.credits == nil then
			glob.credits = 0
		end

  		frame.credits.caption = string.format("credits: %d",glob.credits)
	else
		create_gui()
	end

	if game.player.opened ~= nil and game.player.opened.valid then

		if game.player.opened.name == "trading-chest-buy" and game.player.gui.left.tradingchest_buy == nil then --buying chest gui
			game.player.gui.left.add{type="frame", name="tradingchest_buy", caption = 'Selected Item', style='frame_style', direction='vertical'}

			item_index = 0
			for i, a in ipairs(glob.buyingtradingchests) do --this gets the trading chest based off of the position of the one clicked on and based on what we have listed
				if a ~= nil then
					if a.position.x == game.player.opened.position.x and a.position.y == game.player.opened.position.y then
						item_index = i
					end
				end
			end
			if glob.buyingtradingchests_enabled[item_index] == nil then
				if glob.buyingtradingchests_enabled == nil then
					glob.buyingtradingchests_enabled = {}
				end
				glob.buyingtradingchests_enabled[item_index] = true
			end
			game.player.gui.left.tradingchest_buy.add{type="checkbox",name="buyingchest_enabled_checkbox",state=glob.buyingtradingchests_enabled[item_index], caption="Enabled"}

			game.player.gui.left.tradingchest_buy.add{name="item_view_table", type="table", colspan=1}
			game.player.gui.left.tradingchest_buy.item_view_table.add{type="label",name="item_label",caption=glob.buyingtradingchests_itemselected[item_index]}
			game.player.gui.left.tradingchest_buy.item_view_table.add{type="checkbox",name="current_item_button", state = false, style = glob.buyingtradingchests_itemselected[item_index].."_gt_button_style"} --the style = item.name.."_gt_button_style" for now

			game.player.gui.left.tradingchest_buy.item_view_table.add{name="current_amount_table", type="table", colspan=2}
			game.player.gui.left.tradingchest_buy.item_view_table.current_amount_table.add{type="label",name="item_amount_label_constant",caption="Current amount: "}
			game.player.gui.left.tradingchest_buy.item_view_table.current_amount_table.add{type="label",name="item_amount_label",caption=glob.buyingtradingchests_itemamount[item_index]}

			game.player.gui.left.tradingchest_buy.item_view_table.add{name="current_ppu_table", type="table", colspan=3}
			game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.add{type="label",name="item_ppu_label_constant_1",caption="Current Price Per Unit (PPU): "}
			game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.add{type="label",name="item_ppu_label"}
			if glob.buyingtradingchests_itemselected[item_index] ~= "blank" then
				game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=get_item_value(glob.buyingtradingchests_itemselected[item_index],1)
			else
				game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.item_ppu_label.caption=0
			end

			game.player.gui.left.tradingchest_buy.item_view_table.current_ppu_table.add{type="label",name="item_ppu_label_constant_2",caption=" credits"}

			game.player.gui.left.tradingchest_buy.item_view_table.add{name="current_cost_table", type="table", colspan=3}
			game.player.gui.left.tradingchest_buy.item_view_table.current_cost_table.add{type="label",name="item_cost_label_constant_1",caption="Current cost: "}
			credit_cost = 0
			if glob.buyingtradingchests_itemselected[item_index] ~= "blank" then
				item_count = game.player.opened.getinventory(1).getitemcount(glob.buyingtradingchests_itemselected[item_index])
				item_difference = tonumber(game.player.gui.left.tradingchest_buy.item_view_table.current_amount_table.item_amount_label.caption) - item_count
				credit_cost = get_item_value(glob.buyingtradingchests_itemselected[item_index],item_difference)
			else
				credit_cost = 0
			end
			if credit_cost < 0 then
				credit_cost = 0
			end
			game.player.gui.left.tradingchest_buy.item_view_table.current_cost_table.add{type="label",name="item_cost_label_constant",caption=credit_cost}
			game.player.gui.left.tradingchest_buy.item_view_table.current_cost_table.add{type="label",name="item_cost_label_constant_2",caption=" credits"}

			game.player.gui.left.tradingchest_buy.item_view_table.add{type="textfield",name="item_amount_field"}

			game.player.gui.left.tradingchest_buy.add{name="gt_buttons", type="table", colspan=1}
			game.player.gui.left.tradingchest_buy.gt_buttons.add{type="button", name="amount_update_button", style="button_style",caption="Update Amount"}
			game.player.gui.left.tradingchest_buy.gt_buttons.add{name="gt_cp_buttons_table", type="table", colspan=2}
			game.player.gui.left.tradingchest_buy.gt_buttons.gt_cp_buttons_table.add{type="button", name="buying_chest_copy", style="button_style",caption="Copy"}
			game.player.gui.left.tradingchest_buy.gt_buttons.gt_cp_buttons_table.add{type="button", name="buying_chest_paste", style="button_style",caption="Paste"}
			if glob.gt_instant_buy_button_enabled then
				game.player.gui.left.tradingchest_buy.gt_buttons.add{type="button", name="instant_buy_button", style="button_style",caption="Instant Buy"} --only for testing
			end

			--gui which has all buyable items

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

		if game.player.opened.name == "trading-chest-sell" and game.player.gui.left.tradingchest_sell == nil then --selling chest gui
			game.player.gui.left.add{type="frame", name="tradingchest_sell", caption = 'Selling Info', style='frame_style', direction='vertical'}

			item_index = 0
			for i, a in ipairs(glob.sellingtradingchests) do --this gets the trading chest based off of the position of the one clicked on and based on what we have listed
				if a ~= nil then
					if a.position.x == game.player.opened.position.x and a.position.y == game.player.opened.position.y then
						item_index = i
					end
				end
			end

			if glob.sellingtradingchests_enabled[item_index] == nil then
				if glob.sellingtradingchests_enabled == nil then
					glob.sellingtradingchests_enabled = {}
				end
				glob.sellingtradingchests_enabled[item_index] = true
			end

			game.player.gui.left.tradingchest_sell.add{type="checkbox",name="sellingchest_enabled_checkbox",state=glob.sellingtradingchests_enabled[item_index], caption="Enabled"}
			game.player.gui.left.tradingchest_sell.add{type="table", name="tradingchest_sell_table",colspan=1}

			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.add{name="merch_info_table", type="table", colspan=3} --table of labels that tells merchant cut
			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_info_label_constant_1", caption="Merchant Cut: "}
			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_cut_label", caption=glob.trader_cut_percentage*100}
			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.merch_info_table.add{type="label", name="merch_info_label_constant_2", caption="%"}

			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.add{name="chest_value_table", type="table", colspan=3}
			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.add{type="label", name="chest_value_label_constant_1", caption="Value of items in chest: "}
			chest_value = 0
			for a, b in pairs(glob.sellingtradingchests) do
				if b ~= nil then
					if b.position.x == game.player.opened.position.x and b.position.y == game.player.opened.position.y then
						for item, z in pairs(b.getinventory(1).getcontents()) do
							if get_item_value(item,1) ~= 0 then
								chest_value = chest_value + get_item_value(item,z)
							end
						end
						break
					end
				end
			end
			chest_value = chest_value - (chest_value * glob.trader_cut_percentage)
			chest_value = math.floor(chest_value)
			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.chest_value_table.add{type="label", name="chest_value_label", caption=chest_value}
			game.player.gui.left.tradingchest_sell.tradingchest_sell_table.add{type="button",name="update_chest_value_button",caption="Update"}
		end

	else
		if game.player.gui.left.tradingchest_buy ~= nil then
			game.player.gui.left.tradingchest_buy.destroy()
			game.player.gui.left.item_selection.destroy()
		end
		if game.player.gui.left.tradingchest_sell ~= nil then
			game.player.gui.left.tradingchest_sell.destroy()
		end
	end



	local time = game.daytime

	if 0.0 <= time and time <=0.01 and not updated then 

		game.player.print("The trade ship is here to trade resources")

		updated = true

		if glob.credits == nil then
			glob.credits = glob.gt_starting_credits
		end

		if glob.sellingtradingchests ~= nil then --daily selling resources

			for i, c in pairs(glob.sellingtradingchests) do
				if glob.sellingtradingchests_enabled[i] then
					contents = c.getinventory(1).getcontents()
					for a, b in pairs(contents) do
						if get_item_value(a,1) ~= 0 then
							sellingprice = (get_item_value(a,b))-(get_item_value(a,b) * glob.trader_cut_percentage)
							sellingprice = math.floor(sellingprice)
							glob.credits = glob.credits + sellingprice
							c.getinventory(1).remove({name = a, count = b})
						else
							game.player.print(a .. " has no value on the galactic market")
						end
					end
				end
			end
			
		end
		if glob.buyingtradingchests ~= nil then --daily buying resources
			for i, c in pairs(glob.buyingtradingchests) do
				if glob.buyingtradingchests_enabled[i] and glob.buyingtradingchests_itemselected[i] ~= "blank" and tonumber(glob.buyingtradingchests_itemamount[i]) > 0 then
					item_count = c.getinventory(1).getitemcount(glob.buyingtradingchests_itemselected[i])
					if item_count < tonumber(glob.buyingtradingchests_itemamount[i]) then
						credit_cost = 0
						if glob.buyingtradingchests_itemselected[i] ~= "blank" then
							item_difference = tonumber(glob.buyingtradingchests_itemamount[i]) - item_count
							available_space = 0
							contents = c.getinventory(1).getcontents()
							c.getinventory(1).clear()
							slots_available = c.getinventory(1).getbar()
							for name, amount in pairs(contents) do
								c.getinventory(1).insert({name = name, count = amount})
								if name ~= glob.buyingtradingchests_itemselected[i] then
									slots_available = slots_available - math.ceil(amount/game.itemprototypes[glob.buyingtradingchests_itemselected[i]].stacksize)
								end
							end

							if slots_available>0 then
								max_buy_amount = (slots_available * game.itemprototypes[glob.buyingtradingchests_itemselected[i]].stacksize) - item_count
								if item_difference > max_buy_amount then
									item_difference = max_buy_amount
								end
							else
								slots_available = 0
							end


							credit_cost = get_item_value(glob.buyingtradingchests_itemselected[i],item_difference)
						else
							credit_cost = 0
						end
						if item_difference < 0 then
							item_difference = 0
						end
						if glob.credits - credit_cost >= 0 and glob.buyingtradingchests_itemselected[i] ~= "blank"  then
							if item_difference > 0 then
								c.insert({name = glob.buyingtradingchests_itemselected[i], count = item_difference})
								glob.credits = glob.credits - credit_cost
							end
						else

							game.player.print("Unable to complete one of your orders")
						end
					end
				end
			end
		end
	end

	if 0.1<=time and time <=0.11 then
		updated = false
	end
end)

remote.addinterface("CreditsWallet", {

	add_funds = function(value)

		if glob.credits ~= nil then
			glob.credits = glob.credits + value
			return true
		end
		return false
	end,

	remove_funds = function(value)

		if glob.credits ~= nil then
			glob.credits = glob.credits - value
			return true
		end
		return false
	end,

	get_funds = function()

		if glob.credits ~= nil then
			return glob.credits
		end
		return nil
	end
})