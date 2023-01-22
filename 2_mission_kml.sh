#!/bin/bash

# LECTURE DU FICHIER DE CONFIGURATION
. './config.env'

# REPERTOIRE DE TRAVAIL
cd $REPER
echo $REPER

folder_mission=$REPER'/2_mission/'$id_mission

# SUPPRESSION DE LA MISSION
rm -r $folder_mission

# CREATION DES REPERTOIRES
mkdir $folder_mission
mkdir $folder_mission'/img_jp2'
mkdir $folder_mission'/img_jpg'
mkdir $folder_mission'/img_jpg_crop'
mkdir $folder_mission'/kml'
mkdir $folder_mission'/couverture'
mkdir $folder_mission'/couverture_bbox'
mkdir $folder_mission'/csv_attributs'
mkdir $folder_mission'/csv_liste_img'


# TELECHARGER LE FICHIER DE LA MISSION
curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/t.kml" > $folder_mission'/kml/'$id_mission'.kml'

# PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+1
xmllint -o $folder_mission'/kml/'$id_mission'.kml' -format $folder_mission'/kml/'$id_mission'.kml'
href=($(awk -F"[><]" '/<\/Link>/{a="";next} /<Link>/{a=1;next} a && /<href>/{print $3}' $folder_mission'/kml/'$id_mission'.kml'))
for k in ${!href[*]}
do
  echo "${href[$k]}"
  echo $href
  curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]}" > $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'.kml'

  # PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+2
  xmllint -o $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'.kml' -format $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'.kml'
  href2=($(awk -F"[><]" '/<\/Link>/{a="";next} /<Link>/{a=1;next} a && /<href>/{print $3}' $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'.kml'))
  for t in ${!href2[*]}
  do
    echo ${href[$k]:0:1}'/'"${href2[$t]}"
    echo $href2
    curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]:0:1}/${href2[$t]}" > $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'.kml'

    # PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+3
    xmllint -o $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'.kml' -format $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'.kml'
    href3=($(awk -F"[><]" '/<\/Link>/{a="";next} /<Link>/{a=1;next} a && /<href>/{print $3}' $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'.kml'))
    for y in ${!href3[*]}
    do
      echo ${href[$k]:0:1}'/'${href2[$t]:0:1}'/'"${href3[$y]}"
      echo $href3
      curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]:0:1}/${href2[$t]:0:1}/${href3[$y]}" > $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'.kml'

      # PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+4
      xmllint -o $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'.kml' -format $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'.kml'
      href4=($(awk -F"[><]" '/<\/Link>/{a="";next} /<Link>/{a=1;next} a && /<href>/{print $3}' $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'.kml'))
      for u in ${!href4[*]}
      do
        echo ${href[$k]:0:1}'/'${href2[$t]:0:1}'/'${href3[$y]:0:1}'/'"${href4[$u]}"
        echo $href4
        curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]:0:1}/${href2[$t]:0:1}/${href3[$y]:0:1}/${href4[$u]}" > $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'_'${href4[$u]:0:1}'.kml'
            
        xmllint -o $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'_'${href4[$u]:0:1}'.kml' -format $folder_mission'/kml/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'_'${href4[$u]:0:1}'.kml'
      done

    done

  done

done


# COUVERTURE DES PRISES DE VUE DE LA MISSION
file=$folder_mission'/couverture/'$id_mission'.shp'

  for i in $(ls $folder_mission'/kml/'*'.kml')
  do
    if [ -f "$file" ]
      then
        echo "merge $i"
        ogr2ogr -f 'ESRI Shapefile' -append $file $i 
      else
        echo "creating merge $i"
        ogr2ogr -f 'ESRI Shapefile' --config SHAPE_ENCODING UTF-8 -lco SPATIAL_INDEX=YES -lco ENCODING=UTF-8 $file $i -nlt POLYGON
    fi
  done
