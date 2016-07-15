#!/bin/bash

# Written July 15, 2016
# Takes an image filename as a parameter, converts its pixels to grayscale 1-byte binary,
# and outputs the resulting numbers in decimal form to an ascii text file.
# Intended to be used for converting images into depth maps for OpenSCAD.

set -e

if [[ $# -eq 0 ]] ; then
    echo "Don't forget to pass an image filename!"
    exit 0
fi

prog="png2dat"

imagefile="$1"

filename=$(basename "$imagefile")
extension="${filename##*.}"
filename="${filename%.*}"

echo "$prog: Converting $imagefile to grayscale 1-byte depth binary..."
convert "$imagefile" -negate -depth 8 gray:"$filename.bin"

echo "$prog: Converting binary file to text..."
size_str=`identify -format "%[w]x%[h]" "$imagefile"`
echo "$prog: Image dimensions: $size_str"
width=`echo "$size_str" | cut -d'x' -f1`
od -t u1 -w"$width" "$filename.bin" | cut -c 9- > "$filename.dat"
rm "$filename.bin"

echo "$prog: Results placed in $filename.dat"
