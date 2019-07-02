





potions.utils.spawn_in = function(nodes, height, node, delay, nmax)
	
	local h = 0
	local i = 1
	
	local function go()
		for n = 1,nmax do
			
			if i > #nodes then
				i = 1
				h = h + 1
				if h > height then
					return
				end
			end
			
			
			local p = nodes[i]
			
			minetest.set_node({x=p.x, y=p.y+h, z=p.z}, {name=node})
			
			i = i + 1 
		end
		
		minetest.after(delay, go)
	end
	
	go()
	
end



potions.utils.stairs = function(start, dir, height, stair_node, space_above, fill_node)
	
	local adv = {x=0, z=0}
	
	local param2 = minetest.dir_to_facedir(dir)
	
	for h = 0,height-1 do
		local p = {x=start.x+adv.x, y=start.y+h, z=start.z+adv.z}
		minetest.set_node(p, {name=stair_node, param2=param2})
		
		
		if fill_node then
			while p.y > start.y do
				p.y = p.y - 1
				minetest.set_node(p, {name=fill_node})
			end
		end
		
		p.y = start.y + h + 1
		for i = 1,space_above do
			minetest.set_node(p, {name="air"})
			p.y = p.y + 1
		end
		
		
		adv.x = adv.x + dir.x
		adv.z = adv.z + dir.z
	end
	
end



potions.utils.disc_cheap = function(pos, radius)
	local r = math.ceil(radius)
	local out = {}
	
	for x = -r,r do
	for z = -r,r do
		if radius >= math.sqrt(x*x + z*z) then
			table.insert(out, {x=pos.x+x, y=pos.y, z=pos.z+z})
		end
	end
	end
	
	return out
end


-- the nodes are not in consecutive order
potions.utils.circle_cheap = function(pos, radius)
	
	local r = radius
	local r2f = math.floor(r * math.sin(math.pi/4) + .5) 
	local r2c = math.floor(r * math.sin(math.pi/4) + .5)
	
	local out = {}
	
	for x = -r2f,r2c,1 do
		local z = math.sqrt(r*r - x*x)
		
		table.insert(out, {x=pos.x+x, y=pos.y, z=pos.z+z})
		table.insert(out, {x=pos.x+x, y=pos.y, z=pos.z-z})
-- 		minetest.set_node({x=pos.x+x, y=pos.y, z=pos.z+z}, {name=node})
-- 		minetest.set_node({x=pos.x+x, y=pos.y, z=pos.z-z}, {name=node})
	end
	
	
	for z = -r2f,r2c,1 do
		local x = math.sqrt(r*r - z*z)
		
		table.insert(out, {x=pos.x+x, y=pos.y, z=pos.z+z})
		table.insert(out, {x=pos.x-x, y=pos.y, z=pos.z+z})
-- 		minetest.set_node({x=pos.x+x, y=pos.y+1, z=pos.z+z}, {name=node})
-- 		minetest.set_node({x=pos.x-x, y=pos.y+1, z=pos.z+z}, {name=node})
	end
	
	return out
end







minetest.register_craftitem("potions:spiral_test", {
	description = "Spiral Seed",
	inventory_image = "default_brick.png",
	groups = {cracky=3,},
 	liquids_pointable=true,
	
	on_use = function(itemstack, player, pointed_thing)
		
		local pos = pointed_thing.above
		if not pos then
			return
		end
		
		pos.y = pos.y + 1
		
		local nodes = potions.utils.circle_cheap(pos, 7)
		
		
		local disc = potions.utils.disc_cheap({x=pos.x, y=pos.y+0, z=pos.z}, 6.8)
		minetest.bulk_set_node(disc, {name="default:wood"})
		local disc = potions.utils.disc_cheap({x=pos.x, y=pos.y+5, z=pos.z}, 6.8)
		minetest.bulk_set_node(disc, {name="default:wood"})
		local disc = potions.utils.disc_cheap({x=pos.x, y=pos.y+10, z=pos.z}, 6.8)
		minetest.bulk_set_node(disc, {name="default:wood"})
		
		pos.y = pos.y + 1
		potions.utils.stairs(pos, {x=-1, z=0}, 5, "stairs:stair_cobble", 3, "default:tree")
		pos.y = pos.y - 1
		
		
		potions.utils.spawn_in(nodes, 10, "default:dirt", .5, 6)
		
	end,
})









