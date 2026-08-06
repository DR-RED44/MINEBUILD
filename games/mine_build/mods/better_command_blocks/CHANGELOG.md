# Changelog

## v2.0 (January 2, 2026)
* Features
  * Command blocks can be copied with aux1+right-click
  * Added "Hover Note" and "Execute on first tick" options, like the non-coffee flavor of ACOVG
* Changes
  * Command blocks are placed facing the placer (as in ACOVG), and are no longer impossible to place vertically
  * Command blocks can now hold multiple commands, which are *all* run sequentially when the command block's conditions are met. So I guess chain command blocks are kind of obsolete now, but whatever.
  * Command block chains can once again turn corners like in ACOVG (somehow I got this wrong in v1.1)
  * Improved formspec
* Bugfixes:
  * Fixed a potential issue where the player's wielded item could get deleted when interacting with command blocks
  * Fixed a bug where command blocks couldn't run commands without parameters
  * Normal commands (not Better Commands) can now *only* be run when the command block's placer is online. Some commands (VL `clearmobs` for example) expect to have a valid player object and will crash otherwise.
  * Command blocks *should* no longer run after being dug during the delay
* Probably added bugs since I basically rewrote half the mod. I wouldn't be surprised if there was a bugfix release in the next few days.

## v1.3
* Fixed a couple random things (commands can now begin with slashes again)

## v1.2
* Command blocks can be dug by hand.
* Repeating command blocks with a missing/invalid command will no longer stop repeating.

## v1.1 (May 31, 2024)
* Chain command blocks must now be facing the same direction as the previous command block ~~to match ACOVG~~ because I *thought* it would match ACOVG but was apparently completely wrong.
* Command block success messages are no longer replaced with "success"
* Command block success messages are now broadcasted in chat, can be disabled by a setting.
* Reorganized the changelog (newer releases first)
* Fixed a bug caused when a command block replaces itself.

## v1.0 (May 5, 2024)
* Initial release.
* Currently ignores third result return value for Better Commands.