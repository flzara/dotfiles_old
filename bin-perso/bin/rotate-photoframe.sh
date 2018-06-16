#! /bin/sh

pwd
for file in IMG_*.JPG ; do
    convert $file -auto-orient $file
    echo $file" traité"
done;
