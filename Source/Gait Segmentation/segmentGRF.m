function cycles = segmentGRF(side, cutoff, motion_data)

    minimum_increase = 5;

    if strcmp(side, 'left')
        str = 'ground_force2_vy';
    else
        str = 'ground_force1_vy';
    end
    
    timesteps = motion_data.getColumn('time');
    indices = find(motion_data.getColumn(str) > cutoff);
    cycles = {};
    k = 1;
    start = 1;
    for j=1:length(indices) - 1
        if indices(j + 1) > indices(j) + minimum_increase
            if start ~= 1  % ignore first, likely incomplete 
                cycles{k} = ...
                    timesteps(indices(start):indices(j + 1) - 1); %#ok<AGROW>
                k = k + 1;
            end
            start = j + 1;
        end
    end

end