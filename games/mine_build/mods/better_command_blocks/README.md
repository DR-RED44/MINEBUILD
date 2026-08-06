# Better Command Blocks
Adds command blocks similar to those of a certain other voxel game (hereafter referred to as ACOVG). It is the only command block mod to support my [Better Commands](https://github.com/thepython10110/better_commands) mod. It includes impulse, repeating, and chain command blocks, and *should* be game-agnostic (although you kind of need Mesecons/redstone for impulse command blocks to be useful).

To use the command blocks, you must have the `better_command_blocks` privilege.

Normal commands (not Better Commands) can *only* be run if the placer is online, and are executed as the placer. Better Commands are executed as the command block itself (same position and rotation).

## License:
* Code: Licensed under MIT
* Textures: Created by me, inspired by ACOVG's textures (and various ACOVG texture packs that I considered using instead), and licensed under CC-BY-SA-4.0

## Known issues:
1. While slashes are usually optional, they are REQUIRED if the command has multiple slashes (such as `//replace` from WorldEdit).
2. Internally, command blocks *technically* face backwards because I accidentally made it that way. This will not be fixed, because it really has no effect besides potentially slightly confusing people who look at the code.