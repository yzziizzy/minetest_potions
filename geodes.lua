



minetest.register_node("potions:crystal_2", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5},
			{-.5, -.5, -.5, -.4, 0.5, 0.5},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})

minetest.register_node("potions:crystal_22", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5},
			{-.5, 0.4, -.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})
minetest.register_node("potions:crystal_3", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5},
			{-.5, -.5, -.5, -.4, 0.5, 0.5},
			{-.5, -.5, -.5, 0.5, 0.5, -.4},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})
minetest.register_node("potions:crystal_32", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5},
			{-.5, -.5, -.5, -.4, 0.5, 0.5},
			{ .4, -.5, -.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})
minetest.register_node("potions:crystal_4", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5},
			{-.5, -.5, -.5, -.4, 0.5, 0.5},
			{-.5, -.5, -.5, 0.5, 0.5, -.4},
			{ .4, -.5, -.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})
minetest.register_node("potions:crystal_42", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5},
			{-.5, -.5, -.5, -.4, 0.5, 0.5},
			{-.5,  .4, -.5, 0.5, 0.5, 0.5},
			{ .4, -.5, -.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})
minetest.register_node("potions:crystal_5", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5},
			{-.5, -.5, -.5, -.4, 0.5, 0.5},
			{-.5, -.5, -.5, 0.5, 0.5, -.4},
			{ .4, -.5, -.5, 0.5, 0.5, 0.5},
			{-.5,  .4, -.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})
minetest.register_node("potions:crystal_6", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {cracky=3, geode_wall = 1},
})





local function probe_geode_neighbor(pos, v)
	local n = minetest.get_node(vector.add(pos, v))
	local def = minetest.registered_nodes[n.name]
	if not def or n.name == "air" then
		return 'i' -- interior
	end
	
	if def.groups and def.groups.geode_wall then
		return 'i' -- crystal wall
	end
	
	if def.groups and (def.groups.cracky or def.groups.crumbly) then
		return 'e' -- exterior
	end
	
	return 'i' -- interior
end



local orient_data = {
	eeeeee = {n = 6, o = 0 }, 
	eieeee = {n = 5, o = 3 }, --
	ieeeee = {n = 5, o = 5 }, --
	iieeee = {n = 42, o = 1 }, --
	
	eeieee = {n = 5, o = 8 }, --
	eiieee = {n = 4, o = 3 }, --
	ieieee = {n = 4, o = 1 }, --
	iiieee = {n = 32, o = 1 }, --
	
	eeeiee = {n = 5, o = 4 }, --
	eieiee = {n = 4, o = 19 }, --
	ieeiee = {n = 42, o = 13 }, --
	iieiee = {n = 32, o = 21 }, --
	
	eeiiee = {n = 42, o = 4 }, --
	eiiiee = {n = 32, o = 17 }, --
	ieiiee = {n = 32, o = 13 }, --
	iiiiee = {n = 22, o = 4 }, --

	
	eeeeie = {n = 5, o = 0 }, --
	eieeie = {n = 4, o = 16 }, --
	ieeeie = {n = 42, o = 5 }, --
	iieeie = {n = 32, o = 5 }, --
	
	eeieie = {n = 4, o = 0 }, --
	eiieie = {n = 3, o = 3 }, --
	ieieie = {n = 3, o = 0 }, --
	iiieie = {n = 2, o = 3 }, --
	
	eeeiie = {n = 4, o = 4 }, --
	eieiie = {n = 3, o = 20 }, --
	ieeiie = {n = 3, o = 4 }, --
	iieiie = {n = 2, o = 7 }, --
	
	eeiiie = {n = 32, o = 4 }, --
	eiiiie = {n = 2, o = 6 }, --
	ieiiie = {n = 2, o = 4 }, --
	iiiiie = {n = 1, o = 4 }, --
	
	
	eeeeei = {n = 5, o = 14 }, --
	eieeei = {n = 4, o = 18 }, --
	ieeeei = {n = 4, o = 9 }, --
	iieeei = {n = 32, o = 9 }, --
	
	eeieei = {n = 4, o = 2 }, --
	eiieei = {n = 3, o = 2 }, --
	ieieei = {n = 3, o = 1 }, --
	iiieei = {n = 2, o = 1 }, --
	
	eeeiei = {n = 4, o = 10 }, --
	eieiei = {n = 3, o = 10 }, --
	ieeiei = {n = 3, o = 9 }, --
	iieiei = {n = 2, o = 9 }, --
	
	eeiiei = {n = 32, o = 8 }, --
	eiiiei = {n = 2, o = 10 }, --
	ieiiei = {n = 2, o = 8 }, --
	iiiiei = {n = 1, o = 8 }, --
	
	eeeeii = {n = 42, o = 0 }, --
	eieeii = {n = 32, o = 16 }, --
	ieeeii = {n = 32, o = 12 }, --
	iieeii = {n = 22, o = 0 }, --
	
	eeieii = {n = 32, o = 0 }, --
	eiieii = {n = 2, o = 2 }, --
	ieieii = {n = 2, o = 0 }, --
	iiieii = {n = 1, o = 0 }, --
	
	eeeiii = {n = 32, o = 20 }, --
	eieiii = {n = 2, o = 18 }, --
	ieeiii = {n = 2, o = 12 }, --
	iieiii = {n = 1, o = 20 }, --
	
	eeiiii = {n = 22, o = 12 }, --
	eiiiii = {n = 1, o = 16 }, --
	ieiiii = {n = 1, o = 12 }, --
	iiiiii = {n = 0, o = 0 },
}



local function orient_geode_wall(pos)
	
	local xp = probe_geode_neighbor(pos, {x=1, y=0, z=0})
	local xm = probe_geode_neighbor(pos, {x=-1, y=0, z=0})
	local yp = probe_geode_neighbor(pos, {x=0, y=1, z=0})
	local ym = probe_geode_neighbor(pos, {x=0, y=-1, z=0})
	local zp = probe_geode_neighbor(pos, {x=0, y=0, z=1})
	local zm = probe_geode_neighbor(pos, {x=0, y=0, z=-1})
	
	local s = xp..xm..yp..ym..zp..zm
	local od = orient_data[s]
	print("["..pos.x..", "..pos.y..", "..pos.z.."]  s: "..s)
	if od.n == 0 then
		minetest.set_node(pos, {name = "air"})
	else
		minetest.swap_node(pos, {name="potions:crystal_"..od.n, param2 = od.o})
	end
end
minetest.register_node("potions:crystal_1", {
	description = "Crystal",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_mese.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{-.5, -.5, -.5, 0.5, -.4, 0.5}
		},
	},
	groups = {cracky=3, geode_wall = 1 },
	on_construct = function(pos) orient_geode_wall(pos) end,
})


minetest.register_abm({
	name = "potions:geode_tester",
	nodenames = "group:geode_wall",
	chance = 1,
	interval = 10,
	action = function(pos, node)
		orient_geode_wall(pos)
	end
})







minetest.register_node("potions:geode_seed", {
	description = "geode mapgen seed",
	drawtype = "node",
	tiles = {"default_cobble.png"},
	drop = "default:cobble",
	groups = {cracky = 1},
})

minetest.register_node("potions:geode_wall", {
	description = "geode mapgen wall",
	drawtype = "node",
	tiles = {"default_cobble.png"},
	drop = "default:cobble",
	groups = {cracky = 1, geode_wall = 1},
	on_timer = function(pos)
	orient_geode_wall(pos)
-- 		minetest.set_node(pos, {name="d"})
	
	end,
})


local function dist3(a, b)
	local x = a.x - b.x
	local y = a.y - b.y
	local z = a.z - b.z
	return math.sqrt(x*x + y*y + z*z)
end


--[[
minetest.register_lbm({
	name = "potions:geode_grow",
	nodenames = "potions:geode_seed",
	run_at_every_load = false,
]]
minetest.register_abm({
	name = "potions:geode_grow",
	nodenames = "potions:geode_seed",
	chance = 1,
	interval = 2,
	action = function(pos, node)
		
-- 		local r = math.random(3) + 1
		local r = 1.5
		local r2 = r+1
		
		for x = pos.x-r2,pos.x+r2,1 do
		for y = pos.y-r2,pos.y+r2,1 do
		for z = pos.z-r2,pos.z+r2,1 do
			local p = {x=x, y=y, z=z}
			local d = dist3(p, pos) 
			
			d = d + math.random() * .5
			
			local dd = d - r
			
			if dd <= -.5 then
				minetest.set_node(p, {name = "default:river_water_source"})
			elseif dd < 1 then
				minetest.set_node(p, {name = "potions:geode_wall"})
				minetest.get_node_timer(p):start(1)
			elseif dd <= 1.5 then
				minetest.set_node(p, {name = "default:obsidian_glass"})
			else
				minetest.set_node(p, {name = "default:stone"})
			end
		end
		end
		end
	end,
})



