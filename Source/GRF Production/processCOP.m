function [cop, forces, moments, time] = ...
    processCOP(cop, forces, moments, time)

    % Value of vertical force for which we trust the CoP calculation.
    f_min = 200;
    
    % Create an array which will store indices of data to be binned.
    bin = [];
    
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
                bin = [bin range];
                
                % Unless we're at the very beginning, we can stop now. 
                if i ~= 1
                    break;
                end
            end
            
            valid_last_idx = find(forces(range, f_index) > f_min, 1, ...
                'last') + range(1) - 1;
            
            % If there's no valid last index, but there is a valid start
            % index since we made it here, just go to the end of the data
            % that we have.
            if isempty(valid_last_idx)
                valid_last_idx = size(forces, 1);
            end

           % Assume that CoP is unchanged outside of the valid range.
           for ind = [cop_z_index, cop_x_index]
               cop(range(1):valid_start_idx - 1, ind) = ...
                   cop(valid_start_idx, ind);
               cop(valid_last_idx + 1:range(end), ind) = ...
                   cop(valid_last_idx, ind);
           end
        end

    end
    
    % Bin the data the we don't trust and couldn't fix.
    forces(bin, :) = [];
    moments(bin, :) = [];
    cop(bin, :) = [];
    time(bin) = [];

end