#!/bin/bash -e

SVG=$1
DIR=`dirname "$SVG"`
NAME=`basename "$SVG"`
NAME=${NAME%.*}

for SIZE in 86 108 128 172 256
do
    mkdir -p "${SIZE}x${SIZE}"
    inkscape -w $SIZE -h $SIZE "$SVG" -e "$DIR/${SIZE}x${SIZE}/$NAME.png"
    optipng -o5 -quiet -strip all "$DIR/${SIZE}x${SIZE}/$NAME.png"
done
