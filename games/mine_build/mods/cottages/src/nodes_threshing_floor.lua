-- cottages/src/nodes_threshing_floor.lua
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
local F = core.formspec_escape

local cottages_formspec_threshing_floor =
    "size[8,8]" ..
    "image[3,0;1,1;default_stick.png]" ..
    "image[0,1.5;1,1;farming_wheat.png]" ..
    "button[6.8,0.0;1.5,0.5;public;" .. F(S("Public?")) .. "]" ..
    "list[context;harvest;1,1.5;2,1;]" ..
    "list[context;straw;5,0;2,2;]" ..
    "list[context;seeds;5,2;2,2;]" ..
    "label[1,1;" .. F(S("Harvested wheat:")) .. "]" ..
    "label[4,0.0;" .. F(S("Straw:")) .. "]" ..
    "label[4,2.0;" .. F(S("Seeds:")) .. "]" ..
    "label[0,0;" .. F(S("Threshing floor")) .. "]" ..
    "label[0,2.5;" .. F(S("Punch threshing floor with a stick\nto get straw and seeds from wheat.")) .. "]" ..
    "list[current_player;main;0,4;8,4;]" ..
    "listring[current_player;main]" ..
    "listring[context;harvest]" ..
    "listring[current_player;main]" ..
    "listring[context;straw]" ..
    "listring[current_player;main]" ..
    "listring[context;seeds]" ..
    "listring[current_player;main]"

local def = {
    description = S("Threshing Floor"),
    tiles = {
        "cottages_junglewood.png^farming_wheat.png",
        "cottages_junglewood.png",
        "cottages_junglewood.png"
    },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { cracky = 2, choppy = 2 },
    sounds = default.node_sound_wood_defaults(),
    is_ground_content = false,

    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            { -0.50, -0.5, -0.50, 0.50,  -0.40, 0.50 },

            { -0.50, -0.4, -0.50, -0.45, -0.20, 0.50 },
            { 0.45,  -0.4, -0.50, 0.50,  -0.20, 0.50 },

            { -0.45, -0.4, -0.50, 0.45,  -0.20, -0.45 },
            { -0.45, -0.4, 0.45,  0.45,  -0.20, 0.50 },
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            { -0.50, -0.5, -0.50, 0.50, -0.20, 0.50 },
        }
    },

    _public_translate_key = "Public threshing floor",
    _private_translate_key = "Private threshing floor (owned by @1)",

    on_construct = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("harvest", 2)
        inv:set_size("straw", 4)
        inv:set_size("seeds", 4)

        meta:set_string("infotext", S("Public threshing floor"))
        meta:set_string("formspec", cottages_formspec_threshing_floor)
        meta:set_string("public", "public")
    end,

    after_place_node = function(pos, placer)
        if not placer:is_player() then return end

        local meta = core.get_meta(pos)
        local pname = placer:get_player_name()

        meta:set_string("owner", pname);
        meta:set_string("infotext", S("Private threshing floor (owned by @1)", pname));
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
        return cottages.check_inventory_empty(inv, { "harvest", "straw", "seeds" })
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, _, count, player)
        local meta = core.get_meta(pos)
        if not cottages.player_can_use(meta, player) then
            return 0
        end

        if to_list == "harvest" then
            local inv = meta:get_inventory()
            local stack = inv:get_stack(from_list, from_index)

            if stack:get_name() ~= 'farming:wheat' then
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
            if stack:get_name() ~= 'farming:wheat' then
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

    on_punch = function(pos, _, puncher)
        if not puncher:is_player() then return end

        do -- `wielded` garbage collect
            local wielded = puncher:get_wielded_item()
            if wielded:is_empty() then return end
            if core.get_item_group(wielded:get_name(), "stick") == 0 then return end
        end

        local meta = core.get_meta(pos)
        if not cottages.player_can_use(meta, puncher) then
            return
        end

        local inv = meta:get_inventory()

        local anz_wheat = 10 + math.random(0, 30)
        local rem_wheat = inv:remove_item("harvest", "farming:wheat " .. anz_wheat)
        local wheat_count = rem_wheat:get_count()

        local add_straw = ItemStack("cottages:straw_mat " .. wheat_count)
        local add_seeds = ItemStack("farming:seed_wheat " .. wheat_count)

        if inv:room_for_item("straw", add_straw) and inv:room_for_item("seeds", add_seeds) then
            inv:add_item("straw", add_straw)
            inv:add_item("seeds", add_seeds)
        else
            inv:add_item("harvest", rem_wheat)
        end

        local infotext = cottages.get_public_infotext(pos)
        infotext = infotext .. "\n" .. S("Processed @1 wheats", wheat_count)
        meta:set_string("infotext", infotext)
    end,
}
default.set_inventory_action_loggers(def, "threshing floor")

core.register_node("cottages:threshing_floor", def)

core.register_craft({
    output = "cottages:threshing_floor",
    recipe = {
        { "default:junglewood", "default:chest_locked", "default:junglewood", },
        { "default:junglewood", "default:stone",        "default:junglewood", },
    },
})
