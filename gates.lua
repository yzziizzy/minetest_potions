







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
	
	return true
	
end






minetest.register_node("potions:gateblock", {
	description = "Gate Block",
	drawtype = "node",
	tiles = {"default_obsidian.png^[colorize:white:30"},
	groups = {cracky=3,},
	on_construct = check_gate,
})












