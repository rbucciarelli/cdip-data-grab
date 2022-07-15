%% Name:    cdip_agg_data.m
%  Desc:    Function to aggregate cdip data in structs
%- Inputs: 
%-          agg_list = array of structs containing stn data                      
 
%- Output: 
%-          data: struct containing variable information
%-
%- Usage:   data = cdip_agg_data(agg_list)
% ------------------------------------------------------------------------

function [ data ] =  cdip_agg_data(agg_list)
    %% Aggregate arrays; Pre-allocate relevant arrays based on time/freq
    
    data = {};
    temp = agg_list{1};

    flds = fieldnames(temp);

    %% Need to figure out total length of time/freqs in each struct
    NT = 0;
    for i = 1:length(agg_list)
        NT = NT + length(agg_list{i}.time);
        NF = length(agg_list{i}.waveFrequency);
    end
    
    for fid = 1:length(flds)
        var_name = flds{fid};
        if(~strcmp(var_name,{'waveFrequency','waveBandwidth','var_list','source'}))
            
            [NI,NJ] = size(temp.(var_name));
            var_size = length(size(temp.(var_name)));
            if(NI == NF)
                data.(var_name) = zeros(NF,NT);
            else
                data.(var_name) = zeros(NT,1);
            end
    
            data.(var_name)(:) = NaN;
            idx = 0;
            for i = 1:length(agg_list)
                D = agg_list{i};
                NREC = length(D.time);
    
                %- Check if 2-D or 1-D
                if(NI == NF)
                    data.(var_name)(:,idx+1:NREC+idx) = D.(var_name)(:,:);                
                else
                    data.(var_name)(idx+1:NREC+idx) = D.(var_name);
                end
                idx = NREC;
            end
        else
            data.(var_name) = temp.(var_name);
        end
    end 
    

end