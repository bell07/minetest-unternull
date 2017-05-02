minetest.register_craft({
	type = "cooking",
	output = "default:lava_source",
	recipe = "default:stone",
	cooktime = 20,
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

if not minetest.get_modpath("nodetest") then

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
		{'default:papyrus', 'default:papyrus'},
		{'default:papyrus', 'default:papyrus'},
	}
})

minetest.register_craft({
	output = 'default:papyrus 4',
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
