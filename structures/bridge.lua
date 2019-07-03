

local function make_bridge(pos, width, length, height, dir, node)
	dir.y = 0
	local ndir = vector.normalize(dir)
	local cross = vector.normalize({x=-dir.z, y=0, z=dir.x})
	
	local w2 = width / 2
	local exp = 2
	local off = math.sin(math.pi/(exp*exp)) * height
	
	for l = 0,length do
		
		local y = -off + math.sin(math.pi/(exp*exp) + ((l / length) * math.pi / exp) ) * height
		
		
		local p = {x = pos.x+l*ndir.x, y=pos.y+y, z=pos.z+l*ndir.z}
		
		local param2 = 0
		if math.floor(y + .5) ~= math.floor(y) then
			p.y = p.y - 1
			param2 = 20
		end
		
		for w = -w2,w2 do
			minetest.set_node(
				vector.add(p, vector.multiply(cross, w)), 
				{name=node,  param2 = param2})
		end
		
	end
	
	
	
	
	
	
end




function make_temp_node(oname)
	local t = string.split(oname, ":")
	local mn = t[1]
	local nn = t[2]
	
	local newname = "potions:temp_slab_"..mn.."_"..nn
	
	-- see if it's already registered
	if minetest.registered_nodes[newname] ~= nil then
		return newname
	end
	
	local odef = minetest.registered_nodes[oname]
	
	minetest.register_node(newname, {
		description = odef.name,
		tiles = odef.tiles,
		special_tiles = odef.special_tiles,
		groups = {cracky=3, crumbly=3, snappy=3, choppy=3, not_in_creative_inventory=1},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		alpha = odef.alpha,
		sounds = odef.sounds,
		drop = "",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
			},
		},
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(10 * 3 + math.random(10))
		end,
		on_timer = function(pos)
			minetest.set_node(pos, {name="air"})
		end,
	})
	
	
	return newname
	
end


function get_temp_node(oname)
	local t = string.split(oname, ":")
	local mn = t[1]
	local nn = t[2]
	
	local newname = "potions:temp_slab_"..mn.."_"..nn
	
	-- see if it's already registered
	if minetest.registered_nodes[newname] ~= nil then
		return newname
	end
	-- TODO: check groups to return the closest analog
	
	return "potions:temp_slab_default_dirt"
end


 make_temp_node("default:dirt")
 -- the special tiles are messed up
--  make_temp_node("default:dirt_with_grass")
--  make_temp_node("default:dirt_with_rainforest_litter")
--  make_temp_node("default:dirt_with_coniferous_litter")
--  make_temp_node("default:dirt_with_dry_grass")
--  make_temp_node("default:dirt_with_snow")
 make_temp_node("default:sand")
 make_temp_node("default:desert_sand")
 make_temp_node("default:silver_sand")
 make_temp_node("default:cobble")
 make_temp_node("default:stone")
 make_temp_node("default:desert_stone")
 make_temp_node("default:desert_cobble")
 make_temp_node("default:mossycobble")
 make_temp_node("default:sandstone")
 make_temp_node("default:desert_sandstone")
 make_temp_node("default:silver_sandstone")
 make_temp_node("default:obsidian")
 make_temp_node("default:permafrost")
 make_temp_node("default:permafrost_with_stones")
 make_temp_node("default:permafrost_with_moss")
 make_temp_node("default:gravel")
 make_temp_node("default:clay")
 make_temp_node("default:snow")
 make_temp_node("default:snowblock")
 make_temp_node("default:cave_ice")
 make_temp_node("default:ice")
 make_temp_node("default:tree")
 make_temp_node("default:wood")
 make_temp_node("default:leaves")
 make_temp_node("default:acacia_tree")
 make_temp_node("default:acacia_wood")
 make_temp_node("default:acacia_leaves")
 make_temp_node("default:aspen_tree")
 make_temp_node("default:aspen_wood")
 make_temp_node("default:aspen_leaves")
 make_temp_node("default:pine_tree")
 make_temp_node("default:pine_wood")
 make_temp_node("default:pine_needles")
 make_temp_node("default:jungletree")
 make_temp_node("default:junglewood")
 make_temp_node("default:jungleleaves")
 make_temp_node("default:water_source")
 make_temp_node("default:water_flowing")
 make_temp_node("default:river_water_source")
 make_temp_node("default:river_water_flowing")
 make_temp_node("default:lava_source")
 make_temp_node("default:lava_flowing")
 make_temp_node("default:glass")
 make_temp_node("default:brick")
 make_temp_node("default:obsidian_glass")




minetest.register_craftitem("potions:bridge_seed", {
	description = "Bridge Seed",
	inventory_image = "default_stone_brick.png",
	groups = {cracky=3,},
 	liquids_pointable=true,
	
	on_use = function(itemstack, player, pointed_thing)
		
		local pos = pointed_thing.above
		if not pos then
			return
		end
		
		local below = {x=pos.x, y=pos.y-1, z=pos.z}
		local n = minetest.get_node(below)
		if n.name == "air" or n.name == "ignore" then
			return
		end
		
		local newname = get_temp_node(n.name)
		
		local th = player:get_look_horizontal()
		local dir = {
			x = -math.sin(th),
			y = 0,
			z = math.cos(th), 
		}
		
		local pos2 = vector.add(pos, vector.multiply(dir, potions.get_manna(player)))
		
		
		local b, pos3 = minetest.line_of_sight(pos, pos2)
		if b == false then
			pos2 = pos3
		end
		
		local dist = vector.distance(pos, pos2)
		
		dist = potions.use_manna(player, dist)
		
		if dist < 2 then
			return
		end
		
		minetest.set_node(pos, {name="air"})
		make_bridge(pos, 3, dist, dist / 3, dir, newname)
		-- get player yaw, calc direction
		
-- 		itemstack:take_item()
		return itemstack
	end,
})
