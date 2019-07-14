CUTLINE=/home/ubuntu/geoserver_data/workspaces/lakeserver/lakes/87f4b651-8fad-46ef-9033-b12595dbf330.shp
GEOTIFF_IN=/home/ubuntu/Desktop/TEST1.tif
GEOTIFF_OUT=/home/ubuntu/geoserver_data/workspaces/lakeserver/lakes/87f4b651-8fad-46ef-9033-b12595dbf330.tif

gdalwarp \
  -s_srs EPSG:4326 \
  -t_srs EPSG:4326 \
  -of GTiff \
  -cutline $CUTLINE \
  -crop_to_cutline \
  -dstalpha \
  $GEOTIFF_IN \
  $GEOTIFF_OUT
