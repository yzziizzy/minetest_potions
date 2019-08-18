




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



local function orient_geode_wall(pos, name)
	
	local xp = probe_geode_neighbor(pos, {x=1, y=0, z=0})
	local xm = probe_geode_neighbor(pos, {x=-1, y=0, z=0})
	local yp = probe_geode_neighbor(pos, {x=0, y=1, z=0})
	local ym = probe_geode_neighbor(pos, {x=0, y=-1, z=0})
	local zp = probe_geode_neighbor(pos, {x=0, y=0, z=1})
	local zm = probe_geode_neighbor(pos, {x=0, y=0, z=-1})
	
	local s = xp..xm..yp..ym..zp..zm
	local od = orient_data[s]
-- 	print("["..pos.x..", "..pos.y..", "..pos.z.."]  s: "..s)
	if od.n == 0 then
		minetest.set_node(pos, {name = "air"})
	else
		minetest.swap_node(pos, {name="potions:geode_"..name.."_"..od.n, param2 = od.o})
	end
end






function potions.register_geode(name, opts)
	local tiles = opts.tiles or "default_diamond.png"
	if type(tiles) == "string" then
		tiles = {tiles}
	end
	
	local desc = opts.desc or opts.description or (name.." Crystal")
	
	local drops = opts.drops
	
	potions.geodes[name] = {
		name = name,
		drops = drops,
		rarity = opts.rarity or 5,
	}
	
	minetest.register_node("potions:geode_"..name.."_1", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops,
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, -.4, 0.5}
			},
		},
		groups = {cracky=3, geode_wall = 1, },
		-- for testing orient functions
		-- 		on_construct = function(pos) potions.orient_geode_wall(pos) end,
		geode_name = name,
	})

	minetest.register_node("potions:geode_"..name.."_2", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 2",
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, -.4, 0.5},
				{-.5, -.5, -.5, -.4, 0.5, 0.5},
			},
		},
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1 },
		geode_name = name,
	})

	minetest.register_node("potions:geode_"..name.."_22", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 2",
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, -.4, 0.5},
				{-.5, 0.4, -.5, 0.5, 0.5, 0.5},
			},
		},
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1 },
		geode_name = name,
	})
	
	minetest.register_node("potions:geode_"..name.."_3", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 3",
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, -.4, 0.5},
				{-.5, -.5, -.5, -.4, 0.5, 0.5},
				{-.5, -.5, -.5, 0.5, 0.5, -.4},
			},
		},
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1 },
		geode_name = name,
	})
	
	minetest.register_node("potions:geode_"..name.."_32", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 3",
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, -.4, 0.5},
				{-.5, -.5, -.5, -.4, 0.5, 0.5},
				{ .4, -.5, -.5, 0.5, 0.5, 0.5},
			},
		},
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1 },
		geode_name = name,
	})
	
	minetest.register_node("potions:geode_"..name.."_4", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 4",
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, -.4, 0.5},
				{-.5, -.5, -.5, -.4, 0.5, 0.5},
				{-.5, -.5, -.5, 0.5, 0.5, -.4},
				{ .4, -.5, -.5, 0.5, 0.5, 0.5},
			},
		},
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1 },
		geode_name = name,
	})
	
	minetest.register_node("potions:geode_"..name.."_42", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 4",
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, -.4, 0.5},
				{-.5, -.5, -.5, -.4, 0.5, 0.5},
				{-.5,  .4, -.5, 0.5, 0.5, 0.5},
				{ .4, -.5, -.5, 0.5, 0.5, 0.5},
			},
		},
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1 },
		geode_name = name,
	})
	
	minetest.register_node("potions:geode_"..name.."_5", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 5",
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
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1 },
		geode_name = name,
	})
	
	minetest.register_node("potions:geode_"..name.."_6", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		tiles = tiles,
		drops = drops .. " 6",
		node_box = {
			type = "fixed",
			fixed = {
				{-.5, -.5, -.5, 0.5, 0.5, 0.5},
			},
		},
		groups = {cracky=3, geode_wall = 1, not_in_creative_inventory = 1},
		geode_name = name,
	})
	
	
	-- generation nodes
	
	minetest.register_node("potions:geode_seed_"..name, {
		description = "geode mapgen seed "..name,
		drawtype = "node",
		tiles = {"default_cobble.png"},
		drop = "default:cobble",
		groups = {cracky = 1, geode_seed = 1},
		geode_name = name,
	})

	minetest.register_node("potions:geode_wall_"..name, {
		description = "geode mapgen wall "..name,
		drawtype = "node",
		tiles = {"default_cobble.png"},
		drop = "default:cobble",
		groups = {cracky = 1, geode_wall = 1, not_in_creative_inventory = 1},
		on_timer = function(pos)
			orient_geode_wall(pos, name)
	-- 		minetest.set_node(pos, {name="d"})
		end,
		geode_name = name,
	})
	
-- 	print("++++++++ ore registration "..name)
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "potions:geode_seed_"..name,
		wherein        = "default:stone",
		clust_scarcity = 48 * 48 * 48,
		clust_num_ores = 1,
		clust_size     = 1,
		y_max          = 100,
		y_min          = -31000,
	})	
	
end



minetest.register_abm({
	name = "potions:geode_tester",
	nodenames = "group:geode_wall",
	chance = 1,
	interval = 1000,
	action = function(pos, node)
-- 		orient_geode_wall(pos)
	end
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
	action = 
})
]]

local function pow(base, p) 
	return math.exp(p * math.log(base))
end

minetest.register_abm({
	name = "potions:geode_grow",
	nodenames = "group:geode_seed",
	chance = 1,
	interval = 5,
	action = function(pos, node)
		
		local def = minetest.registered_nodes[node.name]
		local name = def.geode_name
		
		local yoff = math.min(math.max(-pos.y, 0), 1000) / 1000
		local rarity = potions.geodes[name].rarity
-- 		print("geode " .. rarity)
		if math.random(rarity + 10 - math.floor(yoff*10)) > 1 then
			minetest.set_node(pos, {name="default:stone"})
			return
		end
-- 		print("growing")
		
		
		local w = math.random(4) == 1
		
		
		-- most geodes are small, rare exponential size increase
		local a = math.random(400 + yoff*100)
		local r = math.min(20, pow((a / 431), 63) / 1160) + .1
		
-- 		local r = (math.random(50)) / math.log(50)) + 1
-- 		local r = 1.5
		local r2 = math.ceil(r+1)
		
		for x = pos.x-r2,pos.x+r2,1 do
		for y = pos.y-r2,pos.y+r2,1 do
		for z = pos.z-r2,pos.z+r2,1 do
			local p = {x=x, y=y, z=z}
			local d = dist3(p, pos) 
			
			d = d + math.random() * .5
			
			local dd = d - r
			
			if dd <= -.5 then
				if w then
					minetest.set_node(p, {name = "default:river_water_source"})
				else
					minetest.set_node(p, {name = "air"})
				end
			elseif dd < 1 then
				minetest.set_node(p, {name = "potions:geode_wall_"..name})
				minetest.get_node_timer(p):start(1)
			elseif dd <= 1.8 then
				minetest.set_node(p, {name = "default:stone"})
			else
-- 				minetest.set_node(p, {name = "default:stone"})
			end
		end
		end
		end
	end,
})





minetest.register_craftitem("potions:quartz_crystal", {
	description = "Quartz Crystal",
	inventory_image = "potions_quartz_crystal.png",
-- 	y_min, y_max, biome, wherein, rarity
})
potions.register_geode("quartz", {
	description = "Quartz",
	drops = "potions:quartz_crystal",
	tiles = "default_diamond_block.png^[colorize:white:120"
})



minetest.register_craftitem("potions:smoky_quartz_crystal", {
	description = "Smoky Quartz Crystal",
	inventory_image = "potions_smoky_quartz_crystal.png",
})
potions.register_geode("smoky_quartz", {
	description = "Smoky Quartz",
	drops = "potions:smoky_quartz_crystal",
	tiles = "default_diamond_block.png^[colorize:brown:50"
})


minetest.register_craftitem("potions:amethyst_crystal", {
	description = "Amethyst Crystal",
	inventory_image = "potions_amethyst_crystal.png",
})
potions.register_geode("amethyst", {
	description = "Amethyst",
	drops = "potions:amethyst_crystal",
	tiles = "default_diamond_block.png^[colorize:purple:60"
})

--[[
minetest.register_craftitem("potions:epidote_crystal", {
	description = "Epidote Crystal",
	inventory_image = "potions_epidote_crystal.png",
})
potions.register_geode("epidote", {
	description = "Epidote",
	drops = "potions:epidote_crystal",
	tiles = "default_diamond_block.png^[colorize:green:220^[colorize:black:120"
})
]]

minetest.register_craftitem("potions:emerald_gem", {
	description = "Emerald Gem",
	inventory_image = "potions_emerald_gem.png",
})
minetest.register_craftitem("potions:emerald_crystal", {
	description = "Emerald Crystal",
	inventory_image = "potions_emerald_crystal.png",
})
potions.register_geode("emerald", {
	description = "Emerald",
	drops = "potions:emerald_crystal",
	tiles = "default_diamond_block.png^[colorize:green:120"
})



minetest.register_craftitem("potions:ruby_gem", {
	description = "Ruby Gem",
	inventory_image = "potions_ruby_gem.png",
})
minetest.register_craftitem("potions:ruby_crystal", {
	description = "Ruby Crystal",
	inventory_image = "potions_ruby_crystal.png",
})
potions.register_geode("ruby", {
	description = "Ruby",
	drops = "potions:ruby_crystal",
	tiles = "default_diamond_block.png^[colorize:red:120"
})


minetest.register_craftitem("potions:sapphire_gem", {
	description = "Sapphire Gem",
	inventory_image = "potions_sapphire_gem.png",
})
minetest.register_craftitem("potions:sapphire_crystal", {
	description = "Sapphire Crystal",
	inventory_image = "potions_sapphire_crystal.png",
})
potions.register_geode("sapphire", {
	description = "Sapphire",
	drops = "potions:sapphire_crystal",
	tiles = "default_diamond_block.png^[colorize:blue:120"
})



minetest.register_craftitem("potions:garnet_gem", {
	description = "Garnet Gem",
	inventory_image = "potions_garnet_gem.png",
})
minetest.register_craftitem("potions:garnet_crystal", {
	description = "Garnet Crystal",
	inventory_image = "potions_garnet_crystal.png",
})
potions.register_geode("garnet", {
	description = "Garnet",
	drops = "potions:garnet_crystal",
	tiles = "default_diamond_block.png^[colorize:red:120^[colorize:black:60"
})



minetest.register_craftitem("potions:zircon_gem", {
	description = "Zircon Gem",
	inventory_image = "potions_zircon_gem.png",
})
minetest.register_craftitem("potions:zircon_crystal", {
	description = "Zircon Crystal",
	inventory_image = "potions_zircon_crystal.png",
})
potions.register_geode("zircon", {
	description = "Zircon",
	drops = "potions:zircon_crystal",
	tiles = "default_diamond_block.png^[colorize:yellow:70"
})


--[[
cinnabar
lazurite
pyrite
gypsum
flourite
calcite
halite

cutting and polishing crystals into gems

]]




