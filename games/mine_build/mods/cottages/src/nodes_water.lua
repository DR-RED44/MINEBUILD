-- cottages/src/nodes_water.lua
-- well for getting water
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

cottages.water_fill_time = 10

local S = cottages.S
local F = core.formspec_escape

-- Key: item name of the bucket
-- Value: item name if it is filled with river water, "" if already filled
cottages.well_accepted_buckets = {
    -- Default buckets
    ["bucket:bucket_empty"] = "bucket:bucket_river_water",
    ["bucket:bucket_water"] = "",
    ["bucket:bucket_river_water"] = "",

    -- Wooden buckets by Hume2
    ["bucket_wooden:bucket_empty"] = "bucket_wooden:bucket_river_water",
    ["bucket_wooden:bucket_water"] = "",
    ["bucket_wooden:bucket_river_water"] = "",
}

cottages.well_empty_buckets = {
    -- Default buckets
    ["bucket:bucket_water"] = "bucket:bucket_empty",
    ["bucket:bucket_river_water"] = "bucket:bucket_empty",

    -- Wooden buckets by Hume2
    ["bucket_wooden:bucket_water"] = "bucket_wooden:bucket_empty",
    ["bucket_wooden:bucket_river_water"] = "bucket_wooden:bucket_empty",
}

-- Old entity should vanish to avodi issues
core.register_entity("cottages:bucket_entity", {
    initial_properties = {
        hp_max = 1,
        visual = "wielditem",
        visual_size = { x = 0.33, y = 0.33 },
        collisionbox = { 0, 0, 0, 0, 0, 0 },
        physical = false,
        textures = { "air" },
        automatic_rotate = 1,
    },
    on_activate = function(self)
        self.object:remove()
    end
})

-- code taken from the itemframes mod in homedecor
core.register_entity("cottages:bucket_entity_new", {
    initial_properties = {
        hp_max = 1,
        visual = "wielditem",
        visual_size = { x = 0.33, y = 0.33 },
        collisionbox = { 0, 0, 0, 0, 0, 0 },
        physical = false,
        textures = { "air" },
        automatic_rotate = 1,
        static_save = false,
    },
    set_item = function(self, well_pos, item_name)
        self.well_pos = well_pos
        self.object:set_properties({ textures = { item_name } })
    end,
    on_activate = function(self)
        if self.well_pos then
            local well_node = core.get_node(self.well_pos)
            if well_node.name == "cottages:water_gen" then
                return
            end
            self.object:remove()
        end
    end,
})

local function spawn_well_entity(pos, item_name)
    local up_pos = vector.add(pos, { x = 0, y = 4 / 16, z = 0 })
    local obj = core.add_entity(up_pos, "cottages:bucket_entity_new")
    if obj then
        obj:get_luaentity():set_item(pos, item_name)
    end
    return obj
end

local function alter_well_entity(pos, item_name)
    local up_pos = vector.add(pos, { x = 0, y = 4 / 16, z = 0 })
    local objs = core.get_objects_inside_radius(up_pos, 0.5)

    local del = false
    for _, obj in ipairs(objs) do
        local luaentity = obj:get_luaentity()
        if luaentity then
            if luaentity.name == "cottages:bucket_entity_new"
                and luaentity.well_pos == pos then
                if del then
                    obj:remove()
                else
                    del = true
                    obj:set_properties({ textures = { item_name } })
                end
            end
        end
    end
end

local function remove_well_entity(pos)
    local up_pos = vector.add(pos, { x = 0, y = 4 / 16, z = 0 })
    local objs = core.get_objects_inside_radius(up_pos, 0.5)

    for _, obj in ipairs(objs) do
        local luaentity = obj:get_luaentity()
        if luaentity then
            if luaentity.name == "cottages:bucket_entity_new"
                and luaentity.well_pos == pos then
                obj:remove()
            end
        end
    end
end

local function check_well_entity(pos, item_name)
    local up_pos = vector.add(pos, { x = 0, y = 4 / 16, z = 0 })
    local objs = core.get_objects_inside_radius(up_pos, 0.5)

    local del = false
    for _, obj in ipairs(objs) do
        local luaentity = obj:get_luaentity()
        if luaentity then
            if luaentity.name == "cottages:bucket_entity_new"
                and luaentity.well_pos == pos then
                if del then
                    obj:remove()
                else
                    del = true
                end
            end
        end
    end

    if not del then
        -- No entity found
        spawn_well_entity(pos, item_name)
    end
end

local well_formspec = "size[8,9]" ..
    "label[3.0,0.0;Tree trunk well]" ..
    "label[1.5,0.7;" .. F(S("Punch the well while wielding an empty bucket.")) .. "]" ..
    "label[1.5,1.0;" .. F(S("Your bucket will slowly be filled with river water.")) .. "]" ..
    "label[1.5,1.3;" .. F(S("Punch again to get the bucket back when it is full.")) .. "]" ..
    "label[1.0,2.9;" .. F(S("Internal bucket storage (passive storage only):")) .. "]" ..
    "item_image[0.2,0.7;1.0,1.0;bucket:bucket_empty]" ..
    "item_image[0.2,1.7;1.0,1.0;bucket:bucket_river_water]" ..
    "label[1.5,1.9;" .. F(S("Punch well with full water bucket in order to empty bucket.")) .. "]" ..
    "button[6.0,0.0;2,0.5;public;" .. F(S("Public?")) .. "]" ..
    "list[context;main;1,3.3;8,1;]" ..
    "list[current_player;main;0,4.85;8,1;]" ..
    "list[current_player;main;0,6.08;8,3;8]" ..
    "listring[context;main]" ..
    "listring[current_player;main]"

local def = {
    description = S("Tree Trunk Well"),
    tiles = { "default_tree_top.png", "default_tree.png^[transformR90", "default_tree.png^[transformR90" },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = { choppy = 2, cracky = 1, flammable = 2 },
    sounds = default.node_sound_wood_defaults(),
    node_box = {
        type = "fixed",
        fixed = {
            -- floor of water bassin
            { -0.5,            -0.5 + (3 / 16), -0.5,            0.5,             -0.5 + (4 / 16), 0.5 },
            -- walls
            { -0.5,            -0.5 + (3 / 16), -0.5,            0.5,             (4 / 16),        -0.5 + (2 / 16) },
            { -0.5,            -0.5 + (3 / 16), -0.5,            -0.5 + (2 / 16), (4 / 16),        0.5 },
            { 0.5,             -0.5 + (3 / 16), 0.5,             0.5 - (2 / 16),  (4 / 16),        -0.5 },
            { 0.5,             -0.5 + (3 / 16), 0.5,             -0.5 + (2 / 16), (4 / 16),        0.5 - (2 / 16) },
            -- feet
            { -0.5 + (3 / 16), -0.5,            -0.5 + (3 / 16), -0.5 + (6 / 16), -0.5 + (3 / 16), 0.5 - (3 / 16) },
            { 0.5 - (3 / 16),  -0.5,            -0.5 + (3 / 16), 0.5 - (6 / 16),  -0.5 + (3 / 16), 0.5 - (3 / 16) },
            -- real pump
            { 0.5 - (4 / 16),  -0.5,            -(2 / 16),       0.5,             0.5 + (4 / 16),  (2 / 16) },
            -- water pipe inside wooden stem
            { 0.5 - (8 / 16),  0.5 + (1 / 16),  -(1 / 16),       0.5,             0.5 + (3 / 16),  (1 / 16) },
            -- where the water comes out
            { 0.5 - (15 / 32), 0.5,             -(1 / 32),       0.5 - (12 / 32), 0.5 + (1 / 16),  (1 / 32) },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = { -0.5, -0.5, -0.5, 0.5, 0.5 + (4 / 16), 0.5 }
    },

    _public_translate_key = "Public tree trunk well",
    _private_translate_key = "Private tree trunk well (owned by @1)",

    on_construct = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size('main', 6)
        inv:set_size("bucket", 1)
        meta:set_string("formspec", well_formspec)
        meta:set_string("infotext", S("Public tree trunk well"))
        meta:set_string("public", "public")
    end,

    after_place_node = function(pos, placer)
        if not placer:is_player() then return end

        local meta = core.get_meta(pos)
        local pname = placer:get_player_name()

        meta:set_string("owner", pname);
        meta:set_string("infotext", S("Private tree trunk well (owned by @1)", pname));
        meta:set_string("public", "")
    end,

    can_dig = function(pos, player)
        if not (player and player:is_player()) then return end
        local meta = core.get_meta(pos)
        local owner = meta:get_string("owner")
        local pname = player:get_player_name()

        if owner ~= "" and owner ~= pname then
            return false
        end

        local inv = meta:get_inventory()
        return cottages.check_inventory_empty(inv, { "main", "bucket" })
    end,

    allow_metadata_inventory_move = function(pos, from_list, _, to_list, _, count, player)
        if to_list == "bucket" or from_list == "bucket" then
            -- That inventory slot is handled only by mod
            return 0
        end
        return cottages.player_can_use(core.get_meta(pos), player) and count or 0
    end,

    allow_metadata_inventory_put = function(pos, listname, _, stack, player)
        if listname == "main" then
            local meta = core.get_meta(pos)
            if not cottages.player_can_use(meta, player) then
                return 0
            end

            local stack_name = stack:get_name()
            if cottages.well_accepted_buckets[stack_name] then
                return stack:get_count()
            end
        end
        return 0
    end,

    allow_metadata_inventory_take = function(pos, listname, _, stack, player)
        if listname == "main" then
            local meta = core.get_meta(pos)
            if not cottages.player_can_use(meta, player) then
                return 0
            end

            return stack:get_count()
        end
        return 0
    end,

    on_blast = function(pos)
        core.get_node_timer(pos):stop()
        cottages.drop_inventory(pos, { "main", "bucket" })
        core.remove_node(pos)
    end,

    on_receive_fields = cottages.on_public_receive_fields,

    on_punch = function(pos, _, puncher)
        if not (puncher and puncher:is_player()) then return end

        local pname = puncher:get_player_name()
        local meta = core.get_meta(pos)
        if not cottages.player_can_use(meta, puncher) then
            local owner = meta:get_string("owner")
            core.chat_send_player(pname,
                S("This tree trunk well is owned by @1. You can't use it.", owner))
        end

        local pinv = puncher:get_inventory()
        local inv = meta:get_inventory()

        local bucket = inv:get_stack("bucket", 1)
        if not bucket:is_empty() then
            if cottages.well_accepted_buckets[bucket:get_name()] == ""
                or cottages.well_accepted_buckets[bucket:get_name()] == nil then
                -- That is, liquid filled
                -- Or it is invalid (avoid them sticking inside forever)
                if not pinv:room_for_item("main", bucket) then
                    core.chat_send_player(pname,
                        S("Insufficient inventory room for the bucket!"))
                    return
                end
                remove_well_entity(pos)
                pinv:add_item("main", bucket)
                inv:set_stack("bucket", 1, "")

                core.log("action", string.format(
                    "%s takes %s from tree trunk well at %s",
                    pname, bucket:to_string(), core.pos_to_string(pos)
                ))
            else
                core.chat_send_player(pname,
                    S("Please wait until your bucket has been filled."))
            end
            return
        end

        local stack = puncher:get_wielded_item()
        local stack_name = stack:get_name()

        if cottages.well_empty_buckets[stack_name] then
            puncher:set_wielded_item(cottages.well_empty_buckets[stack_name])
            return
        end

        if cottages.well_accepted_buckets[stack_name] and cottages.well_accepted_buckets[stack_name] ~= "" then
            local hand_bucket = stack:take_item()
            inv:set_stack("bucket", 1, hand_bucket)
            puncher:set_wielded_item(stack)

            core.log("action", string.format(
                "%s moves %s to tree trunk well at %s",
                pname, hand_bucket:to_string(), core.pos_to_string(pos)
            ))

            spawn_well_entity(pos, stack_name)

            local timer = core.get_node_timer(pos)
            timer:start(cottages.water_fill_time)
        end
    end,

    on_timer = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()

        local stack = inv:get_stack("bucket", 1)
        local filled_name = cottages.well_accepted_buckets[stack:get_name()]
        if filled_name and filled_name ~= "" then
            inv:set_stack("bucket", 1, filled_name)
            alter_well_entity(pos, filled_name)
        end
    end,
}
default.set_inventory_action_loggers(def, "tree trunk well")
core.register_node("cottages:water_gen", def)

core.register_lbm({
    label = "Move legacy bucket into inventory",
    name = "cottages:water_compact_legacy",
    nodenames = { 'cottages:water_gen' },
    run_at_every_load = false,
    action = function(pos)
        local meta = core.get_meta(pos)
        local bucket = meta:get_string("bucket")
        if bucket ~= "" then
            local inv = meta:get_inventory()
            inv:set_size("bucket", 1)
            inv:set_stack("bucket", 1, bucket)

            meta:set_string("bucket", "")
            meta:set_string("fillstarttime", "")

            -- Start timer, assume just started
            local timer = core.get_node_timer(pos)
            timer:start(cottages.water_fill_time)
        end
    end,
})

core.register_lbm({
    label = "Respawn vanished bucket entity",
    name = "cottages:water_spawn_entityy",
    nodenames = { 'cottages:water_gen' },
    run_at_every_load = true,
    action = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()
        local bucket = inv:get_stack("bucket", 1)

        if not bucket:is_empty() then
            check_well_entity(pos, bucket:get_name())
        end
    end,
})


core.register_craft({
    output = 'cottages:water_gen',
    recipe = {
        { 'default:stick', '',                    '' },
        { 'default:tree',  'bucket:bucket_empty', 'bucket:bucket_empty' },
        { 'default:tree',  'default:tree',        'default:tree' },
    }
})
