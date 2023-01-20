#!/bin/bash

# LECTURE DU FICHIER DE CONFIGURATION
. './config.env'

# REPERTOIRE DE TRAVAIL
cd $REPER
echo $REPER

# REPERTOIRE DE LA MISSION
folder_mission=$REPER'/2_mission/'$id_mission

# SUPPRESSION DE LA MISSION
rm -r $folder_mission

# CREATION DES REPERTOIRES
mkdir $folder_mission
mkdir $folder_mission'/img_jp2'
mkdir $folder_mission'/img_jpg'
mkdir $folder_mission'/img_jpg_crop'

# TELECHARGER LE FICHIER DE LA MISSION
curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/t.kml" > $folder_mission'/'$id_mission'.kml'

# PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+1
href=($(grep -oP '(?<=href>)[^<]+' $folder_mission'/'$id_mission'.kml'))
for k in ${!href[*]}
do
  echo "${href[$k]}"
  echo $href
  curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]}" > $folder_mission'/'$id_mission'_'${href[$k]:0:1}'.kml'

  # PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+2
  href2=($(grep -oP '(?<=href>)[^<]+' $folder_mission'/'$id_mission'_'${href[$k]:0:1}'.kml'))
  for t in ${!href2[*]}
  do
    echo ${href[$k]:0:1}'/'"${href2[$t]}"
    echo $href2
    curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]:0:1}/${href2[$t]}" > $folder_mission'/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'.kml'

    # PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+3
    href3=($(grep -oP '(?<=href>)[^<]+' $folder_mission'/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'.kml'))
    for y in ${!href3[*]}
    do
      echo ${href[$k]:0:1}'/'${href2[$t]:0:1}'/'"${href3[$y]}"
      echo $href3
      curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]:0:1}/${href2[$t]:0:1}/${href3[$y]}" > $folder_mission'/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'.kml'

      # PERMET DE TELECHARGER LES FICHIERS KML DES MISSIONS DECOUPEES POUR UN NIVEAU N+4
      href4=($(grep -oP '(?<=href>)[^<]+' $folder_mission'/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'.kml'))
      for u in ${!href4[*]}
      do
        echo ${href[$k]:0:1}'/'${href2[$t]:0:1}'/'${href3[$y]:0:1}'/'"${href4[$u]}"
        echo $href4
        curl "https://wxs.ign.fr/$key/dematkml/DEMAT.PVA/$id_mission/${href[$k]:0:1}/${href2[$t]:0:1}/${href3[$y]:0:1}/${href4[$u]}" > $folder_mission'/'$id_mission'_'${href[$k]:0:1}'_'${href2[$t]:0:1}'_'${href3[$y]:0:1}'_'${href4[$u]:0:1}'.kml'

      done

    done

  done

done
