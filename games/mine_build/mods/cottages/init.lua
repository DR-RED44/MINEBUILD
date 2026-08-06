-- cottages/init.lua
-- Decorations that fit to medieval settlements and small cottages
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

cottages = {
    fork = "1F616EMO",
    S = core.get_translator("cottages"),
    MP = core.get_modpath("cottages")
}

for _, name in ipairs({
    "functions",
    "compact",
    "alias",
    "nodes_anvil",
    "nodes_barrel",
    "nodes_doorlike",
    "nodes_feldweg",
    "nodes_fences",
    "nodes_furniture",
    "nodes_pitchfork", -- This must come before hay
    "nodes_hay",
    "nodes_historic",
    "nodes_mining",
    "nodes_roof",
    "nodes_straw",
    "nodes_threshing_floor",
    "nodes_mill",
    "nodes_water",
}) do
    dofile(cottages.MP .. "/src/" .. name .. ".lua")
end
