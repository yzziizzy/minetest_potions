

minetest.register_node("potions:grass_growth_accel", {
	description = "Grass Growth Accelerator",
	inventory_image = "default_grass.png",
	tiles = {"default_grass.png"},
	groups = {cracky=3,},
})



local function random_pos(pos, dist)
	local p = {
		x=pos.x + math.random(-dist, dist),
		y=pos.y + 4,
		z=pos.z + math.random(-dist, dist),
	}
	
	while p.y > pos.y - dist do
		local n = minetest.get_node(p)
		if n.name ~= "air" and n.name ~= "ignore" then
			if n.name == "default:water_source" or n.name == "default:water_flowing" then
				return nil
			end
			
			return p
		end
		
		p.y = p.y - 1
	end
	
	return nil
end


minetest.register_abm({
	nodenames = "potions:grass_growth_accel",
	interval = 1,
	chance = 1,
	action = function(pos)
		local p = random_pos(pos, 10)
		if not p then return end
		
		local b = minetest.get_node(p)
		if b.name == "default:dirt" or b.name == "default:dirt_with_dry_grass" then
			minetest.set_node(p, {name="default:dirt_with_grass"})
		elseif b.name == "default:dirt_with_grass" then
			p.y = p.y + 1
			
			local n = minetest.get_node(p)
			if n.name == "air" then
				minetest.set_node(p, {name="default:grass_1"})
			end
		elseif b.name == "default:grass_1" then
			minetest.set_node(p, {name="default:grass_2"})
		elseif b.name == "default:grass_2" then
			minetest.set_node(p, {name="default:grass_3"})
		elseif b.name == "default:grass_3" then
			minetest.set_node(p, {name="default:grass_4"})
		elseif b.name == "default:grass_4" then
			minetest.set_node(p, {name="default:grass_5"})
		elseif b.name == "default:grass_5" then
			return
		end
	end,
})


minetest.register_node("potions:flower_growth_accel", {
	description = "Flower Growth Accelerator",
	inventory_image = "default_grass.png^flowers_rose.png",
	tiles = {"default_grass.png^flowers_rose.png"},
	groups = {cracky=3,},
})





minetest.register_abm({
	nodenames = "potions:flower_growth_accel",
	interval = 1,
	chance = 1,
	action = function(pos)
		local p = random_pos(pos, 10)
		if not p then return end
		
		local b = minetest.get_node(p)
		if b.name == "default:dirt" then
			minetest.set_node(p, {name="default:dirt_with_grass"})
		else
			if b.name == "default:dirt_with_grass" then
				p.y = p.y + 1
				
				local n = minetest.get_node(p)
				if n.name == "air" then
					local f = flowers.datas[math.random(#flowers.datas)]
					minetest.set_node(p, {name="flowers:"..f[1]})
				end
			else
				local def = minetest.registered_nodes[b.name]
				if def.groups.grass then
					local f = flowers.datas[math.random(#flowers.datas)]
					minetest.set_node(p, {name="flowers:"..f[1]})
				end
			end
		end
	end,
})




-- TODO: mushroom accelerator
-- max lifetime for these nodes
