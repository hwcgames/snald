# Config Mods

This page will walk you through making a simple config mod for SNALD. You can read SNALD's parameter files in the source code in the `cvars` directory. SNALD's parameter names should be intelligible enough, but you can search for a cvar's name in the source code to find where and how it is used if you're unsure.

## Fewer Batteries

For our simple mod, we want to make the last night harder by reducing the number of batteries you receive at the start.

First, create a file called `02-fewer-batteries.tres`. The file starts with `02` to make sure it always loads after the built-in configuration, since they all start with `01`. Set it up with this structure:

```json
[gd_resource type="Resource" load_steps=2 format=2]
[ext_resource path="res://scripts/stored_cvars.gd" type="Script" id=1]
[resource]
script = ExtResource( 1 )
ints = {}
floats = {}
bools = {}
tables = {}
```

Once you have the file, add a new integer, matching the one in `cvars/01-tanner.tres`:

```json
[gd_resource type="Resource" load_steps=2 format=2]
[ext_resource path="res://scripts/stored_cvars.gd" type="Script" id=1]
[resource]
script = ExtResource( 1 )
ints = {
	"tanner_n20_battery_count": 1
}
floats = {}
bools = {}
tables = {}
```

Put this file in a directory called `cvars`, and put that directory at the root of a ZIP file. When you put that ZIP file in the `mods` folder, SNALD should load it and you should receive one battery at the start of night 5 instead of three.
