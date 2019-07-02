

local function make_tunnel(pos, radius, length, dir)
-- 	dir.y = 0
	local ndir = vector.normalize(dir)
	local cross = vector.normalize({x=-dir.z, y=0, z=dir.x})
	
	local wlow = math.ceil(width / 2)
	local whigh = math.floor(width / 2)
	local exp = 2
-- 	local off = math.sin(math.pi/(exp*exp)) * height
	
	for l = 0,length do
		
-- 		local y = -off + math.sin(math.pi/(exp*exp) + ((l / length) * math.pi / exp) ) * height
		
		
		local p = {x = pos.x+l*ndir.x, y=pos.y+l*ndir.y, z=pos.z+l*ndir.z}
		
-- 		local param2 = 0
-- 		if math.floor(y + .5) ~= math.floor(y) then
-- 			p.y = p.y - 1
-- 			param2 = 20
-- 		end
			print(dump(p))
		minetest.set_node(p, {name="air"})
		
		
 		for h = -radius,radius do
		for w = -radius,radius do
			if math.sqrt(h*h + w*w) <= radius then
				local p2 = vector.add(p, vector.multiply(cross, w))
				p2.y = p2.y + h
				minetest.set_node(
					p2, 
					{name="air"})
			end
		end
		end
	end
	
	
end





minetest.register_craftitem("potions:tunnel_seed", {
	description = "Tunnel Seed",
	inventory_image = "default_sandstone_brick.png",
	groups = {cracky=3,},
 	liquids_pointable=true,
	
	on_use = function(itemstack, player, pointed_thing)
		
		local pos = player:get_pos()
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
		
		local th = player:get_look_horizontal()
		local thv = player:get_look_vertical()
		local dir = vector.normalize({
			x = -math.sin(th),
			y = math.sin(thv),
			z = math.cos(th), 
		})
		
		local pos2 = vector.add(pos, vector.multiply(dir, potions.get_manna(player)))
		
		
-- 		local b, pos3 = minetest.line_of_sight(pos, pos2)
-- 		if b == false then
-- 			pos2 = pos3
-- 		end
		
		local dist = 20 -- vector.distance(pos, pos2)
		
		dist = potions.use_manna(player, dist)
		
		if dist < 2 then
			return
		end
		
		print(dump(dir))
		
-- 		minetest.set_node(pos, {name="air"})
		make_tunnel(pos, 4, 5, 30, dir)
		-- get player yaw, calc direction
		
-- 		itemstack:take_item()
		return itemstack
	end,
})
