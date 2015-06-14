
--This file is currently not in use

--[[VALUE_TAG = "_gt_value"

--solid-fuel
--stone
--iron-ore
--raw-fish
--copper-ore
--raw-wood
--coal
--alien-artifact
--crude-oil-barrel
--coin
--tank-cannon
--computer

if glob.gt_values == nil then --base resources (no recipies)
	glob.gt_values = {}
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

end

glob.gt_blacklist = {}
glob.gt_blacklist["computer"] = true
glob.gt_blacklist["tank-cannon"] = true
glob.gt_blacklist["player-port"] = true

--table.insert(glob.gt_blacklist,"computer")
--table.insert(glob.gt_blacklist,"tank-cannon")

if glob["iron-plate"..VALUE_TAG]==nil then --values are WIP

	glob["iron-plate"..VALUE_TAG] = 55
	glob["copper-plate"..VALUE_TAG] = 55
	glob["pipe"..VALUE_TAG] = 60
	glob["pipe-to-ground"..VALUE_TAG] = 620
	glob["wooden-chest"..VALUE_TAG] = 8
	glob["iron-chest"..VALUE_TAG] = 440
	glob["steel-chest"..VALUE_TAG] = 2210
	glob["smart-chest"..VALUE_TAG] = 2630
	glob["basic-transport-belt"..VALUE_TAG] = 165
	glob["fast-transport-belt"..VALUE_TAG] = 720
	glob["express-transport-belt"..VALUE_TAG] = 1400
	glob["inserter"..VALUE_TAG] = 305
	glob["long-handed-inserter"..VALUE_TAG] = 470
	glob["fast-inserter"..VALUE_TAG] = 695
	glob["smart-inserter"..VALUE_TAG] = 1250
	glob["assembling-machine-1"..VALUE_TAG] = 1465
	glob["assembling-machine-2"..VALUE_TAG] = 2380
	glob["assembling-machine-3"..VALUE_TAG] = 25200
	glob["solar-panel"..VALUE_TAG] = 3750
	glob["diesel-locomotive"..VALUE_TAG] = 11050
	glob["cargo-wagon"..VALUE_TAG] = 3575
	glob["straight-rail"..VALUE_TAG] = 355
	glob["curved-rail"..VALUE_TAG] = 1265
	glob["stone-wall"..VALUE_TAG] = 525
	glob["gate"..VALUE_TAG] = 1355
	glob["car"..VALUE_TAG] = 6525
	--glob["tank"..VALUE_TAG] = 100
	glob["science-pack-1"..VALUE_TAG] = 165
	glob["science-pack-2"..VALUE_TAG] = 480 --good value
	glob["science-pack-3"..VALUE_TAG] = 2900
	glob["alien-science-pack"..VALUE_TAG] = 6000 --debating value
	glob["lab"..VALUE_TAG] = 3150
	glob["train-stop"..VALUE_TAG] = 2075
	glob["rail-signal"..VALUE_TAG] = 415
	glob["steel-plate"..VALUE_TAG] = 275
	glob["basic-transport-belt-to-ground"..VALUE_TAG] = 965
	glob["fast-transport-belt-to-ground"..VALUE_TAG] = 2070
	glob["express-transport-belt-to-ground"..VALUE_TAG] = 2625
	glob["basic-splitter"..VALUE_TAG] = 1640
	glob["fast-splitter"..VALUE_TAG] = 5375
	glob["express-splitter"..VALUE_TAG] = 15500
	glob["advanced-circuit"..VALUE_TAG] = 880
	glob["processing-unit"..VALUE_TAG] = 4631
	glob["logistic-robot"..VALUE_TAG] = 4360
	glob["construction-robot"..VALUE_TAG] = 2880
	glob["logistic-chest-passive-provider"..VALUE_TAG] = 3510
	glob["logistic-chest-active-provider"..VALUE_TAG] = 3510
	glob["logistic-chest-storage"..VALUE_TAG] = 3510
	glob["logistic-chest-requester"..VALUE_TAG] = 3510
	glob["roboport"..VALUE_TAG] = 57000
	glob["coin"..VALUE_TAG] = 100
	glob["small-electric-pole"..VALUE_TAG] = 48
	glob["medium-electric-pole"..VALUE_TAG] = 660
	glob["big-electric-pole"..VALUE_TAG] = 1650
	glob["substation"..VALUE_TAG] = 7430
	glob["basic-accumulator"..VALUE_TAG] = 2510
	glob["steel-furnace"..VALUE_TAG] = 3250
	glob["electric-furnace"..VALUE_TAG] = 9580
	glob["basic-beacon"..VALUE_TAG] = 23420
	glob["storage-tank"..VALUE_TAG] = 2500
	glob["small-pump"..VALUE_TAG] = 1250
	glob["offshore-pump"..VALUE_TAG] = 450
	glob["pumpjack"..VALUE_TAG] = 7600
	glob["oil-refinery"..VALUE_TAG] = 8275
	glob["chemical-plant"..VALUE_TAG] = 2930
	glob["sulfur"..VALUE_TAG] = 168
	glob["empty-barrel"..VALUE_TAG] = 280
	glob["crude-oil-barrel"..VALUE_TAG] = 1405
	glob["solid-fuel"..VALUE_TAG] = 110
	glob["plastic-bar"..VALUE_TAG] = 240
	glob["engine-unit"..VALUE_TAG] = 505
	glob["electric-engine-unit"..VALUE_TAG] = 915
	glob["explosives"..VALUE_TAG] = 245
	glob["battery"..VALUE_TAG] = 480
	glob["flying-robot-frame"..VALUE_TAG] = 2600 --pretty good value to make
	glob["steel-axe"..VALUE_TAG] = 1431
	glob["basic-oil-processing"..VALUE_TAG] = 300
	glob["advanced-oil-processing"..VALUE_TAG] = 300
	glob["heavy-oil-cracking"..VALUE_TAG] = 300
	glob["light-oil-cracking"..VALUE_TAG] = 300
	glob["stone-brick"..VALUE_TAG] = 105
	glob["iron-stick"..VALUE_TAG] = 28
	glob["iron-gear-wheel"..VALUE_TAG] = 110
	glob["copper-cable"..VALUE_TAG] = 28
	glob["electronic-circuit"..VALUE_TAG] = 139
	glob["raw-wood"..VALUE_TAG] = 40
	glob["burner-mining-drill"..VALUE_TAG] = 750
	glob["basic-mining-drill"..VALUE_TAG] = 1520
	glob["burner-inserter"..VALUE_TAG] = 165
	glob["stone-furnace"..VALUE_TAG] = 255
	glob["coal"..VALUE_TAG] = 75
	glob["iron-ore"..VALUE_TAG] = 50
	glob["copper-ore"..VALUE_TAG] = 50
	glob["stone"..VALUE_TAG] = 50
	glob["wood"..VALUE_TAG] = 20
	glob["iron-axe"..VALUE_TAG] = 85
	glob["alien-artifact"..VALUE_TAG] = 10000
	glob["radar"..VALUE_TAG] = 1800
	glob["boiler"..VALUE_TAG] = 315
	glob["steam-engine"..VALUE_TAG] = 1130
	glob["small-lamp"..VALUE_TAG] = 280
	glob["poison-capsule"..VALUE_TAG] = 100

	--glob["raw-fish"..VALUE_TAG] = 200
	glob["speed-module"..VALUE_TAG] = 5100
	--glob["productivity-module"..VALUE_TAG] = 5100
	--glob["effectivity-module"..VALUE_TAG] = 5100

	--crude oil 45
	--petrolium 55 (guess and goes with all processed oil)
	--water 1
	--sulfuric acid 182
	--lubricant 65 (guess)
	
	
end

--blacklist

--computer
--tank-cannon


--whitelist (custom set value)--]]