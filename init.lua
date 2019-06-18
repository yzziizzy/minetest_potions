
potions = {
	geodes = {},
}

local potions_players = {}


local modpath = minetest.get_modpath("potions")

-- Add everything:
local modname = "potions"


dofile(modpath.."/geodes.lua")
dofile(modpath.."/alchemy.lua")





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


--[[
fermentation, distillation, soaking/boiling pot

ink, black/gold/silver/red
ethanol, methanol
ammonia
saltpeter, halite, iron(II) sulfate aka green vitriol (melanterite), soda nitre, pot ash
pyrite
sulfur, iodine

extra metals:
silver, lead, platinum, rhodium, arsenic, bismuth, mercury, iridium, osmium

gems:
emerald, ruby, lapis lazuli, opal, sapphire, citrine, aquamarine, amethyst





magic beanstalk
arcing bridge



mana
]]


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


