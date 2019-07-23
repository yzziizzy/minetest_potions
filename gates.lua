


local gate_list = {}





minetest.register_node("potions:gate_horizon", {
	description = "Gate Horizon",
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	paramtype2 = "facedir",
	tiles = {
		{
			name = "default_water_source_animated.png^[colorize:purple:180",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_water_source_animated.png^[colorize:purple:180",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	groups = {cracky=3},
	alpha = 160,
-- 	pointable = false,
	walkable = false,
	post_effect_color = {a = 103, r = 160, g = 60, b = 190},
	sounds = default.node_sound_water_defaults(),
-- 	drop = "xpanes:" .. name .. "_flat",
	node_box = {
		type = "fixed",
		fixed = {{-3/2, -3/2, -1/32, 3/2, 3/2, 1/32}},
	},
	selection_box = {
		type = "fixed",
		fixed = {{-3/2, -3/2, -1/32, 3/2, 3/2, 1/32}},
	},
	
	on_timer = function (pos, elapsed)
		local node = minetest.get_node(pos)

		local objs = minetest.get_objects_inside_radius(pos, 2)
		
		for k, obj in pairs(objs) do
			if obj:is_player() then
				local objpos = obj:getpos()
				
				if #gate_list > 0 then
					local p = gate_list[math.random(#gate_list)]
					
					obj:setpos(p)
				end
				
				print("player in gate")
			end
		end
		
		return true
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(3)
	end,
})






local function check_gate(pos)
	
	local function is_gate_node(p) 
		local n = minetest.get_node(p)
		return n.name == "potions:gateblock"
	end
	
	
	if not is_gate_node({x=pos.x, y=pos.y, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x+1, y=pos.y, z=pos.z}) then return false end 
	if not is_gate_node({x=pos.x-1, y=pos.y, z=pos.z}) then return false end 
	if not is_gate_node({x=pos.x, y=pos.y+4, z=pos.z}) then return false end 
	if not is_gate_node({x=pos.x+1, y=pos.y+4, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x-1, y=pos.y+4, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x-2, y=pos.y+1, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x-2, y=pos.y+2, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x-2, y=pos.y+3, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x+2, y=pos.y+1, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x+2, y=pos.y+2, z=pos.z}) then return false end
	if not is_gate_node({x=pos.x+2, y=pos.y+3, z=pos.z}) then return false end
	
	
	local center = {x=pos.x, y=pos.y + 2, z=pos.z}
	
	minetest.set_node(center, {name="potions:gate_horizon"})
	
	
	
	table.insert(gate_list, center);
	
	--[[
	minetest.add_particlespawner({
		amount = 200,
		time = 2,
		minpos = pos,
		maxpos = pos,
		minvel = {x=-0.1, y=2.6, z=-0.1},
		maxvel = {x=0.1,  y=3.6,  z=0.1},
		minacc = {x=-0.1, y=.1, z=-0.1},
		maxacc = {x=0.1, y=.1, z=0.1},
		minexptime = 2.5,
		maxexptime = 4.5,
		minsize = 4.2,
		maxsize = 5.2,
		texture = "tnt_smoke.png",
	})
	]]
	
	return true
	
end






minetest.register_node("potions:gateblock", {
	description = "Gate Block",
	drawtype = "node",
	tiles = {"default_obsidian.png^[colorize:white:30"},
	groups = {cracky=3,},
	on_construct = check_gate,
})












