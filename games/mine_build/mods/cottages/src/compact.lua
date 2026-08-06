-- cottages/src/compact.lua
-- Compactibility with old cottage
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

-- NPC chests don't seem to be in use

for _, name in ipairs({
    "cottages:chest_private",
    "cottages:chest_work",
    "cottages:chest_storage"
}) do
    core.register_node(name, {
        tiles = core.registered_nodes["default:chest"].tiles,
        paramtype2 = "facedir",
        groups = { not_in_creative_inventory = 1, legacy_cottages_chests = 1 },
        legacy_facedir_simple = true,
        diggable = false,
    })
end

core.register_lbm({
    label = "Convert old cottags NPC chests",
    name = "cottages:compact_npc_chest",
    nodenames = { "group:legacy_cottages_chests" },
    run_at_every_load = false,
    action = function(pos, node)
        node.name = "default:chest"
        core.set_node(pos, node)
    end,
})
