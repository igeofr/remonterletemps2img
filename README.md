# remonterletemps2raster

Solution permettant de télécharger les images historiques du site [Remonter le temps](https://remonterletemps.ign.fr/) pour produire une image aérienne sur un territoire.

___

## Télécharger et préparer les images

Créer un répertoire de travail et y ajouter les scripts suivants : 

- `1_missions.sh` : Liste de toutes les missions sur un territoire donné
- `2_mission_kml.sh` : Permet de télécharger les fichiers kml de la mission
- `3_mission_download_img.sh` : Permet de télécharger les images dans la BBOX définie et de renseigner  la position et la date de prise de vue sur chaque image
- `4_mission_crop_img.sh` : Permet de découper les images pour éliminer le contour périphérique

## Créer des GCP

## Lancer [OpenDroneMap](https://opendronemap.org)

```powershell
run --project-path C:\ODM 19XX --fast-orthophoto --skip-3dmodel --min-num-features 30000 --feature-quality high --orthophoto-resolution 50 --skip-report --gcp "C:\ODM\19XX\images\gcp_list.txt"
```
