-- cottages/src/nodes_mill.lua
-- Mill - punch-powered flour machine
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
local F = core.formspec_escape

cottages.handmill_product = {}
cottages.handmill_product["farming:seed_wheat"] = 'farming:flour 1'

local cottages_handmill_formspec = "size[8,8]" ..
    "image[0,1;1,1;farming_wheat_seed.png]" ..
    "button[6.0,0.0;1.5,0.5;public;" .. F(S("Public?")) .. "]" ..
    "list[current_name;seeds;1,1;1,1;]" ..
    "list[current_name;flour;5,1;2,2;]" ..
    "label[0,0.5;" .. F(S("Wheat seeds:")) .. "]" ..
    "label[4,0.5;" .. F(S("Flour:")) .. "]" ..
    "label[0,0;" .. F(S("Mill")) .. "]" ..
    "label[0,2.5;" .. F(S("Punch this hand-driven mill\nto convert wheat seeds into flour.")) .. "]" ..
    "list[current_player;main;0,4;8,4;]" ..
    "listring[current_player;main]" ..
    "listring[context;seeds]" ..
    "listring[current_player;main]" ..
    "listring[context;flour]" ..
    "listring[current_player;main]"

local mill_box = {
    type = "fixed",
    fixed = {
        { -0.50, -0.5, -0.50, 0.50, 0.25, 0.50 },
    }
}

local def = {
    short_description = S("Mill"),
    description = S("Mill, powered by punching"),
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { cracky = 2 },
    sounds = default.node_sound_stone_defaults(),
    is_ground_content = false,

    drawtype = "mesh",
    mesh = "cottages_handmill.obj",
    tiles = { "default_stone.png" },
    selection_box = mill_box,
    collision_box = mill_box,

    _public_translate_key = "Public mill, powered by punching",
    _private_translate_key = "Private mill, powered by punching (owned by @1)",

    on_construct = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("seeds", 1)
        inv:set_size("flour", 4)

        meta:set_string("infotext", S("Public mill, powered by punching"))
        meta:set_string("formspec", cottages_handmill_formspec)
        meta:set_string("public", "public")
    end,

    after_place_node = function(pos, placer)
        if not placer:is_player() then return end

        local meta = core.get_meta(pos)
        local pname = placer:get_player_name()

        meta:set_string("owner", pname);
        meta:set_string("infotext", S("Private mill, powered by punching (owned by @1)", pname));
        meta:set_string("public", "")
    end,

    on_receive_fields = cottages.on_public_receive_fields,

    can_dig = function(pos, player)
        if not (player and player:is_player()) then return end
        local meta = core.get_meta(pos)
        local owner = meta:get_string("owner")
        local pname = player:get_player_name()

        if owner ~= "" and owner ~= pname then
            return false
        end

        local inv = meta:get_inventory()
        return cottages.check_inventory_empty(inv, { "flour", "seeds" })
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, _, count, player)
        local meta = core.get_meta(pos)
        if not cottages.player_can_use(meta, player) then
            return 0
        end

        if to_list == "seeds" then
            local inv = meta:get_inventory()
            local stack = inv:get_stack(from_list, from_index)

            if not cottages.handmill_product[stack:get_name()] then
                return 0
            end
        end

        return count
    end,

    allow_metadata_inventory_put = function(pos, listname, _, stack, player)
        local meta = core.get_meta(pos)
        if not cottages.player_can_use(meta, player) then
            return 0
        end

        if listname == "harvest" then
            if not cottages.handmill_product[stack:get_name()] then
                return 0
            end
        end

        -- return -1
        return stack:get_count()
    end,

    allow_metadata_inventory_take = function(pos, _, _, stack, player)
        local meta = core.get_meta(pos)
        return cottages.player_can_use(meta, player) and stack:get_count() or 0
    end,

    on_punch = function(pos, node, puncher)
        if not puncher:is_player() then return end

        local meta = core.get_meta(pos)
        if not cottages.player_can_use(meta, puncher) then
            return
        end

        local inv = meta:get_inventory()

        local seed = inv:get_stack("seeds", 1)
        local product_def = cottages.handmill_product[seed:get_name()]
        if seed:is_empty() or not product_def then
            return
        end
        local anz = math.min(seed:get_count(), 1 + math.random(1, 20))
        seed:set_count(seed:get_count() - anz)

        local produced = ItemStack(product_def)
        produced:set_count(produced:get_count() * anz)


        if inv:room_for_item("flour", produced) then
            inv:add_item("flour", produced)
            inv:set_stack("seeds", 1, seed)
        end

        node.param2 = (node.param2 + 1) % 4
        core.swap_node(pos, node)

        local infotext = cottages.get_public_infotext(pos)
        infotext = infotext .. "\n" .. S("Processed @1 seeds", anz)
        meta:set_string("infotext", infotext)
    end,
}

default.set_inventory_action_loggers(def, "hand mill")

core.register_node("cottages:handmill", def)

core.register_craft({
    output = "cottages:handmill",
    recipe = {
        { "group:stick", "default:stone",       "", },
        { "",            "default:steel_ingot", "", },
        { "",            "default:stone",       "", },
    },
})
