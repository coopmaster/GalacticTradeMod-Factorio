
factory_init_max_tech = 25
factory_init_max_money = 1000

factory_types = {
	"miner",
	"smelter",
	"electronics",
	"oil",
	"weapon-manufactor",
	"militrist",--gets enemy drops
	"manufactor",
	"lab",
	"misc" --makes items that don't fit any above categories
}


factory = {}

if global.gt_factory_id_index == nil then
	global.gt_factory_id_index = 0
end
if global.gt_factories == nil then
	global.gt_factories = {}
end

function factory.new(f)
	if f == nil then
		f = {}
	end

	global.gt_factory_id_index = global.gt_factory_id_index+1

	f.id = global.gt_factory_id_index
	f.active = f.active or true
	f.type = f.type or factory_types[math.random(#factory_types)] --randomly selects factory type
	f.size = f.size or math.random(global.gt_max_factory_initial_size)
	f.security = f.security or math.random(10) --how secure from disasters a factory is
	f.tech = f.tech or math.random(factory_init_max_tech)
	f.money = f.money or math.random(factory_init_max_money)

	f.required_resource_cost = 0 --following values will be calculated later
	f.profit = 0
	f.production = 0 --number of items a factory produces

	--f.greed = 0 --would determine if they tried to "milk" an item or participate in market manipulation

	table.insert(global.gt_factories,f)
	return f
end

function factory.update_all()
	for i, f in pairs(global.gt_factories) do

	end
end