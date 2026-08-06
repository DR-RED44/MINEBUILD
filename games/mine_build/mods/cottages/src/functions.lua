-- cottages/src/functions.lua
-- Functions used internally
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

function cottages.player_can_use(meta, player)
    if not player:is_player() then
        return false
    end
    local pname = player:get_player_name()
    local privs = core.get_player_privs(pname)

    if privs.protection_bypass or privs.server then
        return true
    end

    local owner = meta:get_string('owner')
    local public = meta:get_string('public')

    if public == "public" or owner == "" or owner == pname then
        return true
    end
    return false
end

function cottages.check_inventory_empty(inv, lists)
    for _, list in ipairs(lists) do
        if not inv:is_empty(list) then
            return false
        end
    end
    return true
end

function cottages.toggle_public(pos, player)
    local node = core.get_node_or_nil(pos)
    if not node then return false end

    local def = core.registered_nodes[node.name]
    if not def then return false end

    local meta = core.get_meta(pos)
    local curr_status = meta:get_string("public")

    if curr_status == "public" then
        local owner = meta:get_string("owner")
        if owner == "" then
            -- Assume the player operating the node is the owner
            -- (The node had no owner before)
            if not player:is_player() then return end
            owner = player:get_player_name()
            meta:set_string("owner", owner)
        end

        -- Turn it into private
        meta:set_string("public", "")

        if def._private_translate_key then
            meta:set_string("infotext", S(def._private_translate_key, owner))
        end
    else
        -- Turn it into public
        meta:set_string("public", "public")

        if def._public_translate_key then
            meta:set_string("infotext", S(def._public_translate_key))
        end
    end
end

function cottages.get_public_infotext(pos)
    local node = core.get_node_or_nil(pos)
    if not node then return "" end

    local def = core.registered_nodes[node.name]
    if not def then return "" end

    local meta = core.get_meta(pos)
    local owner = meta:get_string("owner")
    local curr_status = meta:get_string("public")

    if curr_status == "public" or owner == "" then
        if def._public_translate_key then
            meta:set_string("infotext", S(def._public_translate_key))
        end
    else
        if def._private_translate_key then
            return S(def._private_translate_key, owner)
        end
    end
    return ""
end

function cottages.on_public_receive_fields(pos, _, fields, sender)
    if fields.public then
        local meta = core.get_meta(pos)
        local pname = sender:get_player_name()
        local owner = meta:get_string("owner")

        if owner == "" or owner == pname then
            cottages.toggle_public(pos, sender)
        end
    end
end

function cottages.drop_inventory(pos, lists)
    local meta = core.get_meta(pos)
    local inv = meta:get_inventory()
    for _, list in ipairs(lists) do
        local items = inv:get_list(list)
        for _, stack in ipairs(items) do
            core.add_item(pos, stack)
        end
    end
end

function cottages.derive_blocks(modname, nodename, def)
    local name = modname .. ":" .. nodename
    if not def then
        def = assert(core.registered_nodes[name])
    end

    if core.global_exists("stairsplus") then
        stairsplus:register_all(modname, nodename, name, {
            description = def.description,
            tiles = def.tiles,
            groups = def.groups,
            sounds = def.sounds,
        })
    elseif core.global_exists("stairs") then
        if stairs.mod == "redo" then
            stairs.register_all(nodename, name,
            def.groups,
            def.tiles,
            def.description,
            def.sounds)
        else
            stairs.register_stair_and_slab(nodename, name,
            def.groups,
            def.tiles,
            S("@1 Stairs", def.description),
            S("@1 Slab", def.description),
            def.sounds,
            nil,
            S("@1 Stairs (Inner)", def.description),
            S("@1 Slab (Outer)", def.description))
        end
    end
end
