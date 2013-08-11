minetest.register_on_newplayer(function(player)
	player:get_inventory():add_item('main', 'default:papyrus_roots 9')
	player:get_inventory():add_item('main', 'default:dirt 9')
	player:get_inventory():add_item('main', 'default:cobble 9')
	player:get_inventory():add_item('main', 'default:sapling')
end)

