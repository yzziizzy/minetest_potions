
--[[

torches
loot
doors
traps
mining side-tunnels
minerals embedded in walls
cave-ins 
signs
poisonous or explosive mine gasses

room types:
	barracks, with beds
	dining hall, kitchen
	ore storage room
	chemistry lab
	
fancy exterior entrance

]]








minetest.register_node("potions:trap_floor", {
	description = "Trap Floor",
	drawtype = "node",
	tiles = {"default_stone_brick.png"},
	groups = {cracky=3,},
})


local function trigger_trap(pos)
	local n = minetest.get_node(pos)
	if not n or n.name ~= "potions:trap_floor" then
		return
	end
	
	minetest.swap_node(pos, {name="default:stonebrick"})
	minetest.spawn_falling_node(pos)
	
	minetest.after(.3, trigger_trap, {x=pos.x-1, y=pos.y, z=pos.z})
	minetest.after(.3, trigger_trap, {x=pos.x+1, y=pos.y, z=pos.z})
	minetest.after(.3, trigger_trap, {x=pos.x, y=pos.y, z=pos.z+1})
	minetest.after(.3, trigger_trap, {x=pos.x, y=pos.y, z=pos.z-1})
	
end

minetest.register_abm({
	nodenames = {"potions:trap_floor"},
	interval = 3,
	chance = 10,
	action = function(pos)
		local objs = minetest.get_objects_inside_radius(pos, 4)
		local found = false
		
		for _,o in ipairs(objs) do
			if o:is_player() then
				found = true
				break
			end
		end
		
		if found then
			trigger_trap(pos)
		end
	end,
})


minetest.register_node("potions:trap_seed", {
	description = "Trap seed",
	drawtype = "node",
	tiles = {"default_mese.png"},
	groups = {cracky=3,},
	on_construct = function(pos)
		potions.build_trap_below(
			{x=pos.x-4, y=pos.y-5, z=pos.z-6},
			{x=pos.x+4, y=pos.y-1, z=pos.z+6},
			1, 1, "default:river_water_source"
		)
	end,
})


minetest.register_node("potions:minetunnel_seed", {
	description = "Minetunnel seed",
	drawtype = "node",
	tiles = {"default_mese.png"},
	groups = {cracky=3,},
})



local function set_column(pos, height, node)
	if type(node) == "string" then
		node = {name=node}
	end
	
	for i = 0,height-1,1 do
		minetest.set_node({x=pos.x, y=pos.y+i, z=pos.z}, node)
	end
end


local function brace_ceiling(pos, name)
	local a = minetest.get_node(pos)
	if a then
		local def = minetest.registered_nodes[a.name]
		if def and def.groups.falling_node then
			minetest.set_node(pos, {name=name})
		end
	end
end

local function tunnel_stack(pos, height, bottom, top, rot)
	if rot then
		minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name=bottom, param2 = rot})
	else
		minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name=bottom})
	end
	
	set_column(pos, height - 1, "air")
	
	brace_ceiling({x=pos.x, y=pos.y+height-1, z=pos.z}, top)
end



function potions.build_trap_below(minp, maxp, fall_depth, lava_depth, lava_node)
	
	-- set the floor
	for x = minp.x,maxp.x do
	for z = minp.z,maxp.z do
		minetest.set_node({x=x, y=maxp.y, z=z}, {name="potions:trap_floor"})
	end
	end
	
	-- empty space underneath
	local y = maxp.y-1
	while y > maxp.y-fall_depth-1 do
		
		for x = minp.x,maxp.x do
		for z = minp.z,maxp.z do
			minetest.set_node({x=x, y=y, z=z}, {name="air"})
		end
		end
		
		y=y-1
	end
	
	-- lava pool
	while y > maxp.y-fall_depth-1-lava_depth do
		
		for x = minp.x,maxp.x do
		for z = minp.z,maxp.z do
			minetest.set_node({x=x, y=y, z=z}, {name=lava_node})
		end
		end
		
		y=y-1
	end
	
	-- TODO: container for lava
end





local function build_tunnel(pos, dir, length, props)
print('buildign tunnel at '..dump(pos))
	local floor_rot
	local def = minetest.registered_nodes[props.nodes.floor]
	if def and def.paramtype2 == 'facedir' then
		floor_rot = minetest.dir_to_facedir({x=-dir.x,y=0,z=-dir.z})
	end
	
	local width = props.tunnel_width
	local w = math.floor(width / 2)

	local w = math.floor(width / 2)
	
	local x = 0
	local y = 0
	
	while x < length do
		for z = 1,width do
			local p = {
				x = pos.x + x*dir.x + (z-w-1)*dir.z,
				y = pos.y - y,
				z = pos.z + (z-w-1)*dir.x + x*dir.z
			}
			
			tunnel_stack(p, props.tunnel_height, props.nodes.floor, props.nodes.ceiling, floor_rot)
			
			
			if props.railpos and props.railpos == z then
				minetest.set_node(p, {name=props.nodes.rail})
			end
			
		end
		
		x = x + 1
	end
	
	return {x=pos.x + x*dir.x, y=pos.y, z=pos.z + x*dir.z}
end

local function build_descending_entrance(pos, dir, depth_into_stone, props)
	print('buildign entrance at '..dump(pos))
	
	local floor_rot
	local def = minetest.registered_nodes[props.nodes.floor]
	if def and def.paramtype2 == 'facedir' then
		floor_rot = minetest.dir_to_facedir({x=-dir.x,y=0,z=-dir.z})
	end
	
	
	local width = props.tunnel_width
	local w = math.floor(width / 2)
	
	local x = 0
	local y = 0
	
	while y < 10 do
		for z = 1,width do
			local p = {
				x = pos.x + x*dir.x + (z-w-1)*dir.z,
				y = pos.y - y,
				z = pos.z + (z-w-1)*dir.x + x*dir.z
			}
			
			
			if props.railpos and props.railpos == z then
				tunnel_stack(p, 5, props.nodes.floor, props.nodes.ceiling, floor_rot)
				minetest.set_node(p, {name=props.nodes.rail})
			else
				tunnel_stack(p, 5, props.nodes.stair, props.nodes.ceiling, floor_rot)
			end
		end
		
		y = y + 1
		x = x + 1
	end
	
	return {x=pos.x + x*dir.x, y=pos.y - y, z=pos.z + x*dir.z}
	
	
end


local function build_room(entrance_pos, dir, props)




end



local function build_junction(pos, dirs, props)
	
	-- TODO: replace tunnel_stack with something that doesn't destroy rail 
	--    so this fn can be called on existing junctions
	
	local z, x

	local width = props.tunnel_width
	local w = math.floor(width / 2)
	
	-- hollow out the cavity
	for z = 1,width do
		for x = 1,width do
			
			local p = {
				x = pos.x + (x-w-1)*dir.x + (z-w-1)*dir.z,
				y = pos.y + 2,
				z = pos.z + (z-w-1)*dir.x + (x-w-1)*dir.z
			}
			
			set_column(p, height - 2, "air")

			minetest.set_node({x=p.x, y=pos.y, z=p.z}, props.nodes.floor)
	
			brace_ceiling({x=p.x, y=pos.y+props.tunnel_height, z=p.z}, props.nodes.ceiling)
		end
	end
	
	for k,v in pairs(dirs) do
		-- install rails
		for z = w,width do
			for x = w,width do
		
				minetest.set_node({
					x=pos.x + v.x*x + v.z*z, 
					y=pos.y+1, 
					z=pos.z + v.z*x + v.x*z
				}, props.nodes.rail)
			end
		end
		
	end
	
end


local function random_dir()
	local d = {
		{x=1, z=0},
		{x=-1, z=0},
		{x=0, z=1},
		{x=0, z=-1},
	}
	return d[math.random(4)]
end

local function random_new_dir(olddir)
	local d = {
		{x=1, z=0},
		{x=-1, z=0},
		{x=0, z=1},
		{x=0, z=-1},
	}
	local i = math.random(4)
	local a = d[i]
	
	if a.x == olddir.x and a.z == olddir.z then
		a = d[((i + 1) % 4) + 1]
	end
	
	return a
end

local function random_perpendicular(dir)
	local d
	
	if dir.x == 0 then
		d = {
			{x=1, z=0},
			{x=-1, z=0},
		}
	else
		d = {
			{x=0, z=1},
			{x=0, z=-1},
		}
	end
	
	return d[math.random(2)]
end

local function build_mine(pos, props)
	print('building mine at '..dump(pos))
	
	local nodes = {
		props.nodes.floor
	}
	
	for i = 2,props.tunnel_width do
		table.insert(nodes, props.nodes.stair)
	end
	
	local p2 = build_descending_entrance(
			pos, 
			props.primary_dir,
			props.min_mine_depth,
			props
		)
	print("1")
	local p3 = p2
	local last_dir = props.primary_dir
	
	for i = 1,4 do
		p3 = build_tunnel(
			p3, 
			last_dir,
			props.min_tunnel_len + math.random(props.max_tunnel_len - props.min_tunnel_len), 
			props
		)
		last_dir = random_perpendicular(last_dir)
	
	end
		
	print("2")
	local p4 = build_descending_entrance(
			p3, 
			last_dir,
			props.tunnel_height + 2 + math.random(10),
			props
		)
	
	print("3")
-- 	p4 = build_tunnel({x=p3.x-1, y=p3.y, z=p3.z}, {x=0,z=1}, 2, 4, 10, "default:stonebrick", "default:stonebrick")


end


local function mf(x, n)
	return math.floor(x / n)
end



local function vdadd(pos, dir, length)
	return {
		x = pos.x + (dir.x * length),
		y = pos.y,
		z = pos.z + (dir.z * length),
	}
end

local function build_mine_maze(pos, o)
	
	local q = 0
	
	local data = {
		stack = {},
		log = {},
	}
	
	
	local function encode(pos)
		return "x"..mf(pos.x,2).."y"..mf(pos.y,2).."z"..mf(pos.z,2)
	end
	
	
	local function do_run(pos, dir, length)
		local n = vector.add(pos, 0)
		for i = 1,length do
			minetest.set_node(n, {name="default:cobble"})
			n.x = n.x + dir.x
			n.z = n.z + dir.z
			n.y = n.y + (dir.y or 0)
		end
		
		return n
	end
	
	
	local function direction_ok(pos, dir, length)
		local e = encode(vdadd(pos, dir, length))
		local g = data.log[e]
		
		return g == nil
	end
	
	
	table.insert(data.stack, {
		n = {x=pos.x, y=pos.y-1, z=pos.z},
		dir = {x=1, z=0},
	})
	
	while q < 10 do
		
		local n = table.remove(data.stack, 1)
		if n == nil then
			break
		end
		
		local e = encode(n.n)
		
		local g = data.log[e]
		data.log[e] = 1
		
		if g == nil then
			
			local n2 = do_run(n.n, n.dir, 10) 
			local newdir = n.dir
			for i = 1,3 do
				newdir = random_new_dir(newdir)
				
				if direction_ok(n2, newdir, 10) then
					table.insert(data.stack, {
						n = n2,
						dir = newdir
					})
					
					break
				elseif math.random(2) == 2 then
					table.insert(data.stack, {
						n = {x=n2.x, y=n2.y+1, z=n2.z},
						dir = newdir
					})
					break
				end
			end
-- 			minetest.set_node(n.n, {name="default:cobble"})
			
-- 			if math.random(20) < 19 then table.insert(data.stack, {x=n.x+2, y=n.y, z=n.z}) end
-- 			if math.random(20) < 19 then table.insert(data.stack, {x=n.x-2, y=n.y, z=n.z}) end
-- 			if math.random(20) < 3 then table.insert(data.stack, {x=n.x, y=n.y, z=n.z+2}) end
-- 			if math.random(20) < 3 then table.insert(data.stack, {x=n.x, y=n.y, z=n.z-2}) end
			
		end
		
		
		q = q + 1
	end
	
	
	
end



local function build_minetunnel(pos)
	
	local props = {
		nodes = {
			floor = "default:stonebrick",
			stair = "stairs:stair_stonebrick",
			slab = "stairs:slab_stonebrick",
			rail = "carts:rail",
			ceiling = "default:cobble",
			torch = "default:torch",
			chest = "default:chest",
		},
		
		min_mine_depth = 15,
		max_mine_depth = 50,
		
		min_tunnel_len = 6,
		max_tunnel_len = 10,
		
		tunnel_width = 3,
		tunnel_height = 4,
		
		primary_dir = random_dir(),
		
		torch_chance = 50,
		
		railpos = 2,
	}
	
	
	build_mine(pos, props)
	
-- 	p2 = build_descending_entrance(pos, {x=1,z=0}, 2, 10, {"carts:rail", "stairs:stair_cobble"}, "")
	
-- 	p3 = build_tunnel(p2, {x=1,z=0}, 2, 4, 10, "default:stonebrick", "default:stonebrick")
-- 	p3 = build_tunnel({x=p3.x-1, y=p3.y, z=p3.z}, {x=0,z=1}, 2, 4, 10, "default:stonebrick", "default:stonebrick")
	
	
end





minetest.register_node("potions:maze_seed", {
	description = "Maze seed",
	drawtype = "node",
	tiles = {"default_mese.png"},
	groups = {cracky=3,},
	on_construct = function(pos)
		build_mine_maze({x=pos.x, y=pos.y-1, z=pos.z})
	end,
})


minetest.register_abm({
	nodenames = "potions:minetunnel_seed",
	chance = 1,
	interval = 3,
	action = function(pos, node)
		minetest.after(2, function()
			minetest.set_node(pos, {name="air"})
-- 			pos.y = pos.y - 1
			
			build_minetunnel(pos)
		end)
	end
})





