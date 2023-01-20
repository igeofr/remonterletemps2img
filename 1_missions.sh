#!/bin/bash

# LECTURE DU FICHIER DE CONFIGURATION
. './config.env'

# REPERTOIRE DE TRAVAIL
cd $REPER
echo $REPER

# AFFICHER L'URL
echo $url

# RECUPERER LA LISTE DES MISSIONS CONCERNEES PAR L'EMPRISE
curl "$url" -H 'Host: wxs.ign.fr' --compressed > './1_missions/missions.json'

# CONVERTIR LE FICHIER JSON EN CSV
ogr2ogr -f CSV './1_missions/missions.csv' './1_missions/missions.json'

# TRIER LES MISSIONS PAR DATE
(tail -n +2 './1_missions/missions.csv' | sort -t, -k2n | cat <(head -1 './1_missions/missions.csv') - ) > './1_missions/missions_sort.csv'

# SUPPRESSION DES FICHIERS TEMPORAIRES
rm './1_missions/missions.csv'
rm './1_missions/missions.json'
