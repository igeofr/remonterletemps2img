#!/bin/bash

# LECTURE DU FICHIER DE CONFIGURATION
. './config.env'

# REPERTOIRE DE TRAVAIL
cd $REPER
echo $REPER

folder_mission=$REPER'/2_mission/'$id_mission

for g in $folder_mission'/img_jpg/'*'.jpg'
do
  g1="${g%%.*}"
  file="${g1##*/}"
  echo $file
  
  # FAIRE PIVOTER UNE IMAGE
  # https://stackoverflow.com/questions/34874771/convert-jpg-image-from-grayscale-to-rgb-using-imagemagick
  # convert $folder_mission'/img_jpg/'$file'.jpg' -rotate -180 $folder_mission'/img_jpg/'$file'.jpg'
  
  # -crop left,top      -crop right,bottom
  convert $folder_mission'/img_jpg/'$file'.jpg' -crop +350+1100 -crop -350-375 -colorspace sRGB -type truecolor $folder_mission'/img_jpg_crop/'$file'.jpg'

done
