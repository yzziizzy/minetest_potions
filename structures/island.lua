


local function dist3(a, b)
	local x = a.x - b.x
	local y = a.y - b.y
	local z = a.z - b.z
	return math.sqrt(x*x + y*y + z*z)
end

local function dist2(a, b)
	local x = a.x - b.x
	local z = a.z - b.z
	return math.sqrt(x*x + z*z)
end


local function make_island(pos, size)
-- 	dir.y = 0
	
	pos.y = pos.y - 3
	
	
	local r = size
	
	local r2 = math.ceil(r+1)
	local top_nodes = {}
	
	-- foundation 
	for x = pos.x-r2,pos.x+r2,1 do
	for y = -r2,0,1 do
	for z = pos.z-r2,pos.z+r2,1 do
		local p = {x=x, y=pos.y+y, z=z}
		local p_squash = {x=x, y=pos.y + (y*2), z=z}
		local d = dist3(p_squash, pos) 
		
		d = d + math.random() * .5
		
		local dd = d - r
		
		if dd < 1 then
			if y == 0 then
				table.insert(top_nodes, p)
			end
			
			local n = minetest.get_node(p)
 			if n.name == "default:water_source" or n.name == "default:water_flowing" then
				minetest.set_node(p, {name = "default:coral_skeleton"})
 			end
		elseif dd < 1.8 and math.random(8) == 1 then
			if math.random(2) == 1 then
				minetest.set_node(p, {name = "default:coral_brown"})
			else
				minetest.set_node(p, {name = "default:coral_orange"})
			end
		end
	end
	end
	end
	
	-- sand
	for _,p in ipairs(top_nodes) do
		p.y = p.y + 1
		
		minetest.set_node(p, {name="default:sand"})
		
		local d = dist2(pos, p) + math.random() * .9
		if d / r < .5 then
			p.y = p.y + 1
			minetest.set_node(p, {name="default:dirt_with_grass"})
			
			if math.random(5) == 1 then
				p.y = p.y + 1
				minetest.set_node(p, {name="default:grass_1"})
			end
		elseif math.random(8) == 1 then
			p.y = p.y + 1
			minetest.set_node(p, {name="default:marram_grass_1"})
		end
		
		
	end
	
	-- add a tree
	if size > 15 then
		default.grow_new_emergent_jungle_tree({x=pos.x, y=pos.y+2, z=pos.z})
	elseif size > 10 then
		default.grow_new_jungle_tree({x=pos.x, y=pos.y+2, z=pos.z})
	elseif size > 7 then
		default.grow_new_aspen_tree({x=pos.x, y=pos.y+2, z=pos.z})
	elseif size > 3 then
		default.grow_new_apple_tree({x=pos.x, y=pos.y+2, z=pos.z})
	end
	
	
end





minetest.register_craftitem("potions:island_seed", {
	description = "Island Seed",
	inventory_image = "default_brick.png",
	groups = {cracky=3,},
 	liquids_pointable=true,
	
	on_use = function(itemstack, player, pointed_thing)
		
		

		
		local pos = pointed_thing.above
		if not pos then
			return
		end
		
		pos.y = pos.y + 1
		
-- 		local below = {x=pos.x, y=pos.y-1, z=pos.z}
-- 		local n = minetest.get_node(below)
-- 		if n.name == "air" or n.name == "ignore" then
-- 			return
-- 		end
		
-- 		local newname = get_temp_node(n.name)
		
		potions.use_manna(player, 20)
		
		make_island(pos, 4)
		-- get player yaw, calc direction
		
-- 		itemstack:take_item()
		return itemstack
	end,
})
