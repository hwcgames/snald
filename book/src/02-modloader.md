# SNALD's Mod Loader

SNALD comes with a built-in mod loader that allows for file replacements. You can read its implementation in the source code at `scripts/modloader.gd`.

To make a mod compatible with this modloader, you can create a ZIP file containing files at their relative paths, which will be overlaid on top of the game's VFS at runtime. For example, to change the game's logo, 