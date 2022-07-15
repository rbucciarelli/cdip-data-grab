
%% Name:    gudb_data_urls.m
%  Desc:    Function to query CDIP GUDB for stn deployments/urls since a start date
%- Inputs: 
%-          stn = '067'                     
%-          sdate = '2019-01-01T00:00:00Z'  
%-  
%- Output: 
%-          url_list: struct containing data urls
%-
%- Usage:   url_list = gudb_data_urls('067' ,2019-01-01T00:00:00Z'
% ------------------------------------------------------------------------

function [ url_list ] =  gudb_data_urls(stn,sdate)
    %% Query GUDB for deployments since sdate
    url = 'https://meta.cdipdata.org/api/deployment_list/';
    url = [url '?station=' stn '&start_date__gte=' sdate];
    meta = webread(url);
    
    %% Figure out deployment numbers and get list of urls to process
    dep_list = [];
    url_list = {};
    for i = 1:length(meta)
        dep_list(i) = meta(i).deploy_num;
        %- Check if active deployment (i.e. REALTIME or ARCHIVE)
        %- First check last "state" of each deployment
        buoy_state = meta(i).buoy_state_deployment(end).buoy_state;     %- 'r' 'm' 'p' 'o'
        %- Check if last state is moored state
        if(strcmp(buoy_state,'m'))
            data_url = ['http://thredds.cdip.ucsd.edu/thredds/dodsC/cdip/realtime/' stn 'p1_rt.nc'];
            url_list{i} = data_url;
        else
            data_url = ['http://thredds.cdip.ucsd.edu/thredds/dodsC/cdip/archive/' stn 'p1/' stn 'p1_historic.nc'];
            url_list{i} = data_url;
        end       
    end
end