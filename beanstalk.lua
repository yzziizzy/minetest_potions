

	
local function reg_stalk_node(name, speed)
	minetest.register_node("potions:beanstalk_"..name, {
		description = "Magic Beanstalk "..name,
		drawtype = "plantlike",
		waving = false,
		tiles = {"default_leaves.png"},
		paramtype = "light",
		paramtype2 = "meshoptions",
		place_param2 = 2,
		walkable = false,
		climbable = true,
		buildable_to = false,
		sunlight_propagates = true,
		drop = {},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		groups = {snappy = 3, oddly_breakable_by_hand = 3, flammable = 1},
		sounds = default.node_sound_leaves_defaults(),
		-- todo: ondestruct
-- 		after_dig_node = cut_whole_plant,
	})
	
	minetest.register_node("potions:beanstalk_active_"..name, {
		description = "Magic Beanstalk "..name,
		drawtype = "plantlike",
		waving = false,
		tiles = {"default_leaves.png"},
		paramtype = "light",
		paramtype2 = "meshoptions",
		place_param2 = 2,
		walkable = false,
		climbable = true,
		buildable_to = false,
		sunlight_propagates = true,
		drop = {},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		on_timer = function(pos)
			pos.y = pos.y + 1
			local n = minetest.get_node(pos)
			if n.name == "ignore" then
				return
			end
			
			if n.name == "air" then
				minetest.set_node(pos, {name="potions:beanstalk_active_"..name, param2 = 2})
				minetest.get_node_timer(pos):start(speed)
			end
			
			pos.y = pos.y - 1 
			minetest.set_node(pos, {name="potions:beanstalk_"..name, param2 = 2})
		end,
		
		groups = {snappy = 3, flammable = 1, oddly_breakable_by_hand = 3, active_beanstalk = 1},
		sounds = default.node_sound_leaves_defaults(),
		
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(speed)
		end,
		-- todo: ondestruct
-- 		after_dig_node = cut_whole_plant,
	})
end

reg_stalk_node("regular", 1)



minetest.register_abm({
	nodenames = "group:active_beanstalk",
	interval = 60,
	chance = 1,
	action = function(pos)
		minetest.get_node_timer(pos):start(1)
		
	end,
})
