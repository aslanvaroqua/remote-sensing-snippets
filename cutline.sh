#!/bin/bash
# export SAGA_MLB=/usr/lib/saga


NASA_RAW="/home/ubuntu/geoserver_data/workspacces/latest/nasa_in/"
TIFS="/home/ubuntu/geoserver_data/workspaces/latest/tif_in"
UUIDS="/home/ubuntu/geoserver_data/workspaces/latest/shp_in/"
SHP_MASTER="/home/ubuntu/geoserver_data/workspaces/master/lakes/geometry.shp"
for file in $NASA_RAW; do  saga_cmd io_gdal 0 -FILES=file -SELECT -SELECT_SORT -TRANSFORM -RESAMPLING=3 ; done
saga_cmd io_gdal 3 -FILES="/home/ubuntu/geoserver_data/workspaces/master/geometry.shp" -GEOM_TYPE=0
saga_cmd grid_tools 3 -GRIDS=$TIFS -NAME=Mosaic -TYPE=7 -RESAMPLING=3 -OVERLAP=1 -MATCH=0 -TARGET_DEFINITION=0 -TARGET_USER_SIZE=0.000630 -TARGET_USER_XMIN=-126.351710 -TARGET_USER_XMAX=-70.101882 -TARGET_USER_YMIN=26.015462 -TARGET_USER_YMAX=48.655960 -TARGET_USER_FITS=0
saga_cmd shapes_grid 7 -INPUT=$TIFS -POLYGONS=$SHP_MASTER

threads=30;

threads=$(( $threads - 1))
for UUID in $UUIDS:
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

