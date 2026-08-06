-- cottages/src/nodes_roof.lua
-- Handle roofs
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

cottages.register_roof = function(name, display_name, tiles, basic_material, homedecor_alternative, sounds)
    core.register_node("cottages:roof_" .. name, {
        description = S("@1 Roof", display_name),
        drawtype = "nodebox",
        tiles = tiles,
        paramtype = "light",
        paramtype2 = "facedir",
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
        node_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.5, 0,   0 },
                { -0.5, 0,    0,    0.5, 0.5, 0.5 },
            },
        },
        selection_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.5, 0,   0 },
                { -0.5, 0,    0,    0.5, 0.5, 0.5 },
            },
        },
        is_ground_content = false,
        sound = sounds,
    })

    -- a better roof than the normal stairs; this one is for usage directly on top of walls (it has the form of a stair)
    if name ~= "straw" or not core.registered_nodes["stairs:stair_straw"] then
        core.register_node("cottages:roof_connector_" .. name, {
            description = S("@1 Roof connector", display_name),
            drawtype = "nodebox",
            -- top, bottom, side1, side2, inner, outer
            tiles = tiles,
            paramtype = "light",
            paramtype2 = "facedir",
            groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
            node_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0,   0.5 },
                    { -0.5, 0,    0,    0.5, 0.5, 0.5 },
                },
            },
            selection_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0,   0.5 },
                    { -0.5, 0,    0,    0.5, 0.5, 0.5 },
                },
            },
            is_ground_content = false,
        })
    else
        core.register_alias("cottages:roof_connector_straw", "stairs:stair_straw")
    end

    -- this one is the slab version of the above roof
    if name ~= "straw" or not core.registered_nodes["stairs:slab_straw"] then
        core.register_node("cottages:roof_flat_" .. name, {
            description = S("@1 Roof (flat) ", display_name),
            drawtype = "nodebox",
            -- top, bottom, side1, side2, inner, outer
            -- this one is from all sides - except from the underside - of the given material
            tiles = { tiles[1], tiles[2], tiles[1], tiles[1], tiles[1], tiles[1] },
            paramtype = "light",
            paramtype2 = "facedir",
            groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
            node_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0, 0.5 },
                },
            },
            selection_box = {
                type = "fixed",
                fixed = {
                    { -0.5, -0.5, -0.5, 0.5, 0, 0.5 },
                },
            },
            is_ground_content = false,
        })
    else
        core.register_alias("cottages:roof_flat_straw", "stairs:slab_straw")
    end

    core.register_node("cottages:roof_" .. name .. "_corner_inner", {
        description = S("@1 Roof (inner corner) ", display_name),
        drawtype = "nodebox",
        tiles = { tiles[1],
            tiles[2],
            tiles[3],
            tiles[2] .. "^(" .. tiles[6] .. "^cottages_corner_inner_mask.png^[transformFX^[makealpha:255,255,255)",
            tiles[5],
            tiles[2] .. "^(" .. tiles[6] .. "^cottages_corner_inner_mask.png^[makealpha:255,255,255)" },
        paramtype = "light",
        paramtype2 = "facedir",
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, roof = 1 },
        node_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.0, 0,   0 },
                { -0.5, 0,    0,    0.5, 0.5, 0.5 },
                { 0,    0,    0,    0.5, 0.5, -0.5 },
            },
        },
        selection_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.0, 0,   0 },
                { -0.5, 0,    0,    0.5, 0.5, 0.5 },
                { 0,    0,    0,    0.5, 0.5, -0.5 },
            },
        },
        is_ground_content = false,
    })

    core.register_node("cottages:roof_" .. name .. "_corner_outer", {
        description = S("@1 Roof (outer corner) ", display_name),
        drawtype = "nodebox",
        tiles = { tiles[1],
            tiles[2],
            tiles[1],
            tiles[2],
            tiles[2],
            tiles[1] },
        paramtype = "light",
        paramtype2 = "facedir",
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, roof = 1 },
        node_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.5, 0,   0 },
                { -0.5, 0,    0,    0,   0.5, 0.5 },
                { 0,    -0.5, 0,    0.5, 0,   0.5 },
            },
        },
        selection_box = {
            type = "fixed",
            fixed = {
                { -0.5, -0.5, -0.5, 0.5, 0,   0 },
                { -0.5, 0,    0,    0,   0.5, 0.5 },
                { 0,    -0.5, 0,    0.5, 0,   0.5 },
            },
        },
        is_ground_content = false,
    })

    if not homedecor_alternative or core.get_modpath("homedecor") then
        core.register_craft({
            output = "cottages:roof_" .. name .. " 6",
            recipe = {
                { '',             '',             basic_material },
                { '',             basic_material, '' },
                { basic_material, '',             '' }
            }
        })
    elseif homedecor_alternative then
        basic_material = 'cottages:roof_wood'

        core.register_craft({
            output = "cottages:roof_" .. name .. " 3",
            recipe = {
                { homedecor_alternative, '',             basic_material },
                { '',                    basic_material, '' },
                { basic_material,        '',             '' }
            }
        })
    end

    core.register_craft({
        output = "cottages:roof_connector_" .. name,
        recipe = {
            { 'cottages:roof_' .. name },
            { "group:wood" },
        }
    })

    core.register_craft({
        output = "cottages:roof_flat_" .. name .. ' 2',
        recipe = {
            { 'cottages:roof_' .. name, 'cottages:roof_' .. name },
        }
    })

    core.register_craft({
        output = "cottages:roof_" .. name .. "_corner_inner 3",
        recipe = {
            { 'cottages:roof_' .. name, 'cottages:roof_' .. name },
            { 'cottages:roof_' .. name, '' },
        }
    })

    core.register_craft({
        output = "cottages:roof_" .. name .. " 3",
        recipe = {
            { "cottages:roof_" .. name .. "_corner_inner",
                "cottages:roof_" .. name .. "_corner_inner",
                "cottages:roof_" .. name .. "_corner_inner" }
        }
    })

    core.register_craft({
        output = "cottages:roof_" .. name .. "_corner_outer 3",
        recipe = {
            { '',                       'cottages:roof_' .. name },
            { 'cottages:roof_' .. name, 'cottages:roof_' .. name },
        }
    })

    core.register_craft({
        output = "cottages:roof_" .. name .. " 3",
        recipe = {
            { "cottages:roof_" .. name .. "_corner_outer",
                "cottages:roof_" .. name .. "_corner_outer",
                "cottages:roof_" .. name .. "_corner_outer" }
        }
    })

    -- convert flat roofs back to normal roofs
    core.register_craft({
        type = "shapeless",
        output = "cottages:roof_" .. name,
        recipe = {
            "cottages:roof_flat_" .. name,
            "cottages:roof_flat_" .. name
        }
    })
end

cottages.register_roof('straw', S("Straw"),
    { "cottages_darkage_straw.png", "cottages_darkage_straw.png",
        "cottages_darkage_straw.png", "cottages_darkage_straw.png",
        "cottages_darkage_straw.png", "cottages_darkage_straw.png" },
    'cottages:straw_mat', nil, default.node_sound_leaves_defaults())
cottages.register_roof('reet', S("Reet"),
    { "cottages_reet.png", "cottages_reet.png",
        "cottages_reet.png", "cottages_reet.png",
        "cottages_reet.png", "cottages_reet.png" },
    "default:papyrus", nil, default.node_sound_leaves_defaults())
cottages.register_roof('wood', S("Wooden"),
    { "default_tree.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "default_tree.png" },
    "group:wood", nil, default.node_sound_wood_defaults())
cottages.register_roof('black', S("Asphalt"),
    { "cottages_homedecor_shingles_asphalt.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "cottages_homedecor_shingles_asphalt.png" },
    'homedecor:shingles_asphalt', "default:coal_lump", default.node_sound_wood_defaults())
cottages.register_roof('red', S("Terracotta"),
    { "cottages_homedecor_shingles_terracotta.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "cottages_homedecor_shingles_terracotta.png" },
    'homedecor:shingles_terracotta', "default:clay_brick", default.node_sound_wood_defaults())
cottages.register_roof('brown', S("Brown shingle"),
    { "cottages_homedecor_shingles_wood.png", "default_wood.png",
        "default_wood.png", "default_wood.png",
        "default_wood.png", "cottages_homedecor_shingles_wood.png" },
    'homedecor:shingles_wood', "default:dirt", default.node_sound_wood_defaults())
cottages.register_roof('slate', S("Slate"),
    { "cottages_slate.png", "default_wood.png",
        "cottages_slate.png", "cottages_slate.png",
        "default_wood.png", "cottages_slate.png" },
    "default:stone", nil, default.node_sound_stone_defaults())

---------------------------------------------------------------------------------------
-- Vertical roofs
---------------------------------------------------------------------------------------

function cottages.register_vertical_roof(name, description, texture, craftitem)
    core.register_node("cottages:" .. name, {
        description = description,
        tiles = {
            texture, cottages.texture_roof_sides,
            texture, texture,
            cottages.texture_roof_sides, texture
        },
        paramtype2 = "facedir",
        groups = { cracky = 2, stone = 1 },
        sounds = default.node_sound_stone_defaults(),
        is_ground_content = false,
    })

    if craftitem ~= false then
        core.register_craft({
            output = "cottages:" .. name,
            recipe = {
                { "default:stone", "group:wood", craftitem }
            }
        })
    end

    cottages.derive_blocks("cottages", name, {
        description = description,
        tiles = { texture },
        groups = { cracky = 2, stone = 1 },
        sounds = default.node_sound_stone_defaults(),
    })
end

cottages.register_vertical_roof("slate_vertical", S("Vertical Slate"),
    "cottages_slate.png", nil)
cottages.register_vertical_roof("roof_vertical_asphalt", S("Vertical asphalt roof"),
    "cottages_homedecor_shingles_asphalt.png", "default:coal_lump")
cottages.register_vertical_roof("roof_vertical_terracotta", S("Vertical terracotta roof"),
    "cottages_homedecor_shingles_terracotta.png", "default:clay_brick")
cottages.register_vertical_roof("roof_vertical_wood", S("Vertical wooden roof"),
    "default_tree.png", "group:tree")
cottages.register_vertical_roof("roof_vertical_brown", S("Vertical brown shingle roof"),
    "cottages_homedecor_shingles_wood.png", "default:dirt")
cottages.register_vertical_roof("roof_vertical_shingle", S("Vertical shingle roof"),
    "cottages_homedecor_shingles_misc_wood.png", false)

core.register_craft({
    output = "cottages:roof_vertical_shingle 2",
    recipe = { { "group:wood", "cottages:wood_flat" } }
})

core.register_node("cottages:roof_vertical_wood", {
    description = S("Vertical wooden roof"),
    tiles = {
        "default_tree.png", cottages.texture_roof_sides,
        "default_tree.png", "default_tree.png",
        cottages.texture_roof_sides, "default_tree.png"
    },
    paramtype2 = "facedir",
    groups = { cracky = 2, stone = 1 },
    sounds = default.node_sound_stone_defaults(),
    is_ground_content = false,
})

---------------------------------------------------------------------------------------
-- Reed might also be needed as a full block
---------------------------------------------------------------------------------------
core.register_node("cottages:reet", {
    description = S("Reed for thatching"),
    tiles = { "cottages_reet.png" },
    groups = { hay = 3, snappy = 3, choppy = 3, oddly_breakable_by_hand = 3, flammable = 3 },
    sounds = default.node_sound_leaves_defaults(),
    is_ground_content = false,
})


core.register_craft({
    output = "cottages:reet",
    recipe = {
        { "default:papyrus", "default:papyrus" },
        { "default:papyrus", "default:papyrus" },
    },
})
