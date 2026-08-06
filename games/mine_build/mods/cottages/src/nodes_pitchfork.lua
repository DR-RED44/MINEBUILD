-- cottages/src/nodes_pitchfork.lua
-- dig dirt with grass to get hay, place with right-click
-- Hay is implemented in cottages/src/node_hay.lua
--[[
    Copyright (C) 2015-2022  Sokomine
	Copyright (C) 2024  1F616EMO

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local S = cottages.S

-- the straw node from default and similar nodes can be digged with the pitchfork as well
local add_hay_group = { "farming:straw", "dryplants:reed", "darkage:straw_bale" }
for _, name in ipairs(add_hay_group) do
	if core.registered_items[name] then
		local new_groups = table.copy(core.registered_items[name].groups)
		new_groups.hay = 3
		core.override_item(name, { groups = new_groups })
	end
end

-- creates hay when digging dirt_with_grass (thanks to the override above);
-- useful for digging hay and straw
-- can be placed as a node
core.register_tool("cottages:pitchfork", {
	short_description = S("Pitchfork"),
	description = S("Pitchfork") .. "\n" .. S("Dig dirt with grass to get hay, place with right-click"),
	inventory_image = "cottages_pitchfork.png",
	wield_image = "cottages_pitchfork.png^[transformFYR180",
	wield_scale = { x = 1.5, y = 1.5, z = 0.5 },
	stack_max = 1,
	liquids_pointable = false,
	-- very useful for digging hay, straw and bales of those materials
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			fleshy = { times = { [2] = 0.80, [3] = 0.40 }, maxlevel = 1, uses = 1 / 0.002 },
			snappy = { times = { [2] = 0.80, [3] = 0.40 }, maxlevel = 1, uses = 1 / 0.002 },
			hay    = { times = { [2] = 0.10, [3] = 0.10 }, maxlevel = 1, uses = 1 / 0.002 },
		},
		damage_groups = { fleshy = 5 }, -- slightly stronger than a stone sword
	},
	sound = { breaks = "default_tool_breaks" },
	-- place the pitchfork somewhere
	on_place = function(itemstack, placer, pointed_thing)
		if placer == nil or pointed_thing == nil or pointed_thing.type ~= "node" then
			return nil
		end
		local pos  = core.get_pointed_thing_position(pointed_thing, true)
		local node = core.get_node_or_nil(pos)
		if node == nil or node.name ~= "air" then
			return nil
		end
		if core.is_protected(pos, placer:get_player_name()) then
			return nil
		end
		core.rotate_and_place(ItemStack("cottages:pitchfork_placed"), placer, pointed_thing)
		-- did the placing succeed? (Check code by Smacker)
		if not core.find_nodes_in_area(
				{ x = pos.x, y = pos.y - 1, z = pos.z },
				{ x = pos.x, y = pos.y + 1, z = pos.z },
				{ "cottages:pitchfork_placed" })[1] then
			return nil
		end
		local meta = core.get_meta(pos)
		meta:set_int("wear", itemstack:get_wear())
		meta:set_string("infotext", S("pitchfork (for hay and straw)"))
		-- the tool has been placed; consume it
		return ItemStack("")
	end,
	node_placement_prediction = "cottages:pitchfork_placed",
})

-- a ptichfork placed somewhere
core.register_node("cottages:pitchfork_placed", {
	tiles = { "default_wood.png^[transformR90" },
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = { snappy = 2, dig_immediate = 3, falling_node = 1, attached_node = 1, not_in_creative_inventory = 1 },
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			-- handle (goes a bit into the ground)
			{ -(1 / 32), -(11 / 16), -(1 / 32), (1 / 32),  16 / 16,   (1 / 32) },
			-- middle connection
			{ -(7 / 32), -(4 / 16),  -(1 / 32), (7 / 32),  -(2 / 16), (1 / 32) },
			-- thongs
			{ -(7 / 32), -(11 / 16), -(1 / 32), -(5 / 32), -(4 / 16), (1 / 32) },
			{ (5 / 32),  -(11 / 16), -(1 / 32), (7 / 32),  -(4 / 16), (1 / 32) },
		},
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.3, -0.5, -0.1, 0.3, 1.0, 0.1 }
	},
	drop = "cottages:pitchfork",
	-- perserve wear
	preserve_metadata = function(_, _, oldmeta, drops)
		if oldmeta["wear"] then
			-- the first drop is the pitchfork
			drops[1]:set_wear(oldmeta["wear"])
		end
	end,
})

--
-- craft recipes
--
core.register_craft({
	output = 'cottages:pitchfork',
	recipe = {
		{ 'default:stick', 'default:stick', 'default:stick' },
		{ '',              'default:stick', '' },
		{ '',              'default:stick', '' },
	}
})
