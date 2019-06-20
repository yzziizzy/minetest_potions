


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
			local rot = nil
			if floor_rot then
				rot = minetest.dir_to_facedir({x=-dir.x,y=0,z=-dir.z})
			end
			
			tunnel_stack(p, props.tunnel_height, props.nodes.floor, props.nodes.ceiling, rot)
			
			
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
				tunnel_stack(p, 5, props.nodes.floor, props.nodes.ceiling, rot)
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


local function random_dir()
	local d = {
		{x=1, z=0},
		{x=-1, z=0},
		{x=0, z=1},
		{x=0, z=-1},
	}
	return d[math.random(4)]
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
	local p3 = build_tunnel(
		p2, 
		props.primary_dir, 
		props.min_tunnel_len + math.random(props.max_tunnel_len - props.min_tunnel_len), 
		props
	)
		
	print("2")
	local p4 = build_descending_entrance(
			p3, 
			props.primary_dir,
			props.tunnel_height + 2 + math.random(10),
			props
		)
	
	print("3")
-- 	p4 = build_tunnel({x=p3.x-1, y=p3.y, z=p3.z}, {x=0,z=1}, 2, 4, 10, "default:stonebrick", "default:stonebrick")


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
		
		min_mine_depth = 10,
		max_mine_depth = 50,
		
		min_tunnel_len = 10,
		max_tunnel_len = 40,
		
		tunnel_width = 3,
		tunnel_height = 4,
		
		primary_dir = random_dir(),
		
		torch_chance = 50,
		
		railpos = 1,
	}
	
	
	build_mine(pos, props)
	
-- 	p2 = build_descending_entrance(pos, {x=1,z=0}, 2, 10, {"carts:rail", "stairs:stair_cobble"}, "")
	
-- 	p3 = build_tunnel(p2, {x=1,z=0}, 2, 4, 10, "default:stonebrick", "default:stonebrick")
-- 	p3 = build_tunnel({x=p3.x-1, y=p3.y, z=p3.z}, {x=0,z=1}, 2, 4, 10, "default:stonebrick", "default:stonebrick")
	
	
end







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





