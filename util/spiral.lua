







potions.utils.area = function(out, min, max, node)
	
	local n
	if type(node) == "string" then
		n = {name=node}
	else
		n = node
	end
	
	local minx = math.min(min.x, max.x)
	local miny = math.min(min.y, max.y)
	local minz = math.min(min.z, max.z)
	local maxx = math.max(min.x, max.x)
	local maxy = math.max(min.y, max.y)
	local maxz = math.max(min.z, max.z)
	
	
	for y = miny,maxy do
	for x = minx,maxx do
	for z = minz,maxz do
		table.insert(out, {{x=x, y=y, z=z}, n})
	end
	end
	end
	
	
	return out
end


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







minetest.register_craftitem("potions:test_tool", {
	description = "Test Tool",
	inventory_image = "default_sand.png",
	groups = {cracky=3,},
 	liquids_pointable=true,
	
	on_use = function(itemstack, player, pointed_thing)
		
		local pos = pointed_thing.above
		pos.y=pos.y-1
		local meta = minetest.get_meta(pos)
		print(dump(meta:to_table()))
		
	end,
})


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
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+10, z=pos.z}, 6.8, "default:aspen_wood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+15, z=pos.z}, 6.8, "default:pine_wood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+20, z=pos.z}, 6.8, "default:junglewood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+25, z=pos.z}, 6.8, "default:wood")
		potions.utils.disc_cheap(nodes, {x=pos.x, y=pos.y+30, z=pos.z}, 6.8, "default:wood")
-- 		minetest.bulk_set_node(disc, {name="default:wood"})
		
		local opos = vector.new(pos)
		potions.utils.stairs(nodes, vector.add(pos, {x=2,y=1,z=0}), {x=-1, z=0}, 5, "stairs:stair_stonebrick", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=-2,y=6,z=1}), {x=1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=2,y=11,z=0}), {x=-1, z=0}, 5, "stairs:stair_aspen_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=-2,y=16,z=1}), {x=1, z=0}, 5, "stairs:stair_pine_wood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=2,y=21,z=0}), {x=-1, z=0}, 5, "stairs:stair_junglewood", 3, "default:tree")
		potions.utils.stairs(nodes, vector.add(pos, {x=-2,y=26,z=1}), {x=1, z=0}, 5, "stairs:stair_wood", 3, "default:tree")
		
		pos = opos
		pos.y = pos.y - 1
		
		potions.utils.cylinder_cheap(nodes, pos, 7, 32, "default:stonebrick")
		
		-- door
		table.insert(nodes, {{x=pos.x+7, y=pos.y+3, z=pos.z}, {name="air"}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+2, z=pos.z}, {name="doors:door_steel_a", param2=1}})
		
		-- windows
		table.insert(nodes, {{x=pos.x+7, y=pos.y+8, z=pos.z}, {name="xpanes:bar_flat", param2=3}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+13, z=pos.z}, {name="xpanes:pane_flat", param2=3}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+18, z=pos.z}, {name="xpanes:pane_flat", param2=3}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+23, z=pos.z}, {name="xpanes:pane_flat", param2=3}})
		table.insert(nodes, {{x=pos.x+7, y=pos.y+28, z=pos.z}, {name="xpanes:obsidian_pane_flat", param2=3}})
		
		table.insert(nodes, {{x=pos.x-7, y=pos.y+8, z=pos.z}, {name="xpanes:bar_flat", param2=3}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+13, z=pos.z}, {name="xpanes:pane_flat", param2=3}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+18, z=pos.z}, {name="xpanes:pane_flat", param2=3}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+23, z=pos.z}, {name="xpanes:pane_flat", param2=3}})
		table.insert(nodes, {{x=pos.x-7, y=pos.y+28, z=pos.z}, {name="xpanes:obsidian_pane_flat", param2=3}})
		
		table.insert(nodes, {{x=pos.x, y=pos.y+8, z=pos.z+7}, {name="xpanes:bar_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+13, z=pos.z+7}, {name="xpanes:pane_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+18, z=pos.z+7}, {name="xpanes:pane_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+23, z=pos.z+7}, {name="xpanes:pane_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+28, z=pos.z+7}, {name="xpanes:obsidian_pane_flat", param2=0}})
		
		table.insert(nodes, {{x=pos.x, y=pos.y+8, z=pos.z-7}, {name="xpanes:bar_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+13, z=pos.z-7}, {name="xpanes:pane_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+18, z=pos.z-7}, {name="xpanes:pane_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+23, z=pos.z-7}, {name="xpanes:pane_flat", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+28, z=pos.z-7}, {name="xpanes:obsidian_pane_flat", param2=0}})
		
		-- first level torches
		table.insert(nodes, {{x=pos.x-6, y=pos.y+4, z=pos.z}, {name="default:torch_wall", param2=3}})
		table.insert(nodes, {{x=pos.x, y=pos.y+4, z=pos.z+6}, {name="default:torch_wall", param2=4}})
		table.insert(nodes, {{x=pos.x, y=pos.y+4, z=pos.z-6}, {name="default:torch_wall", param2=5}})

		-- second level beds
		table.insert(nodes, {{x=pos.x-3, y=pos.y+7, z=pos.z-5}, {name="beds:fancy_bed_top", param2=2}})
		table.insert(nodes, {{x=pos.x-3, y=pos.y+7, z=pos.z-4}, {name="beds:fancy_bed_bottom", param2=2}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+7, z=pos.z-5}, {name="beds:fancy_bed_top", param2=2}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+7, z=pos.z-4}, {name="beds:fancy_bed_bottom", param2=2}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+7, z=pos.z-5}, {name="beds:fancy_bed_top", param2=2}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+7, z=pos.z-4}, {name="beds:fancy_bed_bottom", param2=2}})
		table.insert(nodes, {{x=pos.x+3, y=pos.y+7, z=pos.z-5}, {name="beds:fancy_bed_top", param2=2}})
		table.insert(nodes, {{x=pos.x+3, y=pos.y+7, z=pos.z-4}, {name="beds:fancy_bed_bottom", param2=2}})
		
		table.insert(nodes, {{x=pos.x-3, y=pos.y+7, z=pos.z+5}, {name="beds:fancy_bed_top", param2=0}})
		table.insert(nodes, {{x=pos.x-3, y=pos.y+7, z=pos.z+4}, {name="beds:fancy_bed_bottom", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+7, z=pos.z+5}, {name="beds:fancy_bed_top", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+7, z=pos.z+4}, {name="beds:fancy_bed_bottom", param2=0}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+7, z=pos.z+5}, {name="beds:fancy_bed_top", param2=0}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+7, z=pos.z+4}, {name="beds:fancy_bed_bottom", param2=0}})
		table.insert(nodes, {{x=pos.x+3, y=pos.y+7, z=pos.z+5}, {name="beds:fancy_bed_top", param2=0}})
		table.insert(nodes, {{x=pos.x+3, y=pos.y+7, z=pos.z+4}, {name="beds:fancy_bed_bottom", param2=0}})
		
		local food_inv = {}
		for _ = 1,32 do table.insert(food_inv, "default:apple 99") end
		
		table.insert(nodes, {{x=pos.x+6, y=pos.y+7, z=pos.z+2}, {name="default:chest", param2=1}, {main=food_inv}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+7, z=pos.z+1}, {name="default:chest", param2=1}, {main=food_inv}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+7, z=pos.z-1}, {name="default:chest", param2=1}, {main=food_inv}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+7, z=pos.z-2}, {name="default:chest", param2=1}, {main=food_inv}})

		
		
		local box_ring = {
			{{x=5, y=0, z=-4}, 1},
			{{x=5, y=0, z=-3}, 1},
			{{x=6, y=0, z=-2}, 1},
			{{x=6, y=0, z=-1}, 1},
			{{x=6, y=0, z=1}, 1},
			{{x=6, y=0, z=2}, 1},
			{{x=5, y=0, z=3}, 1},
			{{x=5, y=0, z=4}, 1},
			
			{{x=-5, y=0, z=-4}, 3},
			{{x=-5, y=0, z=-3}, 3},
			{{x=-6, y=0, z=-2}, 3},
			{{x=-6, y=0, z=-1}, 3},
			{{x=-6, y=0, z=1}, 3},
			{{x=-6, y=0, z=2}, 3},
			{{x=-5, y=0, z=3}, 3},
			{{x=-5, y=0, z=4}, 3},
			
			{{x=-4, y=0, z=5}, 0},
			{{x=-3, y=0, z=5}, 0},
			{{x=-2, y=0, z=6}, 0},
			{{x=-1, y=0, z=6}, 0},
			{{x=1, y=0, z=6}, 0},
			{{x=2, y=0, z=6}, 0},
			{{x=3, y=0, z=5}, 0},
			{{x=4, y=0, z=5}, 0},
			
			{{x=-4, y=0, z=-5}, 2},
			{{x=-3, y=0, z=-5}, 2},
			{{x=-2, y=0, z=-6}, 2},
			{{x=-1, y=0, z=-6}, 2},
			{{x=1, y=0, z=-6}, 2},
			{{x=2, y=0, z=-6}, 2},
			{{x=3, y=0, z=-5}, 2},
			{{x=4, y=0, z=-5}, 2},
		}
		
-- 		local main = {"default:dirt 12"}

		local book_inv = {}
		for _ = 1,16 do table.insert(book_inv, "default:book") end
		
-- 		local book_inv = {}
-- 		for _ = 1,16 do table.insert(book_inv, "default:book") end

		
		for i,v in ipairs(box_ring) do
			table.insert(nodes, {vector.add({x=0,y=17,z=0}, vector.add(pos, v[1])), {name="default:chest_locked", param2=v[2]}, {}})
			
			table.insert(nodes, {vector.add({x=0,y=22,z=0}, vector.add(pos, v[1])), {name="vessels:shelf", param2=v[2]}, {}})
			table.insert(nodes, {vector.add({x=0,y=23,z=0}, vector.add(pos, v[1])), {name="vessels:shelf", param2=v[2]}, {}})
			
			table.insert(nodes, {vector.add({x=0,y=27,z=0}, vector.add(pos, v[1])), {name="default:bookshelf", param2=v[2]}, {books=book_inv}})
			table.insert(nodes, {vector.add({x=0,y=28,z=0}, vector.add(pos, v[1])), {name="default:bookshelf", param2=v[2]}, {books=book_inv}})
			table.insert(nodes, {vector.add({x=0,y=29,z=0}, vector.add(pos, v[1])), {name="default:bookshelf", param2=v[2]}, {books=book_inv}})
			table.insert(nodes, {vector.add({x=0,y=30,z=0}, vector.add(pos, v[1])), {name="default:bookshelf", param2=v[2]}, {books=book_inv}})
			
		end
			
		-- workshop equipment
		table.insert(nodes, {{x=pos.x+1, y=pos.y+22, z=pos.z-3}, {name="default:wood", param2=0}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+23, z=pos.z-3}, {name="potions:glass_still", param2=0}})
		table.insert(nodes, {{x=pos.x+0, y=pos.y+22, z=pos.z-3}, {name="default:wood", param2=0}})
		table.insert(nodes, {{x=pos.x+0, y=pos.y+23, z=pos.z-3}, {name="potions:glass_still", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+22, z=pos.z-3}, {name="default:wood", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+23, z=pos.z-3}, {name="potions:glass_still", param2=0}})
		
		table.insert(nodes, {{x=pos.x, y=pos.y+27, z=pos.z-3}, {name="potions:ench_table_wood", param2=0}})
		
		-- coral tank contents
		table.insert(nodes, {{x=pos.x+2, y=pos.y+12, z=pos.z-6}, {name="default:sand", param2=0}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+12, z=pos.z-6}, {name="default:coral_green", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+12, z=pos.z-6}, {name="default:coral_cyan", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+12, z=pos.z-6}, {name="default:coral_pink", param2=0}})
		table.insert(nodes, {{x=pos.x-2, y=pos.y+12, z=pos.z-6}, {name="default:sand", param2=0}})
	
		table.insert(nodes, {{x=pos.x+2, y=pos.y+12, z=pos.z+6}, {name="default:sand", param2=0}})
		table.insert(nodes, {{x=pos.x+1, y=pos.y+12, z=pos.z+6}, {name="default:coral_green", param2=0}})
		table.insert(nodes, {{x=pos.x, y=pos.y+12, z=pos.z+6}, {name="default:coral_pink", param2=0}})
		table.insert(nodes, {{x=pos.x-1, y=pos.y+12, z=pos.z+6}, {name="default:coral_cyan", param2=0}})
		table.insert(nodes, {{x=pos.x-2, y=pos.y+12, z=pos.z+6}, {name="default:sand", param2=0}})
		table.insert(nodes, {{x=pos.x+2, y=pos.y+12, z=pos.z+6}, {name="default:sand", param2=0}})
	
		-- coral tank water
		potions.utils.area(nodes, {x=pos.x-2, y=pos.y+13, z=pos.z+6},{x=pos.x+2, y=pos.y+13, z=pos.z+6}, "default:river_water_source")
		potions.utils.area(nodes, {x=pos.x-2, y=pos.y+13, z=pos.z-6},{x=pos.x+2, y=pos.y+13, z=pos.z-6}, "default:river_water_source")
		
		-- coral tank glass
		potions.utils.area(nodes, {x=pos.x-3, y=pos.y+12, z=pos.z+5},{x=pos.x+3, y=pos.y+13, z=pos.z+5}, "default:obsidian_glass")
		potions.utils.area(nodes, {x=pos.x-3, y=pos.y+12, z=pos.z-5},{x=pos.x+3, y=pos.y+13, z=pos.z-5}, "default:obsidian_glass")
		
		
		table.insert(nodes, {{x=pos.x-6, y=pos.y+17, z=pos.z+0}, {name="default:furnace", param2=3}})
		table.insert(nodes, {{x=pos.x+6, y=pos.y+17, z=pos.z+0}, {name="default:furnace", param2=1}})
		table.insert(nodes, {{x=pos.x+0, y=pos.y+17, z=pos.z+6}, {name="default:furnace", param2=0}})
		table.insert(nodes, {{x=pos.x+0, y=pos.y+17, z=pos.z-6}, {name="default:furnace", param2=2}})
	
		
		potions.utils.spawn_set(nodes, .5, 500)
		
	end,
})









