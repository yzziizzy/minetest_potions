

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








