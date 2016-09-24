
consumer_init_max_money = 1000
consumer_init_min_pop = 100
consumer_init_max_pop = 1000
chance_add_remove_min = 0.005
chance_add_remove_max = 0.05
chance_change_min = 0.01
chance_change_max = 0.1
income_modifier_min = 0.1
income_modifier_max = 5

consumer = {}

if global.gt_consumer_id_index == nil then
	global.gt_consumer_id_index = 0
end
if global.gt_consumers == nil then
	global.gt_consumers = {}
end

function consumer.new(c)
	if c == nil then
		c = {}
	end

	global.gt_consumer_id_index = global.gt_consumer_id_index + 1

	c.id = global.gt_consumer_id_index
	c.active = c.active or true
	c.pop = c.pop or math.random(consumer_init_min_pop,consumer_init_max_pop)
	c.chance_add_remove = c.chance_add_remove or math.random(chance_add_remove_min,chance_add_remove_max) --chance to add or remove items from list of demands, 0.5% - 5%
	c.chance_change = c.chance_change or math.random(chance_change_min,chance_change_max)
	c.income = 0
	c.income_modifier = c.income_modifier or math.random(income_modifier_min,income_modifier_max) --simulates a consumers wealth
	c.demands = c.demands or {}
end