#! /usr/bin/env python
# Python script template for SAGA tool execution (automatically created, experimental)

import saga_api, sys, os

##########################################
def Call_SAGA_Module(fDEM):            # pass your input file(s) here

    # ------------------------------------
    # initialize input dataset(s)
    dem    = saga_api.SG_Get_Data_Manager().Add_Grid(unicode(fDEM))
    if dem == None or dem.is_Valid() == 0:
        print 'ERROR: loading grid [' + fDEM + ']'
        return 0

    # ------------------------------------
    # initialize output dataset(s)
    outgrid = saga_api.SG_Get_Data_Manager().Add_Grid(dem.Get_System())

    # ------------------------------------
    # call module: Import Raster
    Module = saga_api.SG_Get_Module_Library_Manager().Get_Module('io_gdal','0')

    Parms = Module.Get_Parameters() # default parameter list
    Parms.Get(unicode('FILES')).Set_Value("/home/ubuntu/geoserver_data/workspaces/latest/tif_in/all.tif")
    Parms.Get(unicode('SELECT')).Set_Value(1)
    Parms.Get(unicode('SELECT_SORT')).Set_Value(1)
    Parms.Get(unicode('TRANSFORM')).Set_Value(1)
    Parms.Get(unicode('RESAMPLING')).Set_Value(3)

    if Module.Execute() == 0:
        print 'Module execution failed!'
        return 0

    print
    print 'The module has been executed.'
    print 'Now you would like to save your output datasets, please edit the script to do so.'
    return 0                           # remove this line once you have edited the script

    # ------------------------------------
    # save results
    path   = os.path.split(fDEM)[0]
    if path == '':
        path = './'
    outgrid.Save(saga_api.CSG_String(path + '/outgrid'))

    print
    print 'Module successfully executed!'
    return 1

##########################################
if __name__ == '__main__':
    print 'Python - Version ' + sys.version
    print saga_api.SAGA_API_Get_Version()
    print
    print 'Usage: %s <in: filename>'
    print
    print 'This is a simple template, please edit the script and add the necessary input and output file(s)!'
    print 'We will exit the script for now.'
    sys.exit()                         # remove this line once you have edited the script
    # This might look like this:
    # fDEM    = sys.argv[1]
    # if os.path.split(fDEM)[0] == '':
    #    fDEM    = './' + fDEM
    fDEM = './../test_data/test.sgrd'  # remove this line once you have edited the script


    saga_api.SG_UI_Msg_Lock(1)
    if os.name == 'nt':    # Windows
        os.environ['PATH'] = os.environ['PATH'] + ';' + os.environ['SAGA'] + '/bin/saga_vc_Win32/dll'
        saga_api.SG_Get_Module_Library_Manager().Add_Directory(os.environ['SAGA'] + '/bin/saga_vc_Win32/modules', 0)
    else:                  # Linux
        saga_api.SG_Get_Module_Library_Manager().Add_Directory(os.environ['SAGA_MLB'], 0)
    saga_api.SG_UI_Msg_Lock(0)

    Call_SAGA_Module(fDEM)             # pass your input file(s) here
