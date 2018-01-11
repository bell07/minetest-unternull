local chest_formspec =
	"size[8,9]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[current_name;main;0,0.3;8,4;]" ..
	"list[current_player;main;0,4.85;8,1;]" ..
	"list[current_player;main;0,6.08;8,3;8]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0,4.85)

local initial_stuff = {
		["all"] = {
			'default:cobble 12',
			'default:dirt 2',
			'default:sapling 2',
		},
		["air"] = {
			'bucket:bucket_water 6',
		},
		["default:water_source"] = {
			'nodetest:papyrus_roots 6',
		},
		["default:lava_source"] = {
			'bucket:bucket_water 6',
		},
	}

local function fill_chest(blockpos, water_node)
	local meta = minetest.get_meta(blockpos)
	meta:set_string("formspec", chest_formspec)
	local inv = meta:get_inventory()
	inv:set_size("main", 8*4)
	-- Fill with stuff
	for _, stack in ipairs(initial_stuff["all"]) do
		inv:add_item("main", stack)
	end
	if initial_stuff[water_node] then
		for _, stack in ipairs(initial_stuff[water_node]) do
			inv:add_item("main", stack)
		end
	end
end

if minetest.global_exists("startanode") then
	minetest.log("Undernull startup player chests handeled by startanode mod")
	if minetest.global_exists("water") then
		local water_node = water.node or "air"
		if water_node == "air" then
			startanode.after_place_func = function(player, pos)
				local chestpos = {x=pos.x, y=pos.y+1,z=pos.z}
				minetest.set_node(chestpos, {name="default:chest"})
				fill_chest(chestpos, water_node)
			end
		else
			startanode.node_name = "default:chest"
			if water_node == "default:water_source" then
				startanode.min_pos.y = 0
				startanode.max_pos.y = 0
			else
				startanode.min_pos.y = 1
				startanode.max_pos.y = 1
			end
			startanode.after_place_func = function(player, pos)
				fill_chest(pos, water_node)
			end
		end
	else
		-- keep the start-a-node as stone and place the chest above without water
		startanode.after_place_func = function(player, pos)
			local chestpos = {x=pos.x, y=pos.y+1,z=pos.z}
			minetest.set_node(chestpos, {name="default:chest"})
			fill_chest(chestpos, "air")
		end
	end
	return
end

minetest.register_on_generated(function(minp, maxp, seed)
	local spawn = minetest.setting_get_pos("static_spawnpoint")
	if minetest.get_gametime() < 5 then
		if spawn ~= nil then
			blockpos = { x=spawn.x, y=spawn.y, z=spawn.z }
		else
			blockpos = { x=0, y=0, z=0 }
		end
		-- Create chest
		minetest.set_node(blockpos, {name="default:chest"})
		local water_node
		if minetest.global_exists("water") then
			water_node = water.node or "air"
		end
		fill_chest(blockpos, water_node)
		local filepath = minetest.get_worldpath().."/origin.mt"
		local file = io.open(filepath, "w")
		file:write(minetest.pos_to_string(blockpos))
	end
end)
