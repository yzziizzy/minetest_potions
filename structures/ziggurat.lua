
local function fill_block(min, max, node)
	for x = min.x, max.x do
	for y = min.y, max.y do
	for z = min.z, max.z do
		minetest.set_node({x=x, y=y, z=z}, node)
	end
	end
	end
end


local function ziggurat(pos, step_width, step_height, bottom_h_sz, num_steps)
	
	local w = bottom_h_sz
	
	for sn = 1,num_steps do
		
		fill_block(
			vector.subtract(pos, {x=w, y=0, z=w}),
			vector.add(pos, {x=w, y=step_height*sn-1, z=w}),
			{name="default:sandstonebrick"}
		)
		
		
		w = w - step_width
	end
	
	
	-- TODO: steps
	
end



minetest.register_node("potions:zseed", {
	description = "Ziggurat Seed",
	drawtype = "node",
	tiles = {"default_stone_brick.png^default_tool_pick_stone.png"},
	groups = {cracky=3,},
	on_construct = function(pos)
		ziggurat(pos, 2, 2, 8, 5)
	end
})


