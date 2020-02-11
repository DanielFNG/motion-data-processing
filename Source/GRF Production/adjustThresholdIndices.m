function [left_indices, right_indices] = ...
    adjustThresholdIndices(left_indices, right_indices)

    % The first recorded index is always to be adjusted.
    adjust_left = 1;
    adjust_right = 1;
    
    % Record the start and end of each set of threshold indices.
    for i=2:length(left_indices)
        if left_indices(i) - left_indices(i - 1) > 1
            adjust_left = [adjust_left, i-1, i]; %#ok<*AGROW>
        end
    end
    
    for i=2:length(right_indices)
        if right_indices(i) - right_indices(i - 1) > 2
            adjust_right = [adjust_right, i-1, i];
        end
    end

    % Adjust (aka remove) the recorded indices. 
    left_indices(adjust_left) = [];
    right_indices(adjust_right) = [];
    
end