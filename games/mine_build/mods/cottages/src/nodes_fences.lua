-- cottages/src/nodes_fences.lua
-- Fences
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

local small_box = {
    type = "fixed",
    fixed = {
        { -0.45, -0.35, 0.46, 0.45,  -0.20, 0.50 },
        { -0.45, 0.00,  0.46, 0.45,  0.15,  0.50 },
        { -0.45, 0.35,  0.46, 0.45,  0.50,  0.50 },

        { -0.50, -0.50, 0.46, -0.45, 0.50,  0.50 },
        { 0.45,  -0.50, 0.46, 0.50,  0.50,  0.50 },
    },
}
core.register_node("cottages:fence_small", {
    description = S("Small fence"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = small_box,
    selection_box = small_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})

local half_box = {
    type = "fixed",
    fixed = {
        { -0.45, -0.35, 0.46, 0.45,  -0.20, 0.50 },
        { -0.45, 0.00,  0.46, 0.45,  0.15,  0.50 },

        { -0.50, -0.50, 0.46, -0.45, 0.15,  0.50 },
        { 0.45,  -0.50, 0.46, 0.50,  0.15,  0.50 },
    },
}
core.register_node("cottages:fence_half_small", {
    description = S("Half fence"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = half_box,
    selection_box = half_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})


local corner_box = {
    type = "fixed",
    fixed = {
        { -0.45, -0.35, 0.46,  0.45,  -0.20, 0.50 },
        { -0.45, 0.00,  0.46,  0.45,  0.15,  0.50 },
        { -0.45, 0.35,  0.46,  0.45,  0.50,  0.50 },

        { -0.50, -0.50, 0.46,  -0.45, 0.50,  0.50 },
        { 0.45,  -0.50, 0.46,  0.50,  0.50,  0.50 },

        { 0.46,  -0.35, -0.45, 0.50,  -0.20, 0.45 },
        { 0.46,  0.00,  -0.45, 0.50,  0.15,  0.45 },
        { 0.46,  0.35,  -0.45, 0.50,  0.50,  0.45 },

        { 0.46,  -0.50, -0.50, 0.50,  0.50,  -0.45 },
        { 0.46,  -0.50, 0.45,  0.50,  0.50,  0.50 },
    },
}
core.register_node("cottages:fence_corner", {
    description = S("Small fence (corner)"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = corner_box,
    selection_box = corner_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})

local half_corner_box = {
    type = "fixed",
    fixed = {
        { -0.45, -0.35, 0.46,  0.45,  -0.20, 0.50 },
        { -0.45, 0.00,  0.46,  0.45,  0.15,  0.50 },

        { -0.50, -0.50, 0.46,  -0.45, 0.15,  0.50 },
        { 0.45,  -0.50, 0.46,  0.50,  0.15,  0.50 },

        { 0.46,  -0.35, -0.45, 0.50,  -0.20, 0.45 },
        { 0.46,  0.00,  -0.45, 0.50,  0.15,  0.45 },

        { 0.46,  -0.50, -0.50, 0.50,  0.15,  -0.45 },
        { 0.46,  -0.50, 0.45,  0.50,  0.15,  0.50 },
    },
}
core.register_node("cottages:fence_half_corner", {
    description = S("Half fence (corner)"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = half_corner_box,
    selection_box = half_corner_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})


local end_box = {
    type = "fixed",
    fixed = {
        { -0.45, -0.35, 0.46,  0.45,  -0.20, 0.50 },
        { -0.45, 0.00,  0.46,  0.45,  0.15,  0.50 },
        { -0.45, 0.35,  0.46,  0.45,  0.50,  0.50 },

        { -0.50, -0.50, 0.46,  -0.45, 0.50,  0.50 },
        { 0.45,  -0.50, 0.46,  0.50,  0.50,  0.50 },

        { 0.46,  -0.35, -0.45, 0.50,  -0.20, 0.45 },
        { 0.46,  0.00,  -0.45, 0.50,  0.15,  0.45 },
        { 0.46,  0.35,  -0.45, 0.50,  0.50,  0.45 },

        { 0.46,  -0.50, -0.50, 0.50,  0.50,  -0.45 },
        { 0.46,  -0.50, 0.45,  0.50,  0.50,  0.50 },

        { -0.50, -0.35, -0.45, -0.46, -0.20, 0.45 },
        { -0.50, 0.00,  -0.45, -0.46, 0.15,  0.45 },
        { -0.50, 0.35,  -0.45, -0.46, 0.50,  0.45 },

        { -0.50, -0.50, -0.50, -0.46, 0.50,  -0.45 },
        { -0.50, -0.50, 0.45,  -0.46, 0.50,  0.50 },
    },
}
core.register_node("cottages:fence_end", {
    description = S("Small fence (end)"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = end_box,
    selection_box = end_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})

local half_end_box = {
    type = "fixed",
    fixed = {
        { -0.45, -0.35, 0.46,  0.45,  -0.20, 0.50 },
        { -0.45, 0.00,  0.46,  0.45,  0.15,  0.50 },

        { -0.50, -0.50, 0.46,  -0.45, 0.15,  0.50 },
        { 0.45,  -0.50, 0.46,  0.50,  0.15,  0.50 },

        { 0.46,  -0.35, -0.45, 0.50,  -0.20, 0.45 },
        { 0.46,  0.00,  -0.45, 0.50,  0.15,  0.45 },

        { 0.46,  -0.50, -0.50, 0.50,  0.15,  -0.45 },
        { 0.46,  -0.50, 0.45,  0.50,  0.150, 0.50 },

        { -0.50, -0.35, -0.45, -0.46, -0.20, 0.45 },
        { -0.50, 0.00,  -0.45, -0.46, 0.15,  0.45 },

        { -0.50, -0.50, -0.50, -0.46, 0.15,  -0.45 },
        { -0.50, -0.50, 0.45,  -0.46, 0.15,  0.50 },
    },
}
core.register_node("cottages:fence_half_end", {
    description = S("Half fence (end)"),
    drawtype = "nodebox",
    -- top, bottom, side1, side2, inner, outer
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = half_end_box,
    selection_box = half_end_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})

local double_box = {
    type = "fixed",
    fixed = {
        { 0.46,  -0.35, -0.45, 0.50,  -0.20, 0.45 },
        { 0.46,  0.00,  -0.45, 0.50,  0.15,  0.45 },
        { 0.46,  0.35,  -0.45, 0.50,  0.50,  0.45 },

        { 0.46,  -0.50, -0.50, 0.50,  0.50,  -0.45 },
        { 0.46,  -0.50, 0.45,  0.50,  0.50,  0.50 },

        { -0.50, -0.35, -0.45, -0.46, -0.20, 0.45 },
        { -0.50, 0.00,  -0.45, -0.46, 0.15,  0.45 },
        { -0.50, 0.35,  -0.45, -0.46, 0.50,  0.45 },

        { -0.50, -0.50, -0.50, -0.46, 0.50,  -0.45 },
        { -0.50, -0.50, 0.45,  -0.46, 0.50,  0.50 },
    },
}
core.register_node("cottages:fence_double", {
    description = S("Small fence (double)"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = double_box,
    selection_box = double_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})

local half_double_box = {
    type = "fixed",
    fixed = {
        { 0.46,  -0.35, -0.45, 0.50,  -0.20, 0.45 },
        { 0.46,  0.00,  -0.45, 0.50,  0.15,  0.45 },

        { 0.46,  -0.50, -0.50, 0.50,  0.15,  -0.45 },
        { 0.46,  -0.50, 0.45,  0.50,  0.15,  0.50 },

        { -0.50, -0.35, -0.45, -0.46, -0.20, 0.45 },
        { -0.50, 0.00,  -0.45, -0.46, 0.15,  0.45 },

        { -0.50, -0.50, -0.50, -0.46, 0.15,  -0.45 },
        { -0.50, -0.50, 0.45,  -0.46, 0.15,  0.50 },
    },
}
core.register_node("cottages:fence_half_double", {
    description = S("Half fence (double)"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    node_box = half_double_box,
    selection_box = half_double_box,
    is_ground_content = false,
    sounds = default.node_sound_wood_defaults(),
})

core.register_craft({
    output = "cottages:fence_small 3",
    recipe = {
        { "group:fence", "group:fence" },
    }
})

-- xfences can be configured to replace normal fences - which makes them uncraftable
if core.get_modpath("xfences") ~= nil then
    core.register_craft({
        output = "cottages:fence_small 3",
        recipe = {
            { "xfences:fence", "xfences:fence" },
        }
    })
end

core.register_craft({
    output = "cottages:fence_corner",
    recipe = {
        { "cottages:fence_small", "cottages:fence_small" },
    }
})

core.register_craft({
    output = "cottages:fence_small 2",
    recipe = {
        { "cottages:fence_corner" },
    }
})

core.register_craft({
    output = "cottages:fence_end",
    recipe = {
        { "",                     "cottages:fence_small", "" },
        { "cottages:fence_small", "",                     "cottages:fence_small" },
    }
})

core.register_craft({
    output = "cottages:fence_small 3",
    recipe = {
        { "cottages:fence_end" },
    }
})

core.register_craft({
    output = "cottages:fence_double",
    recipe = {
        { "cottages:fence_small", "", "cottages:fence_small" },
    }
})

core.register_craft({
    output = "cottages:fence_small 2",
    recipe = {
        { "cottages:fence_double" },
    }
})

for _, variant in ipairs({ "small", "corner", "end", "double" }) do
    core.register_craft({
        output = "cottages:fence_half_" .. variant .. " 6",
        recipe = {
            { "cottages:fence_" .. variant, "cottages:fence_" .. variant, "cottages:fence_" .. variant },
        }
    })

    core.register_craft({
        type = "shapeless",
        output = "cottages:fence_" .. variant,
        recipe = {
            "cottages:fence_half_" .. variant,
            "cottages:fence_half_" .. variant,
        }
    })
end
