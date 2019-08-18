

local function make_hole(pos, depth)
	
	
	for d = 0,depth do
		
		local p = {x=pos.x, y=pos.y-d, z=pos.z}

		
		minetest.set_node(p, {name="default:ladder", param2 = 3})
	end
	
	
end





minetest.register_craftitem("potions:instant_hole", {
	description = "Instant Hole",
	inventory_image = "default_dirt_with_grass.png",
	wield_image = "default_dirt_with_grass.png",
	
	on_use = function(itemstack, player, pointed_thing)
		
		local pos = pointed_thing.under
		if not pos then
			return
		end
		
		local dist = 100 -- vector.distance(pos, pos2)
		
		dist = potions.use_manna(player, dist)
		
		if dist < 2 then
			return
		end

		make_hole(pos, dist)
		
		itemstack:take_item()
		return itemstack
	end,
})
