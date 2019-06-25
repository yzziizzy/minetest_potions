
potions = {
	geodes = {},
}

local potions_players = {}


local modpath = minetest.get_modpath("potions")

-- Add everything:
local modname = "potions"


-- nodes and some mapgen
dofile(modpath.."/metals.lua")
dofile(modpath.."/geodes.lua")
dofile(modpath.."/hotsprings.lua")

-- core
dofile(modpath.."/minetunnels.lua")
dofile(modpath.."/beanstalk.lua")
dofile(modpath.."/enchanting.lua")
dofile(modpath.."/alchemy.lua")

-- pure mapgen
dofile(modpath.."/rocks.lua")

-- utility
dofile(modpath.."/scanner.lua")


--[[
potions/magic
	destroy all nodes in area of certain type (stone), leaving others
	transform all nearby nodes into another node
	underwater breathing
	dig faster
	loaves and fishes when placing nodes
	summon a homunculus to provide knowledge
	conjure more magic books
	wards, ie area node protection
	spawn ice crust on nearby water
	scry for nearby things; particles lead the way
	summon a storm
	blight an area
	accerate (certain) plant/fungus growth in an area
	conjure a volcano
		spawn magma node
		forge-style movement
		each move takes a time meta value along for cooling
	conjure a meteor
	freeze/thaw an area
	conjure a coffer dam
	conjure an island
	conjure a floatland
	conjure butterflies or fireflies
	a spell with two areas that sucks life-force from one area and vents it to another
	conjure a fully equipped wizard's tower
	conjure a (fully equipped) castle
	hollow a horizontal tunnel
	some potions are thrown, to break and activate where they land
		conjure a prison
	effectively change biome
	clone
	
	
[engine]
	stateless particle systems
	custom particle shaders
	above/below positional abms
	on_craft callback
	nodes that randomly emit particles on their own
	particles that break into or emit more particles
	mapgen "regions" or extra biome params ("magicness" or other such variations)
	ore-ish registration that guarantees a certain limited number of spawns
	mapgen distance-from-center params

fermentation, distillation, soaking/boiling pot, ball mill
glass crafting furnace
need books to do certain spells

"Apocryphon" - secret book

ink, black/gold/silver/red
ethanol, methanol
ammonia
saltpeter, halite, iron(II) sulfate aka green vitriol (melanterite), soda nitre, pot ash
pyrite
iodine (from seaweed)
fossils

fireworks

green alchemist's fire that ignites on and burns water

extra metals:
silver, lead, platinum, rhodium, arsenic, bismuth, mercury, iridium, osmium, zinc

gems:
lapis lazuli, opal, citrine, aquamarine

cyclopian masonry


fumaroles spwaning, textures and features

joshua trees (connected node)
bogs
cobwebs
prickly pear - polishing, spawning and fruit
barrel cactus
bamboo forests
clover fields
basalt outcroppings with mesh nodes 
undersea sponges
undersea volcanic vents
deep-sea worms
thornbushes
blighted areas, purple miasma, dead plants, etc


magic beanstalk
arching bridge
fancy tower
summon a ziggurat (player is flung into the air while it spawns underneath)
magic armor
regeneration amulets
force field
fireball
spell to unlock chests

minetunnels:
	torches in coves
	wood bracing
	minecart chests
	wood walkways over caverns
	hail of arrows trap
	catapult that flings player back

chemistry glassware getting used or consumed
brown version of glassware
fancier glassware needed for fancier chemicals
some chemicals are light-sensitive and are ruined or explode if in bright light
some chemicals explode if heated

can place potions bottles on the ground

enchant tools
	can only dig certain nodes
	explode and damage player if used to dig certain nodes
	only works below ground/above ground
	

ancient artifacts

volcanic hotsprings
geysers
minetunnels a la mobehavior with geodes

pentagram on enchanting table top
higher level enchanting tables
]]


minetest.register_node("potions:prickly_pear", {

	description = "Prickly Pear",
	drawtype = "plantlike",
	waving = 0,
	visual_scale = 2.828,
	tiles = {"potions_prickly_pear.png"},
	inventory_image = "potions_prickly_pear.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, flammable = 3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-8 / 16, -0.5, -8 / 16, 8 / 16, 0.5, 8 / 16},
	},
})

minetest.register_node("potions:prickly_pear_plus", {

	description = "Prickly Pear",
	drawtype = "plantlike",
	waving = 0,
	visual_scale = 2,
	tiles = {"potions_prickly_pear.png"},
	inventory_image = "potions_prickly_pear.png",
	wield_image = "default_junglegrass.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 2,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "potions:prickly_pear",
	groups = {snappy = 3, flora = 1, flammable = 3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-8 / 16, -0.5, -8 / 16, 8 / 16, 0.5, 8 / 16},
	},
})

minetest.register_abm({
	nodenames = "potions:prickly_pear",
	chance = 3,
	interval = 1,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		local h = meta:get_int("height") + 1
		
		if 1 ~= math.random(h*h*h*h) then
			return
		end
		
		local offs = {
			{x=1, y=1, z=1},
			{x=1, y=1, z=-1},
			{x=-1, y=1, z=1},
			{x=-1, y=1, z=-1},
		}
		
		local p = vector.add(pos, offs[math.random(#offs)])
		
		local opts = {
			"potions:prickly_pear_plus",
			"potions:prickly_pear_plus",
		}
		
		local n = minetest.get_node(p)
		if n.name == "air" then
			minetest.set_node(p, {name=opts[math.random(#opts)], param2 = 1})
			local pmeta = minetest.get_meta(p)
			pmeta:set_int("height", h)
		end
	end
})


minetest.register_abm({
	nodenames = "potions:prickly_pear_plus",
	chance = 3,
	interval = 1,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		local h = meta:get_int("height") + 1

		if 1 ~= math.random(h*h*h*h) then
			return
		end
		
		local offs = {
			{x=0, y=1, z=1},
			{x=0, y=1, z=-1},
			{x=1, y=1, z=0},
			{x=-1, y=1, z=0},
		}
		
		local p = vector.add(pos, offs[math.random(#offs)])
		
		local opts = {
			"potions:prickly_pear",
			"potions:prickly_pear",
		}
		
		local n = minetest.get_node(p)
		if n.name == "air" then
			minetest.set_node(p, {name=opts[math.random(#opts)]})
			local pmeta = minetest.get_meta(p)
			pmeta:set_int("height", h)
		end
	end
})




minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	

	local mid = player:hud_add({
		hud_elem_type = "image",
		position  = {x = 0, y = 1},
		offset    = {x = 10, y = -120},
		text      = "potions_manna_bar.png",
		scale     = { x = 1, y = .1},
		alignment = { x = 0, y = -1 },
	})

	player:hud_add({
		hud_elem_type = "image",
		position  = {x = 0, y = 1},
		offset    = {x = 10, y = -120},
		text      = "potions_manna_border.png",
		scale     = { x = 1, y = 1 },
		alignment = { x = 0, y = -1 },
	})
	
	if player:get_attribute("max_manna") == nil then
		player:set_attribute("manna", 10)
		player:set_attribute("max_manna", 100)
	end
	
	potions_players[name] = {
		player = player,
		
		ui = {
			manna_bar = mid,
		},
	}
	
	

-- 	player:hud_change(idx, "text", "New Text")
-- 	
-- 	    local meta        = player:get_meta()
--     local digs_text   = "Digs: " .. meta:get_int("score:digs")
--     local places_text = "Places: " .. meta:get_int("score:places")
--     local percent     = tonumber(meta:get("score:score") or 0.2)
--     
--      player:hud_change(ids["bar_foreground"],
--                 "scale", { x = percent, y = 1 })
-- 	
	
	print(dump(potions_players[name].default_sky))
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	potions_players[name] = nil
end)




local function update_player_manna(player, increase)
	local p = player.player
	
	
	local manna = tonumber(p:get_attribute("manna")) or 0
	local max_manna = tonumber(p:get_attribute("max_manna")) or 100
	
	manna = math.min(manna + increase, max_manna)
	
	
	local mpct = manna / max_manna
	
	p:hud_change(player.ui.manna_bar, "scale", {x = 1, y = mpct})

	p:set_attribute("manna", manna)
end

local function update_all_manna() 
	for _,p in pairs(potions_players) do
		update_player_manna(p, 2)
	end
	
	minetest.after(1, update_all_manna)
end

minetest.after(1, update_all_manna)


potions.use_manna = function(player, amt) 
	local m = tonumber(player:get_attribute("manna")) or 0
	m = m - amt
	if m < 0 then
		if trigger_negative_manna(player, m) then
			return
		end
	end
	
	player:set_attribute("manna", math.max(0, m))
	update_player_manna(potions_players[player:get_player_name()], 0)
end

potions.get_manna = function(player) 
	return tonumber(player:get_attribute("manna")) or 0
end

potions.set_manna = function(player, amt) 
	local max = tonumber(player:get_attribute("max_manna")) or 100
	player:set_attribute("manna", math.max(0, math.min(max, amt)))
	update_player_manna(potions_players[player:get_player_name()], 0)
end

potions.add_manna = function(player, amt) 
	update_player_manna(potions_players[player:get_player_name()], amt)
end

potions.set_max_manna = function(player, amt) 
	player:set_attribute("manna", math.max(0, amt))
	update_player_manna(potions_players[player:get_player_name()], 0)
end



minetest.register_craftitem("potions:holy_water", {
	description = "Holy Water",
	inventory_image = "potions_healing_broth.png",
	stack_max = 5,
})

minetest.register_craftitem("potions:solvent", {
	description = "Solvent",
	inventory_image = "potions_healing_broth.png",
	stack_max = 5,
})

--[[
minetest.register_craft({
	output = "potions:solvent 3",
	recipe = {
		{"flowers:mushroom_red", "dye:red", "default:apple"}, 
		{"", "bucket:bucket_water", ""},
		{"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})
]]


minetest.register_craftitem("potions:healing_broth", {
	description = "Healing Potion Broth",
	inventory_image = "potions_healing_broth.png",
	stack_max = 5,
})

minetest.register_craftitem("potions:healing", {
	description = "Healing Potion",
	inventory_image = "potions_healing.png",
	stack_max = 5,
	on_use = function(itemstack, user, pointed_thing)
		user:set_hp(2*10)
	
		itemstack:take_item(1)
		
		local inv = user:get_inventory()
		inv:add_item("main", "vessels:glass_bottle 1")
		
		return itemstack
	end,
})

minetest.register_craft( {
	type = "cooking",
	cooktime = 90,
	output = "potions:healing",
	recipe = "potions:healing_broth",
})

minetest.register_craft({
	output = "potions:healing_broth 3",
	recipe = {
		{"flowers:mushroom_red", "dye:red", "default:apple"}, 
		{"", "bucket:bucket_water", ""},
		{"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})



-- -----------------------------------






minetest.register_craftitem("potions:speed_broth", {
	description = "Speed Potion Broth",
	inventory_image = "potions_speed_broth.png",
	stack_max = 5,
})

minetest.register_craftitem("potions:speed", {
	description = "Speed Potion",
	inventory_image = "potions_speed.png",
	stack_max = 5,
	on_use = function(itemstack, user, pointed_thing)
		user:set_physics_override({
			speed = 3.0,
		})
		
		minetest.after(10, function()
			user:set_physics_override({
				speed = 1.0,
			})
		end)
	
		itemstack:take_item(1)
		
		local inv = user:get_inventory()
		inv:add_item("main", "vessels:glass_bottle 1")
		
		return itemstack
	end,
})

minetest.register_craft( {
	type = "cooking",
	cooktime = 90,
	output = "potions:speed",
	recipe = "potions:speed_broth",
})

minetest.register_craft({
	output = "potions:speed_broth 3",
	recipe = {
		{"default:mese_crystal_fragment", "dye:yellow", "default:mese_crystal_fragment"}, 
		{"", "bucket:bucket_water", ""},
		{"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})



----------------------------------------------------


minetest.register_craftitem("potions:lowgrav_broth", {
	description = "Low Gravity Potion Broth",
	inventory_image = "potions_lowgrav_broth.png",
	stack_max = 5,
})

minetest.register_craftitem("potions:lowgrav", {
	description = "Low Gravity Potion",
	inventory_image = "potions_lowgrav.png",
	stack_max = 5,
	on_use = function(itemstack, user, pointed_thing)
		user:set_physics_override({
			gravity = .1,
		})
		
		minetest.after(10, function()
			user:set_physics_override({
				gravity = .5,
			})
		end)		
		
		minetest.after(12, function()
			user:set_physics_override({
				gravity = .75,
			})
		end)
		minetest.after(14, function()
			user:set_physics_override({
				gravity = 1.0,
			})
		end)
	
		itemstack:take_item(1)
		
		local inv = user:get_inventory()
		inv:add_item("main", "vessels:glass_bottle 1")
		
		return itemstack
	end,
})

minetest.register_craft( {
	type = "cooking",
	cooktime = 90,
	output = "potions:lowgrav",
	recipe = "potions:lowgrav_broth",
})

minetest.register_craft({
	output = "potions:lowgrav_broth 3",
	recipe = {
		{"flowers:dandelion_white", "dye:white", "flowers:dandelion_white"}, 
		{"", "bucket:bucket_water", ""},
		{"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})





----------------------------------------------------


minetest.register_craftitem("potions:teleport_broth", {
	description = "Teleportation Potion Broth",
	inventory_image = "potions_teleport_broth.png",
	stack_max = 3,
})

minetest.register_craftitem("potions:teleport", {
	description = "Teleportation Potion",
	inventory_image = "potions_teleport.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		return {name="potions:teleport_recall", count=1, wear=0, metadata=minetest.serialize(user:getpos())}
	end,
})

minetest.register_craftitem("potions:teleport_recall", {
	description = "Teleportation Recall Potion",
	inventory_image = "potions_teleport_recall.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	
		local item = itemstack:take_item(1)
		
		local pos = minetest.deserialize(item:get_metadata())
		
		if pos ~= nil then
			user:setpos(pos)
		end
		
		return "vessels:glass_bottle 1"
	end,
})

minetest.register_craft( {
	type = "cooking",
	cooktime = 90,
	output = "potions:teleport",
	recipe = "potions:teleport_broth",
})

minetest.register_craft({
	output = "potions:teleport_broth 3",
	recipe = {
		{"default:obsidian_shard", "dye:violet", "default:obsidian_shard"}, 
		{"", "bucket:bucket_water", ""},
		{"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})





-----------------------------------------------



minetest.register_craftitem("potions:flight_broth", {
	description = "Flight Potion Broth",
	inventory_image = "potions_flight_broth.png",
	stack_max = 5,
})

minetest.register_craftitem("potions:flight", {
	description = "Flight Potion",
	inventory_image = "potions_flight.png",
	stack_max = 5,
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		local privs = minetest.get_player_privs(name)
	
		privs.fly = true
		minetest.set_player_privs(name, privs)
		
		minetest.after(10, function()
			local privs = minetest.get_player_privs(name)
			privs.fly = nil
			minetest.set_player_privs(name, privs)
			
			user:set_physics_override({
				gravity = .5,
			})
		end)		
		
		minetest.after(14, function()
			user:set_physics_override({
				gravity = .75,
			})
		end)
		minetest.after(18, function()
			user:set_physics_override({
				gravity = 1.0,
			})
		end)
	
		itemstack:take_item(1)
		
		local inv = user:get_inventory()
		inv:add_item("main", "vessels:glass_bottle 1")
		
		return itemstack
	end,
})

minetest.register_craft( {
	type = "cooking",
	cooktime = 90,
	output = "potions:flight",
	recipe = "potions:flight_broth",
})

minetest.register_craft({
	output = "potions:flight_broth 3",
	recipe = {
		{"farming:cotton", "dye:cyan", "farming:cotton"}, 
		{"", "bucket:bucket_water", ""},
		{"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})


