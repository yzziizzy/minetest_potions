












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

local function replace_nonempty_block(min, max, with)
	
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
		if minetest.get_node(n).name ~= "air" then
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





local function execute_alchemy(pos, layout, player)
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
		
		if v.fn then
			v.fn({x=p.x, y=p.y, z=p.z}, player)
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
	
	{particle_spawner = {
		min={x=-1, z=-1, y=1}, 
		max={x=1, z=1, y=3},
		radius = 3,
		type = "rise",
		speed = 1,
		accel = .3,
		random = .2,
		density = 100,
		plife = 2, 
	}}
}


potions.alchemy_layouts.silver_snake = {
	{x=0, z=0, n="tnt:tnt"},
	
	{x=1, z=1, n="default:mossycobble"},
	{x=1, z=-1, n="default:mossycobble"},
	{x=-1, z=1, n="default:mossycobble"},
	{x=-1, z=-1, n="default:mossycobble",},
	
	{x=-2, z=-2, n="default:silver_sandstone_brick",},
	{x=2, z=-2, n="default:silver_sandstone_brick",},
	{x=-2, z=2, n="default:silver_sandstone_brick",},
	{x=2, z=2, n="default:silver_sandstone_brick",},
	
	{x=1, z=0, n="default:silver_sandstone_brick",},
	{x=-1, z=0, n="default:silver_sandstone_brick",},
	{x=0, z=1, n="default:silver_sandstone_brick",},
	{x=0, z=-1, n="default:silver_sandstone_brick",},
	
	{x=3, z=0, n="default:silver_sandstone_brick",},
	{x=3, z=-1, n="default:silver_sandstone_brick",},
	{x=3, z=1, n="default:silver_sandstone_brick",},
	{x=-3, z=0, n="default:silver_sandstone_brick",},
	{x=-3, z=-1, n="default:silver_sandstone_brick",},
	{x=-3, z=1, n="default:silver_sandstone_brick",},
	{x=0, z=3, n="default:silver_sandstone_brick",},
	{x=-1, z=3, n="default:silver_sandstone_brick",},
	{x=1, z=3, n="default:silver_sandstone_brick",},
	{x=0, z=-3, n="default:silver_sandstone_brick",},
	{x=-1, z=-3, n="default:silver_sandstone_brick",},
	{x=1, z=-3, n="default:silver_sandstone_brick",},
	
	{fn = function(pos, player)
-- 		pos.y = pos.y + 1
-- 		minetest.set_node(pos, {name="default:glass"})
		
		local min = vector.add(pos, {x=-3, y=-32, z=-3})
		local max = vector.add(pos, {x=3, y=-1, z=3})
		
		set_block(
			min, max,
			"air"
		)
		
		-- flying around
		minetest.add_particlespawner({
			amount = 100,
			time = 5,
			minpos = {x=min.x, y=max.y+1, z=min.z},
			maxpos = {x=max.x, y=max.y+1, z=max.z},
			minvel = {x=-01.01, y=2, z=-01.01},
			maxvel = {x=01.05,  y=3,  z=01.05},
			minacc = {x=-01.1, y=0.1, z=-01.1},
			maxacc = {x=01.1, y=0.3, z=01.1},
			minexptime = 0.5,
			maxexptime = 2.5,
	-- 		collisiondetection = true,
	-- 		collision_removal = true,
			minsize = 4,
			maxsize = 4,
			texture = "potions_particle.png^[colorize:red:60",
	-- 		animation = tileanimation
			glow = 1
		})
		
		-- going down
		minetest.add_particlespawner({
			amount = 800,
			time = 5,
			minpos = {x=min.x, y=max.y, z=min.z},
			maxpos = {x=max.x, y=max.y, z=max.z},
			minvel = {x=-0.01, y=-5, z=-0.01},
			maxvel = {x=0.05,  y=-6,  z=0.05},
			minacc = {x=0, y=-0.1, z=0},
			maxacc = {x=0, y=-1.3, z=0},
			minexptime = 1.5,
			maxexptime = 1.5,
	-- 		collisiondetection = true,
	-- 		collision_removal = true,
			minsize = 4,
			maxsize = 4,
			texture = "potions_particle.png^[colorize:red:60",
	-- 		animation = tileanimation
			glow = 1
		})
		
		
		minetest.after(1, function() 
			replace_block(vadd(pos, {x=-3,z=-3}), vadd(pos, {x=3,z=3}), "air", "fire:basic_flame")
		end)
		minetest.after(6, function() 
			set_block(vadd(pos, {x=-3,z=-3}), vadd(pos, {x=3,z=3}), "air")
			minetest.add_particlespawner({
				amount = 300,
				time = 4,
				minpos = vadd(pos, {x=-3, y=-.5, z=-3}),
				maxpos = vadd(pos, {x=3, y=-.5, z=3}),
				minvel = {x=-0.1, y=-.6, z=-0.1},
				maxvel = {x=0.1,  y=.6,  z=0.1},
				minacc = {x=-02.1, y=-1.1, z=-02.1},
				maxacc = {x=02.1, y=1.1, z=02.1},
				minexptime = 1.5,
				maxexptime = 1.5,
				minsize = 2.2,
				maxsize = 2.2,
				texture = "potions_particle.png^[colorize:purple:60",
				glow = 1
			})
		end)
		
		local function dig(p, s)
			minetest.set_node({x=p.x, y=p.y-1, z=p.z}, {name="default:silver_sandstone_brick"})
			
			if s ~= 0 then
				minetest.set_node(p, {name="stairs:slab_silver_sandstone_brick"})
			else
				minetest.set_node(p, {name="air"})
			end
			
			minetest.set_node({x=p.x, y=p.y+1, z=p.z}, {name="air"})
			minetest.set_node({x=p.x, y=p.y+2, z=p.z}, {name="air"})
			minetest.set_node({x=p.x, y=p.y+3, z=p.z}, {name="air"})
		end
		
		
		local function iterate(i)
			local m = math.floor(i % 8) 
			local d = math.floor((i % 32) / 8)
			local x, z
			if d < 1 then
				x = m - 4
				z = -4
			elseif d < 2 then
				x = 4
				z = m - 4
			elseif d < 3 then
				x = 4 - m
				z = 4
			else
				x = -4
				z = 4 - m
			end
				
			local p = vadd(pos, {x=x, y=math.floor(i/-2), z=z})
			dig(p, i%2)
			
			p.y = p.y - 0.5
			minetest.add_particlespawner({
				amount = 80,
				time = 2,
				minpos = p,
				maxpos = p,
				minvel = {x=-0.1, y=1, z=-0.1},
				maxvel = {x=0.1,  y=.6,  z=0.1},
				minacc = {x=-02.1, y=0.1, z=-02.1},
				maxacc = {x=02.1, y=1.3, z=02.1},
				minexptime = 1.5,
				maxexptime = 1.5,
		-- 		collisiondetection = true,
		-- 		collision_removal = true,
				minsize = 2.2,
				maxsize = 2.2,
				texture = "potions_particle.png^[colorize:green:60",
		-- 		animation = tileanimation
				glow = 1
			})
			
			
			if i < 64 then
				minetest.after(1, function() iterate(i+1) end)
			end
		end
		
		iterate(0)
	end},
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
		
		if potions.get_manna(user) > 20 then
				
			local pos = pointed_thing.under
			
			local name, def = find_layout(pos)
			if name then
				
				execute_alchemy(pos, def, user)
				
				potions.add_manna(user, -15)
			end
		end
		
	end,
})



minetest.register_craftitem("potions:book_silver_snake", {
	description = "Alchemy Wand",
	inventory_image = "default_book.png^[colorize:white:200",
	stack_max = 5,
	on_use = function(itemstack, user, pointed_thing)
		
		local pos = pointed_thing.under
		local def = potions.alchemy_layouts.silver_snake
		
		if not pos then
			return itemstack
		end
		
		if probe_layout(pos, def) then
			execute_alchemy(pos, def, user)
			itemstack:take_item()
		end
		
		return itemstack
		
	end,
})







minetest.register_node("potions:cauldron", {
	description = "Cauldron",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_steel_block.png^[colorize:black:160"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.45, .45, -.45, 0.45, .5, 0.45},
			{-.5, -.3, -.5, 0.5, .3, 0.5},
			{-.4, -.4, -.4, 0.4, .45, 0.4},
			{-.3, -.5, -.3, 0.3, -.4, 0.3},
		},
	},
	groups = {cracky=3,},
	on_construct = function(pos) 
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory();
		
		inv:set_size("main", 4*4)
	
		local formspec =
			"size[8,9]" ..
			"list[current_name;main;2,0.3;4,4;]" ..
			"list[current_player;main;0,4.85;8,1;]" ..
			"list[current_player;main;0,6.08;8,3;8]" ..
			"listring[nodemeta:" .. spos .. ";main]" ..
			"listring[current_player;main]" ..
			default.get_hotbar_bg(0,4.85)
		
		meta:set_string("formspec", formspec)
	end,
	
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		-- take water out of bucket
	end,
	
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	
})

minetest.register_node("potions:still", {
	description = "Still",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_copper_block.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.45, -5, -.45, 0.45, -.45, 0.45},
			{-.1, -.45, -.1, 0.1, .4, 0.1},
			{-.1, .3, -.1, 1.1, .4, 0.1},
			{1.1, -.5, -.1, .9, .4, .1},
		},
	},
	groups = {cracky=3,},
})



minetest.register_node("potions:ethanol_flask", {
	description = "Flask of Ethanol",
	inventory_image = "potions_eflask_clear.png",
	tiles = {"potions_eflask_clear.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})

minetest.register_node("potions:methanol_flask", {
	description = "Flask of Methanol",
	inventory_image = "potions_eflask_clear.png",
	tiles = {"potions_eflask_clear.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})


minetest.register_node("potions:ammonia_flask", {
	description = "Flask of Ammonia",
	inventory_image = "potions_eflask_ammonia.png",
	tiles = {"potions_eflask_ammonia.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})

minetest.register_node("potions:muriatic_acid_flask", {
	description = "Flask of Muriatic Acid",
	inventory_image = "potions_eflask_clear.png",
	tiles = {"potions_eflask_ammonia.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})

-- hydrochloric acid
minetest.register_node("potions:muriatic_acid_flask", {
	description = "Flask of Muriatic Acid",
	inventory_image = "potions_eflask_clear.png",
	tiles = {"potions_eflask_ammonia.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})

-- sulfuric acid
minetest.register_node("potions:vitriol_flask", {
	description = "Flask of Vitriol",
	inventory_image = "potions_eflask_clear.png",
	tiles = {"potions_eflask_ammonia.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})

-- nitric acid
minetest.register_node("potions:aqua_fortis_flask", {
	description = "Flask of Vitriol",
	inventory_image = "potions_eflask_clear.png",
	tiles = {"potions_eflask_ammonia.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})


minetest.register_node("potions:iodine_flask", {
	description = "Flask of Iodine",
	inventory_image = "potions_rflask_iodine.png",
	tiles = {"potions_rflask_iodine.png"},
	drawtype = "plantlike",
	visual_scale = .5,
	waving = false,
	buildable_to = false,
	walkable = false,
	groups = {vessel=1, oddly_breakable_by_hand=3, cracky=3, choppy=3, snappy=3, crumbly=3},
})


