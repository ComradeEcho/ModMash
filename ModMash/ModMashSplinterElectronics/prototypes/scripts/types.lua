﻿local ends_with = modmashsplinterelectronics.util.ends_with
local starts_with = modmashsplinterelectronics.util.starts_with
local get_item = modmashsplinterelectronics.util.get_item
local get_name_for = modmashsplinterelectronics.util.get_name_for
local ensure_ingredient_format = modmashsplinterelectronics.util.ensure_ingredient_format
local get_standard_results = modmashsplinterelectronics.util.get_standard_results
local get_normal_results = modmashsplinterelectronics.util.get_normal_results
local create_layered_icon_using =	modmashsplinterelectronics.util.create_layered_icon_using
local table_contains = modmashsplinterelectronics.util.table.contains

local icon_pin_topleft = modmashsplinterelectronics.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterelectronics.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterelectronics.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterelectronics.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterelectronics.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterelectronics.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterelectronics.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterelectronics.util.defines.icon_pin_left

local local_update_tech = function(old_recipe,new_recipe)
		log("checking for "..old_recipe)
		for name, value in pairs(data.raw.technology) do			
			if value.effects ~= nil then				
				for k =1, #value.effects do
					if value.effects[k] ~= nil then
						if value.effects[k].type == "unlock-recipe" and value.effects[k].recipe == old_recipe then
							log("found "..name)
							table.insert(data.raw["technology"][name].effects,{type = "unlock-recipe",recipe = new_recipe})
							return
						end		
					end
				end
			end
		end
	end

local local_flatten_duplicates = function(ingredients)	
	if ingredients == nil then return nil end
	local map = {}
	local flat = {}
	for k = 1, #ingredients do local i=ingredients[k]
		if i ~= nil then
			if map[i.name] == nil then
				map[i.name] = {type=i.type, name=i.name, amount=i.amount}
			else 
				map[i.name].amount = map[i.name].amount+i.amount
			end
		end
	end
	for name, value in pairs(map) do	
		table.insert(flat,value)
	end
	return flat
end

local local_update_recipe = function(recipe)	
	if recipe == nil then return nil end

	if recipe.ingredients == nil then return nil end
	if #recipe.ingredients > 3 then return nil end
	local foundcircuit = false
	for k = 1, #recipe.ingredients do
		local ingredient = ensure_ingredient_format(recipe.ingredients[k])
		if ingredient ~= nil then
			if ingredient.name == "blank-circuit" then return nil end
			if ingredient.name == "gold-cable" then return nil end
			if ingredient.name == "gold-plate" then return nil end
			if ingredient.name == "glass" then return nil end
			if ingredient.name == "electronic-circuit" then
				ingredient.name = "blank-circuit"
				ingredient.amount = math.ceil((ingredient.amount * 1.75))
				foundcircuit = true
			end
			if ingredient.name == "advanced-circuit" then
				ingredient.name = "blank-circuit"
				ingredient.amount = math.ceil((ingredient.amount * 4.5))
				foundcircuit = true
			end
		end
		recipe.ingredients[k] = ingredient		
	end
	if foundcircuit == false then return nil end
	return local_flatten_duplicates(recipe.ingredients)
end

local local_update_ai_recipe = function(recipe)	
	if recipe == nil then return nil end

	if recipe.ingredients == nil then return nil end
	local foundcircuit = false
	for k = 1, #recipe.ingredients do
		local ingredient = ensure_ingredient_format(recipe.ingredients[k])
		if ingredient ~= nil then
			if ingredient.name == "advanced-circuit" then
				ingredient.name = "ai-circuit"
				ingredient.amount = math.ceil((ingredient.amount * 1.75))
				foundcircuit = true
			end
		end
		recipe.ingredients[k] = ingredient		
	end
	if foundcircuit == false then return nil end
	return local_flatten_duplicates(recipe.ingredients)
end

local local_update_result = function(recipe)
	local name = nil
	
	if recipe.result ~= nil then
		name = recipe.result
		--recipe.result_count = (recipe.result_count or 1ensure_ingredient_format2
		local n = recipe.result
		local c = recipe.result_count or 1
		recipe.main_product = n
		recipe.result = nil
		recipe.result_count = nil
		recipe.results = {{name=n,amount=c},{name = "faulty-circuit",amount = 1, probability = 0.05}}
		return n
	end
	if recipe.results ~= nil then
		for k=1, #recipe.results do
			local result = ensure_ingredient_format(recipe.results[k])			
			--[[if result ~= nil then
				if result.type == nil or result.type ~= "fluid" then
					result.amount = result.amount * 2
				end
			end]]
			recipe.results[k] = result
		end
		table.insert(recipe.results,{name = "faulty-circuit",amount = 1, probability = 0.05})
		
		if name ~= nil then 
			recipe.main_product = name
			return name
		end 
		if #recipe.results > 0 then
			recipe.main_product = recipe.results[1].name 
			return recipe.results[1].name 
		end
	end
	return nil
end

local local_update_ai_result = function(recipe)
	local name = nil
	
	if recipe.result ~= nil then
		name = recipe.result
		recipe.result_count = (recipe.result_count or 1)*2
		return recipe.result
	end
	if recipe.results ~= nil then
		for k=1, #recipe.results do
			local result = ensure_ingredient_format(recipe.results[k])
			if result ~= nil then
				if result.type == nil or result.type ~= "fluid" then
					result.amount = result.amount * 2
				end
			end
			recipe.results[k] = result
		end
		if name ~= nil then return name end 
		if #recipe.results > 0 then return recipe.results[1].name end
	end
	return nil
end

local half_icon = function(initial_icons)
	if initial_icons == nil or type(initial_icons) ~= "table" or #initial_icons == 0 then 
		return initial_icons 
	end
	local icons = {}
	for k = 1, #initial_icons do local icon = initial_icons[k]
		if icon ~= nil then
			local current_icon = {}
			current_icon.icon = icon.icon
			current_icon.icon_size = icon.icon_size
			current_icon.icon_mipmaps = icon.icon_mipmaps
			current_icon.tint = icon.tint
			if icon.scale  ~= nil then
				current_icon.scale  = icon.scale *0.5
			else
				current_icon.scale = 0.5
			end
			if icon.shift~= nil then
				current_icon.shift = {icon.shift[1]*0.5, icon.shift[2]*0.5}
			end

			table.insert(icons,current_icon)
		end
	end
	return icons
end

local local_circuit_recipe = function(recipe)
	if recipe == nil then return nil end
	local name = nil
	local standard_ingredients = local_update_recipe(recipe)
	local normal_ingredients = local_update_recipe(recipe.normal)
	local expensive_ingredients = local_update_recipe(recipe.expensive)
	if standard_ingredients == nil and normal_ingredients == nil and expensive_ingredients == nil then return nil end
	if standard_ingredients ~= nil then 
		recipe.ingredients = standard_ingredients 
	end
	if normal_ingredients ~= nil then 
		recipe.normal.ingredients = normal_ingredients 
		name = local_update_result(recipe.normal)
	end
	if expensive_ingredients ~= nil then 
		recipe.expensive.ingredients = expensive_ingredients 
		if name == nil then
			name = local_update_result(recipe.expensive)
		else
			local_update_result(recipe.expensive)
		end
	end
	if name == nil then
		name = local_update_result(recipe)
	else
		local_update_result(recipe)
	end

	if name == nil then return nil end
	local item = get_item(name)
	if item == nil then return nil end
	if item.stackable == false or item.name == "warptorio-armor" or ends_with(item.name,"beltbox") or ends_with(item.name,"transport-belt-loader") then
		return nil
	end
	if item.subgroup == "raw-resource" then return nil end
	if item.stack_size == 1 then return nil end
	if item.flags ~= nil then
		for k=1, #item.flags do
			if item.flags[k] == "hidden" or item.flags[k] ==  "not-stackable" then return nil end
		end
	end

	local rname = recipe.name	 
	if item.icon_size ~= nil and (type(item.icon_size) ~= "number" or item.icon_size > 64) then return nil end
	if item.icons ~= nil then
		for k=1, #item.icons do
			if item.icons[k].icon_size ~= nil and (type(item.icons[k].icon_size) ~= "number" or item.icons[k].icon_size > 64)  then return nil end
		end
	end

	recipe.localised_name = item.localised_name
	recipe.localised_description = item.localised_description
	recipe.name = recipe.name.."-with-blank-circuit"
	recipe.icon = false
	recipe.icons = half_icon(create_layered_icon_using(
	{
		{
			from = item,
		},
		{
	
			from = data.raw["item"]["blank-circuit"],
			scale = 0.45,
			pin = icon_pin_bottomright		
		}
	}))
	recipe.allow_as_intermediate = false
    recipe.allow_decomposition = false	
	return recipe
end

local local_circuit_ai_recipe = function(recipe)
	if recipe == nil then return nil end
	local name = nil
	local standard_ingredients = local_update_ai_recipe(recipe)
	local normal_ingredients = local_update_ai_recipe(recipe.normal)
	local expensive_ingredients = local_update_ai_recipe(recipe.expensive)
	if standard_ingredients == nil and normal_ingredients == nil and expensive_ingredients == nil then return nil end
	if standard_ingredients ~= nil then 
		recipe.ingredients = standard_ingredients 
	end
	if normal_ingredients ~= nil then 
		recipe.normal.ingredients = normal_ingredients 
		name = local_update_ai_result(recipe.normal)
	end
	if expensive_ingredients ~= nil then 
		recipe.expensive.ingredients = expensive_ingredients 
		if name == nil then
			name = local_update_ai_result(recipe.expensive)
		else
			local_update_ai_result(recipe.expensive)
		end
	end
	if name == nil then
		name = local_update_ai_result(recipe)
	else
		local_update_ai_result(recipe)
	end

	if name == nil then return nil end
	local item = get_item(name)
	if item == nil then return nil end
	if item.stackable == false or item.name == "warptorio-armor" or ends_with(item.name,"beltbox") or ends_with(item.name,"transport-belt-loader") then
		return nil
	end
	if item.type ~= "module" then return nil end 
	if item.subgroup == "raw-resource" then return nil end
	if item.stack_size == 1 then return nil end
	if item.flags ~= nil then
		for k=1, #item.flags do
			if item.flags[k] == "hidden" or item.flags[k] ==  "not-stackable" then return nil end
		end
	end

	local rname = recipe.name	 
	if item.icon_size ~= nil and (type(item.icon_size) ~= "number" or item.icon_size > 64) then return nil end
	if item.icons ~= nil then
		for k=1, #item.icons do
			if item.icons[k].icon_size ~= nil and (type(item.icons[k].icon_size) ~= "number" or item.icons[k].icon_size > 64)  then return nil end
		end
	end

	recipe.localised_name = item.localised_name
	recipe.localised_description = item.localised_description
	recipe.name = recipe.name.."-with-ai-circuit"
	recipe.icon = false
	recipe.icons = half_icon(create_layered_icon_using(
	{
		{
			from = item,
		},
		{
	
			from = data.raw["item"]["ai-circuit"],
			scale = 0.45,
			pin = icon_pin_bottomright		
		}
	}))
	recipe.allow_as_intermediate = false
    recipe.allow_decomposition = false	
	return recipe
end

local local_create_circuit_recipies = function()
	local recipies = {}
	for name, recipe in pairs(data.raw.recipe) do
		recipies[#recipies+1] = table.deepcopy(recipe)
	end
	for k=1, #recipies do local recipe = recipies[k];			
	    if recipe.hidden or recipe.hide_from_player_crafting 
			or starts_with(recipe.name,"creative-mod") 
			or ends_with(recipe.name,"combinator") 
			or starts_with(recipe.name,"deadlock-stack") then
			-- do nothing
		else
			local name = recipe.name
			local new_recipe = local_circuit_recipe(recipe)
			if new_recipe ~= nil then
				data:extend({new_recipe}) 
				--log(serpent.block(new_recipe))
				local_update_tech(name,new_recipe.name)
			end
		end
	end	
end

local local_create_ai_circuit_recipies = function()
	local recipies = {}
	for name, recipe in pairs(data.raw.recipe) do
		recipies[#recipies+1] = table.deepcopy(recipe)
	end
	for k=1, #recipies do local recipe = recipies[k];			
	    if recipe.hidden or recipe.hide_from_player_crafting 
			or starts_with(recipe.name,"creative-mod") 
			or ends_with(recipe.name,"combinator") 
			or starts_with(recipe.name,"deadlock-stack") then
			-- do nothing
		else
			local name = recipe.name
			local new_recipe = local_circuit_ai_recipe(recipe)
			if new_recipe ~= nil then
				data:extend({new_recipe}) 
				--log(serpent.block(new_recipe))
				local_update_tech(name,new_recipe.name)
			end
		end
	end	
end

local local_add_module_limits = function()
	for name, module in pairs(data.raw["module"]) do
		if module ~= nil and module.limitation ~= nil then
			if table_contains(module.limitation,"ai-circuit") == false then table.insert(module.limitation,"ai-circuit") end
			if table_contains(module.limitation,"blank-circuit") == false then table.insert(module.limitation,"blank-circuit") end
		end
	end
end

if data ~= nil and data_final_fixes == true then
	local_create_circuit_recipies()
	local_create_ai_circuit_recipies()
	local_add_module_limits()
end


