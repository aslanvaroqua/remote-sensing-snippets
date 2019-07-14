  #!/bin/bash
input="/home/ubuntu/jobs"
while IFS= read -r UUID
do
  CUTLINE=/home/ubuntu/geoserver_data/workspaces/lakeserver/lakes/$UUID.shp
  GEOTIFF_IN=/home/ubuntu/Desktop/TEST1.tif
  GEOTIFF_OUT=/home/ubuntu/geoserver_data/workspaces/lakeserver/lakes/$UUID.TIF

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
    $UUID.countour.shp
   
   echo "$UUID" complete
done < "$input"


