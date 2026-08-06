-- katana--
minetest.register_tool('medieval_weapons:katana',{
   description = 'katana',
   inventory_image = 'katana.png',
   tool_capabilities = {
      full_punch_interval = 0.1, --amount of seconds between repeating action--
      max_drop_level = 1, --not shure what this does--
      damage_groups = {fleshy=15}, --damage delt to fleshy (mobs/players)--
   },
   range = 6,
})

minetest.register_craft({
   output = "medieval_weapons:katana",
   recipe ={
      {"","","default:steel_ingot"},
      {"","default:steel_ingot",""},
      {"medieval_weapons:hilt","",""},
   },
})

--sabre--
minetest.register_tool('medieval_weapons:sabre',{
   description = 'sabre',
   inventory_image = 'sabre.png',
   tool_capabilities = {
      full_punch_interval = 1, --amout of seconds between  repeating action--
      max_drop_level = 1, --not shure what this does--
      damage_groups= {fleshy = 17}, --damage delt to flesh (mobs/players)--
   },
   range = 4,
})

minetest.register_craft({
   output = "medieval_weapons:sabre",
   recipe ={
      {"","","default:steel_ingot"},
      {"medieval_weapons:hilt","default:steel_ingot",""},
      {"default:steel_ingot","",""},
   },
})

--axe--
minetest.register_tool('medieval_weapons:axe',{
   description = 'axe',
   inventory_image = 'axe.png',
   tool_capabilities = {
      full_punch_interval = 1.5,
      max_drop_level = 1,
      damage_groups = {fleshy = 20},
   },
   range = 3,
})

minetest.register_craft({
   output = "medieval_weapons:axe",
   recipe ={
      {"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
      {"default:steel_ingot","medieval_weapons:hilt","default:steel_ingot"},
      {"","medieval_weapons:hilt",""},
   },
})

--hilt for katana , sabre and axe--

minetest.register_tool ("medieval_weapons:hilt",{
   description = "hilt",
   inventory_image = "hilt.png"
})

minetest.register_craft({
   output = "medieval_weapons:hilt",
   recipe ={
      {"","","default:stick"},
      {"farming:cotton","default:stick","farming:cotton"},
      {"default:stick","",""},
   },
})
-- if anyone can tell me how to make the hilt without this weird tool stuff and all , pls write it out in the package comments--

--khopesh -- 
minetest.register_tool('medieval_weapons:khopesh',{
   description = 'khopesh',
   inventory_image = 'khopesh.png',
   tool_capabilities = {
      full_punch_interval = 0.2, --amount of seconds between repeating action--
      max_drop_level = 1, --not shure what this does--
      damage_groups = {fleshy=17}, --damage delt to fleshy (mobs/players)--
   },
   range = 8,
})

minetest.register_craft({
   output = "medieval_weapons:khopesh",
   recipe ={
      {"","","default:steel_ingot"},
      {"","default:steel_ingot",""},
      {"medieval_weapons:hilt","default:steel_ingo",""},
   },
})

--dagger--
minetest.register_tool("medieval_weapons:dagger",{
description="dagger",
inventory_image="dagger.png",
 tool_capabilities = {
      full_punch_interval = 0.02, --amount of seconds between repeating action--
      max_drop_level = 1, --not shure what this does--
      damage_groups = {fleshy=4}, --damage delt to fleshy (mobs/players)--
   },
   range = 8,
})

minetest.register_craft({
output = "medieval_weapons:dagger",
recipe = {
	{"","default:steel_ingot",""},
	{"","default:steel_ingot",""},
	{"","medieval_weapons:hilt",""},
	},
})