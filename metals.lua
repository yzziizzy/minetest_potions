



-- returns true if the item needs to be registered
local function check_aliases(item, aliases)
	local missing = true
	
	for _,a in ipairs(aliases) do
		if minetest.registered_items[a] then
			missing = false
			minetest.register_alias(item, a)
		end
	end
	
	return missing
end


-- zinc 

if check_aliases("potions:zinc_ingot", {"default:zinc_ingot"}) then
	minetest.register_craftitem("potions:zinc_ingot", {
		description = "Zinc Ingot",
		inventory_image = "default_steel_ingot.png^[colorize:blue:30",
	})
end

if check_aliases("potions:sphalerite_lump", {"default:zinc_lump"}) then
	minetest.register_craftitem("potions:sphalerite_lump", {
		description = "Sphalerite Lump",
		inventory_image = "potions_sphalerite_lump.png",
	})
end


if check_aliases("potions:sphalerite_ore", {"default:zinc_ore"}) then
	minetest.register_node("potions:sphalerite_ore", {
		description = "Sphalerite Ore",
		tiles = {"default_stone.png^potions_sphalerite_ore.png"},
		drop = "potions:sphalerite_lump",
		groups = {cracky = 3},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_craft({
		output = "potions:zinc_ingot",
		type = "cooking",
		recipe = "potions:sphalerite_lump",
	})
end



-- brass

if check_aliases("potions:brass_ingot", {"default:brass_ingot"}) then
	minetest.register_craftitem("potions:brass_ingot", {
		description = "Brass Ingot",
		inventory_image = "default_gold_ingot.png^[colorize:white:50",
	})
	
	minetest.register_craft({
		output = "potions:brass_ingot 3",
		type = "shapeless",
		recipe = {
			"potions:zinc_ingot",
			"default:copper_ingot",
			"default:copper_ingot",
		},
	})
end


-- lead

if check_aliases("potions:lead_ingot", {"default:lead_ingot"}) then
	minetest.register_craftitem("potions:lead_ingot", {
		description = "Lead Ingot",
		inventory_image = "default_steel_ingot.png^[colorize:black:30",
	})
end

if check_aliases("potions:lead_lump", {"default:lead_lump"}) then
	minetest.register_craftitem("potions:lead_lump", {
		description = "lead Lump",
		inventory_image = "default_steel_lump^[colorize:black:30",
	})
end

if check_aliases("potions:lead_block", {"default:leadblock"}) then
	minetest.register_craftitem("potions:lead_block", {
		description = "Lead Block",
		inventory_image = "default_steelblock.png^[colorize:black:30",
	})
	
	minetest.register_craft({
		output = "potions:lead_block 1",
		type = "shapeless",
		recipe = {
			"potions:lead_ingot", "potions:lead_ingot", "potions:lead_ingot",
			"potions:lead_ingot", "potions:lead_ingot", "potions:lead_ingot",
			"potions:lead_ingot", "potions:lead_ingot", "potions:lead_ingot",
		},
	})
end


if check_aliases("potions:galena", {"default:lead_ore"}) then
	minetest.register_node("potions:galena", {
		description = "Lead Ore",
		tiles = {"default_stone.png^potions_galena_ore.png"},
		drop = "potions:galena_lump",
		-- TODO: drop silver sometimes
		groups = {cracky = 3},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_craft({
		output = "potions:lead_ingot",
		type = "cooking",
		recipe = "potions:galena_lump",
	})
end



-- mercury

minetest.register_craftitem("potions:mercury_vial", {
	description = "Quicksilver Vial",
	inventory_image = "potions_mercury_vial.png",
	groups = {vessel = 1},
})

minetest.register_craftitem("potions:mercury_flask", {
	description = "Quicksilver Flask",
	inventory_image = "potions_mercury_flask.png",
	groups = {vessel = 1},
})

minetest.register_craftitem("potions:mercury_bottle", {
	description = "Quicksilver Bottle",
	inventory_image = "potions_mercury_bottle.png",
	groups = {vessel = 1},
})

minetest.register_craft({
	output = "potions:mercury_flask",
	type = "shapeless",
	recipe = {
		"potions:mercury_vial", "potions:mercury_vial", "potions:mercury_vial",
		"potions:mercury_vial", "potions:mercury_vial", "potions:mercury_vial",
		"potions:mercury_vial", "potions:mercury_vial", "potions:mercury_vial",
	},
})

minetest.register_craft({
	output = "potions:mercury_bottle",
	type = "shapeless",
	recipe = {
		"potions:mercury_flask", "potions:mercury_flask", "potions:mercury_flask",
		"potions:mercury_flask", "potions:mercury_flask", "potions:mercury_flask",
		"potions:mercury_flask", "potions:mercury_flask", "potions:mercury_flask",
	},
})

minetest.register_craft({
	output = "potions:mercury_flask 9",
	type = "shapeless",
	recipe = {"potions:mercury_bottle"},
})

minetest.register_craft({
	output = "potions:mercury_vial 9",
	type = "shapeless",
	recipe = {"potions:mercury_flask"},
})

-- mercury ore

minetest.register_craftitem("potions:cinnabar_lump", {
	description = "Cinnabar",
	inventory_image = "potions_cinnabar_lump.png",
})

minetest.register_node("potions:cinnabar_ore", {
	description = "Cinnabar Ore",
	tiles = {"default_sandstone.png^potions_cinnabar_ore.png"},
	drop = "potions:cinnabar_lump",
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

-- mercury can't be cooked, it has to be distilled












minetest.register_ore({
	ore_type        = "blob",
	ore             = "potions:sphalerite_ore",
	wherein         = {"default:desert_sandstone"},
	clust_scarcity  = 16 * 16 * 16,
	clust_size      = 5,
	y_max           = 82,
	y_min           = 25,
	noise_threshold = -0.0,
	noise_params    = {
		offset = 0.5,
		scale = 0.2,
		spread = {x = 5, y = 5, z = 5},
		seed = 5776,
		octaves = 1,
		persist = 0.0
	},
	biomes = {"desert"},
})

minetest.register_ore({
	ore_type        = "blob",
	ore             = "potions:cinnabar_ore",
	wherein         = {"default:sandstone"},
	clust_scarcity  = 16 * 16 * 16,
	clust_size      = 5,
	y_max           = 82,
	y_min           = 30,
	noise_threshold = -0.0,
	noise_params    = {
		offset = 0.5,
		scale = 0.2,
		spread = {x = 5, y = 5, z = 5},
		seed = 2467,
		octaves = 1,
		persist = 0.0
	},
	biomes = {"sandstone_desert"},
})




minetest.register_ore({
	ore_type        = "scatter",
	ore             = "potions:galena",
	wherein         = {"default:silver_sandstone"},
	clust_scarcity  = 16 * 16 * 16,
	clust_num_ores  = 12,
	clust_size      = 5,
	y_max           = 62,
	y_min           = 15,
	noise_threshold = 0.0,
	noise_params    = {
		offset = 0.5,
		scale = 0.2,
		spread = {x = 5, y = 5, z = 5},
		seed = 27636,
		octaves = 1,
		persist = 0.0
	},
	biomes = {"cold_desert"},
})
