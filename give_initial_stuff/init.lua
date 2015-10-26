minetest.register_on_newplayer(function(player)
	player:get_inventory():add_item('main', 'default:cobble 12')
	player:get_inventory():add_item('main', 'nodetest:papyrus_roots 6')
	player:get_inventory():add_item('main', 'default:dirt 2')
	player:get_inventory():add_item('main', "default:sapling")
	player:get_inventory():add_item('main', "default:junglesapling")
	if minetest.get_modpath("conifer") then
		player:get_inventory():add_item('main', "conifer:sapling")
	end
end)
