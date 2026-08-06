-- cottages/src/nodes_hay.lua
-- contains hay_mat, hay and hay bale
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

core.override_item("default:dirt_with_grass", {
    after_dig_node = function(pos, _, _, digger)
        if not digger or not digger:is_player() then
            return
        end
        local wielded = digger:get_wielded_item()
        if wielded:get_name() ~= "cottages:pitchfork" then
            return
        end

        local pos_above = { x = pos.x, y = pos.y + 1, z = pos.z }
        local pname = digger:get_player_name()
        if core.is_protected(pos_above, pname) then
            -- This is not a violation, but an action impossible to be carried out
            return
        end

        local node_above = core.get_node_or_nil(pos_above)
        if not node_above or node_above.name ~= "air" then
            return nil
        end
        core.swap_node(pos, { name = "default:dirt" })
        core.add_node(pos_above, { name = "cottages:hay_mat", param2 = math.random(2, 25) })
        -- start a node timer so that the hay will decay after some time
        local timer = core.get_node_timer(pos_above)
        if not timer:is_started() then
            timer:start(math.random(60, 300))
        end
        -- TODO: prevent dirt from beeing multiplied this way (that is: give no dirt!)
        return
    end,
})

core.register_node("cottages:hay_mat", {
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "leveled",
    description = S("Hay mat"),
    tiles = { "cottages_darkage_straw.png^[multiply:#88BB88" },
    groups = { hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_leaves_defaults(),
    -- the bale is slightly smaller than a full node
    is_ground_content = false,
    sunlight_propagates = true,
    node_box = {
        type = "leveled",
        fixed = {
            { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
        }
    },
    -- make sure a placed hay block looks halfway reasonable
    after_place_node = function(pos)
        core.swap_node(pos, { name = "cottages:hay_mat", param2 = math.random(2, 25) })
    end,
    on_timer = function(pos)
        local node = core.get_node(pos)
        if node and node.name == "cottages:hay_mat" then
            core.remove_node(pos)
            core.check_for_falling(pos)
        end
    end,
})

core.register_node("cottages:hay", {
    description = S("Hay"),
    tiles = { "cottages_darkage_straw.png^[multiply:#88BB88" },
    groups = { hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_leaves_defaults(),
    is_ground_content = false,
})

local bale_box = {
    type = "fixed",
    fixed = {
        { -0.45, -0.5, -0.45, 0.45, 0.45, 0.45 },
    }
}
core.register_node("cottages:hay_bale", {
    drawtype = "nodebox",
    description = S("Hay bale"),
    tiles = { "cottages_darkage_straw_bale.png^[multiply:#88BB88" },
    paramtype = "light",
    sunlight_propagates = true,
    groups = { hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_leaves_defaults(),
    node_box = bale_box,
    selection_box = bale_box,
    is_ground_content = false,
})

--
-- craft recipes
--
core.register_craft({
    output = "cottages:hay_mat 9",
    recipe = {
        { "cottages:hay" },
    },
})

core.register_craft({
    output = "cottages:hay",
    recipe = {
        { "cottages:hay_mat", "cottages:hay_mat", "cottages:hay_mat" },
        { "cottages:hay_mat", "cottages:hay_mat", "cottages:hay_mat" },
        { "cottages:hay_mat", "cottages:hay_mat", "cottages:hay_mat" },
    },
})

core.register_craft({
    output = "cottages:hay",
    recipe = { { "cottages:hay_bale" } },
})

core.register_craft({
    output = "cottages:hay_bale",
    recipe = { { "cottages:hay" } },
})
