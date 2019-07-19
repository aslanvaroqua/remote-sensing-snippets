  #!/bin/bash
input="/home/ubuntu/geoserver_data/workspaces/latest/shp_in/input_list.txt"
while IFS= read -r UUID
do
  CUTLINE=/home/ubuntu/geoserver_data/workspaces/latest/shp_in/$UUID.shp
  GEOTIFF_IN=/home/ubuntu/geoserver_data/workspaces/latest/tif_in/all.tif
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
done < "$input"

#python
# for x in os.listdir("/home/ubuntu/geoserver_data/workspaces/tif_in/"):
#     os.system("cp " + x + " ../countour_out/" + x.replace(".TIF","") + "/ -R")

