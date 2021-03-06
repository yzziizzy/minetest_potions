
minetest.register_node("potions:hotspring_seed", {
	description = "Hotspring seed",
	drawtype = "node",
	tiles = {"default_mese.png"},
	groups = {cracky=3,},
})

minetest.register_node("potions:sulphur_deposit_1", {
	description = "Sulphur",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_silver_sandstone.png^[colorize:yellow:140"},
-- 		drops = {},
	node_box = {
		type = "fixed",
		fixed = {
			{-.3, -.5, -.3, -0.1, -.45, -0.1},
			{.3, -.5, .3, 0.1, -.45, 0.1,},
			{-.3, -.5, .3, -0.1, -.45, 0.1},
		},
	},
	groups = {cracky=3, geode_wall = 1 },
})


minetest.register_node("potions:fumarole", {
	description = "Fumarole",
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	tiles = {"default_stone.png^[colorize:black:10"},
	drop = 'default:cobble',
	damage_per_second = 3,
	node_box = {
		type = "fixed",
		fixed = {
			{-.4, -.5, -.4, 0.3, -.4, 0.3},
			{-.3+.05, -.4, -.3+.05, 0.2+.05, -.3, 0.2+.05},
			{-.2+.08, -.3, -.2+.08, 0.1+.08, -.2, 0.1+.08},
		},
	},
	groups = {cracky=3, },
})



minetest.register_abm({
	nodenames = "potions:fumarole",
	chance = 1,
	interval = 20,
	action = function(pos, node)
		pos.y = pos.y + 0
		minetest.add_particlespawner({
			amount = 20,
			time = 20,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-0.1, y=.6, z=-0.1},
			maxvel = {x=0.1,  y=1.6,  z=0.1},
			minacc = {x=-0.1, y=.1, z=-0.1},
			maxacc = {x=0.1, y=.1, z=0.1},
			minexptime = 2.5,
			maxexptime = 4.5,
			minsize = 4.2,
			maxsize = 5.2,
			texture = "tnt_smoke.png",
		})
	end
})



minetest.register_node("potions:hotspring_water_source", {
	description = "Hotspring Water Source",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_river_water_source_animated.png^[colorize:yellow:50",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_river_water_source_animated.png^[colorize:yellow:50",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "potions:hotspring_water_flowing",
	liquid_alternative_source = "potions:hotspring_water_source",
	liquid_viscosity = 1,
	-- Not renewable to avoid horizontal spread of water sources in sloping
	-- rivers that can cause water to overflow riverbanks and cause floods.
	-- River water source is instead made renewable by the 'force renew'
	-- option used in the 'bucket' mod by the river water bucket.
	liquid_renewable = false,
	liquid_range = 2,
	damage_per_second = 1,
	post_effect_color = {a = 103, r = 60, g = 96, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("potions:hotspring_water_flowing", {
	description = "Flowing Hotspring Water",
	drawtype = "flowingliquid",
	tiles = {"default_river_water.png^[colorize:yellow:50"},
	special_tiles = {
		{
			name = "default_river_water_flowing_animated.png^[colorize:yellow:50",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "default_river_water_flowing_animated.png^[colorize:yellow:50",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "potions:hotspring_water_flowing",
	liquid_alternative_source = "potions:hotspring_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 2,
	damage_per_second = 1,
	post_effect_color = {a = 103, r = 60, g = 96, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})



minetest.register_node("potions:scalding_stone_1", {
	description = "Scalding Stone",
	tiles = {"default_stone.png^[colorize:orange:120"},
	groups = {cracky = 3, scalding_stone = 1},
	drop = 'default:cobble',
	damage_per_second = 1,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("potions:scalding_stone_2", {
	description = "Scalding Stone",
	tiles = {"default_stone.png^[colorize:yellow:80"},
	groups = {cracky = 3, scalding_stone = 1},
	drop = 'default:cobble',
	damage_per_second = 1,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("potions:scalding_stone_3", {
	description = "Scalding Stone",
	tiles = {"default_desert_stone.png^[colorize:orange:120"},
	groups = {cracky = 3, scalding_stone = 1},
	drop = 'default:cobble',
	damage_per_second = 1,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("potions:scalding_stone_4", {
	description = "Scalding Stone",
	tiles = {"default_desert_stone.png^[colorize:yellow:80"},
	groups = {cracky = 3, scalding_stone = 1},
	drop = 'default:cobble',
	damage_per_second = 1,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("potions:scalding_stone_5", {
	description = "Scalding Stone",
	tiles = {"default_stone.png^[colorize:red:80"},
	groups = {cracky = 3, scalding_stone = 1},
	drop = 'default:cobble',
	damage_per_second = 1,
	sounds = default.node_sound_stone_defaults(),
})



local scalding_stones = {
	"potions:scalding_stone_1",
	"potions:scalding_stone_2",
	"potions:scalding_stone_3",
	"potions:scalding_stone_4",
	"potions:scalding_stone_5",
}


local function dist3(a, b)
	local x = a.x - b.x
	local y = a.y - b.y
	local z = a.z - b.z
	return math.sqrt(x*x + y*y + z*z)
end

local function spawn_hotspring(pos, size)
	
	-- hotsprings don't spawn near forests
	if minetest.find_node_near(pos, 20, {"group:tree"}) then
		return
	end
	

	local r = size
	
	local r2 = math.ceil(r+1)
	
	for x = pos.x-r2,pos.x+r2,1 do
	for y = -r2,r2,1 do
	for z = pos.z-r2,pos.z+r2,1 do
		local p = {x=x, y=pos.y+y, z=z}
		local p_squash = {x=x, y=pos.y + (y*2), z=z}
		local d = dist3(p_squash, pos) 
		
		d = d + math.random() * .5
		
		local dd = d - r
		
		local n = minetest.get_node(p)
		if n.name ~= "air" then
			if dd <= -.5 then
					minetest.set_node(p, {name = "potions:hotspring_water_source"})
			elseif dd < 1 then
				minetest.set_node(p, {name = scalding_stones[math.random(#scalding_stones)]})
-- 				minetest.get_node_timer(p):start(1)
			elseif dd <= 1.8 then
				minetest.set_node(p, {name = "default:stone"})
			else
	-- 				minetest.set_node(p, {name = "default:stone"})
			end
		end
	end
	end
	end
	
	
	
end












minetest.register_abm({
	nodenames = "potions:hotspring_water_source",
	chance = 60,
	interval = 5,
	action = function(pos, node)
			minetest.add_particlespawner({
				amount = 1,
				time = 1,
				minpos = pos,
				maxpos = pos,
				minvel = {x=-0.1, y=.6, z=-0.1},
				maxvel = {x=0.1,  y=1.6,  z=0.1},
				minacc = {x=-0.1, y=.1, z=-0.1},
				maxacc = {x=0.1, y=.1, z=0.1},
				minexptime = 3.5,
				maxexptime = 6.5,
				minsize = 10.2,
				maxsize = 12.2,
				texture = "tnt_smoke.png",
			})
	end
})


local function random_pos(pos, dist)
	local p = {
		x=pos.x + math.random(-dist, dist),
		y=pos.y + dist,
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
	name = "potions:hotspring_tester",
	nodenames = "potions:hotspring_seed",
	chance = 1,
	interval = 5,
	action = function(pos, node)
		minetest.after(2, function()
			minetest.set_node(pos, {name="air"})
			
			-- spawn with greater frequency the farther we get from the origin
			local max_penalty = 20
			local ramp_dist = 10000
			local origind = math.sqrt(pos.x*pos.x + pos.z*pos.z)
			local penalty = math.min(max_penalty, max_penalty * (1 - (origind / ramp_dist))) 
			
			-- random bail here
			if math.random(10 + penalty) > 1 then
				return
			end
			
			for i = 1,(math.random(3) + 1) do
				spawn_hotspring(random_pos(pos, 10), math.random(3) + 3)
			end
			
			for i = 1,(math.random(6) + 2) do
				spawn_hotspring(random_pos(pos, 20), math.random(2) + 1)
			end
		end)
	end
})


-- life dies near hotsprings
minetest.register_abm({
	nodenames = "group:flora",
	neighbors = {"group:scalding_stone"},
	chance = 10,
	interval = 15,
	action = function(pos, node)
		minetest.set_node(pos, {name="air"})
	end
})

-- life dies near hotsprings
minetest.register_abm({
	nodenames = "group:flora",
	neighbors = {"group:scalding_stone"},
	chance = 80,
	interval = 15,
	action = function(pos, node)
		local p = minetest.find_node_near(pos, 15, {"group:flora", "group:sapling", "group:leaves", "group:leafdecay"})
		if p then
			minetest.set_node(p, {name="air"})
		end
	end
})


-- minerals accumulate
minetest.register_abm({
	nodenames = "group:scalding_stone",
	neighbors = {"air"},
	chance = 180,
	interval = 30,
	action = function(pos, node)
		-- TODO: place sulphur on sides too
		pos.y = pos.y + 1
		local n = minetest.get_node(pos)
		if n.name == "air" then
			minetest.set_node(pos, {name="potions:sulphur_deposit_1"})
		end
	end
})



-- water scalds stone
minetest.register_abm({
	nodenames = {"group:stone", "group:dirt"},
	neighbors = {"potions:hotspring_water_source", "potions:hotspring_water_flowing"},
	chance = 80,
	interval = 10,
	action = function(pos, node)
		minetest.set_node(pos, {name=scalding_stones[math.random(#scalding_stones)]})
	end
})

-- stones scald dirt
minetest.register_abm({
	nodenames = "group:soil",
	neighbors = {"group:scalding_stone"},
	chance = 80,
	interval = 10,
	action = function(pos, node)
		minetest.set_node(pos, {name="default:stone"})
	end
})



-- water melts snow
minetest.register_abm({
	nodenames = {"default:snow", "default:snowblock"},
	neighbors = {"potions:hotspring_water_source", "potions:hotspring_water_flowing"},
	chance = 80,
	interval = 10,
	action = function(pos, node)
		minetest.set_node(pos, {name="air"})
	end
})



-- add hotspring seeds to mapgen
minetest.register_decoration({
	name = "potions:hotspring_seed",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_snow", "default:snowblock",
		"default:silver_sand", "default:sand", "default:desert_sand"
	},
	place_offset_y = 1,
	sidelen = 16,
	noise_params = {
		offset = -0.010,
		scale = 0.01,
		spread = {x = 200, y = 200, z = 200},
		seed = 65645647,
		octaves = 3,
		persist = 0.7,
	},
	biomes = {"grassland", "snowy_grassland", "tundra", "taiga", "desert", "cold_desert", "sandstone_desert"},
	y_max = 1000,
	y_min = 5,
	place_offset_y = 1,
	decoration = "potions:hotspring_seed",
	flags = "force_placement",
})


-- hotsprings boil rivers
minetest.register_abm({
	nodenames = {"default:river_water_source"},
	neighbors = {"potions:hotspring_water_source", "potions:hotspring_water_flowing"},
	chance = 15,
	interval = 5,
	action = function(pos, node)
	
		-- only spread downhill
		local hw = minetest.find_nodes_in_area(
			{x=pos.x-1, y=pos.y, z=pos.z-1},
			{x=pos.x+1, y=pos.y+1, z=pos.z+1},
			{"potions:hotspring_water_source", "potions:hotspring_water_flowing"})
		
		if not hw or #hw == 0 then
			return
		end
		
		-- don't spread under rivers
		pos.y = pos.y + 1
		local n = minetest.get_node(pos)
		if n.name == "default:river_water_source" or n.name == "default:river_water_flowing" then
			return
		end
		
		pos.y = pos.y - 1
		
		minetest.set_node(pos, {name="potions:hotspring_water_source"})
	end
})

