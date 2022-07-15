
%% Initialize input vars
clear all; close all;
%path('./mfiles',path);

%- CDIP buoy id as 3-digit string
stn = '067';

%- Start date as string 'YYYY-MM-DDTHH:MM:SSZ'
%- Note: assumes end date is present day
sdate = '2019-01-01T00:00:00Z';

%- List of variables to grab --> {'all'} will grab all bulk wave vars
%input_list = {'all'};
input_list = {'waveEnergyDensity','waveMeanDirection','waveHs','waveFlagPrimary','waveFlagSecondary'};

%% Call function to query gudb and get stn deployment data urls since start date 
url_list = gudb_data_urls(stn ,sdate);

%% Iterate over urls and grab relevant data
agg_list = {};
NT = 0;
D = {};     %- output data struct
for i = 1:length(url_list)
    ncfile = url_list{i};

    %% Make sure we can read the url
    try
        ncmeta = ncinfo(ncfile);
    catch
        disp(['Could not read ncfile: ' ncfile])
        return;    
    end  

    %- Get deployment data as struct
    disp(['Grabbing vars from dataset' num2str(i)])
    D = cdip_get_data(ncfile,input_list,sdate);

    %- Add struct to aggregate list
    agg_list{i} = D;
end

%% Aggregate these into output dataset
disp('Aggregating files ...')
data = cdip_agg_data(agg_list);


%% Apply wave QC flags
disp('Applying QC flags ...')

%% Report flagged records to screen
data =  cdip_apply_flags(data);
if(ismember('flags',fieldnames(data)))
    disp('Flagged Records');
    fprintf('\n%5s\t%s\t%10s\t%15s\n','Index','Time-UTC','Flag','Meaning')
    disp('----------------------------------------------------------------')
    for i = 1:length(data.flags)
        flag = data.flags{i};
        fprintf('%d\t%s\t%5d\t%20s\n',flag.index,datestr(flag.time,'yyyymmddThh:MM'),flag.flag,flag.meaning)
        
    end
end

%% Plot to test
figure
subplot(2,1,1)
plot(data.time,data.waveHs)
set(gca,'XTickLabel',datestr(get(gca,'XTick'),'yyyy-mm-ddThhZ'))
title(['CDIP ' stn ' Hs ' sdate(1:10) ' to ' 'Present']);
ylabel('Hs (m)');
xlabel('Time (UTC)');
axis tight;
hold on;
subplot(2,1,2)
[xi,yi] = meshgrid(data.time,data.waveFrequency);
pcolor(xi,yi,log10(data.waveEnergyDensity));
shading flat;
set(gca,'XTickLabel',datestr(get(gca,'XTick'),'yyyy-mm-ddThhZ'))
title(['CDIP ' stn ' Wave Energy Density ' sdate(1:10) ' to ' 'Present']);
ylabel('Frequency (Hz)');
xlabel('Time (UTC)');

