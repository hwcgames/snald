#!/bin/bash

for model in $(find $1 | grep zip); do bash $(realpath $(dirname $0))/polyhaven-decoration.sh $model $(basename $(echo $model | sed s/_1k.blend.zip//)); done