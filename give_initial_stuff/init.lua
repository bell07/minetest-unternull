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

local filepath = minetest.get_worldpath().."/origin.mt"
local file = io.open(filepath, "r")
if file then
	io.close(file)
	origin_exists = true
else
	origin_exists = false
end

minetest.register_on_generated(function(minp, maxp, seed)
	local spawn = minetest.setting_get_pos("static_spawnpoint")
	if not origin_exists then
		if spawn ~= nil then
			blockpos = { x=spawn.x, y=spawn.y, z=spawn.z }
		else
			blockpos = { x=0, y=0, z=0 }
		end
		if(minp.x <= blockpos.x and maxp.x >= blockpos.x and minp.y <= blockpos.y and maxp.y >= blockpos.y and minp.z <= blockpos.z and maxp.z >= blockpos.z) then
			-- Create chest
			minetest.set_node(blockpos, {name="default:chest"})
			local meta = minetest.get_meta(blockpos)
			meta:set_string("formspec", chest_formspec)
			local inv = meta:get_inventory()
			inv:set_size("main", 8*4)

			-- Fill with stuff
			inv:set_stack("main", 1, 'default:cobble 12')
			inv:set_stack("main", 2, 'nodetest:papyrus_roots 6')
			inv:set_stack("main", 3, 'default:dirt 2')
			inv:set_stack("main", 4, 'default:sapling')
			inv:set_stack("main", 5, 'default:junglesapling')
			if minetest.get_modpath("conifer") then
				inv:set_stack("main", 6, 'conifer:sapling')
			end

			local filepath = minetest.get_worldpath().."/origin.mt"
			local file = io.open(filepath, "w")
			file:write(minetest.pos_to_string(blockpos))
		end
	end
	origin_exists = true
end)
