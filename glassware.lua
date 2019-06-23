
minetest.register_craftitem("potions:erlenmeyer_flask", {
	description = "Erlenmeyer Flask",
	inventory_image = "potions_erlenmeyer_flask_empty.png",
	groups = {vessel = 1},
})

minetest.register_craftitem("potions:beaker", {
	description = "Glass Beaker",
	inventory_image = "potions_beaker_empty.png",
	groups = {vessel = 1},
})

minetest.register_craftitem("potions:vial", {
	description = "Glass Vial",
	inventory_image = "potions_test_tube_empty.png",
	groups = {vessel = 1},
})

minetest.register_craftitem("potions:round_flask", {
	description = "Round-bottom Flask",
	inventory_image = "potions_round_flask_empty.png",
	groups = {vessel = 1},
})




local function get_gbf_formspec()
	return 
	
	
	
end



minetest.register_node("potions:glass_blowing_furnace", {
	description = "Glass Blowing Furnace",
	tiles = {"default_furnace.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory(pos)
		inv:set_size("fuel", 1)
		inv:set_size("input", 2*3)
		inv:set_size("output", 2*3)
		
		meta:set_string("formspec", get_gbf_formspec())
	end,
	
	on_timer = function(pos)
	
	end,
	
	on_receive_fields = function()
	
		minetest.swap_node(pos, {name = "potions:glass_blowing_furnace_warming"})
		minetest.get_timer(pos):start(1)
	end,
})

minetest.register_node("potions:glass_blowing_furnace_warming", {
	description = "Glass Blowing Furnace",
	tiles = {"default_furnace.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory(pos)
		inv:set_size("fuel", 1)
		inv:set_size("input", 2*3)
		inv:set_size("output", 2*3)
		
		meta:set_string("formspec", get_gbf_formspec())
	end,
	
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory(pos)
		
		
		
		
		if burned >= 60 then
			minetest.swap_node(pos, {name = "potions:glass_blowing_furnace_on"})
		end
	end,
})
	
minetest.register_node("potions:glass_blowing_furnace_on", {
	description = "Glass Blowing Furnace",
	tiles = {"default_furnace.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory(pos)
		inv:set_size("fuel", 1)
		inv:set_size("input", 2*3)
		inv:set_size("output", 2*3)
		
		meta:set_string("formspec", get_gbf_formspec())
	end,
	
	on_timer = function(pos)
		
	end,
})
	

