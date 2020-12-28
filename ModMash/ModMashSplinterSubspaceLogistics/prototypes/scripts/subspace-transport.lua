﻿require("prototypes.scripts.defines")
	
--[[create local references]]
--[[util]]
local is_valid = modmashsplintersubspacelogistics.util.is_valid
local is_valid_and_persistant = modmashsplintersubspacelogistics.util.entity.is_valid_and_persistant
local table_index_of = modmashsplintersubspacelogistics.util.table.index_of
local table_remove = modmashsplintersubspacelogistics.util.table.remove
local table_contains = modmashsplintersubspacelogistics.util.table.contains
local starts_with  = modmashsplintersubspacelogistics.util.starts_with
local get_entities_to  = modmashsplintersubspacelogistics.util.entity.get_entities_to
local change_fluidbox_fluid = modmashsplintersubspacelogistics.util.fluid.change_fluidbox_fluid
local get_connected_input_fluid = modmashsplintersubspacelogistics.util.fluid.get_connected_input_fluid
local opposite_direction = modmashsplintersubspacelogistics.util.opposite_direction


--[[unitialized globals]]
local transports = nil
local boilers = nil

local transports_per_tick = 2
local stock_transports_per_tick = 1



--[[ensure globals]]
local local_init = function() 
	if global.modmashsplintersubspacelogistics.boilers == nil then global.modmashsplintersubspacelogistics.boilers = {} end
	if global.modmashsplintersubspacelogistics.subspace_transports == nil then global.modmashsplintersubspacelogistics.subspace_transports = {} end
	transports = global.modmashsplintersubspacelogistics.subspace_transports
	boilers = global.modmashsplintersubspacelogistics.boilers
	end
local local_load = function() 
	transports = global.modmashsplintersubspacelogistics.subspace_transports
	boilers = global.modmashsplintersubspacelogistics.boilers
	end


local local_subspace_transports_share = function(name,stock,entity)
	for index=1, #transports do local transport = transports[index]
		if transport ~= entity and is_valid_and_persistant(transport) and transport.energy > 0 then
			local inventory = transport.get_inventory(defines.inventory.lab_input)
			if inventory == nil then return stock end
			if inventory.get_item_count(name) < stock and inventory.can_insert({name=name,count=1}) then
				inventory.insert({name=name,count=1})
				stock = stock -1;
				global.modmashsplintersubspacelogistics.stock_transports = global.modmashsplintersubspacelogistics.stock_transports + 1
			end
			if stock == 0 or global.modmashsplintersubspacelogistics.stock_transports >= stock_transports_per_tick then return stock end
		end
	end
	return stock
end

local local_subspace_transports_process = function(entity)	
	local inventory = entity.get_inventory(defines.inventory.lab_input)
	if inventory == nil then return end
	local contents = inventory.get_contents()			
	for name, count in pairs(contents) do
		
		local stock = inventory.remove({name=name,count=count})		
		local balance = count-stock		
		balance = balance + local_subspace_transports_share(name,stock,entity)
		if balance>0 then inventory.insert({name=name,count=balance}) end
	end
end

local local_subspace_transports_tick = function()	
	global.modmashsplintersubspacelogistics.stock_transports = 0
	local index = global.modmashsplintersubspacelogistics.transports_update_index
	if not index then index = 1 end
	local numiter = 0
	local updates = math.min(#transports,transports_per_tick)
	for k=index, #transports do local transport = transports[k]
		if is_valid_and_persistant(transport) and transport.energy > 0 then
			local_subspace_transports_process(transport)
		end
		if k >= #transports then k = 1 end
		numiter = numiter + 1
		if numiter >= updates or global.modmashsplintersubspacelogistics.stock_transports >= stock_transports_per_tick then 
			global.modmashsplintersubspacelogistics.transports_update_index	= k
			return
		end
	end
end

local local_tick = function()	
	for k=1, #boilers  do
		local entity = boilers[k]
		if is_valid(entity) and entity.to_be_deconstructed(entity.force) ~= true and entity.is_crafting() then							
			local outpipe = get_connected_input_fluid(entity,2)
			if outpipe ~= nil then
				if entity.fluidbox[2] ~= nil then
					local t = entity.fluidbox[2]
					t.temperature = 400
					entity.fluidbox[2] = t
				end
				local t = outpipe.entity.fluidbox[outpipe.box]
				if t ~= nil then 
					t.temperature = 400
					outpipe.entity.fluidbox[outpipe.box] = t
				end
			end
		end
	end	
	if game.tick%30==0 then
		local_subspace_transports_tick()
	end
	end

local local_added = function(entity)	
	if entity.name == "modmash-super-boiler-valve" then
		table.insert(boilers, entity)
	elseif entity.name == "subspace-transport" then
		table.insert(transports, entity)
	end
end

local local_remove = function(tbl, element)
	for k = 1, #tbl do
		if tbl[k] == element then 
			table.remove(tbl,k)
			return
		end
	end
end

local local_removed = function(entity)	
	if entity.name == "modmash-super-boiler-valve" then
		local_remove(boilers, entity)
	elseif entity.name == "subspace-transport" then
		local_remove(transports, entity)		
	end
end

--[[local local_on_entity_cloned = function(event)
	if is_valid(event.source) then
		if event.source.name == subspace_transport then 		
			table_remove(transports, event.source)	
			table.insert(transports, event.destination)	
		end
	end
end


script.on_event(defines.events.on_entity_cloned,
	function(event) 
		if is_valid(event.source) then local_on_entity_cloned(event.source, nil) end 
	end,{filter = "name", name = "subspace-transport"})]]

script.on_event(defines.events.on_tick, local_tick)

script.on_init(local_init)
script.on_load(local_load)
script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_removed(event.entity,event) end 
	end)

script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_removed(event.entity,event) end 
	end)

script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_removed(event.entity,event) end 
	end)


script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_added(event.entity,event) end 
	end)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_added(event.created_entity,event) end 
	end)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_added(event.created_entity,event) end 
	end)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_added(event.entity,event) end 
	end)