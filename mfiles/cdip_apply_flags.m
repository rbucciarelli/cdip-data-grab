%% Name:    cdip_apply_flags.m
%  Desc:    Function to apply QC Flags keeping only good data, will fill
%           data values that are not good with NaN
%- Inputs: 
%-          data = struct containing stn data                      
 
%- Output: 
%-          data: struct w/ filtered data and added field 'errors'
%-
%- Usage:   data = cdip_agg_data(agg_list)
% ------------------------------------------------------------------------

function [ data ] =  cdip_apply_flags(data)
   
    %% Apply wave QC flags
    %-  Flag_values: Flag_meaning
    %-   1:good, 2:not_evaluated, 3:questionable, 4:bad, 9:missing
    %flag_values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
    flag_meanings = {'unspecified sensor_issues', 'Hs_out_of_range', 'Tp_out_of_range', ...
        'Ta_out_of_range', 'elevated_check_factors', 'Hs_spike', 'Ta_spike', 'low_freq_energy_spike' ...
        'excessive_low_freq_energy', 'hf_transmission_errors_fixed','hf_transmission_errors_present', ...
        'directional_coeffs_out_of_range', 'incomplete_spectrum', 'spectrum_layout_modified', ...
        'too_few_segments', 'inclination_off', 'max_energy_at_highest_freq'};

    if(ismember('waveFlagPrimary',fieldnames(data)))
        idx = find(data.waveFlagPrimary ~= 1);
        data.flags = {};
    else
        disp('Field: waveFlagPrimary not in data');
        return
    end

    NT = length(data.time);
    NF = length(data.waveFrequency);
    flds = fieldnames(data);
    
    for fid = 1:length(flds)
        var_name = flds{fid};
        if(~strcmp(var_name,{'flags','time','waveFrequency','waveBandwidth','var_list','source',...
                'waveFlagPrimary','waveFlagSecondary'}))
            
            [NI,NJ] = size(data.(var_name));
    
            %- Check if 2-D or 1-D
            if(NI == NF)
                data.(var_name)(:,idx) = nan;                
            else
                data.(var_name)(idx) = nan;
            end            
           
        end
    end 

    %% Give report of errors
    if(~isempty(idx))
        for i = 1:length(idx)
            rec = idx(i);
            F = {};
            F.index = rec;
            F.time = data.time(rec);
            if(ismember('waveFlagSecondary',fieldnames(data)))
                F.flag = data.waveFlagSecondary(rec);
                F.meaning = flag_meanings{flag+1};
            else
                F.flag = '';
                F.meaning = '';
            end
            data.flags{i} = F;     
        end
    end

    
end