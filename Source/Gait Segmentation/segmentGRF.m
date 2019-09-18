function [cycles_time, cycles_frame] = segmentGRF(side, cutoff, motion_data)

    minimum_increase = 5;

    if strcmp(side, 'left')
        str = 'ground_force2_vy';
    else
        str = 'ground_force1_vy';
    end
    
    timesteps = motion_data.getColumn('time');
    indices = find(motion_data.getColumn(str) > cutoff);
    cycles_time = {};
    cycles_frame = {};
    k = 1;
    start = 1;
    for j=1:length(indices) - 1
        if indices(j + 1) > indices(j) + minimum_increase
            if start ~= 1 || indices(1) ~= 1 % ignore first if incomplete 
                cycles_time{k} = ...
                    timesteps(indices(start):indices(j + 1) - 1); %#ok<*AGROW>
                cycles_frame{k} = indices(start):indices(j + 1) - 1; 
                k = k + 1;
            end
            start = j + 1;
        end
    end

end