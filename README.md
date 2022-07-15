# cdip-data-grab
Matlab script repository to grab CDIP wave data across deployments

## Run test script: test_cdip_data.m
Will download buoy deployment data from CDIP THREDDS Server and aggregate into matlab struct.

Example inputs:
* stn = '067' (CDIP Station ID)
* sdate = '2019-01-01T00:00:00Z' (Start date string)
* input_list = {'all'} (Cell array of variables namees)

### Relevant functions in ./mfiles
* cdip_agg_data.m: Aggregate input array of structs containing CDIP data.
* cdip_apply_flags.m: Apply QC Flags keeping only good data
* cdip_get_data.m: Grab data from input cdip netcdf file
* gudb_data_urls.m: Query CDIP GUDB for stn deployments/urls since a start date
* nc_get_vars.m: Grab variable information from netcdf file
* waveTime_to_datenum.m: Convert waveTime (unix epoch times) to matlab datenum format
