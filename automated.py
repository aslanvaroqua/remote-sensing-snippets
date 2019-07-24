#python
import os
from datetime import date
from rasterstats import zonal_stats

overwrite=false

if not os.path.exists('/mnt/master'):
        os.makedirs('/mnt/master')
        os.makedirs('/mnt/current')
        os.system("yas3fs s3://lakemonster/master /mnt/master")
        os.system("yas3fs s3://lakemonster/current /mnt/current")


input_path = "/mnt/current/"
today = date.today()
if not os.path.exists(input_path + str(today)):
        os.makedirs(input_path + str(today))
if not os.path.exists(input_path + str(today) + "/tif_in"):
        os.makedirs(input_path + str(today) + "/tif_in")


os.chdir(input_path + str(today) + tif_in)

download_list = "/mnt/current/downloads.txt"

downloads = []

with open(download_list) as fp:
   line = fp.readline()
   cnt = 1
   while line:
       print("Line {}: {}".format(cnt, line.strip()))
       downloads.append(line.strip())
       line = fp.readline()
       cnt += 1


def worker():
    for dl in downloads:
            download = True
            for f in os.listdir(download_dir):
                    if dl.split("_")[3] in f:
                            download = False
            if download:
                    os.system("wget -nc " + dl)

threads = []

for i in range(4):
    t = threading.Thread(target=worker)
    threads.append(t)
    t.start()

for file in os.listdir():
        os.system("saga_cmd io_gdal 0 -GRIDS=" + file + " -FILES=./" + file + " -SELECTION -SELECT_SORT -RESAMPLING=3")

os.system("saga_cmd io_gdal 3 -SHAPES=geometry -FILES=/mnt/master/lakes/geometry.shp -GEOM_TYPE=0")

GRIDS = ""    

for file in os.listdir():
        if "sgrd" in file:
 os.system("saga_cmd io_gdal 2 -GRIDS=./Mosaic.sgrd -FILE=./Mosaic.tif")
 #!/bin/bash

os.system("saga_cmd grid_tools 3 -GRIDS=" + '"'  + GRIDS + '"' + " -TYPE=7 -RESAMPLING=3 -OVERLAP=1 -MATCH=0 -TARGET_DEFINITION=0 -TARGET_USER_SIZE=0.000630 -TARGET_USER_XMIN=-126.351710 -TARGET_USER_XMAX=-70.101882 -TARGET_USER_YMIN=26.015462 -TARGET_USER_YMAX=48.655960 -TARGET_USER_FITS=0 -TARGET_OUT_GRID=./MosaicTEst.sgrd")

# tool: Clip Grid with Polygon

os.system("saga_cmd shapes_grid 7 -OUTPUT=./Clipped.sgrd -INPUT=./Mosaic.sgrd -POLYGONS=/mnt/master/lakes/geometry.shp")

# tool: Export GeoTIFF

os.system("saga_cmd io_gdal 2 -GRIDS=./Clipped.sgrd -FILE=./Clipped.tif")

# Get file names
input = "./Clipped.tif"
output = "./lst" + "-" + str(today).tif

os.system('gdal_calc.py -A '+ input + ' --outfile=' + output + ' --calc="(((A*0.02)-272)*(9/5))+32" --NoDataValue=0')



#from rasterstats import zonal_stats

stats = zonal_stats("/mnt/master/lakes/geometry.shp", "lst-" + str(today) + ".tif",
            stats="median", geojson_out=True)

import json
with open('temperature.geojson', 'w') as outfile:
   json.dump(result, outfile) # or geojson.dump(result, outfile)
