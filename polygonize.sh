import os
path = "/home/ubuntu/Desktop/rasters/"
raster_dir = os.listdir(path)
for location in raster_dir:
    if "TIF" in location:
        gtiff_in =  path + location
        shp_out = path + location.replace("TIF","shp")
        gdal_polygonize.py gtiff_in shp_out -b 1 -f "ESRI Shapefile" OUTPUT DN
    
 
