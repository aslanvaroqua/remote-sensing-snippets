#!/bin/bash


threads=30;

threads=$(( $threads - 1))
for UUID in $UUIDS:
do
    CUTLINE=/home/ubuntu/geoservelakes/workspaces/master/lakes/$UUID.shp
    GEOTIFF_IN=/home/ubuntu/Downloads/2019-07-27/sgrd/Clipped.tif
    GEOTIFF_OUT=/home/ubuntu/Downloads/2019-07-27/tif/$UUID.TIF
    COUNTOUR_OUT=/home/ubuntu/Downloads/2019-07-27/tif/$UUID.shp

    gdalwarp \
      -s_srs EPSG:4326 \
      -t_srs EPSG:4326 \
      -of GTiff \
      -cutline $CUTLINE \
      -crop_to_cutline \
      -dstalpha \
      $GEOTIFF_IN \
      $GEOTIFF_OUT

    gdal_edit.py \
      -a_srs EPSG:4326 \
      $GEOTIFF_OUT

    gdal_contour \
      -b 1 \
      -a ECO_LST_F \
      -i 3.0 \
      -f "ESRI Shapefile" \
      $GEOTIFF_OUT \
      $COUNTOUR_OUT

     echo "$UUID" complete
  for thread in `seq $threads`
  
  do
    CUTLINE=/home/ubuntu/geoserver_data/workspaces/latest/shp_in/$UUID.shp
    GEOTIFF_IN=/home/ubuntu/geoserver_data/workspaces/latest/tif_in/latest.tif
    GEOTIFF_OUT=/home/ubuntu/geoserver_data/workspaces/latest/tif_out/$UUID.TIF
    COUNTOUR_OUT=/home/ubuntu/geoserver_data/workspaces/latest/countour_out/$UUID.TIF

    gdalwarp \
      -s_srs EPSG:4326 \
      -t_srs EPSG:4326 \
      -of GTiff \
      -cutline $CUTLINE \
      -crop_to_cutline \
      -dstalpha \
      $GEOTIFF_IN \
      $GEOTIFF_OUT

    gdal_edit.py \
      -a_srs EPSG:4326 \
      $GEOTIFF_OUT

    gdal_contour \
      -b 1 \
      -a ECO_LST_F \
      -i 3.0 \
      -f "ESRI Shapefile" \
      $GEOTIFF_OUT \
      $COUNTOUR_OUT

     echo "$UUID" complete
   done
done < "$input"

#python
# for x in os.listdir("/home/ubuntu/geoserver_data/workspaces/tif_in/"):
#     os.system("cp " + x + " ../countour_out/" + x.replace(".TIF","") + "/ -R")

