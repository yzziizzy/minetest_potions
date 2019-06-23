
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
		if n.name ~= "air" then
			return p
		end
		
		p.y = p.y - 1
	end
	
	return p
end

local function spawn_rock(pos, node)
	pos.y = pos.y + 2

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
			minetest.set_node(p, {name=node})
		else
-- 				minetest.set_node(p, {name = "default:stone"})
		end
	end
	end
	end
end


minetest.register_node("potions:rock_seed", {
	description = "Rock Seed",
	tiles = {"default_sandstone.png^default_tool_bronzepick.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	
	on_construct = function(pos)
		minetest.set_node(pos, {name="air"})
		
		for i = 1,(math.random(12) + 4) do
			spawn_rock(random_pos(pos, 30), "default:sandstone")
		end
		
	end,
})
