






potions.enchantments = {
	simple = {
		{
			size = 2,
			layout = {"", "default:stick", "default:stick", "" },
			output = "potions:wand",
		}
	}
}

-- TODO: check size 
local function compare_recipe(a, b, bsize) 
	for k,v in ipairs(a.layout) do
		if b[k] ~= v then
			return false
		end
	end
	
	return true
end

local function check_enchanting_recipe(type, layout, size) 
	local tab = potions.enchantments[type]
	if not tab then
		return nil
	end
	
	for _,v in ipairs(tab) do
		if compare_recipe(v, layout, size) then
			return v.output
		end
	end
	
	return nil
end





local function ench_inv_op(pos, listname, index, stack, player)
	if listname == "output" then
		return 
	end
	
	
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	
	local m = inv:get_list("main")--to_table()
	local l = {}
	for k,v in ipairs(m) do
		l[k] = v:get_name()
	end
	
	local res = check_enchanting_recipe("simple", l, 2)
	if res then
		
		inv:set_list("output", {res})
	end
	
end




minetest.register_node("potions:ench_table_wood",  {
	description = "Wooden Enchanting Table", 
	drawtype = "nodebox", 
	node_box = {
		type = "fixed", 
		fixed = {
			{ -0.4, -0.5, -0.4,  -0.25, 0.45, -0.25},
			{ 0.25, -0.5,  0.25,  0.4,  0.45,  0.4},
			{ -0.4, -0.5,  0.25, -0.25, 0.45,  0.4},
			{ 0.25, -0.5, -0.4,   0.4,  0.45, -0.25},
			
			{-0.5, 0.35, -0.5, 0.5, 0.5, 0.5}, 
		},
	},
	tiles = {"default_junglewood.png"},
	paramtype = "light", 
	paramtype2 = "facedir", 
	groups = {choppy = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_wood_defaults(),

	stack_max = 1,
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local formspec = "size[8,8.5]"..
			"label[5,0;Wooden Enchanting Table]" ..
			"list[current_name;main;1,.5;2,2;]" ..
			"list[current_name;output;4.5,1.5;1,1;]" ..
			"list[current_player;main;0,4.25;8,1;]"..
			"list[current_player;main;0,5.5;8,3;8]"..
			default.gui_bg..default.gui_bg_img..default.gui_slots
		
		meta:set_string("formspec", formspec)
		
		meta:set_int("uses", 0)
		
		local inv = meta:get_inventory()
		inv:set_size("main", 2*2)
		inv:set_size("output", 1)

	end,
	
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local owner = placer and placer:get_player_name() or ""
		meta:set_string("owner",  owner)
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "output" then
			return 0
		end
		
		return stack:get_count()
	end,
	
	on_metadata_inventory_put = ench_inv_op,
	on_metadata_inventory_move = ench_inv_op,
	
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "output" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_list("main", {})
		end
	end,
-- 	on_receive_fields = function(pos, formname, fields, player)
-- 		
-- 	end,
})


minetest.register_craft({
	output = 'potions:ench_table_wood',
	recipe = {
		{'dye:black',          'dye:red',            'dye:black'},
		{'default:junglewood', 'default:junglewood', 'default:junglewood'},
		{'default:junglewood', '',                   'default:junglewood'},
	}
})




minetest.register_craftitem("potions:arcane_book", {
	description = "Arcane Book",
	inventory_image = "default_book.png",
	groups = {book = 1, flammable = 3},
})


minetest.register_node("potions:treasure_seed", {
	description = "Treasure Seed",
	tiles = {"default_mese.png"},
	groups = {crumbly = 3},
	drop = "default:sand",
	sounds = default.node_sound_dirt_defaults(),
})




local spawn_treasure = function(pos, node)
print("treasure at " .. dump(pos))
	minetest.set_node(pos, {name="air"})
	pos.y = pos.y - 5

	for x = -1,1 do
		for z = -1,1 do
			minetest.set_node({x=pos.x+x, y=pos.y-1, z=pos.z+z}, {name="default:junglewood"})
		end
	end
	
	
	for y = 0,1 do
	for x = -1,1 do
		for z = -1,1 do
			minetest.set_node({x=pos.x+x, y=pos.y+y, z=pos.z+z}, {name="air"})
		end
	end
	end
	
	for x = -1,1 do
		for z = -1,1 do
			minetest.set_node({x=pos.x+x, y=pos.y+2, z=pos.z+z}, {name="default:junglewood"})
		end
	end
	
	minetest.set_node({x=pos.x+1, y=pos.y+0, z=pos.z+1}, {name="default:fence_junglewood"})
	minetest.set_node({x=pos.x-1, y=pos.y+0, z=pos.z+1}, {name="default:fence_junglewood"})
	minetest.set_node({x=pos.x+1, y=pos.y+0, z=pos.z-1}, {name="default:fence_junglewood"})
	minetest.set_node({x=pos.x-1, y=pos.y+0, z=pos.z-1}, {name="default:fence_junglewood"})
	minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z+1}, {name="default:fence_junglewood"})
	minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z+1}, {name="default:fence_junglewood"})
	minetest.set_node({x=pos.x+1, y=pos.y+1, z=pos.z-1}, {name="default:fence_junglewood"})
	minetest.set_node({x=pos.x-1, y=pos.y+1, z=pos.z-1}, {name="default:fence_junglewood"})
	
	
	pos.z = pos.z + 1
	minetest.set_node(pos, {name = "potions:small_chest"})
	
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_list("main", {"potions:arcane_book"})
	
end


minetest.register_lbm({
	label = "spawn treasure",
	name = "potions:treasure_1",
	nodenames = {"potions:treasure_seed"},
	action = spawn_treasure,
})

--[[
minetest.register_abm({
	label = "spawn treasure",
	name = "potions:treasure_1",
	nodenames = {"potions:treasure_seed"},
	chance = 1,
	interval = 2,
	action = spawn_treasure,
})
]]


minetest.register_decoration({
	name = "potions:treasure_seed",
	deco_type = "simple",
	place_on = {"default:sand"},
	sidelen = 16,
	noise_params = {
		offset = -0.016,
		scale = 0.024,
		spread = {x = 100, y = 100, z = 100},
		seed = 230,
		octaves = 4,
		persist = 0.6
	},
	flags = "force_placement",
	y_max = 5,
	y_min = -8,
	decoration = "potions:treasure_seed",
})




minetest.register_node("potions:small_chest", {
	description = "Small Chest",
	tiles = {
		"default_chest_top.png",
		"default_chest_top.png",
		"default_chest_side.png",
		"default_chest_side.png",
		"default_chest_lock.png",
		"default_chest_side.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4, -0.5, -0.3, 0.4, 0.0, 0.3},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.4, -0.5, -0.3, 0.4, 0.0, 0.3},
		},
	},
	groups = {choppy = 3, oddly_breakable_by_hand = 2, divinable = 1 },
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 3 * 2)
		meta:set_string("formspec",
			"size[8,7;]" ..
			"list[context;main;2,0.3;3,2;]" ..
			"list[current_player;main;0,2.85;8,1;]" ..
			"list[current_player;main;0,4.08;8,3;8]" ..
			"listring[context;main]" ..
			"listring[current_player;main]" ..
			default.get_hotbar_bg(0,2.85)
		)
	end,
	
	can_dig = function(pos,player)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("main")
	end,
})






minetest.register_node("potions:divining_block", {
	description = "Divining Block",
	tiles = {"default_mese.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
	
	on_punch = function(pos, node, player)
		
		if potions.get_manna(player) > 20 then
			
			local p = minetest.find_node_near(pos, 50, {"group:divinable"})
			
			print(dump(p))
			
			if p then
				local dx = p.x - pos.x
				local dz = p.z - pos.z
				local l = math.sqrt(dx*dx + dz*dz)
				
				dx = dx / l
				dz = dz / l
				
				local vel = 4
				
				minetest.add_particlespawner({
					amount = 140,
					time = 15,
					minpos = pos,
					maxpos = pos,
					minvel = {x=dx*vel, y=5.5, z=dz*vel},
					maxvel = {x=dx*vel, y=5.5, z=dz*vel},
					minacc = {x=-0.1, y=-02.1, z=-0.1},
					maxacc = {x=0.1, y=-02.1, z=0.1},
					minexptime = 1.5,
					maxexptime = 5.5,
			-- 		collisiondetection = true,
			-- 		collision_removal = true,
					minsize = 0.5,
					maxsize = 2.5,
					texture = "potions_particle.png^[colorize:yellow:60",
			-- 		animation = tileanimation
					glow = 1
				})
			
			end
			
			potions.add_manna(player, -20)
		end
	
	
	end
	
	
})

