







potions.utils.stairs = function(out, start, dir, height, stair_node, space_above, fill_node)
	
-- 	local out = {}
	local adv = {x=0, z=0}
	
	local param2 = minetest.dir_to_facedir(dir)
	
	for h = 0,height-1 do
		local p = {x=start.x+adv.x, y=start.y+h, z=start.z+adv.z}
		table.insert(out, {vector.new(p), {name=stair_node, param2=param2}})
		
		if fill_node then
			while p.y > start.y do
				p.y = p.y - 1
				table.insert(out, {vector.new(p), {name=fill_node, param2=param2}})
			end
		end
		
		p.y = start.y + h + 1
		for i = 1,space_above do
			table.insert(out, {vector.new(p), {name="air"}})
			p.y = p.y + 1
		end
		
		
		adv.x = adv.x + dir.x
		adv.z = adv.z + dir.z
	end
	
	return out
end



potions.utils.disc_cheap = function(out, pos, radius, node)
	local r = math.ceil(radius)
-- 	local out = {}
	
	for x = -r,r do
	for z = -r,r do
		if radius >= math.sqrt(x*x + z*z) then
			table.insert(out, {{x=pos.x+x, y=pos.y, z=pos.z+z}, {name=node}})
		end
	end
	end
	
	return out
end


-- the nodes are not in consecutive order
potions.utils.circle_cheap = function(out, pos, radius, node)
	
	local r = radius
	local r2f = math.floor(r * math.sin(math.pi/4) + .5) 
	local r2c = math.floor(r * math.sin(math.pi/4) + .5)
	
-- 	local out = {}
	
	for x = -r2f,r2c,1 do
		local z = math.sqrt(r*r - x*x)
		
		table.insert(out, {{x=pos.x+x, y=pos.y, z=pos.z+z}, {name=node}})
		table.insert(out, {{x=pos.x+x, y=pos.y, z=pos.z-z}, {name=node}})
-- 		minetest.set_node({x=pos.x+x, y=pos.y, z=pos.z+z}, {name=node})
-- 		minetest.set_node({x=pos.x+x, y=pos.y, z=pos.z-z}, {name=node})
	end
	
	
	for z = -r2f,r2c,1 do
		local x = math.sqrt(r*r - z*z)
		
		table.insert(out, {{x=pos.x+x, y=pos.y, z=pos.z+z}, {name=node}})
		table.insert(out, {{x=pos.x-x, y=pos.y, z=pos.z+z}, {name=node}})
-- 		minetest.set_node({x=pos.x+x, y=pos.y+1, z=pos.z+z}, {name=node})
-- 		minetest.set_node({x=pos.x-x, y=pos.y+1, z=pos.z+z}, {name=node})
	end
	
	return out
end

-- the nodes are not in consecutive order
potions.utils.cylinder_cheap = function(out, pos, radius, height, node)
	
	local circ = potions.utils.circle_cheap({}, pos, radius, node)
	
-- 	local out = {}
	
	for h = 1,height do
		for _,pn in ipairs(circ) do
			table.insert(out, {vector.add(pn[1], {x=0, y=h, z=0}), pn[2]})
		end
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
		
		local nodes = {}
		
		
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+0, z=pos.z}, 6.8, "default:stonebrick")
-- 		minetest.bulk_set_node(disc, {name="default:wood"})
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+5, z=pos.z}, 6.8, "default:wood")
-- 		minetest.bulk_set_node(disc, {name="default:wood"})
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+10, z=pos.z}, 6.8, "default:wood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+15, z=pos.z}, 6.8, "default:wood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+20, z=pos.z}, 6.8, "default:wood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+25, z=pos.z}, 6.8, "default:wood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+30, z=pos.z}, 6.8, "default:wood")
-- 		minetest.bulk_set_node(disc, {name="default:wood"})
		
		local opos = vector.new(pos)
		potions.utils.stairs(nodes, vector.add(pos, {x=0,y=1,z=0}), {x=-1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=-4,y=6,z=1}), {x=1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=0,y=11,z=0}), {x=-1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=-4,y=16,z=1}), {x=1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=0,y=21,z=0}), {x=-1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=-4,y=26,z=1}), {x=1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		
		pos = opos
		pos.y = pos.y - 1
		
		potions.utils.cylinder_cheap(nodes, pos, 7, 32, "default:stonebrick")
		
		table.insert(nodes, {{x=pos.x+7, y=pos.y+2, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+3, z=pos.z}, {name="air"}})
		
		table.insert(nodes, {{x=pos.x+7, y=pos.y+8, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+13, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+18, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+23, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+28, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+33, z=pos.z}, {name="air"}})
		
		table.insert(nodes, {{x=pos.x-7, y=pos.y+8, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+13, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+18, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+23, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+28, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+33, z=pos.z}, {name="air"}})
		
		table.insert(nodes, {{x=pos.x, y=pos.y+8, z=pos.z+7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+13, z=pos.z+7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+18, z=pos.z+7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+23, z=pos.z+7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+28, z=pos.z+7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+33, z=pos.z+7}, {name="air"}})
		
		table.insert(nodes, {{x=pos.x, y=pos.y+8, z=pos.z-7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+13, z=pos.z-7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+18, z=pos.z-7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+23, z=pos.z-7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+28, z=pos.z-7}, {name="air"}})
		table.insert(nodes, {{x=pos.x, y=pos.y+33, z=pos.z-7}, {name="air"}})
		
		table.insert(nodes, {{x=pos.x-6, y=pos.y+4, z=pos.z}, {name="default:torch_wall", param2=3}})
		table.insert(nodes, {{x=pos.x, y=pos.y+4, z=pos.z+6}, {name="default:torch_wall", param2=4}})
		table.insert(nodes, {{x=pos.x, y=pos.y+4, z=pos.z-6}, {name="default:torch_wall", param2=5}})
		
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z-2}, {name="default:chest_locked", param2=1}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z-1}, {name="default:chest_locked", param2=1}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z+1}, {name="default:chest_locked", param2=1}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z+2}, {name="default:chest_locked", param2=1}})
		
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z-2}, {name="default:chest_locked", param2=3}})
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z-1}, {name="default:chest_locked", param2=3}})
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z+1}, {name="default:chest_locked", param2=3}})
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z+2}, {name="default:chest_locked", param2=3}})
		
		table.insert(nodes, {{x=pos.x-2, y=pos.y+22, z=pos.z+6}, {name="default:chest_locked", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+22, z=pos.z+6}, {name="default:chest_locked", param2=0}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+22, z=pos.z+6}, {name="default:chest_locked", param2=0}})
		table.insert(nodes, {{x=pos.x+2, y=pos.y+22, z=pos.z+6}, {name="default:chest_locked", param2=0}})
		
		table.insert(nodes, {{x=pos.x-2, y=pos.y+22, z=pos.z-6}, {name="default:chest_locked", param2=2}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+22, z=pos.z-6}, {name="default:chest_locked", param2=2}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+22, z=pos.z-6}, {name="default:chest_locked", param2=2}})
		table.insert(nodes, {{x=pos.x+2, y=pos.y+22, z=pos.z-6}, {name="default:chest_locked", param2=2}})
		
		
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z-2}, {name="default:bookshelf", param2=1}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z-1}, {name="default:bookshelf", param2=1}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z+1}, {name="default:bookshelf", param2=1}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+22, z=pos.z+2}, {name="default:bookshelf", param2=1}})
		
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z-2}, {name="default:bookshelf", param2=3}})
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z-1}, {name="default:bookshelf", param2=3}})
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z+1}, {name="default:bookshelf", param2=3}})
		table.insert(nodes, {{x=pos.x-6, y=pos.y+22, z=pos.z+2}, {name="default:bookshelf", param2=3}})
		
		table.insert(nodes, {{x=pos.x-2, y=pos.y+22, z=pos.z+6}, {name="default:bookshelf", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+22, z=pos.z+6}, {name="default:bookshelf", param2=0}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+22, z=pos.z+6}, {name="default:bookshelf", param2=0}})
		table.insert(nodes, {{x=pos.x+2, y=pos.y+22, z=pos.z+6}, {name="default:bookshelf", param2=0}})
		
		table.insert(nodes, {{x=pos.x-2, y=pos.y+22, z=pos.z-6}, {name="default:bookshelf", param2=2}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+22, z=pos.z-6}, {name="default:bookshelf", param2=2}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+22, z=pos.z-6}, {name="default:bookshelf", param2=2}})
		table.insert(nodes, {{x=pos.x+2, y=pos.y+22, z=pos.z-6}, {name="default:bookshelf", param2=2}})
		
		
		
		potions.utils.spawn_set(nodes, .5, 350)
		
	end,
})









