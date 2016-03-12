

local modpath = minetest.get_modpath("potions")

-- Add everything:
local modname = "potions"


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
	stack_max = 1,
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


