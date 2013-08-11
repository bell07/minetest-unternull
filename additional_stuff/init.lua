minetest.register_craft({
	type = "cooking",
	output = "default:lava_source",
	recipe = "default:stone",
	cooktime = 30,
})

minetest.register_craft({
	output = 'default:furnace',
	recipe = {
		{'default:cobble', 'default:cobble', 'default:cobble'},
		{'default:cobble', '', 'default:cobble'},
		{'default:cobble', 'default:cobble', 'default:cobble'},
	}
})

minetest.register_craft({
	output = 'default:dirt',
	recipe = {
		{'default:papyrus_roots', 'default:papyrus_roots'},
		{'default:papyrus_roots', 'default:papyrus_roots'},
	}
})
