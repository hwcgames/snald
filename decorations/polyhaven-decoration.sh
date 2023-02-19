#!/bin/bash

MODELPATH=$(realpath $1)
DECORNAME=$2
BLENDERSCRIPT=$(realpath $(dirname $0)/blender-reducemodel.py)
OUTFILE=$(realpath $(dirname $0))/$DECORNAME
HASH=$(cat $MODELPATH | sha256sum | cut -d' ' -f 1)

# Setup output directory
mkdir -p $OUTFILE
# Setup working directory
mkdir -p /tmp/snald-decor-gen/$HASH
pushd /tmp/snald-decor-gen/$HASH
# Extract model
unzip $MODELPATH
# Convert textures from ESR to JPG
#for i in textures/*.exr; do convert $i $(dirname $i)/$(basename $i .exr).jpg; done
#for i in textures/*.png; do convert $i $(dirname $i)/$(basename $i .png).jpg; done
#for i in textures/*.jpg; do magick $i -resize 10% -quality 60% $i; done
# Run blender script; should produce `model.glb`
blender -b $(ls *.blend | head -n 1) -P $BLENDERSCRIPT -- $OUTFILE/model.glb
popd
rm -rf /tmp/snald-decor-gen/$HASH
# Create scene from template
if [ ! -f $(realpath $(dirname $0))/$DECORNAME.tscn ]; then
	cat $(realpath $(dirname $0))/phmodel.tscn.template | sed s/NAME/$DECORNAME/g > $(realpath $(dirname $0))/$DECORNAME.tscn
fi
for i in $OUTFILE/*.jpg; do magick $i -resize 10% -quality 60% $i; done
for i in $OUTFILE/*.png; do magick $i -resize 10% -quality 60% $i; done
for i in $OUTFILE/*.exr; do magick $i -resize 10% -quality 60% $i; done
