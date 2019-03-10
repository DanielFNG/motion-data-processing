function [cop, forces, moments, time] = processCOP(cop, forces, moments, time)

    % Value of vertical force for which we trust the CoP calculation.
    f_min = 200;

    % For left and right feet.
    for k=0:3:3
        
        % Store some indices.
        f_index = 2 + k;
        cop_z_index = 1 + k;
        cop_x_index = 3 + k;
        
        % Get the indices of stance.
        stance = find(forces(:, f_index) ~= 0);

        % For segmentation.
        splits = find(diff(stance) > 1);

        % For every stance phase. 
        start = 1;
        for i=1:length(splits) + 1
            if i == length(splits) + 1
                range = stance(start):stance(end);
            else
                range = stance(start):stance(splits(i));
                start = splits(i) + 1;
            end
            
            % Get indices of trusted CoP data.
            valid_start_idx = find(forces(range, f_index) > f_min, ...
                1, 'first') + range(1) -1;
            
            % If we are left with a small enough section of the gait cycle
            % such that the CoP never becomes trustworthy (i.e. F_Y < f_min
            % for the entire portion) then... bin it, it's useless anyway.
            if isempty(valid_start_idx)
                forces(range, :) = [];
                moments(range, :) = [];
                cop(range, :) = [];
                time(range) = [];
                continue;
            end
            
            valid_last_idx = find(forces(range, f_index) > f_min, 1, ...
                'last') + range(1) - 1;
            
            % If there's no valid last index, but there is a valid start
            % index since we made it here, just go to the end of the data
            % that we have.
            if isempty(valid_last_idx)
                valid_last_idx = forces(end, f_index);
            end

            % Add the nearest known points of value 0 (e.g. not stance
            % phase).
            valid = valid_start_idx:valid_last_idx;
            z_vals = cop(valid, cop_z_index);
            x_vals = cop(valid, cop_x_index);
            if range(1) ~= valid_start_idx
                valid = [range(1) valid]; %#ok<*AGROW>
                z_vals = [0; z_vals];
                x_vals = [0; x_vals];
            end
            if range(end) ~= valid_last_idx
                valid = [valid range(end)];
                z_vals = [z_vals; 0];
                x_vals = [x_vals; 0];
            end

            % Extrapolate the data where F_Y < f_min.
            cop(range, cop_z_index) = ...
                interp1(valid, z_vals, range, 'pchip', 'extrap');
            cop(range, cop_x_index) = ...
                interp1(valid, x_vals, range, 'pchip', 'extrap');
        end

    end

end