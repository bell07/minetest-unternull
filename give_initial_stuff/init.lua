minetest.register_on_newplayer(function(player)
	if minetest.get_modpath("nodetest") then
		player:get_inventory():add_item('main', 'default:cobble 27')
	else
		player:get_inventory():add_item('main', 'default:cobble 9')
	end
	player:get_inventory():add_item('main', 'nodetest:papyrus_roots 18')
	player:get_inventory():add_item('main', 'default:dirt 9')
	player:get_inventory():add_item('main', "default:sapling")
	player:get_inventory():add_item('main', "default:junglesapling")
	if minetest.get_modpath("conifer") then
		player:get_inventory():add_item('main', "conifer:sapling")
	end
end)
