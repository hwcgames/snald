#!/bin/bash
# Take the texture's zip path from $1
ZIP=$1
NAME=$(basename $ZIP .zip)

# Clean the texture directory, preserving imports
rm $NAME/*.jpg || true
# Clean up existing materials
rm $NAME.tres $NAME.material

# Create a texture directory for the material
mkdir -p $NAME
cd $NAME

# Unzip all of the entries
unzip $ZIP
mv textures/* .
rm -d textures

# Copy the diffuse file to the base
cp *_diff_*k.jpg ../$NAME.jpg

# Generate the .tres material
cp ../material.tres.template ../$NAME.tres
# Write the name of the material
sed -i s/NAME/$NAME/ ../$NAME.tres
# Write the AO texture path
sed -i s/AO/$(ls *_ao_* | head -n 1)/ ../$NAME.tres
# Write the normal texture path
sed -i s/NORM/$(ls *_nor_* | head -n 1)/ ../$NAME.tres
# Write the diffuse texture path
sed -i s/DIFF/$(ls *_diff_* | head -n 1)/ ../$NAME.tres
# Write the displacement texture path
sed -i s/DISP/$(ls *_disp_* | head -n 1)/ ../$NAME.tres
# Write the roughness texture path
sed -i s/ROUGH/$(ls *_rough_* | head -n 1)/ ../$NAME.tres
# Write the metallic texture path
sed -i s/ARM/$(ls *_arm_* | head -n 1)/ ../$NAME.tres

# Reimport all assets
godot --no-window --editor --quit

# Run the conversion script
cd ../../
godot -s textures/convert_to_material.gd --no-window

# Remove the generated .tres
cd textures
rm $NAME.tres