


minetest.register_node("potions:scanner_endpoint", {
	description = "Scanner Endpoint",
	tiles = {"default_stone.png^default_tool_steelsword.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("potions:scanner_noreplace", {
	description = "Scanner NoReplace",
	drawtype = "glasslike",
	tiles = {"default_glass.png^default_tool_diamondsword.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("potions:scanner_center", {
	description = "Scanner Center",
	tiles = {"default_stone.png^default_tool_bronzesword.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	on_punch = function(pos)
		
		local path = minetest.get_worldpath().."/potions_testfile.txt"
		local ends = minetest.find_nodes_in_area(
			vector.subtract(pos, 51), 
			vector.add(pos, 51), 
			{"potions:scanner_endpoint"})
			
		if #ends < 2 then
			return
		end
		
		local e1 = {
			x = math.min(ends[1].x, ends[2].x)+1,
			y = math.min(ends[1].y, ends[2].y)+1,
			z = math.min(ends[1].z, ends[2].z)+1,
		}
		local e2 = {
			x = math.max(ends[1].x, ends[2].x)-1,
			y = math.max(ends[1].y, ends[2].y)-1,
			z = math.max(ends[1].z, ends[2].z)-1,
		}
		
		local data = {}
		
		for x = e1.x,e2.x do
		for y = e1.y,e2.y do
		for z = e1.z,e2.z do
			local p = {x=x, y=y, z=z}
			
			local n = minetest.get_node(p)
			
			if n.name ~= "air" then
				local nn = { name=n.name, }
				if n.param2 and n.param2 > 0 then
					nn.param2 = n.param2
				end
				
				table.insert(data, {p=vector.subtract(p, pos), n=nn})
			end
		end
		end
		end
		
		
		local f = io.open(path, "w")
		f:write(dump(data))
		f:close()
	end,
})





