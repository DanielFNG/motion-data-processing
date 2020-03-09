function [cycles_time, cycles_frame] = segmentMarkers(side, motion_data)
% Segment markers according to an approximation of hip flexion/extension.
%
% Segments according to the point of maximum EXTENSION of the chosen side.
%
% This assumes that the input motion data is in the OpenSim coordinate
% system (X forward from subject, Y up, Z to the right).    

    if strcmp(side, 'left')
        upper_str = 'L_ASIS';
        front_str = 'L_Thigh_Front';
    else
        upper_str = 'R_ASIS';
        front_str = 'R_Thigh_Front';
    end
    
    % Calculate the angle between these markers. 
    upper_x = motion_data.getColumn([upper_str '_X']);
    upper_y = motion_data.getColumn([upper_str '_Y']);
    front_x = motion_data.getColumn([front_str '_X']);
    front_y = motion_data.getColumn([front_str '_Y']);
    angle = atan((front_x - upper_x)./(upper_y - front_y));
    
    % Find the crossing points.
    crossing_points = [];
    for i=2:length(angle)
        if angle(i) > 0 && angle(i - 1) <= 0
            crossing_points = [crossing_points i];
        end
    end
    
    % Find the largest peak between each pair of crossing points,
    % discarding the positive ones.
    indices = [];
    for i=2:length(crossing_points)
        temp = ones(size(angle))*100;
        range = crossing_points(i - 1):crossing_points(i);
        temp(range) = angle(range);
        [~, idx] = min(temp);
        indices = [indices idx];  %#ok<*AGROW>
    end
    
    % Note: motion_data must be in OpenSim coordinate system!
    n_cycles = length(indices) - 1;
    cycles_time = cell(1, n_cycles);
    cycles_frame = cycles_time;
    timesteps = motion_data.getColumn('time');
    
    for i=1:n_cycles
        cycles_time{i} = timesteps(indices(i):indices(i+1) - 1);
        cycles_frame{i} = indices(i):indices(i+1) - 1;
    end

end