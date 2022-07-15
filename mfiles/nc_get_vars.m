%% Name:    nc_get_vars.m
%  Desc:    Function to grab variable information from netcdf file
%- Inputs: 
%-          ncfile = netcdf file url                     
%-          input_list = {'all'} or {'waveHs','waveEnergyDensity'}  
%-  
%- Output: 
%-          var_list: struct containing variable information
%-
%- Usage:   url_list = gudb_data_urls('067' ,2019-01-01T00:00:00Z')
% ------------------------------------------------------------------------

function [ var_list ] =  nc_get_vars(ncfile,input_list)
    %%- Get variable metadata and setup master variable list (var_list)
    var_list = {};
    %- Make sure we can read the url using matlabs netcdf functions
    try
        ncmeta = ncinfo(ncfile);
    catch
        disp(['Could not read ncfile: ' ncfile])
        return;    
    end  
    %- Now iterate over variabls and get name/dims/size
    j = 1;
    for vid = 1:length(ncmeta.Variables)
        var_name = ncmeta.Variables(vid).Name;
        var_dims = ncmeta.Variables(vid).Dimensions;
        var_size = ncmeta.Variables(vid).Size;
        if(strcmp('all',input_list{1}))            
            %- Just grab wave relevant vars for now
            if((~ ismember(var_name, {'waveTime','waveFrequency','waveBandwidth'})) ... 
                    && (strcmp(var_name(1:4),'wave')))
                var_list(j).name = var_name;
                var_list(j).dims = var_dims;
                var_list(j).size = var_size;
                j = j + 1;
            end                
        elseif(ismember(var_name,input_list))
            var_list(j).name = var_name;
            var_list(j).dims = var_dims;
            var_list(j).size = var_size;
            j = j + 1;
        end
    end

end