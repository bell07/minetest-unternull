additional_stuff = {}

minetest.register_craft({
	type = "cooking",
	output = "default:lava_source",
	recipe = "default:stone",
	cooktime = 20,
})

minetest.register_craft({
	type = "cooking",
	output = "default:coal_lump",
	recipe = "group:tree",
})

minetest.register_craft({
	type = "cooking",
	output = "default:coal_lump",
	recipe = "group:tree",
})

minetest.register_craft({
	output = "default:mossycobble",
	type = "shapeless",
	recipe = {"default:cobble", "group:flora"},
})

minetest.register_craft({
	output = 'default:dirt',
	recipe = {
		{'nodetest:papyrus_roots', 'nodetest:papyrus_roots'},
		{'nodetest:papyrus_roots', 'nodetest:papyrus_roots'},
	}
})

minetest.register_craft({
	output = 'default:desert_cobble 9',
	recipe = {
		{'default:gravel', 'default:gravel', 'default:gravel'},
		{'default:gravel', 'default:lava_source', 'default:gravel'},
		{'default:gravel', 'default:gravel', 'default:gravel'},
	}
})

minetest.register_craft({
	output = 'default:desert_cobble 9',
	recipe = {
		{'default:gravel', 'default:gravel', 'default:gravel'},
		{'default:gravel', 'bucket:bucket_lava', 'default:gravel'},
		{'default:gravel', 'default:gravel', 'default:gravel'},
	},
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}}
})


if not minetest.registered_items["nodetest:papyrus_roots"] then

minetest.register_node(":nodetest:papyrus_roots", {
	description = "Papyrus Roots",
	tiles = {"nodetest_papyrus_roots.png"},
	paramtype = "light",
	is_ground_content = true,
	liquids_pointable = true,
	groups = {snappy=3, flammable=2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = 'nodetest:papyrus_roots',
	recipe = {
		{'default:papyrus', 'default:papyrus', 'default:papyrus'},
		{'default:papyrus', 'default:papyrus', 'default:papyrus'},
		{'default:papyrus', 'default:papyrus', ''},
	}
})

minetest.register_craft({
	output = 'default:papyrus 8',
	recipe = {
		{'nodetest:papyrus_roots'},
	}
})

minetest.register_abm({
	nodenames = {"nodetest:papyrus_roots"},
	neighbors = {"group:water"},
	interval = 14,
	chance = 71,
	action = function(pos, node)
		pos.y = pos.y+1
		if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos, {name="default:papyrus"})
		end
	end,
})

local function grow_papyrus(pos, node)
	pos.y = pos.y - 1
	local name = minetest.get_node(pos).name
	if name ~= "nodetest:papyrus_roots" then
		return
	end
	if not minetest.find_node_near(pos, 3, {"group:water"}) then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:papyrus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	if minetest.get_node_light(pos) < 13 then
		return
	end
	minetest.set_node(pos, {name = "default:papyrus"})
	return true
end

minetest.register_abm({
	label = "Grow papyrus on roots",
	nodenames = {"default:papyrus"},
	neighbors = {"nodetest:papyrus_roots"},
	interval = 14,
	chance = 71,
	action = function(...)
		grow_papyrus(...)
	end
})

end

-- Lava cooling

-- Exclude coal and diamond from being generated
additional_stuff.not_an_ore = {"default:stone_with_coal", "default:stone_with_diamond"}
additional_stuff.not_an_ore = {"default:stone_with_coal"} --bell07 prefered setting

local function is_not_an_ore(ore_name)
	for _,no_ore in ipairs(additional_stuff.not_an_ore) do
		if ore_name == no_ore then
			return true
		end
	end
	return false
end

-- Place ore just as often as they occur in mapgen.
local function choose_ore(pos)
	local cool_flowing = "default:stone"
	for _, ore in pairs(minetest.registered_ores) do
		if is_not_an_ore(ore.ore) then
			-- Do noting, keep cycling.
		elseif ore.wherein == cool_flowing and ore.ore_type == "scatter" then
			local rarity = math.floor(ore.clust_scarcity / ore.clust_size)
			if math.random(rarity) == 1 then
				cool_flowing = ore.ore
				break
			end
		end
	end
	return cool_flowing
end

default.cool_lava = function(pos, node)
	if node.name == "default:lava_source" then
		local cool_source = "default:stone"
		-- different for subgame used
		if minetest.registered_items["default:molten_rock"] then
			-- Voxelgarden
			cool_source = "default:molten_rock"
		elseif minetest.registered_items["default:obsidian"] then
			-- Minetest Game
			cool_source = "default:obsidian"
		end
		minetest.set_node(pos, {name = cool_source})
	else -- Lava flowing
		local cool_flowing = choose_ore(pos)
		minetest.set_node(pos, {name = cool_flowing})
	end
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end
