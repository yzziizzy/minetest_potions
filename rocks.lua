
local function dist3(a, b)
	local x = a.x - b.x
	local y = a.y - b.y
	local z = a.z - b.z
	return math.sqrt(x*x + y*y + z*z)
end

local function random_pos(pos, dist)
	local p = {
		x=pos.x + math.random(-dist, dist),
		y=pos.y + dist,
		z=pos.z + math.random(-dist, dist),
	}
	
	while p.y > pos.y - dist do
		local n = minetest.get_node(p)
		if n.name ~= "air" and n.name ~= "ignore" then
			return p
		end
		
		p.y = p.y - 1
	end
	
	return nil
end

local function spawn_rock(pos, nodes)
	if pos == nil then
		return
	end
	pos.y = pos.y + 2
	
	local ns = {}
	for name,chance in pairs(nodes) do
		for i = 1,chance do
			table.insert(ns, name)
		end
	end
	

	local r = math.random() * 1.1 + .3
	local stry = math.random(6) + 1
	local strx = math.random() * .5 + .5
	local strz = math.random() * .5 + .5
	
	local lx = math.random() * 1.6 - .8
	local lz = math.random() * 1.6 - .8
	
	local r2 = math.ceil(r+1)
	
	for x = -r2,r2,1 do
	for y = -r2*stry,r2*stry,1 do
	for z = -r2,r2,1 do
		
		local p = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
		local p_squash = {
			x = pos.x + (x/strx) + lx*y, 
			y = pos.y + (y/stry), 
			z = pos.z + (z/strz) + lz*y
		}
		local d = dist3(p_squash, pos) 
		
		d = d + math.random() * .5
		
		local dd = d - r
		
		if dd <= 1 then
			minetest.set_node(p, {name=ns[math.random(#ns)]})
		else
-- 				minetest.set_node(p, {name = "default:stone"})
		end
	end
	end
	end
end


local seed_biomes = {
	["default:sand"] = {
		{
			["default:desert_stone"] = 7, 
			["potions:sphalerite_ore"] = 1, 
		},
	},
	["default:desert_sand"] = {
		{
			["default:sandstone"] = 7, 
			["potions:cinnabar_ore"] = 1, 
		},
		{
			["default:sandstone"] = 5, 
			["potions:cinnabar_ore"] = 1, 
		},
		
	},
	["default:silver_sand"] = {
		{
			["default:stone"] = 7, 
			["potions:galena"] = 1, 
		},
	},

}





minetest.register_node("potions:rock_seed", {
	description = "Rock Seed",
	tiles = {"default_sandstone.png^default_tool_bronzepick.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
	
	on_timer = function(pos)
		minetest.set_node(pos, {name="air"})
		
-- 		if 1 ~= math.random(10) then
-- 			return
-- 		end
		print("rock seed")
		local p = minetest.find_node_near(pos, 4, {"default:sand", "default:desert_sand", "default:silver_sand"})
		local n = minetest.get_node(p)
		print(dump(n.name))
		local b = seed_biomes[n.name]
		if not b then return end
		print("b")
		
		for i = 1,(math.random(1) + 0) do
			spawn_rock(random_pos(pos, math.random(20) + 20), b[1])
		end
		
	end,
})


minetest.register_abm({
	nodenames = "potions:rock_seed",
	chance = 1,
	interval = 5,
	action = function(pos, node)
		minetest.get_node_timer(pos):start(2)
	end
})


minetest.register_decoration({
	name = "potions:rock_seed",
	deco_type = "simple",
	place_on = {"default:desert_sand", "default:silver_sand", "default:sand",},
	place_offset_y = 1,
	sidelen = 16,
	noise_params = {
		offset = -0.0105,
		scale = 0.01,
		spread = {x = 200, y = 200, z = 200},
		seed = 29724537,
		octaves = 3,
		persist = 0.7,
	},
	biomes = {"desert", "cold_desert", "sandstone_desert"},
	y_max = 1000,
	y_min = 5,
	place_offset_y = 1,
	decoration = "potions:rock_seed",
	flags = "force_placement",
})


