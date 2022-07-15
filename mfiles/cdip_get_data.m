%% Name:    cdip_get_data.m
%  Desc:    Function to grab data from cdip netcdf file
%- Inputs: 
%-          ncfile = netcdf file url                     
%-          input_list = {'all'} or {'waveHs','waveEnergyDensity'} 
%-          sdate = '2019-01-01T00:00:00Z'
%-  
%- Output: 
%-          var_list: struct containing variable information
%-
%- Usage:   D = cdip_get_data(ncfile,{'all'},'2019-01-01T00:00:00Z')
% ------------------------------------------------------------------------

function [ D ] =  cdip_get_data(ncfile,input_list,sdate)
    %% Convert sdate to datenum
    sdn = datenum(sdate(1:10));

    %- Call function to grab netcdf variables of interest (input_list)
    var_list =  nc_get_vars(ncfile,input_list);

    %% Read in times
    wave_time = ncread(ncfile,'waveTime');
    NT = length(wave_time);
    %- convert epoch time to matlab datenum format
    mtimes = waveTime_to_datenum(double(wave_time));

    %- Find indices w/in dates of interest
    %- If start date of interest > start of file, subset
    if(sdn > mtimes(1))
        idx = find((mtimes >= sdn));
    else
        idx = 1;
    end
    %- Subset time data
    mtimes = mtimes(idx:end);
    D.time = mtimes;

    %% Read in freqs,bw
    D.waveFrequency = double(ncread(ncfile,'waveFrequency'));
    D.waveBandwidth = double(ncread(ncfile,'waveBandwidth'));
    NF = length(D.waveFrequency);  

    %% Iterate over variables of interest and grab data from netcdf
    for j = 1:length(var_list)
        var_name = var_list(j).name;
        var_size = var_list(j).size;
        if(length(var_size) == 2)
            %%- make sure this relevant variable with dims (NF,NT)
            if((var_size(1) == NF) && (var_size(2) == NT))        
                var = double(ncread(ncfile,var_name,[1 idx(1)],[NF,length(mtimes)]));
                D.(var_name) = var;              
            end
        elseif(var_size == NT)
            var = double(ncread(ncfile,var_name,[idx(1)],[length(mtimes)]));                     
            D.(var_name) = var;                  
        end            
    end
    D.var_list = var_list;
    D.source = [ncfile '.html'];
end