








local function drop_column(pos, node, maxdrop)
	local maxd = pos.y - maxdrop
	local p = {x=pos.x, y=pos.y, z=pos.z}
	
	while p.y >= maxd do
		
		local n = minetest.get_node(p)
		local def = minetest.registered_nodes[n.name]
		if def.groups.liquid then
			minetest.set_node(p, {name=node})
		else
			break
		end
		
		p.y = p.y - 1
	end
	
end



local function drop_wall(start, length, dir, node, maxdrop)
	local p = {x=start.x, y=start.y, z=start.z}
	
	for i = 1,length do
		drop_column(p, node, maxdrop)
		
		p = vector.add(p, dir)
	end
	
end


local function drop_octagon(center, rad)
	
	drop_wall(vector.add(center, {x=rad*2, y=0, z=rad}), rad*2+1, {x=0,y=0,z=-1}, "default:cobble", 10)
	drop_wall(vector.add(center, {x=-rad*2, y=0, z=-rad}), rad*2+1, {x=0,y=0,z=1}, "default:cobble", 10)
	
	drop_wall(vector.add(center, {x=rad, y=0, z=rad*2}), rad*2+1, {x=-1,y=0,z=0}, "default:cobble", 10)
	drop_wall(vector.add(center, {x=-rad, y=0, z=-rad*2}), rad*2+1, {x=1,y=0,z=0}, "default:cobble", 10)
	
	drop_wall(vector.add(center, {x=rad, y=0, z=-rad*2}), rad, {x=1,y=0,z=1}, "default:cobble", 10)
	drop_wall(vector.add(center, {x=-rad, y=0, z=rad*2}), rad, {x=-1,y=0,z=-1}, "default:cobble", 10)
	
	drop_wall(vector.add(center, {x=-rad, y=0, z=-rad*2}), rad, {x=-1,y=0,z=1}, "default:cobble", 10)
	drop_wall(vector.add(center, {x=rad, y=0, z=rad*2}), rad, {x=1,y=0,z=-1}, "default:cobble", 10)

-- 	drop_wall(vector.add(center, {x=-rad, y=0, z=rad/2}), rad/2, {x=1,y=0,z=-1}, "default:cobble", 10)
	
	
end


local function freeze_top(pos, max_nodes, cb)
	local stack = {}
	local out = {}
	table.insert(stack, pos)
	
	local function process()
		local i = 0
		while #stack > 0 do
			local nn = math.random(#stack)
-- 			print("index "..nn .. " of "..#stack)
			local p = table.remove(stack, nn)
-- 			print(dump(p))
			local n = minetest.get_node(p)
			if n.name == "default:water_source" then
				table.insert(out, p)
				
				minetest.set_node(p, {name="default:ice"})
				
				table.insert(stack, vector.add(p, {x=1, y=0, z=0}))
				table.insert(stack, vector.add(p, {x=-1, y=0, z=0}))
				table.insert(stack, vector.add(p, {x=0, y=0, z=1}))
				table.insert(stack, vector.add(p, {x=0, y=0, z=-1}))
				
				if #out > max_nodes then
					cb(out)
					return
				end
				
				if #stack > 0 and i > 5 then
					minetest.after(1, process)
					return
				elseif #stack == 0 then
					cb(out)
				end
				
				i = i + 1
			end
		end
		
		cb(out)
	end
	
	process()
	
end




local function clear_water(pts, maxd, top_off)
	for _,p in ipairs(pts) do
		drop_column({x=p.x, y=p.y-top_off, z=p.z}, "air", maxd - top_off)
	end
	
end

local function remove_points(pts, lvl)
	
	for _,p in ipairs(pts) do
		minetest.set_node({x=p.x, y=p.y-lvl, z=p.z}, {name="air"})
	end
end



minetest.register_node("potions:coffer_dam_seed", {
	description = "Coffer Dam Seed",
	drawtype = "node",
	tiles = {"default_stone_brick.png"},
	groups = {cracky=3,},
	liquids_pointable=true,
	on_construct = function(pos)
		minetest.set_node(pos, {name="default:water_source"})
		drop_octagon(pos, 3)
		freeze_top(pos, 12*12, function(pts)
-- 			print("points "..#pts)
			clear_water(pts, 10, 1)
			minetest.add_particlespawner({
				amount = 800,
				time = 4,
				minpos = vector.subtract(pos, 3+2),
				maxpos = vector.add(pos, 3+2),
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
				texture = "potions_particle.png^[colorize:blue:110",
		-- 		animation = tileanimation
				glow = 1
			})
			minetest.after(2.5, remove_points, pts, 0)
		end)
	end
})
