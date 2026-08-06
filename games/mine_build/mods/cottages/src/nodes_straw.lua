-- cottages/src/nodes_straw.lua
-- straw - a very basic material
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

-- an even simpler from of bed - usually for animals
-- it is a nodebox and not wallmounted because that makes it easier to replace beds with straw mats
core.register_node("cottages:straw_mat", {
    description = S("Layer of straw"),
    drawtype = 'nodebox',
    tiles = { "cottages_darkage_straw.png" }, -- done by VanessaE
    wield_image = "cottages_darkage_straw.png",
    inventory_image = "cottages_darkage_straw.png",
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "facedir",
    walkable = false,
    groups = { hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_leaves_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.48, -0.5, -0.48, 0.48, -0.45, 0.48 },
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.48, -0.5, -0.48, 0.48, -0.25, 0.48 },
        }
    },
    is_ground_content = false,
})

-- straw bales are a must for farming environments;
-- if you for some reason do not have the darkage mod installed, this here gets you a straw bale
core.register_node("cottages:straw_bale", {
    drawtype = "nodebox",
    description = S("Straw Bale"),
    tiles = { "cottages_darkage_straw_bale.png" },
    paramtype = "light",
    groups = { hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_leaves_defaults(),
    -- the bale is slightly smaller than a full node
    node_box = {
        type = "fixed",
        fixed = {
            { -0.45, -0.5, -0.45, 0.45, 0.45, 0.45 },
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.45, -0.5, -0.45, 0.45, 0.45, 0.45 },
        }
    },
    is_ground_content = false,
})

core.register_alias("cottages:straw", "farming:straw")

core.register_craft({
    output = "cottages:straw_mat 6",
    recipe = {
        { "default:stone", '',              '' },
        { "farming:wheat", "farming:wheat", "farming:wheat" },
    },
    replacements = { { "default:stone", "farming:seed_wheat 3" } },
})

core.register_craft({
    output = "cottages:straw_bale",
    recipe = {
        { "cottages:straw_mat" },
        { "cottages:straw_mat" },
        { "cottages:straw_mat" },
    },
})

core.register_craft({
    output = "cottages:straw_bale",
    recipe = {
        { "cottages:straw" },
    },
})

core.register_craft({
    output = "cottages:straw_mat 3",
    recipe = {
        { "cottages:straw_bale" },
    },
})
