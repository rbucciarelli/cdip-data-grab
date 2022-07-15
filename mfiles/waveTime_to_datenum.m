%% Function to convert waveTime (unix epoch times) to matlab datenum format
function [ mat_time ] = waveTime_to_datenum(ts)
    toff = datenum(1970,1,1,0,0,0);
    mat_time = ts./(24*60*60) + toff;
end