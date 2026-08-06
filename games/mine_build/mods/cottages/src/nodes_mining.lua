-- cottages/src/nodes_mining.lua
-- Blocks for mines
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

---------------------------------------------------------------------------------------
-- a rope that is of use to the mines
---------------------------------------------------------------------------------------
-- the rope can only be digged if there is no further rope above it; (configuratble)
-- Note: This rope also counts as a rail node; thus, carts can move through it

local rope_dig_without_support = core.settings:get_bool("cottages.rope_dig_without_support", false)
core.register_node("cottages:rope", {
    description = S("Rope for climbing"),
    tiles = { "cottages_rope.png" },
    groups = { snappy = 3, choppy = 3, oddly_breakable_by_hand = 3, rail = 1, connect_to_raillike = 1 },
    walkable = false,
    climbable = true,
    paramtype = "light",
    sunlight_propagates = true,
    drawtype = "plantlike",
    is_ground_content = false,
    selection_box = {
        type = "fixed",
        fixed = { -0.2, -0.5, -0.2, 0.2, 0.5, 0.2 }
    },
    can_dig = rope_dig_without_support and function(pos, player)
        local below = core.get_node({ x = pos.x, y = pos.y - 1, z = pos.z })
        if below.name == "cottages:rope" then
            if player and player:is_player() then
                core.chat_send_player(player:get_player_name(),
                    S('The entire rope would be too heavy. Start digging at its lowest end!'))
            end
            return false
        end
        return true
    end or nil,
    sounds = default.node_sound_leaves_defaults(),
})

core.register_craft({
    output = "cottages:rope",
    recipe = {
        { "farming:cotton" },
        { "farming:cotton" },
        { "farming:cotton" }
    }
})

-- Note: This rope also counts as a rail node; thus, carts can move through it
core.register_node("cottages:ladder_with_rope_and_rail", {
    description = S("Ladder with rail support"),
    drawtype = "signlike",
    tiles = { "default_ladder_wood.png^carts_rail_straight.png^cottages_rope.png" },
    inventory_image = "default_ladder_wood.png^carts_rail_straight.png^cottages_rope.png",
    wield_image = "default_ladder_wood.png^carts_rail_straight.png^cottages_rope.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    walkable = false,
    climbable = true,
    is_ground_content = false,
    selection_box = {
        type = "wallmounted",
    },
    groups = { choppy = 2, oddly_breakable_by_hand = 3, rail = 1, connect_to_raillike = 1 },
    legacy_wallmounted = true,
    sounds = default.node_sound_wood_defaults(),
})



core.register_craft({
    output = "cottages:ladder_with_rope_and_rail 3",
    recipe = {
        { "default:ladder", "cottages:rope", "default:rail" }
    }
})
