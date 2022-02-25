﻿local patch_technology  = modmashsplinterlogistics.util.tech.patch_technology
local starts_with  = modmashsplinterlogistics.util.starts_with

local local_create_belt_animation_set = function(name)
	local belt_animation_set = 
	{
		animation_set =
		{			
			filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name ..".png",
			priority = "extra-high",
			width = 64,
			height = 64,
			frame_count = 16,
			direction_count = 20,
			hr_version =
			{
				filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. ".png",
				priority = "extra-high",
				width = 128,
				height = 128,
				scale = 0.5,
				frame_count = 16,
				direction_count = 20
			}			
		},
  
		east_index = 1,
		west_index = 2,
		north_index = 3,
		south_index = 4,
  
		east_to_north_index = 5,
		north_to_east_index = 6,
  
		west_to_north_index = 7,
		north_to_west_index = 8,
  
		south_to_east_index = 9,
		east_to_south_index = 10,
  
		south_to_west_index = 11,
		west_to_south_index = 12,
 
		starting_south_index = 13,
		ending_south_index = 14,
  
		starting_west_index = 15,
		ending_west_index = 16,
  
		starting_north_index = 17,
		ending_north_index = 18,
  
		starting_east_index = 19,
		ending_east_index = 20,
	}	
	return belt_animation_set end

local local_create_mini_loader = function(name,max_health,filter_count,localised_name,localised_description,speed,belt_animation_set,order,ingredients,ingredients_expensive, healing_per_tick,technology,next_upgrade,category)
	local icon = "__modmashsplinterlogistics__/graphics/icons/" .. name .. "-structure.png"
	local entity = {
		type = "loader-1x1",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   
		flags = {"placeable-neutral", "player-creation", "fast-replaceable-no-build-while-moving"},
		minable = {mining_time = 0.1, result = name},
		max_health = max_health,
		filter_count = filter_count,
		healing_per_tick = healing_per_tick,
		corpse = "small-remnants",
		resistances =
		{
		  {
			type = "fire",
			percent = 60
		  }
		},
		collision_box =  {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.75, -0.75}, {0.75, 0.75}},
		animation_speed_coefficient = 32,
		belt_animation_set = belt_animation_set,
		fast_replaceable_group = "transport-belt",
		speed = speed,
		belt_distance = 0.1,
		container_distance = 1,
		structure_render_layer = "lower-object",
		structure =
		{
		  direction_in =
		  {
			sheet =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/loader/".. name .. "-structure.png",
			  priority = "extra-high",
			  width    = 53,
			  height   = 43,
			  shift = {0.15625, 0.0703125},
			  y = 43,
			  hr_version =
				{
				  filename = "__modmashsplinterlogistics__/graphics/entity/loader/hr-" .. name .. "-structure.png",
				  priority = "extra-high",
				  shift = {0.15625, 0.0703125},
				  width = 106,
				  height = 85,
				  y = 85,
				  scale = 0.5
				}
			}
		  },
		  direction_out =
		  {
			sheet =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/loader/".. name .. "-structure.png",
			  priority = "extra-high",
			  width    = 53,
			  height   = 43,
			  shift = {0.15625, 0.0703125},
			  priority = "extra-high",
			  hr_version =
				{
				  filename = "__modmashsplinterlogistics__/graphics/entity/loader/hr-" .. name .. "-structure.png",
				  priority = "extra-high",
				  shift = {0.15625, 0.0703125},				  
				  width = 106,
				  height = 85,
				  scale = 0.5
				}
			}
		  }
		}}
	local item = {
		type = "item",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   
		subgroup = "belt",		    
		order = "d[mini-loader]-".. order .. "[" .. name .. "]",
		place_result = name,
		stack_size = 50}
	local recipe = {
      type = "recipe",
      name = name,
	  localised_name = localised_name,
	  localised_description = localised_description,
      normal =
		{
			enabled = false,
			ingredients = ingredients,
			result = name
		},
		expensive = 
		{
			enabled = false,
			ingredients = ingredients_expensive,
			result = name,
		}
	 }
	if category ~= nil then recipe.category = category end
	data:extend({item})
	data:extend({entity})
	data:extend({recipe})	
	patch_technology(technology,name)
end

local local_create_splitter = function(name,max_health,localised_name,localised_description,next_upgrade,speed,belt_animation_set,order,ingredients,ingredients_expensive, healing_per_tick,technology)
	local icon = "__modmashsplinterlogistics__/graphics/icons/" .. name .. ".png"
	local entity = {
		type = "splitter",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = name},
		max_health = max_health,
		healing_per_tick = healing_per_tick,
		corpse = "medium-remnants",
		resistances =
		{
		  {
			type = "fire",
			percent = 60
		  }
		},
		collision_box = {{-0.9, -0.4}, {0.9, 0.4}},
		selection_box = {{-1.2, -0.8}, {1.2, 0.8}},
		animation_speed_coefficient = 32,
		structure_animation_speed_coefficient = 0.7,
		structure_animation_movement_cooldown = 10,
		fast_replaceable_group = "transport-belt",
		next_upgrade = next_upgrade,
		speed = speed,
		belt_animation_set = belt_animation_set,
		structure =
		{
		  north =
		  {
			filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. "-north.png",
			frame_count = 32,
			line_length = 8,
			priority = "extra-high",
			width = 82,
			height = 36,
			shift = util.by_pixel(6, 0),
			hr_version =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. "-north.png",
			  frame_count = 32,
			  line_length = 8,
			  priority = "extra-high",
			  width = 160,
			  height = 70,
			  shift = util.by_pixel(7, 0),
			  scale = 0.5
			}
		  },
		  east =
		  {
			filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. "-east.png",
			frame_count = 32,
			line_length = 8,
			priority = "extra-high",
			width = 46,
			height = 80,
			shift = util.by_pixel(4, -6),
			hr_version =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. "-east.png",
			  frame_count = 32,
			  line_length = 8,
			  priority = "extra-high",
			  width = 90,
			  height = 160,
			  shift = util.by_pixel(4, -6),
			  scale = 0.5
			}
		  },
		  south =
		  {
			filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. "-south.png",
			frame_count = 32,
			line_length = 8,
			priority = "extra-high",
			width = 82,
			height = 32,
			shift = util.by_pixel(4, 0),
			hr_version =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. "-south.png",
			  frame_count = 32,
			  line_length = 8,
			  priority = "extra-high",
			  width = 164,
			  height = 64,
			  shift = util.by_pixel(4, 0),
			  scale = 0.5
			}
		  },
		  west =
		  {
			filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. "-west.png",
			frame_count = 32,
			line_length = 8,
			priority = "extra-high",
			width = 46,
			height = 76,
			shift = util.by_pixel(6, -4),
			hr_version =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. "-west.png",
			  frame_count = 32,
			  line_length = 8,
			  priority = "extra-high",
			  width = 90,
			  height = 150,
			  shift = util.by_pixel(6, -4),
			  scale = 0.5
			}
		  }
		}}
	local item = {
		type = "item",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   
		subgroup = "belt",
		order = "c[splitter]-".. order .. "[" .. name .. "]",
		place_result = name,
		stack_size = 50}
	local recipe = {
      type = "recipe",
      name = name,
	  localised_name = localised_name,
	  localised_description = localised_description,
      normal =
		{
			enabled = false,
			ingredients = ingredients,
			result = name
		},
		expensive = 
		{
			enabled = false,
			ingredients = ingredients_expensive,
			result = name,
		}
	}
	data:extend({item})
	data:extend({entity})
	data:extend({recipe})	
	patch_technology(technology,name)
end

local local_create_belt_underground = function(name,max_health,max_distance,speed,localised_name,localised_description,next_upgrade,belt_animation_set,order,ingredients,ingredients_expensive, healing_per_tick,technology)
	local icon = "__modmashsplinterlogistics__/graphics/icons/" .. name .. ".png"
	local entity = {
		type = "underground-belt",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = name},
		max_health = max_health,
		healing_per_tick = healing_per_tick,
		corpse = "small-remnants",
		max_distance = max_distance,
		underground_sprite =
		{
		  filename = "__core__/graphics/arrows/underground-lines.png",
		  priority = "high",
		  width = 64,
		  height = 64,
		  x = 64,
		  scale = 0.5
		},
		underground_remove_belts_sprite =
		{
		  filename = "__core__/graphics/arrows/underground-lines-remove.png",
		  priority = "high",
		  width = 64,
		  height = 64,
		  x = 64,
		  scale = 0.5
		},
		resistances =
		{
		  {
			type = "fire",
			percent = 60
		  },
		  {
			type = "impact",
			percent = 30
		  }
		},
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
		animation_speed_coefficient = 32,
		belt_animation_set = belt_animation_set,
		fast_replaceable_group = "transport-belt",
		next_upgrade = next_upgrade,
		speed = speed,
		structure =
		{
		  direction_in =
		  {
			sheet =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. ".png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  y = 96,
			  hr_version =
			  {
				filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. ".png",
				priority = "extra-high",
				width = 192,
				height =192,
				y = 192,
				scale = 0.5
			  }
			}
		  },
		  direction_out =
		  {
			sheet =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. ".png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  hr_version =
			  {
				filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. ".png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5
			  }
			}
		  },
		  direction_in_side_loading =
		  {
			sheet =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. ".png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  y = 96*3,
			  hr_version =
			  {
				filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. ".png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y = 192*3,
				scale = 0.5
			  }
			}
		  },
		  direction_out_side_loading =
		  {
			sheet =
			{
			  filename = "__modmashsplinterlogistics__/graphics/entity/logistics/" .. name .. ".png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  y = 96*2,
			  hr_version =
			  {
				filename = "__modmashsplinterlogistics__/graphics/entity/logistics/hr-" .. name .. ".png",
				priority = "extra-high",
				width = 192,
				height = 192,
				y= 192*2,
				scale = 0.5
			  },
			}
		  },
		  back_patch =
		  {
			sheet =
			{
			  filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-back-patch.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  hr_version =
			  {
				filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-back-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5
			  }
			}
		  },
		  front_patch =
		  {
			sheet =
			{
			  filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-front-patch.png",
			  priority = "extra-high",
			  width = 96,
			  height = 96,
			  hr_version =
			  {
				filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-front-patch.png",
				priority = "extra-high",
				width = 192,
				height = 192,
				scale = 0.5
			  }
			}
		  }
		}}
	local item =   {
		type = "item",
		name = name,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   	
		subgroup = "belt",
		order = "b[underground-belt]-" .. order .. "[" .. name .. "]",
		place_result = name,
		stack_size = 50}
	local recipe = {
		type = "recipe",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = ingredients,
			result = name,
			result_count = 2
		},
		expensive = 
		{
			enabled = false,
			ingredients = ingredients_expensive,
			result = name,
			result_count = 2
		}
	}
	data:extend({item})
	data:extend({entity})
	data:extend({recipe})	
	patch_technology(technology,name)
	end

local local_create_belt = function(name,max_health,speed,localised_name,localised_description,order,ingredients,ingredients_expensive, healing_per_tick,technology,next_upgrade,related_underground_belt)
	local icon = "__modmashsplinterlogistics__/graphics/icons/" .. name .. ".png"
	local entity = {
		type = "transport-belt",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 0.1, result = name},
		max_health = max_health,
		healing_per_tick = healing_per_tick,
		corpse = "small-remnants",
		resistances =
		{
			{
			type = "fire",
			percent = 90
			}
		},
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
		working_sound =
		{
			sound =
			{
			filename = "__base__/sound/transport-belt.ogg",
			volume = 0.4
			},
			persistent = true
		},
		animation_speed_coefficient = 32,
		belt_animation_set = local_create_belt_animation_set(name),
		fast_replaceable_group = "transport-belt",
		next_upgrade = next_upgrade,
		related_underground_belt = related_underground_belt,
		speed = speed,
		connector_frame_sprites = transport_belt_connector_frame_sprites,
		circuit_wire_connection_points = circuit_connector_definitions["belt"].points,
		circuit_connector_sprites = circuit_connector_definitions["belt"].sprites,
		circuit_wire_max_distance = transport_belt_circuit_wire_max_distance}
	local item =   {
		type = "item",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		icon = icon,
		icon_size = 64,
        icon_mipmaps = 4,   
		subgroup = "belt",
		order = "a[transport-belt]-" .. order .. "[" .. name .. "]",
		place_result = name,
		stack_size = 100}
	local recipe = {
		type = "recipe",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = ingredients,
			result = name
		},
		expensive = 
		{
			enabled = false,
			ingredients = ingredients_expensive,
			result = name
		}
    }
	data:extend({item})
	data:extend({entity})
	data:extend({recipe})	
	patch_technology(technology,name)
	end

local local_underground_belts = {
	{
		name = "high-speed-underground-belt-structure",
		localised_name = {"item-name.high-speed-underground-belt-structure"},
		localised_description = {"item-name.high-speed-underground-belt-structure"},
		max_health = 250,
		max_distance = 12,
		speed = 0.125,
		next_upgrade = "regenerative-underground-belt-structure",
		belt_animation_set = local_create_belt_animation_set("high-speed-transport-belt"),
		order = "d",
		technology = "logistics-4",
		healing_per_tick = 0.0,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"express-underground-belt", 2},
				{"titanium-plate", 3}
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"express-underground-belt", 2},
				{"titanium-plate", 7}
		}),
	},{
		name = "regenerative-underground-belt-structure",
		localised_name = {"item-name.regenerative-underground-belt-structure"},
		localised_description = {"item-name.regenerative-underground-belt-structure"},
		max_health = 300,
		max_distance = 16,
		speed = 0.1875,
		next_upgrade = nil,
		belt_animation_set = local_create_belt_animation_set("regenerative-transport-belt"),
		order = "e",
		technology = "logistics-5",
		healing_per_tick = modmashsplinterlogistics.util.defines.healing_per_tick,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{
				{"high-speed-underground-belt-structure", 1},
				{"alien-plate", 5},
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{
				{"high-speed-underground-belt-structure", 1},
				{"alien-plate", 8},
		}),
	}
}
local local_belts = {
	{
		name = "high-speed-transport-belt",		
		max_health = 250,
		speed = 0.125,		
		localised_name = {"item-name.high-speed-transport-belt"},		
		localised_description = {"item-name.high-speed-transport-belt"},
		order = "d",
		technology = "logistics-4",
		healing_per_tick = 0.0,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"express-transport-belt", 1},
				{"titanium-plate", 5}
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"express-transport-belt", 1},
				{"titanium-plate", 8}
		}),
		next_upgrade = "regenerative-transport-belt",
		related_underground_belt = "high-speed-underground-belt-structure"
	},{
		name = "regenerative-transport-belt",		
		max_health = 300,
		speed = 0.1875,		
		localised_name = {"item-name.regenerative-transport-belt"},		
		localised_description = {"item-name.regenerative-transport-belt"},
		order = "e",
		technology = "logistics-5",
		healing_per_tick = modmashsplinterlogistics.util.defines.healing_per_tick,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{
				{"high-speed-transport-belt", 1},
				{"alien-plate", 5},
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{
				{"high-speed-transport-belt", 1},
				{"alien-plate", 8},
		}),
		next_upgrade = nil,
		related_underground_belt = "regenerative-underground-belt-structure"
	}}

local local_splitters = {
	{
		name = "high-speed-splitter",		
		max_health = 250,
		speed = 0.125,		
		localised_name =  {"item-name.high-speed-splitter"},
		localised_description = {"item-name.high-speed-splitter"},
		belt_animation_set = local_create_belt_animation_set("high-speed-transport-belt"),
		order = "d",
		technology = "logistics-4",
		healing_per_tick = 0.0,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"express-splitter", 1},
				{"titanium-plate", 6},
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"express-splitter", 1},
				{"titanium-plate", 10},
		}),
		next_upgrade = "regenerative-splitter"
	},{
		name = "regenerative-splitter",		
		max_health = 300,
		speed = 0.1875,		
		localised_name = {"item-name.regenerative-splitter"},	
		localised_description = {"item-name.regenerative-splitter"},
		belt_animation_set = local_create_belt_animation_set("regenerative-transport-belt"),
		order = "e",
		technology = "logistics-5",
		healing_per_tick = modmashsplinterlogistics.util.defines.healing_per_tick,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{
				{"high-speed-splitter", 1},
				{"alien-plate", 6},
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{
				{"high-speed-splitter", 1},
				{"alien-plate", 10},
		}),
		next_upgrade = nil
	}}

local local_mini_loaders = {
	{
		name = "mini-loader",		
		max_health = 170,
		speed = 0.03125,		
		filter_count = 1,
		localised_name = {"item-name.mini-loader"},		
		localised_description = {"item-name.mini-loader"},
		belt_animation_set = basic_belt_animation_set,
		order = "a",
		technology = "logistics",
		healing_per_tick = 0.0,
		ingredients = {
				{"inserter", 4},
				{"iron-gear-wheel", 6},
				{"electronic-circuit", 2},
				{"transport-belt", 1},
		},
		ingredients_expensive = {
				{"inserter", 4},
				{"iron-gear-wheel", 12},
				{"electronic-circuit", 2},
				{"transport-belt", 1},
		},
		next_upgrade = "fast-mini-loader"
	},
	{		
		name = "fast-mini-loader",		
		max_health = 180,
		speed = 0.0625,		
		filter_count = 2,
		localised_name = {"item-name.fast-mini-loader"},		
		localised_description = {"item-name.fast-mini-loader"},
		belt_animation_set = fast_belt_animation_set,
		order = "b",
		technology = "logistics-2",
		healing_per_tick = 0.0,
		ingredients = {			
				{"mini-loader", 1},
				{"iron-gear-wheel", 4},
				{"electronic-circuit", 2},
		},
		ingredients_expensive = {			
				{"mini-loader", 1},
				{"iron-gear-wheel", 8},
				{"electronic-circuit", 2},
		},
		next_upgrade = "express-mini-loader"
	},
	{		
		name = "express-mini-loader",		
		max_health = 200,
		speed = 0.09375,		
		filter_count = 4,
		localised_name = {"item-name.express-mini-loader"},	
		localised_description = {"item-name.express-mini-loader"},	
		belt_animation_set = express_belt_animation_set,
		order = "c",
		technology = "logistics-3",
		healing_per_tick = 0.0,
		category = "crafting-with-fluid",
		ingredients = {			
				{"fast-mini-loader", 1},
				{"iron-gear-wheel", 4},
				{"electronic-circuit", 2},
				{type="fluid", name="lubricant", amount=20},
		},
		ingredients_expensive = {			
				{"fast-mini-loader", 1},
				{"iron-gear-wheel", 8},
				{"electronic-circuit", 2},
				{type="fluid", name="lubricant", amount=40},
		},
		next_upgrade = "high-speed-mini-loader"
	},
	{		
		name = "high-speed-mini-loader",		
		max_health = 220,
		speed = 0.125,		
		filter_count = 4,
		localised_name = {"item-name.high-speed-mini-loader"},		
		localised_description = {"item-name.high-speed-mini-loader"},
		belt_animation_set = local_create_belt_animation_set("high-speed-transport-belt"),
		order = "d",
		technology = "logistics-4",
		healing_per_tick = 0.0,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{			
				{"express-mini-loader", 1},
				{"electronic-circuit", 2},
				{"titanium-plate", 5},
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{			
				{"express-mini-loader", 1},
				{"electronic-circuit", 2},
				{"titanium-plate", 10},
		}),
		next_upgrade = "regenerative-mini-loader"
	},
	{		
		name = "regenerative-mini-loader",		
		max_health = 250,
		speed = 0.1875,		
		filter_count = 4,
		localised_name = {"item-name.regenerative-mini-loader"},		
		localised_description = {"item-name.regenerative-mini-loader"},
		belt_animation_set = local_create_belt_animation_set("regenerative-transport-belt"),
		order = "e",
		technology = "logistics-5",
		healing_per_tick = modmashsplinterlogistics.util.defines.healing_per_tick,
		ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{			
				{"high-speed-mini-loader", 1},
				{"electronic-circuit", 2},
				{"alien-plate", 5},
		}),
		ingredients_expensive = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{			
				{"high-speed-mini-loader", 1},
				{"electronic-circuit", 2},
				{"alien-plate", 10},
		}),
		next_upgrade = nil
	}
}

if data_final_fixes then
	data.raw["transport-belt"]["express-transport-belt"].next_upgrade = "high-speed-transport-belt"
	data.raw["underground-belt"]["express-underground-belt"].next_upgrade = "high-speed-underground-belt-structure"
	data.raw["splitter"]["express-splitter"].next_upgrade = "high-speed-splitter"

	if settings.startup["setting-mini-loaders"].value == "Enabled" then 
		data.raw["loader-1x1"]["mini-loader"].speed = data.raw["transport-belt"]["transport-belt"].speed
		data.raw["loader-1x1"]["fast-mini-loader"].speed = data.raw["transport-belt"]["fast-transport-belt"].speed
		data.raw["loader-1x1"]["express-mini-loader"].speed = data.raw["transport-belt"]["express-transport-belt"].speed

		local speeds = {}
		for name, ent in pairs(data.raw["transport-belt"]) do
			if starts_with(name,"regenerative") ~= true and starts_with(name,"high-speed")  ~= true then
				table.insert(speeds,ent.speed)
			end
		end 
		table.sort(speeds, function(a,b) return a < b end)

		if data.raw["loader-1x1"]["regenerative-mini-loader"].speed < speeds[#speeds] then
			log("Resetting belt speeds")		
			local rspeed = speeds[#speeds] * 1.05
			local items =math.ceil(rspeed*480)
			rspeed = items/480
			log("Regenerative ".. rspeed .. " " .. items)
			local fspeed = (speeds[#speeds]+rspeed)/2.0
			items =math.floor(fspeed*480)
			fspeed = items/480
			log("high-speed ".. fspeed .. " " .. items.. " base")

			data.raw["loader-1x1"]["regenerative-mini-loader"].speed = rspeed
			data.raw["loader-1x1"]["high-speed-mini-loader"].speed = fspeed

			--data.raw.loader["regenerative-loader"].speed = rspeed			
			--data.raw.loader["high-speed-loader"].speed = fspeed

			data.raw["underground-belt"]["high-speed-underground-belt-structure"].speed = rspeed
			data.raw["underground-belt"]["regenerative-underground-belt-structure"].speed = fspeed

			data.raw["transport-belt"]["regenerative-transport-belt"].speed = rspeed
			data.raw["transport-belt"]["high-speed-transport-belt"].speed = fspeed

			data.raw["splitter"]["regenerative-splitter"].speed = rspeed
			data.raw["splitter"]["high-speed-splitter"].speed = fspeed

		end
	end
else
	for index=1, #local_belts do local belt = local_belts[index]
		log("Creating Belt " .. belt.name)
		local_create_belt(belt.name,belt.max_health,belt.speed,belt.localised_name,belt.localised_description,belt.order,belt.ingredients,belt.ingredients_expensive, belt.healing_per_tick, belt.technology,belt.next_upgrade,belt.related_underground_belt)
	end
	for index=1, #local_underground_belts do local belt = local_underground_belts[index]
		log("Creating Underground Belt " .. belt.name)
		local_create_belt_underground(belt.name,belt.max_health,belt.max_distance,belt.speed,belt.localised_name,belt.localised_description,belt.next_upgrade,belt.belt_animation_set,belt.order,belt.ingredients,belt.ingredients_expensive, belt.healing_per_tick,belt.technology)
	end
	for index=1, #local_splitters do local splitter = local_splitters[index]
		log("Creating Splitter " .. splitter.name)
		local_create_splitter(splitter.name,splitter.max_health,splitter.localised_name,splitter.localised_description,splitter.next_upgrade,splitter.speed,splitter.belt_animation_set,splitter.order,splitter.ingredients,splitter.ingredients_expensive, splitter.healing_per_tick,splitter.technology)
	end
	if settings.startup["setting-mini-loaders"].value == "Enabled" then 
		for index=1, #local_mini_loaders do local loader = local_mini_loaders[index]
			log("Creating Loader " .. loader.name)		
			local_create_mini_loader(loader.name,loader.max_health,loader.filter_count,loader.localised_name,loader.localised_description,loader.speed,loader.belt_animation_set, loader.order,loader.ingredients,loader.ingredients_expensive, loader.healing_per_tick, loader.technology,loader.next_upgrade,loader.category)
		end
	end

	if deadlock_stacking then
		deadlock.add_tier({
			transport_belt      = "high-speed-transport-belt",
			colour              = {r=64, g=64, b=64},
			underground_belt    = "high-speed-underground-belt-structure",
			splitter            = "high-speed-splitter",
			technology          = "logistics-4",
			order               = "0",
			loader_ingredients  = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"express-mini-loader", 1},
				{"electronic-circuit", 2},
				{"titanium-plate", 5}
			}),
			beltbox_ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{"fast-inserter", 4},
				{"iron-gear-wheel", 6},
				{"titanium-plate", 2}
			}),
		})
		deadlock.add_tier({
			transport_belt      = "regenerative-transport-belt",
			colour              = {r=255, g=0, b=196},
			underground_belt    = "regenerative-underground-belt-structure",
			splitter            = "regenerative-splitter",
			technology          = "logistics-5",
			order               = "0",
			loader_ingredients  = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{				
				{"high-speed-mini-loader", 1},
				{"electronic-circuit", 2},
				{"alien-plate", 5},
			}),
			beltbox_ingredients = modmashsplinterlogistics.util.get_item_ingredient_substitutions({"alien-plate"},{
				{"fast-inserter", 8},
				{"electronic-circuit", 2},
				{"alien-plate", 5},
			}),
		})
	end
end