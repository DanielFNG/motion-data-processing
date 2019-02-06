function cycles = segmentMarkers(side, motion_data)
% Segment markers according to peak toe displacement in forward direction.
%
% This assumes that the input motion data is in the OpenSim coordinate
% system (X forward from subject, Y up, Z to the right).    

    if strcmp(side, 'left')
        str = 'L_MTP1_X';
    else
        str = 'R_MTP1_X';
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