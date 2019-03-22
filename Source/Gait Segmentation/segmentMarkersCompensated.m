function [cycles_time, cycles_frame] = segmentMarkersCompensated(side, motion_data)
% Segment markers according to peak toe displacement in forward direction.
%
% This assumes that the input motion data is in the OpenSim coordinate
% system (X forward from subject, Y up, Z to the right).    

    minimum_increase = 5;

    if strcmp(side, 'left')
        str = 'L_MTP1_X';
    else
        str = 'R_MTP1_X';
    end
    
    % Note: motion_data must be in OpenSim coordinate system!
    mtp1_vel = diff(motion_data.getColumn(str));
    
    indices = find(mtp1_vel < 1e-3);
    
    cycles_time = {};
    cycles_frame = {};
    timesteps = motion_data.getColumn('time');
    
    k = 1;
    start = 1;
    for j=1:length(indices) - 1
        if indices(j + 1) > indices(j) + minimum_increase
            if start ~= 1  % ignore first, likely incomplete 
                cycles_time{k} = ...
                    timesteps(indices(start):indices(j + 1) - 1); %#ok<*AGROW>
                cycles_frame{k} = indices(start):indices(j + 1) - 1; 
                k = k + 1;
            end
            start = j + 1;
        end
    end

end