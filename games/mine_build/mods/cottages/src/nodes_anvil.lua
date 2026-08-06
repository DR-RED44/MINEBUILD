-- cottages/src/nodes_anvil.lua
-- Tool repairing anvil
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

core.register_tool("cottages:hammer", {
    short_description = S("Steel hammer"),
    description       = S("Steel hammer") .. "\n" .. S("For repairing tools on the anvil"),
    image             = "glooptest_tool_steelhammer.png",
    inventory_image   = "glooptest_tool_steelhammer.png",

    tool_capabilities = {
        full_punch_interval = 0.8,
        max_drop_level = 1,
        groupcaps = {
            -- about equal to a stone pick (it's not intended as a tool)
            cracky = { times = { [2] = 2.00, [3] = 1.20 }, uses = 30, maxlevel = 1 },
        },
        damage_groups = { fleshy = 6 },
    }
})

local cottages_anvil_formspec =
    "size[8,8]" ..
    "image[7,3;1,1;glooptest_tool_steelhammer.png]" ..
    "list[context;input;2.5,1.5;1,1;]" ..
    "list[context;hammer;5,3;1,1;]" ..
    "label[2.5,1.0;" .. F(S("Workpiece:")) .. "]" ..
    "label[6,2.7;" .. F(S("Optional\nhammer\nstorage")) .. "]" ..
    "label[0,0;" .. F(S("Anvil")) .. "]" ..
    "label[0,3.0;" .. F(S("Punch anvil with hammer to\nrepair tool in workpiece-slot.")) .. "]" ..
    "list[current_player;main;0,4;8,4;]" ..
    "listring[current_player;main]" ..
    "listring[context;input]" ..
    "listring[current_player;main]" ..
    "listring[context;hammer]"

-- Model from realtest
local anvil_node_box = {
    type = "fixed",
    fixed = {
        { -0.5,  -0.5, -0.3,  0.5,  -0.4, 0.3 },
        { -0.35, -0.4, -0.25, 0.35, -0.3, 0.25 },
        { -0.3,  -0.3, -0.15, 0.3,  -0.1, 0.15 },
        { -0.35, -0.1, -0.2,  0.35, 0.1,  0.2 },
    }
}

local function check_tool_input(stack)
    if stack:is_empty() or stack:get_wear() == 0 then
        return false
    end

    local name = stack:get_name()
    local def = core.registered_tools[name]
    if def then
        if def.wear_represents then
            -- Probably not normal tools
            -- e.g. liquid cans and RE tols from technic
            return false
        end

        return true
    end
    return false
end

local player_huds = {}
local function clear_hud(pname)
    local player = core.get_player_by_name(pname)
    if player and player_huds[pname] then
        if player_huds[pname].hud1 then
            player:hud_remove(player_huds[pname].hud1)
        end
        if player_huds[pname].hud2 then
            player:hud_remove(player_huds[pname].hud2)
        end
        if player_huds[pname].hud3 then
            player:hud_remove(player_huds[pname].hud3)
        end
    end

    player_huds[pname] = nil
end

core.register_on_leaveplayer(function(player)
    local pname = player:get_player_name()
    if player_huds[pname] then
        player_huds[pname].job:cancel()
        player_huds[pname] = nil
    end
end)

local def = {
    description = S("Anvil"),
    tiles = { "default_stone.png" },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { cracky = 2 },
    sounds = default.node_sound_metal_defaults(),

    node_box = anvil_node_box,
    selection_box = anvil_node_box,
    is_ground_content = false,

    on_construct = function(pos)
        local meta = core.get_meta(pos)
        local inv  = meta:get_inventory()

        meta:set_string("infotext", S("Anvil"))
        meta:set_string("formspec", cottages_anvil_formspec)
        inv:set_size("input", 1)
        inv:set_size("hammer", 1)
    end,
    after_place_node = function(pos, placer)
        if not placer:is_player() then return end

        local meta  = core.get_meta(pos)
        local pname = placer:get_player_name()
        meta:set_string("owner", pname)
        meta:set_string("infotext", S("Anvil (owned by @1)", pname))
    end,

    can_dig = function(pos, player)
        if not player:is_player() then return end

        local meta  = core.get_meta(pos)
        local pname = player:get_player_name()

        if not cottages.player_can_use(meta, player) then
            core.chat_send_player(pname, S("Can't dig node: @1", S("You are not the owner!")))
            return false
        end

        local inv = meta:get_inventory()
        if not cottages.check_inventory_empty(inv, { "input", "hammer" }) then
            core.chat_send_player(pname, S("Can't dig node: @1", S("Inventory is not empty!")))
            return false
        end

        return true
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, _, count, player)
        local meta = core.get_meta(pos)

        if to_list == "input" then
            local inv = meta:get_inventory()
            local stack = inv:get_stack(from_list, from_index)

            if check_tool_input(stack) then
                return stack:get_count()
            end
            local pname = player:get_player_name()
            if pname ~= "" then
                core.chat_send_player(pname, S("The workpiece slot is for damaged tools only."))
            end
            return 0
        end

        return cottages.player_can_use(meta, player) and count or 0
    end,
    allow_metadata_inventory_put = function(pos, listname, _, stack, player)
        if listname == "hammer" then
            if stack:get_name() ~= "cottages:hammer" then return 0 end
            local meta = core.get_meta(pos)
            return cottages.player_can_use(meta, player) and 1 or 0
        elseif listname == "input" then
            if check_tool_input(stack) then
                return stack:get_count()
            end
            local pname = player:get_player_name()
            if pname ~= "" then
                core.chat_send_player(pname, S("The workpiece slot is for damaged tools only."))
            end
            return 0
        end
        return 0
    end,
    allow_metadata_inventory_take = function(pos, listname, _, stack, player)
        if listname ~= "input" then
            local meta = core.get_meta(pos)
            if not cottages.player_can_use(meta, player) then
                return 0
            end
        end
        return stack:get_count()
    end,

    on_punch = function(pos, _, puncher)
        if not puncher:is_player() then return end
        local wielded = puncher:get_wielded_item();
        if wielded:get_name() ~= "cottages:hammer" then
            return
        end

        local pname = puncher:get_player_name();
        local meta  = core.get_meta(pos);
        local inv   = meta:get_inventory();

        local input = inv:get_stack("input", 1)

        if not check_tool_input(input) then
            return
        end

        local tool_name = input:get_name()
        local tool_def = core.registered_tools[tool_name]

        local hud_image
        if tool_def then
            if tool_def.inventory_image then
                hud_image = tool_def.inventory_image
            elseif tool_def.textures then
                local type_textures = type(tool_def.textures)
                if type_textures == "string" then
                    hud_image = tool_def.textures
                elseif type_textures == "table" then
                    hud_image = tool_def.textures[1]
                end
            end
        end

        if player_huds[pname] then
            player_huds[pname].job:cancel()
        end
        player_huds[pname] = player_huds[pname] or {}

        if player_huds[pname].hud1 then
            if hud_image then
                puncher:hud_change(player_huds[pname].hud1, "text", hud_image)
            else
                puncher:hud_remove(player_huds[pname].hud1)
                player_huds[pname].hud1 = nil
            end
        elseif hud_image then
            player_huds[pname].hud1 = puncher:hud_add({
                hud_elem_type = "image",
                scale = { x = 15, y = 15 },
                text = hud_image,
                position = { x = 0.5, y = 0.5 },
                alignment = { x = 0, y = 0 }
            })
        end

        if input:get_wear() > 0 then
            if not player_huds[pname].hud2 then
                -- HUD 2 is a static HUD for statbar background.
                player_huds[pname].hud2 = puncher:hud_add({
                    hud_elem_type = "statbar",
                    text = "default_cloud.png^[colorize:#ff0000:256",
                    number = 40,
                    direction = 0, -- left to right
                    position = { x = 0.5, y = 0.65 },
                    alignment = { x = 0, y = 0 },
                    offset = { x = -320, y = 0 },
                    size = { x = 32, y = 32 },
                })
            end

            -- 65535 is max damage
            local damage_state = 40 - math.floor(input:get_wear() / 1638)

            if player_huds[pname].hud3 then
                puncher:hud_change(player_huds[pname].hud3, "number", damage_state)
            else
                player_huds[pname].hud3 = puncher:hud_add({
                    hud_elem_type = "statbar",
                    text = "default_cloud.png^[colorize:#00ff00:256",
                    number = damage_state,
                    direction = 0, -- left to right
                    position = { x = 0.5, y = 0.65 },
                    alignment = { x = 0, y = 0 },
                    offset = { x = -320, y = 0 },
                    size = { x = 32, y = 32 },
                })
            end
        else
            if player_huds[pname].hud2 then
                puncher:hud_remove(player_huds[pname].hud2)
            end

            if player_huds[pname].hud3 then
                puncher:hud_remove(player_huds[pname].hud3)
            end
        end

        player_huds[pname].job = core.after(2, clear_hud, pname)

        -- do the actual repair
        input:add_wear(-5000) -- equals to what technic toolshop does in 5 seconds
        inv:set_stack("input", 1, input)

        -- damage the hammer slightly
        wielded:add_wear(100)
        puncher:set_wielded_item(wielded)
    end,
}

default.set_inventory_action_loggers(def, "anvil")

core.register_node("cottages:anvil", def)

core.register_craft({
    output = "cottages:anvil",
    recipe = {
        { "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
        { "",                    "default:steel_ingot", "" },
        { "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" } },
})

-- the castle-mod has an anvil as well - with the same receipe. convert the two into each other
if core.get_modpath("castle") ~= nil then
    core.unregister_craft({
        output = "castle:anvil",
        recipe = {
            { "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
            { "",                    "default:steel_ingot", "" },
            { "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" } },
    })

    core.register_craft({
        output = "cottages:anvil",
        recipe = {
            { 'castle:anvil' },
        },
    })

    core.register_craft({
        output = "castle:anvil",
        recipe = {
            { 'cottages:anvil' },
        },
    })
end

core.register_craft({
    output = "cottages:hammer",
    recipe = {
        { "default:steel_ingot" },
        { "cottages:anvil" },
        { "default:stick" } }
})
