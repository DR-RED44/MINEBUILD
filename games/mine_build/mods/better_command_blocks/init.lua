local S = core.get_translator(core.get_current_modname())

better_command_blocks = {}

local anim = { type = "vertical_frames" }

local chain_tracker = {}

local mesecons_rules = {
    { x = 0,  y = 0,  z = 1 },
    { x = 0,  y = 0,  z = -1 },
    { x = 0,  y = 1,  z = 0 },
    { x = 0,  y = -1, z = 0 },
    { x = 1,  y = 0,  z = 0 },
    { x = -1, y = 0,  z = 0 },
}

---Gets a metadata string or a fallback falue
---@param meta core.MetaDataRef
---@param key string
---@param fallback any
---@return any
local function get_string_or(meta, key, fallback)
    local result = meta:get_string(key)
    return result == "" and fallback or result
end

local command_blocks = {
    { type = "impulse",   name = "Impulse",   description = S("Command Block") },
    { type = "repeating", name = "Repeating", description = S("Repeating @1", S("Command Block")) },
    { type = "chain",     name = "Chain",     description = S("Chain @1", S("Command Block")) },
}

local copy_keys = {
    "_command",
    "_power",
    "_delay",
    "_first_tick",
    "_success",
    "_message",
    "_count",
    "infotext"
}

local function copy_meta(source, dest)
    for _, key in pairs(copy_keys) do
        dest:set_string(key, source:get_string(key))
    end
end

better_command_blocks.command_block_itemstrings = {}

---Opens command block formspec
---@param pos vector.Vector
---@param node core.Node
---@param player core.Player
local function on_rightclick(pos, node, player, held_item)
    if not core.check_player_privs(player, "better_command_blocks") then return end
    local meta = core.get_meta(pos)
    local node_info = core.registered_items[node.name]._better_command_blocks
    if not node_info then return held_item end

    local command = meta:get_string("_command")
    local power = meta:get_string("_power")
    local delay = get_string_or(meta, "_delay", (node_info.type == "repeating") and "1" or "0")
    local note = meta:get_string("infotext")
    local message = meta:get_string("_message")
    local first_tick = meta:get_string("_first_tick")
    local group = core.get_item_group(node.name, "command_block")

    if player:get_player_control().aux1 then
        local itemstack = ItemStack(node.name)
        local item_meta = itemstack:get_meta()
        copy_meta(meta, item_meta)
        item_meta:set_string("_stored_command", "true")
        local command_string = command
        if #command_string > 35 then
            command_string = command_string:sub(1, 32) .. "..."
        end
        command_string = minetest.colorize("#555555", "[" .. command_string .. "]")
        item_meta:set_string("description", itemstack:get_description() .. "\n" .. command_string)
        player:get_inventory():add_item("main", itemstack)
        return player:get_wielded_item()
    end
    local formspec = table.concat({
        "formspec_version[4]",
        "size[14,10]",
        "no_prepend[]",
        "set_focus[command]",

        "label[0.5,0.5;", ItemStack(node.name):get_short_description(), "]",

        "checkbox[11,1.5;first_tick;Execute on first tick;", first_tick ~= "false" and "true" or "false", "]",

        "field[0.5,1.5;4.5,0.7;note;Hover Note;", note, "]",
        "button[5,1.5;1,0.7;set_note;Set]",
        "field_close_on_enter[note;false]",

        "field[6.5,1.5;2,0.7;delay;Delay (s);", delay, "]",
        "button[8.5,1.5;1,0.7;set_delay;Set]",
        "field_close_on_enter[delay;false]",

        "textarea[0.5,3;12,4;command;Commands;", core.formspec_escape(command), "]",
        "field_close_on_enter[command;false]",
        "button[12.5,3;1,0.7;set_command;Set]",

        "button[0.5,7.5;4.3,0.7;type;", command_blocks[(group % 3 == 0) and 3 or (group % 3)].name, "]",
        "button[4.85,7.5;4.3,0.7;conditional;", node_info.conditional and "Conditional" or "Unconditional", "]",
        "button[9.2,7.5;4.3,0.7;power;", power ~= "false" and "Needs Power" or "Always Active", "]",

        "textarea[0.5,9;12,0.7;;Previous output;", core.formspec_escape(message), "]",
    })
    local player_name = player:get_player_name()
    core.show_formspec(player_name, "better_command_blocks:" .. core.pos_to_string(pos), formspec)
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if not core.check_player_privs(player, "better_command_blocks") then return end
    -- better_command_blocks:(x,y,z)
    if not formname:match("^better_command_blocks:.*") then return end
    local pos = core.string_to_pos(formname:match("^better_command_blocks:(%(%-?[%d%.]+,%-?[%d%.]+,%-?[%d%.]+%))$"))
    if not pos then return end
    local meta = core.get_meta(pos)
    local node = core.get_node(pos)
    local group = core.get_item_group(node.name, "command_block")
    local node_info = core.registered_items[node.name]._better_command_blocks
    if not node_info then return end
    local show_formspec
    if fields.command then
        meta:set_string("_command", fields.command)
    end
    if fields.note then
        meta:set_string("infotext", fields.note)
    end
    local delay = tonumber(fields.delay)
    if delay and delay >= 0 then
        meta:set_string("_delay", fields.delay)
    end
    if fields.first_tick then
        meta:set_string("_first_tick", fields.first_tick)
    end
    if fields.key_enter_field == "command" or fields.set_command then
        show_formspec = true
    elseif fields.key_enter_field == "delay" or fields.set_delay then
        show_formspec = true
    elseif fields.type then
        local new_group = (group - ((group - 1) % #command_blocks)) + (group % #command_blocks)
        local new_node = table.copy(node)
        new_node.name = better_command_blocks.command_block_itemstrings[new_group]
        core.swap_node(pos, new_node)
        local new_node_info = core.registered_items[new_node.name]._better_command_blocks
        if new_node_info.type == "repeating" then
            if (tonumber(meta:get_string("_delay")) or 1) < 1 then
                meta:set_string("_delay", "1")
            end
        elseif node_info.type == "repeating" then -- previous = repeating
            if (tonumber(meta:get_string("_delay")) or 1) == 1 then
                meta:set_string("_delay", "0")
            end
        end
        if new_node_info.type == "repeating" then
            core.get_node_timer(pos):start(1)
        else
            core.get_node_timer(pos):stop()
        end
        show_formspec = true
    elseif fields.conditional then
        -- this is just bad but it works
        local new_group
        if math.floor((group - 1) / #command_blocks) % 2 == 1 then
            new_group = group - #command_blocks
        else
            new_group = group + #command_blocks
        end
        local new_node = table.copy(node)
        new_node.name = better_command_blocks.command_block_itemstrings[new_group]
        core.swap_node(pos, new_node)
        show_formspec = true
    elseif fields.power then
        local result = fields.power == "Needs Power" and "false" or "true"
        meta:set_string("_power", result)
        if result == "false" then
            if node_info.type ~= "chain" then
                better_command_blocks.trigger(pos)
            end
        end
        show_formspec = true
    end

    if show_formspec then
        on_rightclick(pos, core.get_node(pos), player)
    end
end)

---Checks for chain command blocks in front of the current command block
---@param pos vector.Vector
function better_command_blocks.check_for_chain(pos)
    local dir = core.facedir_to_dir(core.get_node(pos).param2)
    local next = vector.add(dir, pos)
    local next_node = core.get_node(next)
    local next_group = core.get_item_group(core.get_node(next).name, "command_block")
    if next_group == 0 then return end
    local string_pos = core.pos_to_string(next)
    if core.registered_items[next_node.name]._better_command_blocks.type == "chain" and not chain_tracker[string_pos] then
        chain_tracker[core.pos_to_string(next)] = true
        better_command_blocks.trigger(next)
        core.after(0, function() chain_tracker[core.pos_to_string(next)] = false end)
    end
end

---Runs commands
---@param pos vector.Vector
function better_command_blocks.run_commands(pos)
    local node = core.get_node(pos)
    local meta = core.get_meta(pos)
    local node_info = core.registered_items[node.name]._better_command_blocks

    -- Other mods' commands may require a valid player name.
    local name = meta:get_string("_player")

    if meta:get_string("_power") ~= "false" then
        if meta:get_string("_mesecons_active") ~= "true" then
            better_command_blocks.check_for_chain(pos)
            return
        end
    end

    if node_info.conditional then
        local dir = core.facedir_to_dir(node.param2)
        local previous = pos - dir
        if core.get_meta(previous):get_int("_success") < 1 then
            better_command_blocks.check_for_chain(pos)
            return
        end
    end

    local commands = meta:get_string("_command"):split("\n", false)

    local success, message, count

    for _, command in pairs(commands) do
        local command_name, param = command:match("%/?(%S+)%s*(.*)$")
        local def = core.registered_chatcommands[command_name]

        if not def then
            success = false
            count = -1
            message = S("Invalid command: @1", command_name or "nil")
            break
        end

        if def.real_func then -- Better Commands
            local context = {
                executor = pos,
                pos = pos,
                command_block = true,
                dir = core.facedir_to_dir(core.get_node(pos).param2),
            }
            if better_commands then context = better_commands.complete_context(S("Command Block"), context) end
            success, message, count = def.real_func(name, param, context)
        else -- Normal command
            if not (name and name ~= "") then
                success = false
                count = -1
                message = S("Command block was not placed by a player, and can only run Better Commands.")
                break
            elseif not core.get_player_by_name(name) then
                success = false
                count = -1
                message = S("Placer is not online; only Better Commands will work.")
                break
            end
            success, message = def.func(name, param)
        end

        --[[if success == true then
            success = 1
        elseif success == false then
            success = 0
        end]]
        if success == 1 and message and message ~= "" then
            if core.settings:get_bool("better_command_blocks.command_block_output", true)
                and ((not better_commands) or (better_commands and core.settings:get_bool("better_commands.send_command_feedback", true))) then
                core.chat_send_all(core.colorize("#aaaaaa", S(
                    "[@1: @2]",
                    S("Command Block"),
                    core.strip_colors(message)
                )))
            end
        end
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    meta:set_int("_success", (success == true and 1) or (success or 0))
    meta:set_string("_message", message or "")
    meta:set_int("_count", count or -1)

    if node_info.type == "repeating" then
        core.get_node_timer(pos):start(tonumber(meta:get_string("_delay")) or 1)
    end
    better_command_blocks.check_for_chain(pos)
end

---Triggers the command block
---@param pos vector.Vector
function better_command_blocks.trigger(pos)
    local node = core.get_node(pos)
    local meta = core.get_meta(pos)

    local node_info = core.registered_items[node.name]._better_command_blocks

    local delay = tonumber(meta:get_string("_delay")) or 1

    if delay == 0 or meta:get_string("_first_tick") then
        better_command_blocks.run_commands(pos)
        if node_info.type == "repeating" then
            core.get_node_timer(pos):start(delay)
        end
    else
        core.get_node_timer(pos):start(delay)
    end
end

---Runs when activated by Mesecons
---@param pos vector.Vector
local function mesecons_activate(pos)
    local meta = core.get_meta(pos)
    meta:set_string("_mesecons_active", "true")
    if meta:get_string("_power") ~= "false" then
        local node_info = core.registered_items[core.get_node(pos).name]._better_command_blocks
        if node_info.type ~= "chain" then
            better_command_blocks.trigger(pos)
        end
    end
end

---Runs when deactivated by Mesecons
---@param pos vector.Vector
local function mesecons_deactivate(pos)
    local meta = core.get_meta(pos)
    meta:set_string("_mesecons_active", "")
    if meta:get_string("_power") ~= "false" then
        core.get_node_timer(pos):stop()
    end
end

for i, node in pairs(command_blocks) do
    local def = {
        description = node.description,
        groups = { oddly_breakable_by_hand = 3, cracky = 3, command_block = i, creative_breakable = 1, mesecon_effector_off = 1, mesecon_effector_on = 1, },
        tiles = {
            { name = "better_command_blocks_" .. node.type .. "_top.png",    animation = anim },
            { name = "better_command_blocks_" .. node.type .. "_bottom.png", animation = anim },
            { name = "better_command_blocks_" .. node.type .. "_right.png",  animation = anim },
            { name = "better_command_blocks_" .. node.type .. "_left.png",   animation = anim },
            { name = "better_command_blocks_" .. node.type .. "_front.png",  animation = anim },
            { name = "better_command_blocks_" .. node.type .. "_back.png",   animation = anim },
        },
        paramtype2 = "facedir",
        on_rightclick = on_rightclick,
        on_timer = better_command_blocks.run_commands,
        mesecons = {
            effector = {
                action_on = mesecons_activate,
                action_off = mesecons_deactivate,
                rules = mesecons_rules
            },
        },
        _better_command_blocks = { type = node.type, conditional = false },
        _mcl_blast_resistance = 3600000,
        _mcl_hardness = -1,
        can_dig = function(pos, player)
            return core.check_player_privs(player, "better_command_blocks")
        end,
        drop = "",
        on_place = function(itemstack, player, pointed_thing)
            if core.check_player_privs(player, "better_command_blocks") then
                return core.item_place(itemstack, player, pointed_thing)
            end
        end,
        after_place_node = function(pos, placer, itemstack, pointed_thing)
            local node = minetest.get_node(pos)
            node.param2 = core.dir_to_facedir(placer:get_look_dir() * -1, true)
            core.swap_node(pos, node)
            local meta = core.get_meta(pos)
            meta:set_string("_player", placer:get_player_name())
            local item_meta = itemstack:get_meta()
            if item_meta:get_string("_stored_command") == "true" then
                copy_meta(item_meta, meta)
                local node_info = core.registered_items[itemstack:get_name()]._better_command_blocks
                if node_info.type ~= "chain" and meta:get_string("_power") == "false" then
                    better_command_blocks.trigger(pos)
                end
            end
        end
    }
    local itemstring = "better_command_blocks:" .. node.type .. "_command_block"
    core.register_node(itemstring, def)
    better_command_blocks.command_block_itemstrings[i] = itemstring

    local conditional_def = table.copy(def)
    conditional_def.groups.not_in_creative_inventory = 1
    conditional_def.groups.command_block = i + #command_blocks
    conditional_def.description = S("Conditional @1", node.description)
    conditional_def._better_command_blocks = { type = node.type, conditional = true }
    conditional_def.tiles = {
        { name = "better_command_blocks_" .. node.type .. "_conditional_top.png",    animation = anim },
        { name = "better_command_blocks_" .. node.type .. "_conditional_bottom.png", animation = anim },
        { name = "better_command_blocks_" .. node.type .. "_conditional_right.png",  animation = anim },
        { name = "better_command_blocks_" .. node.type .. "_conditional_left.png",   animation = anim },
        { name = "better_command_blocks_" .. node.type .. "_front.png",              animation = anim },
        { name = "better_command_blocks_" .. node.type .. "_back.png",               animation = anim },
    }
    itemstring = "better_command_blocks:" .. node.type .. "_command_block_conditional"
    core.register_node(itemstring, conditional_def)
    better_command_blocks.command_block_itemstrings[i + #command_blocks] = itemstring
end

core.register_alias("better_command_blocks:command_block", "better_command_blocks:impulse_command_block")
core.register_alias("better_command_blocks:command_block_conditional",
    "better_command_blocks:impulse_command_block_conditional")

---@diagnostic disable-next-line: missing-fields
core.register_privilege("better_command_blocks", {
    description = S("Allows players to use Better Command Blocks"),
    give_to_singleplayer = false,
    give_to_admin = true
})
