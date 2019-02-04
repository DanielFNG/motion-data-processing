function cycles = segmentMarkers(side, motion_data)

    if strcmp(side, 'left')
        str = 'L_MTP1_Z';
    else
        str = 'R_MTP1_Z';
    end
    
    % Note: motion_data must be in OpenSim coordinate system!
    [~, indices] = findpeaks(motion_data.getColumn(str));
    n_cycles = length(indices) - 1;
    cycles = cell(1, n_cycles);
    timesteps = motion_data.getColumn('time');
    
    for i=1:n_cycles
        cycles{i} = timesteps(indices(i):indices(i+1) - 1);
    end

end