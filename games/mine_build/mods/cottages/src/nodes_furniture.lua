-- cottages/src/nodes_furniture.lua
-- Beds, benches, tables, etc.
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

core.register_node("cottages:bed_foot", {
    description = S("Bed"),
    drawtype = "nodebox",
    tiles = {
        "cottages_beds_bed_top_bottom.png",
        "default_wood.png",
        "cottages_beds_bed_side.png",
        "cottages_beds_bed_side.png",
        "cottages_beds_bed_side.png",
        "cottages_beds_bed_side.png"
    },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            -- bed
            { -0.5, 0.0,  -0.5, 0.5,  0.3, 0.5 },

            -- stützen
            { -0.5, -0.5, -0.5, -0.4, 0.5, -0.4 },
            { 0.4,  -0.5, -0.5, 0.5,  0.5, -0.4 },

            -- Querstrebe
            { -0.4, 0.3,  -0.5, 0.4,  0.5, -0.4 }
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.5, 0.5, 0.3, 0.5 },
        }
    },
    is_ground_content = false,

    on_construct = function(pos)
        local node = core.get_node(pos)
        local direction = core.facedir_to_dir(node.param2)
        local pos2 = vector.add(pos, direction)

        if core.get_node(pos2).name == "air" then
            core.set_node(pos2, {
                name = "cottages:bed_head",
                param2 = node.param2
            })
        end
    end,
    on_destruct = function(pos)
        local node = core.get_node(pos)
        local direction = core.facedir_to_dir(node.param2)
        local pos2 = vector.add(pos, direction)
        local node2 = core.get_node(pos2)

        if node2.name == "cottages:bed_head" and node2.param2 == node.param2 then
            core.remove_node(pos2)
            core.check_for_falling(pos2)
        end
    end,
})

core.register_node("cottages:bed_head", {
    drawtype = "nodebox",
    tiles = {
        "cottages_beds_bed_top_top.png",
        "default_wood.png",
        "cottages_beds_bed_side_top_r.png",
        "cottages_beds_bed_side_top_l.png",
        "default_wood.png",
        "cottages_beds_bed_side.png"
    },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            -- bed
            { -0.5, 0.0,  -0.5, 0.5,  0.3, 0.5 },

            -- stützen
            { -0.5, -0.5, 0.4,  -0.4, 0.5, 0.5 },
            { 0.4,  -0.5, 0.4,  0.5,  0.5, 0.5 },

            -- Querstrebe
            { -0.4, 0.3,  0.4,  0.4,  0.5, 0.5 }
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.5, 0.5, 0.3, 0.5 },
        }
    },
    is_ground_content = false,

    drop = "cottages:bed_foot",
    on_destruct = function(pos)
        local node = core.get_node(pos)
        local direction = core.facedir_to_dir(node.param2)
        local root_pos = vector.subtract(pos, direction)

        core.swap_node(pos, { name = "air" })

        local root_node = core.get_node(root_pos)
        if root_node.name == "cottages:bed_foot" and root_node.param2 == node.param2 then
            core.remove_node(root_pos)
            core.check_for_falling(root_pos)
        end
    end,

    on_place = function(itemstack, placer, pointed_thing)
        itemstack:set_name("cottages:bed_foot")
        core.item_place(itemstack, placer, pointed_thing)
        return itemstack
    end
})

core.register_node("cottages:sleeping_mat", {
    description = S("Sleeping mat"),
    drawtype = 'nodebox',
    tiles = { 'cottages_sleepingmat.png' }, -- done by VanessaE
    wield_image = 'cottages_sleepingmat.png',
    inventory_image = 'cottages_sleepingmat.png',
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "facedir",
    walkable = false,
    groups = { snappy = 3 },
    sounds = default.node_sound_leaves_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.48, -0.5, -0.48, 0.48, -0.5 + 1 / 16, 0.48 },
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.48, -0.5, -0.48, 0.48, -0.5 + 2 / 16, 0.48 },
        }
    },
    is_ground_content = false,
})

core.register_node("cottages:sleeping_mat_head", {
    description = S("sleeping mat with pillow"),
    drawtype = 'nodebox',
    tiles = { 'cottages_sleepingmat.png' }, -- done by VanessaE
    wield_image = 'cottages_sleepingmat.png',
    inventory_image = 'cottages_sleepingmat.png',
    sunlight_propagates = true,
    paramtype = 'light',
    paramtype2 = "facedir",
    groups = { snappy = 3 },
    sounds = default.node_sound_leaves_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.48, -0.5,          -0.48, 0.48, -0.5 + 1 / 16, 0.48 },
            { -0.34, -0.5 + 1 / 16, -0.12, 0.34, -0.5 + 2 / 16, 0.34 },
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.48, -0.5, -0.48, 0.48, -0.5 + 2 / 16, 0.48 },
        }
    },
    is_ground_content = false,
})

core.register_node("cottages:bench", {
    drawtype = "nodebox",
    description = S("simple wooden bench"),
    tiles = {
        "cottages_minimal_wood.png",
        "cottages_minimal_wood.png",
        "cottages_minimal_wood.png",
        "cottages_minimal_wood.png",
        "cottages_minimal_wood.png",
        "cottages_minimal_wood.png"
    },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
    sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            -- sitting area
            { -0.5, -0.15, 0.1, 0.5,  -0.05, 0.5 },

            -- stützen
            { -0.4, -0.5,  0.2, -0.3, -0.15, 0.4 },
            { 0.3,  -0.5,  0.2, 0.4,  -0.15, 0.4 },
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, 0, 0.5, 0, 0.5 },
        }
    },
    is_ground_content = false,
})

core.register_node("cottages:table", {
    description = S("Table"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.1, -0.5, -0.1, 0.1, 0.3, 0.1 },
            { -0.5, 0.48, -0.5, 0.5, 0.4, 0.5 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.5, 0.5, 0.4, 0.5 },
        },
    },
    is_ground_content = false,
})

local shelf_box = {
    type = "fixed",
    fixed = {
        { -0.5, -0.5, -0.3, -0.4, 0.5,  0.5 },
        { 0.4,  -0.5, -0.3, 0.5,  0.5,  0.5 },

        { -0.5, -0.2, -0.3, 0.5,  -0.1, 0.5 },
        { -0.5, 0.3,  -0.3, 0.5,  0.4,  0.5 },
    },
}
local shelf_def = {
    description = S("Open storage shelf"),
    drawtype = "nodebox",
    tiles = { "cottages_minimal_wood.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    sounds = default.node_sound_wood_defaults(),
    node_box = shelf_box,
    selection_box = shelf_box,

    on_construct = function(pos)
        local meta = core.get_meta(pos);

        meta:set_string("formspec",
            "size[8,8]" ..
            "list[current_name;main;0,0;8,3;]" ..
            "list[current_player;main;0,4;8,4;]" ..
            "listring[context;main]" ..
            "listring[current_player;main]")
        meta:set_string("infotext", S("Open storage shelf"))
        local inv = meta:get_inventory();
        inv:set_size("main", 24);
    end,

    can_dig = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,

    on_metadata_inventory_put = function(pos)
        local meta = core.get_meta(pos);
        meta:set_string('infotext', S('Open storage shelf') .. " " .. S("(in use)"));
    end,
    on_metadata_inventory_take = function(pos)
        local meta = core.get_meta(pos);
        local inv = meta:get_inventory();
        if inv:is_empty("main") then
            meta:set_string('infotext', S('Open storage shelf') .. " " .. S("(empty)"));
        end
    end,
    is_ground_content = false,
}
default.set_inventory_action_loggers(shelf_def, "open storage shelf")
core.register_node("cottages:shelf", shelf_def)

core.register_node("cottages:stovepipe", {
    description = S("stovepipe"),
    drawtype = "nodebox",
    tiles = { "cottages_steel_block.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { 0.20, -0.5, 0.20, 0.45, 0.5, 0.45 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { 0.20, -0.5, 0.20, 0.45, 0.5, 0.45 },
        },
    },
    is_ground_content = false,
})

local waters = {
    ['default:water_source'] = true,
    ['default:water_flowing'] = true,
    ['default:river_water_source'] = true,
    ['default:river_water_flowing'] = true,
}
core.register_node("cottages:washing", {
    description = S("Washing Place"),
    drawtype = "nodebox",
    tiles = { "cottages_clay.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
    sounds = default.node_sound_dirt_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.5, 0.5,  -0.2, -0.2 },

            { -0.5, -0.5, -0.2, -0.4, 0.2,  0.5 },
            { 0.4,  -0.5, -0.2, 0.5,  0.2,  0.5 },

            { -0.4, -0.5, 0.4,  0.4,  0.2,  0.5 },
            { -0.4, -0.5, -0.2, 0.4,  0.2,  -0.1 },

        },
    },
    on_rightclick = function(pos, _, player)
        if not player:is_player() then return end
        local pname = player:get_player_name()
        -- works only with water beneath
        local node_under = core.get_node({ x = pos.x, y = (pos.y - 1), z = pos.z });
        if not waters[node_under.name] then
            core.chat_send_player(pname,
                S("Sorry. This washing place is out of water. Please place it above water!"));
        else
            core.chat_send_player(pname, S("You feel much cleaner after some washing."));
        end
    end,
    is_ground_content = false,

})

---------------------------------------------------------------------------------------
-- crafting receipes
---------------------------------------------------------------------------------------
core.register_craft({
    output = "cottages:bed_foot",
    recipe = {
        { "wool:white",  "", "", },
        { "group:wood",  "", "", },
        { "group:stick", "", "", }
    }
})

core.register_craft({
    output = "cottages:bed_head",
    recipe = {
        { "", "",            "wool:white", },
        { "", "group:stick", "group:wood", },
        { "", "",            "group:stick", }
    }
})

core.register_craft({
    output = "cottages:sleeping_mat 3",
    recipe = {
        { "cottages:wool_tent", "cottages:straw_mat", "cottages:straw_mat" }
    }
})


core.register_craft({
    output = "cottages:sleeping_mat_head",
    recipe = {
        { "cottages:sleeping_mat", "cottages:straw_mat" }
    }
})

core.register_craft({
    output = "cottages:table",
    recipe = {
        { "", "stairs:slab_wood", "", },
        { "", "group:stick",      "" }
    }
})

core.register_craft({
    output = "cottages:bench",
    recipe = {
        { "",            "group:wood", "", },
        { "group:stick", "",           "group:stick", }
    }
})


core.register_craft({
    output = "cottages:shelf",
    recipe = {
        { "group:stick", "group:wood", "group:stick", },
        { "group:stick", "group:wood", "group:stick", },
        { "group:stick", "",           "group:stick" }
    }
})

core.register_craft({
    output = "cottages:washing 2",
    recipe = {
        { "group:stick" },
        { "default:clay_lump" },
    }
})

core.register_craft({
    output = "cottages:stovepipe 2",
    recipe = {
        { "default:steel_ingot", '', "default:steel_ingot" },
    }
})
