-- cottages/src/nodes_feldweg.lua
-- Register dirt paths
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

local register_feldweg_node = function(node_name, def)
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, crumbly = 2 }
	def.sounds = default.node_sound_dirt_defaults()
	def.is_ground_content = false

	core.register_node(node_name, def)
end
function cottages.register_feldweg(suffix, texture_top, texture_bottom, texture_side, name_suffix,
								   texture_side_with_dent, texture_edges)
	register_feldweg_node(":cottages:feldweg" .. suffix, {
		description = S("Dirt road @1", name_suffix),
		tiles = { texture_side_with_dent,
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			texture_edges },
		drawtype = "mesh",
		mesh = "feldweg.obj",
	})

	register_feldweg_node("cottages:feldweg_crossing" .. suffix, {
		description = S("Dirt road crossing @1", name_suffix),
		tiles = { texture_side_with_dent,
			texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			texture_edges },
		drawtype = "mesh",
		mesh = "feldweg-crossing.obj",
	})

	register_feldweg_node("cottages:feldweg_t_junction" .. suffix, {
		description = S("Dirt road T-junction @1", name_suffix),
		tiles = { texture_side_with_dent,
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			texture_edges },
		drawtype = "mesh",
		mesh = "feldweg-T-junction.obj",
	})

	register_feldweg_node("cottages:feldweg_curve" .. suffix, {
		description = S("Dirt road curve @1", name_suffix),
		tiles = {
			texture_side, texture_top,
			texture_side,
			"cottages_feldweg_surface.png",
			texture_bottom,
			texture_edges,
			texture_side,
			texture_bottom,
			texture_top, },
		drawtype = "mesh",
		mesh = "feldweg-curve.obj",
	})

	register_feldweg_node("cottages:feldweg_end" .. suffix, {
		description = S("Dirt road end @1", name_suffix),
		tiles = { texture_side_with_dent,
			texture_side, texture_bottom, texture_top,
			texture_edges,
			"cottages_feldweg_surface.png" },
		drawtype = "mesh",
		mesh = "feldweg_end.obj",
	})

	register_feldweg_node("cottages:feldweg_45" .. suffix, {
		description = S("Dirt road 45º @1", name_suffix),
		tiles = {
			"cottages_feldweg_surface.png",
			texture_edges,
			texture_side, texture_bottom, texture_top,
		},
		drawtype = "mesh",
		mesh = "feldweg_45.b3d",
	})

	register_feldweg_node("cottages:feldweg_s_45" .. suffix, {
		description = S("Dirt road 45º edge @1", name_suffix),
		tiles = {
			texture_top, texture_side, texture_bottom,
			"cottages_feldweg_surface.png",
			texture_edges,
		},
		drawtype = "mesh",
		mesh = "feldweg_s_45.b3d",
	})

	register_feldweg_node("cottages:feldweg_d_45" .. suffix, {
		description = S("Dirt road 45º double edge @1", name_suffix),
		tiles = {
			texture_side, texture_bottom, texture_top,
			texture_edges,
			"cottages_feldweg_surface.png",
		},
		drawtype = "mesh",
		mesh = "feldweg_d_45.b3d",
	})

	register_feldweg_node("cottages:feldweg_l_curve" .. suffix, {
		description = S("Dirt road left curve @1", name_suffix),
		tiles = {
			texture_side, texture_bottom, texture_top,
			texture_edges,
			"cottages_feldweg_surface.png",
		},
		drawtype = "mesh",
		mesh = "feldweg_l_45_curve.b3d",
	})

	register_feldweg_node("cottages:feldweg_r_curve" .. suffix, {
		description = S("Dirt road right curve @1", name_suffix),
		tiles = {
			texture_side, texture_bottom, texture_top,
			texture_edges,
			"cottages_feldweg_surface.png",
		},
		drawtype = "mesh",
		mesh = "feldweg_r_45_curve.b3d",
	})

	-- Slopes
	local box_slope = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5,  -0.5,  0.5, -0.25, 0.5 },
			{ -0.5, -0.25, -0.25, 0.5, 0,     0.5 },
			{ -0.5, 0,     0,     0.5, 0.25,  0.5 },
			{ -0.5, 0.25,  0.25,  0.5, 0.5,   0.5 }
		}
	}

	local box_slope_long = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5,  -1.5, 0.5, -0.10, 0.5 },
			{ -0.5, -0.25, -1.3, 0.5, -0.25, 0.5 },
			{ -0.5, -0.25, -1.0, 0.5, 0,     0.5 },
			{ -0.5, 0,     -0.5, 0.5, 0.25,  0.5 },
			{ -0.5, 0.25,  0,    0.5, 0.5,   0.5 }
		}
	}

	register_feldweg_node("cottages:feldweg_slope" .. suffix, {
		description = S("Dirt road slope @1", name_suffix),
		tiles = { texture_side_with_dent,
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			texture_edges },
		drawtype = "mesh",
		mesh = "feldweg_slope.obj",

		collision_box = box_slope,
		selection_box = box_slope,
	})

	register_feldweg_node("cottages:feldweg_slope_long" .. suffix, {
		description = S("Dirt road slope long @1", name_suffix),
		tiles = { texture_side_with_dent,
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			texture_edges },
		drawtype = "mesh",
		mesh = "feldweg_slope_long.obj",
		collision_box = box_slope_long,
		selection_box = box_slope_long,
	})
end

function cottages.register_feldweg_recipe(suffix, base_craftitem)
	local base_node = "cottages:feldweg" .. suffix

	core.register_craft({
		output = base_node .. " 4",
		recipe = {
			{ "",             "cottages:wagon_wheel", "" },
			{ base_craftitem, base_craftitem,         base_craftitem }
		},
		replacements = { { 'cottages:wagon_wheel', 'cottages:wagon_wheel' }, }
	})

	core.register_craft({
		output = "cottages:feldweg_crossing" .. suffix .. " 5",
		recipe = {
			{ "",        base_node, "" },
			{ base_node, base_node, base_node },
			{ "",        base_node, "" },
		},
	})

	core.register_craft({
		output = "cottages:feldweg_t_junction" .. suffix .. " 5",
		recipe = {
			{ "",        base_node, "" },
			{ "",        base_node, "" },
			{ base_node, base_node, base_node }

		},
	})

	core.register_craft({
		output = "cottages:feldweg_curve" .. suffix .. " 5",
		recipe = {
			{ base_node, "",        "" },
			{ base_node, "",        "" },
			{ base_node, base_node, base_node }
		},
	})

	core.register_craft({
		output = "cottages:feldweg_end" .. suffix .. " 5",
		recipe = {
			{ base_node, "",        base_node },
			{ base_node, base_node, base_node }
		},
	})

	core.register_craft({
		output = "cottages:feldweg_45" .. suffix,
		recipe = { { base_node } }
	})
	core.register_craft({
		output = "cottages:feldweg_l_curve" .. suffix,
		recipe = { { "cottages:feldweg_45" .. suffix } }
	})
	core.register_craft({
		output = "cottages:feldweg_r_curve" .. suffix,
		recipe = { { "cottages:feldweg_l_curve" .. suffix } }
	})
	core.register_craft({
		output = "cottages:feldweg_s_45" .. suffix,
		recipe = { { "cottages:feldweg_r_curve" .. suffix } }
	})
	core.register_craft({
		output = "cottages:feldweg_d_45" .. suffix,
		recipe = { { "cottages:feldweg_s_45" .. suffix } }
	})
	core.register_craft({
		output = "cottages:feldweg" .. suffix,
		recipe = { { "cottages:feldweg_d_45" .. suffix } }
	})

	core.register_craft({
		output = "cottages:feldweg_slope" .. suffix .. " 3",
		recipe = {
			{ base_node, "",        "" },
			{ base_node, base_node, "" }
		},
	})

	core.register_craft({
		output = "cottages:feldweg_slope_long" .. suffix .. " 4",
		recipe = {
			{ base_node, "",        "" },
			{ base_node, base_node, base_node }
		},
	})
end

-- Default variants
local variants = {}
variants["grass"] = {
	"default_grass.png",
	"default_dirt.png",
	"default_dirt.png^default_grass_side.png",
	"",
	"default:dirt",
	S("on grass"),
	"cottages_feldweg_end.png",
	"cottages_feldweg_surface.png^cottages_feldweg_edges.png",
}
variants["gravel"] = {
	"default_gravel.png", -- grass top
	"default_gravel.png", -- bottom
	"default_gravel.png", -- side
	"_gravel",
	"default:gravel",
	S("on gravel"),
	"default_gravel.png",
	"cottages_feldweg_surface.png^default_gravel.png",
}
variants["coniferous"] = {
	"default_coniferous_litter.png",                       -- grass top
	"default_dirt.png",                                    -- bottom
	"default_dirt.png^default_coniferous_litter_side.png", -- side
	"_coniferous",
	"default:dirt_with_coniferous_litter",
	S("on coniferious litter"),
	"default_dirt.png^default_coniferous_litter_side.png", -- side with dent
	"cottages_feldweg_surface.png^default_coniferous_litter.png",
}
variants["snow"] = {
	"default_snow.png",                       -- grass top
	"default_dirt.png",                       -- bottom
	"default_dirt.png^default_snow_side.png", -- side
	"_snow",
	"default:dirt_with_snow",
	S("on snow"),
	"default_dirt.png^default_snow_side.png", -- side
	"cottages_feldweg_surface.png^default_snow.png",
}
variants["dry"] = {
	"default_dry_grass.png",                       -- grass top
	"default_dirt.png",                            -- bottom
	"default_dirt.png^default_dry_grass_side.png", -- side
	"_dry",
	"default:dry_dirt",
	S("on dry dirt"),
	"default_dirt.png^default_dry_grass_side.png", -- side
	"cottages_feldweg_surface.png^default_dry_grass.png",
}
if core.get_modpath("ethereal") then
	variants["bamboo"] = {
		"ethereal_grass_bamboo_top.png",                   -- grass top
		"default_dirt.png",                                -- bottom
		"default_dirt.png^ethereal_grass_bamboo_side.png", -- side
		"_bamboo",
		"ethereal:bamboo_dirt",
		S("on bamboo dirt"),
		"default_dirt.png^ethereal_grass_bamboo_side.png", -- side
		"cottages_feldweg_surface.png^ethereal_grass_bamboo_top.png",
	}
end

for _, v in pairs(variants) do
	cottages.register_feldweg(v[4], v[1], v[2], v[3], v[6], v[7], v[8])
	cottages.register_feldweg_recipe(v[4], v[5])
end
