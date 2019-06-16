
local function vadd(a, b)
	return {
		x = (a.x or 0) + (b.x or 0),
		y = (a.y or 0) + (b.y or 0),
		z = (a.z or 0) + (b.z or 0),
	}
end


local function check_block(min, max, name)
	
	for x = min.x,max.x,1 do
	for y = min.y,max.y,1 do
	for z = min.z,max.z,1 do
		
		if minetest.get_node({x=x, y=y, z=z}).name ~= name then
			return false
		end
		
	end
	end
	end
	
	return true
end

local function set_block(min, max, name)
	
	local node
	if type(name) == "string" then
		node = {name=name}
	else
		node = name
	end
	
	for x = min.x,max.x,1 do
	for y = min.y,max.y,1 do
	for z = min.z,max.z,1 do
		
		minetest.set_node({x=x, y=y, z=z}, node)
		
	end
	end
	end
	
	return true
end

local function replace_block(min, max, what, with)
	
	local node
	if type(with) == "string" then
		node = {name = with}
	else
		node = with
	end
	
	for x = min.x,max.x,1 do
	for y = min.y,max.y,1 do
	for z = min.z,max.z,1 do
		local n = {x=x, y=y, z=z}
		if minetest.get_node(n).name == what then
			minetest.set_node(n, node)
		end
	end
	end
	end
	
	return true
end



local function check_layout(pos, layout)
	local correct = 0
	
	for i,v in ipairs(layout) do
		
		local p = vadd(pos, v)
		
		local n = minetest.get_node(p)
		if n.name == v.n then
			correct = correct + 1
		end
	end
	
	return (correct == #layout), correct, #layout
end



local function probe_layout(pos, layout)
	local correct = 0
	
	for i,v in ipairs(layout) do
		if v.n then
			if v.min and v.max then
				if not check_block(vadd(pos, v.min), vadd(pos, v.max), v.n) then
					return false
				end
			else
				local p = vadd(pos, v)
				
				local n = minetest.get_node(p)
				if n.name ~= v.n then
					return false
				end
			end
		end
	end
	
	return true
end



local function create_spawner(pos, sz, tex)
	minetest.add_particlespawner({
		amount = 4000,
		time = 5,
		minpos = vector.add({x=pos.x-sz, y=pos.y-ht, z=pos.z-sz}, vector.multiply(vel, -.95)),
		maxpos = vector.add({x=pos.x+sz, y=pos.y+ht, z=pos.z+sz}, vector.multiply(vel, -.95)),
		minvel = vector.add(vel, {x=-1, y=0, z=-1}),
		maxvel = vector.add(vel, {x=5,  y=0.5,  z=5}),
		minacc = {x=-01.1, y=0.1, z=-01.1},
		maxacc = {x=01.1, y=01.3, z=01.1},
		minexptime = 1.5,
		maxexptime = 2.5,
-- 		collisiondetection = true,
-- 		collision_removal = true,
		minsize = 40,
		maxsize = 45,
		texture = tex,
-- 		animation = tileanimation
-- 		glow = 1
	})
end





local function execute_alchemy(pos, layout)
	local correct = 0
	
	for i,v in ipairs(layout) do
		local p = vadd(pos, v)
		
		if v.set then
			if v.min and v.max then
				set_block(vadd(pos, v.min), vadd(pos, v.max), v.set)
			else
		
				if type(v.set) == "string" then
					minetest.set_node(p, {name=v.set})
				else
					minetest.set_node(p, v.set)
				end
			end
		elseif v.replace then
			if v.min and v.max then
				replace_block(vadd(pos, v.min), vadd(pos, v.max), v.replace, v.with)
			end
		end
	end
	
	return true
end



potions.alchemy_layouts = {}
potions.alchemy_layouts.sand = {
	{x=0, z=0, n="default:stone"},
	{x=1, z=1, n="default:sand"},
	{x=1, z=-1, n="default:sand"},
	{x=-1, z=1, n="default:sand"},
	{x=-1, z=-1, n="default:sand",},
	
	{y=1, set="default:glass"},

}
potions.alchemy_layouts.dirt = {
	{x=0, z=0, n="default:stone"},
	{x=1, z=1, n="default:desert_sand"},
	{x=1, z=-1, n="default:desert_sand"},
	{x=-1, z=1, n="default:desert_sand"},
	{x=-1, z=-1, n="default:desert_sand",},
	
	{min={x=-1, z=-1, y=1}, max={x=1, z=1, y=1}, n="air"},
	{min={x=-1, z=-1, y=1}, max={x=1, z=1, y=3}, replace="air", with="fire:basic_flame"},
	
	{y=1, set="default:brick"},
	
}


local function find_layout(pos) 
	for k,v in pairs(potions.alchemy_layouts) do
		if probe_layout(pos, v) then
			return k, v
		end
	end
	
	return nil, nil
end





minetest.register_craftitem("potions:wand", {
	description = "Alchemy Wand",
	inventory_image = "default_stick.png^[colorize:black:200",
	stack_max = 5,
	on_use = function(itemstack, user, pointed_thing)
		
		local pos = pointed_thing.under
		
		local name, def = find_layout(pos)
		if name then
			execute_alchemy(pos, def)
			
		end
		
	end,
})








