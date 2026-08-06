# Cottages: Decorations that fit to medieval settlements and small cottages

This mod is a rewrite of [Sokomine's cottage mod](https://github.com/Sokomine/cottages), commit [`dbe69bc`](https://github.com/Sokomine/cottages/commit/dbe69bcfafa2efc256554b9fa3b9196b35928f1e). Some bug fixes and enhancements are adopted from [Smacker's fork](https://github.com/h-v-smacker/cottages).

This mod is a drop-in replacement in terms of player experience; most things will work as they were. However, some changes are made, and API compatibility is not guaranteed.


## List of notable changes

### Initial fork release

* Players with `protection_bypass` or `server` can interact with any private nodes.
* Window shutters no longer close or open with the sunlight.
* Only one type of feldweg is left: the mesh type with 45 degree slope.
* Removed the over-complicated sleeping mechanics (Hope to be added back one day)
* Beds are now handled by a single item (the bed foot): placing it will automatically place the another one.
* Table is not longer looking for workbenches
* Washing place now accepts river water
* Removed the akward hud of threshing floor. It is replaced by infotext alteration.
* The operating bucket in Tree Trunk Well is now handled with an inventory slot, not metadata field. The object is also generated every time the mapblock is loaded, not stored on disk.
* Tree Trunk Well now supports Wooden bucket from Hume2.
* Selection box of fences now matches their appearance; double fence is added (Thx Smacker)

### Added later

* Whether ropes can be dug without starting from the bottom is now configurable. (`cottages.rope_dig_without_support`)
