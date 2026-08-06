-- cottages/src/nodes_doorlike.lua
-- Doors and gates
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

-- Window Shutters

local function shutter_post_operate(pos, param2, old, new)
    for _, i in ipairs({ 1, 2, 3 }) do
        local targ_pos = vector.add(pos, { x = 0, y = i, z = 0 })
        local targ_node = core.get_node(targ_pos)
        if targ_node.name ~= old or targ_node.param2 ~= param2 then
            break
        end
        targ_node.name = new
        core.swap_node(targ_pos, targ_node)
    end

    for _, i in ipairs({ -1, -2, -3 }) do
        local targ_pos = vector.add(pos, { x = 0, y = i, z = 0 })
        local targ_node = core.get_node(targ_pos)
        if targ_node.name ~= old or targ_node.param2 ~= param2 then
            break
        end
        targ_node.name = new
        core.swap_node(targ_pos, targ_node)
    end
end

core.register_node("cottages:window_shutter_open", {
    description = S("Window shutters"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	sounds = default.node_sound_wood_defaults(),
    -- larger than one node but slightly smaller than a half node so that wallmounted torches pose no problem
    node_box = {
        type = "fixed",
        fixed = {
            { -0.90, -0.5, 0.4, -0.45, 0.5, 0.5 },
            { 0.45,  -0.5, 0.4, 0.9,   0.5, 0.5 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.9, -0.5, 0.4, 0.9, 0.5, 0.5 },
        },
    },
    on_rightclick = function(pos, node)
        node.name = "cottages:window_shutter_closed"
        core.swap_node(pos, node)
        shutter_post_operate(pos, node.param2, "cottages:window_shutter_open", "cottages:window_shutter_closed");
    end,
    is_ground_content = false,
})

core.register_node("cottages:window_shutter_closed", {
    description = S("Window shutters"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1 },
	sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, 0.4, -0.05, 0.5, 0.5 },
            { 0.05, -0.5, 0.4, 0.5,   0.5, 0.5 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, 0.4, 0.5, 0.5, 0.5 },
        },
    },
    on_rightclick = function(pos, node)
        node.name = "cottages:window_shutter_open"
        core.swap_node(pos, node)
        shutter_post_operate(pos, node.param2, "cottages:window_shutter_closed", "cottages:window_shutter_open");
    end,
    is_ground_content = false,
    drop = "cottages:window_shutter_open",
})

core.register_node("cottages:half_door", {
    description = S("Half Door"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, 0.4, 0.48, 0.5, 0.5 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, 0.4, 0.48, 0.5, 0.5 },
        },
    },
    on_rightclick = function(pos, node)
        local new_node = table.copy(node)
        local param2 = node.param2 % 4;
        if param2 == 1 then
            new_node.param2 = node.param2 + 1; --2;
        elseif param2 == 2 then
            new_node.param2 = node.param2 - 1; --1;
        elseif param2 == 3 then
            new_node.param2 = node.param2 - 3; --0;
        elseif param2 == 0 then
            new_node.param2 = node.param2 + 3; --3;
        end;
        core.swap_node(pos, new_node)

        -- if the node above consists of a door of the same type, open it as well
        -- Note: doors beneath this one are not opened!
        -- It is a special feature of these doors that they can be opend partly
        local pos2 = vector.add(pos, { x = 0, y = 1, z = 0 })
        local node2 = core.get_node(pos2)
        if node2.name == node.name and node2.param2 == node.param2 then
            core.swap_node(pos2, new_node)
        end
    end,
    is_ground_content = false,
})


core.register_node("cottages:half_door_inverted", {
    description = S("Half Door (Inverted)"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.5, 0.48, 0.5, -0.4 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.5, 0.48, 0.5, -0.4 },
        },
    },
    on_rightclick = function(pos, node)
        local new_node = table.copy(node)
        local param2 = node.param2 % 4;
        if param2 == 1 then
            new_node.param2 = node.param2 - 1; --0;
        elseif param2 == 0 then
            new_node.param2 = node.param2 + 1; --1;
        elseif param2 == 2 then
            new_node.param2 = node.param2 + 1; --3;
        elseif param2 == 3 then
            new_node.param2 = node.param2 - 1; --2;
        end;
        core.swap_node(pos, new_node)

        -- if the node above consists of a door of the same type, open it as well
        -- Note: doors beneath this one are not opened!
        -- It is a special feature of these doors that they can be opend partly
        local pos2 = vector.add(pos, { x = 0, y = 1, z = 0 })
        local node2 = core.get_node(pos2)
        if node2.name == node.name and node2.param2 == node.param2 then
            core.swap_node(pos2, new_node)
        end
    end,
    is_ground_content = false,
})

core.register_node("cottages:gate_closed", {
    description = S("Fence Gate"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.85, -0.25, -0.02, 0.85,  -0.05, 0.02 },
            { -0.85, 0.15,  -0.02, 0.85,  0.35,  0.02 },

            { -0.80, -0.05, -0.02, -0.60, 0.15,  0.02 },
            { 0.60,  -0.05, -0.02, 0.80,  0.15,  0.02 },
            { -0.15, -0.05, -0.02, 0.15,  0.15,  0.02 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.85, -0.25, -0.1, 0.85, 0.35, 0.1 },
        },
    },
    on_rightclick = function(pos, node)
        node.name = "cottages:gate_open"
        core.swap_node(pos, node)
    end,
    is_ground_content = false,
})

core.register_node("cottages:gate_open", {
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1 },
	sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.85, -0.5, -0.25, 0.85,  -0.46, -0.05 },
            { -0.85, -0.5, 0.15,  0.85,  -0.46, 0.35 },

            { -0.80, -0.5, -0.05, -0.60, -0.46, 0.15 },
            { 0.60,  -0.5, -0.05, 0.80,  -0.46, 0.15 },
            { -0.15, -0.5, -0.05, 0.15,  -0.46, 0.15 },

        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.85, -0.5, -0.25, 0.85, -0.3, 0.35 },
        },
    },
    on_rightclick = function(pos, node)
        node.name = "cottages:gate_closed"
        core.swap_node(pos, node)
    end,
    is_ground_content = false,
    drop = "cottages:gate_closed",
})

local new_facedirs = { 10, 19, 4, 13, 2, 18, 22, 14, 20, 16, 0, 12, 11, 3, 7, 21, 9, 23, 5, 1, 8, 15, 6, 17 }
cottages.register_hatch = function(nodename, description, texture, receipe_item, sounds)
    core.register_node(nodename, {
        description = description, -- not that there are any other...
        drawtype = "nodebox",
        -- top, bottom, side1, side2, inner, outer
        tiles = { texture },
        paramtype = "light",
        paramtype2 = "facedir",
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
        sounds = sounds,

        node_box = {
            type = "fixed",
            fixed = {
                { -0.49,  -0.55,  -0.49,  -0.3,   -0.45,  0.45 },
                -- {-0.5, -0.55, 0.3, 0.3, -0.45, 0.5},
                { 0.3,    -0.55,  -0.3,   0.49,   -0.45,  0.45 },
                { 0.49,   -0.55,  -0.49,  -0.3,   -0.45,  -0.3 },
                { -0.075, -0.55,  -0.3,   0.075,  -0.45,  0.3 },
                { -0.3,   -0.55,  -0.075, -0.075, -0.45,  0.075 },
                { 0.075,  -0.55,  -0.075, 0.3,    -0.45,  0.075 },

                { -0.3,   -0.55,  0.3,    0.3,    -0.45,  0.45 },

                -- hinges
                { -0.45,  -0.530, 0.45,   -0.15,  -0.470, 0.525 },
                { 0.15,   -0.530, 0.45,   0.45,   -0.470, 0.525 },

                -- handle
                { -0.05,  -0.60,  -0.35,  0.05,   -0.40,  -0.45 },
            },
        },
        selection_box = {
            type = "fixed",
            fixed = { -0.5, -0.55, -0.5, 0.5, -0.45, 0.5 },
        },
        on_rightclick = function(pos, node)
            node.param2 = new_facedirs[node.param2 + 1] or 0
            core.swap_node(pos, node)
        end,
        is_ground_content = false,
        on_place = core.rotate_node,
    })

    core.register_craft({
        output = nodename,
        recipe = {
            { '',           '',              receipe_item },
            { receipe_item, "default:stick", '' },
            { '',           '',              '' },
        }
    })
end

cottages.register_hatch(
    'cottages:hatch_wood', S("Wooden Hatch"),
    'cottages_minimal_wood.png', "stairs:slab_wood",
    default.node_sound_wood_defaults())
cottages.register_hatch(
    'cottages:hatch_steel', S("Metal Hatch"),
    'cottages_steel_block.png', "default:steel_ingot",
    default.node_sound_metal_defaults())


core.register_craft({
    output = "cottages:window_shutter_open",
    recipe = {
        { "group:wood", "", "group:wood" },
    }
})

-- transform one half door into another
core.register_craft({
    output = "cottages:half_door",
    recipe = {
        { "cottages:half_door_inverted" },
    }
})

core.register_craft({
    output = "cottages:half_door_inverted",
    recipe = {
        { "cottages:half_door" },
    }
})

core.register_craft({
    output = "cottages:half_door 2",
    recipe = {
        { "", "group:wood",      "" },
        { "", "doors:door_wood", "" },
    }
})


-- transform open and closed versions into into another for convenience
core.register_craft({
    output = "cottages:gate_closed",
    recipe = {
        { "cottages:gate_open" },
    }
})

core.register_craft({
    output = "cottages:gate_open",
    recipe = {
        { "cottages:gate_closed" },
    }
})

core.register_craft({
    output = "cottages:gate_closed",
    recipe = {
        { "default:stick", "default:stick", "group:wood" },
    }
})
