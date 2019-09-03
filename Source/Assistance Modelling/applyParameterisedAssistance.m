function [grfs, markers] = ...
    applyParameterisedAssistance(grfs, params, cutoff, markers)

    % Parameters. 
    sides = {'left', 'right'};
    left_index = 1;
    right_index = 2;
    init = 1000;
    avg_window = 3;
    
    % Setup some arrays. 
    n_sides = length(sides);
    frames = cell(1, n_sides);
    apo_torques = ones(grfs.NFrames, n_sides)*init;
    
    for side = 1:n_sides
        % Get the indices corresponding to each gait cycle.
        [~, frames{side}] = segmentGRF(sides{side}, cutoff, grfs);
        
        % Get the number of cycles and create an array to store the number
        % of frames in each cycle.
        n_cycles = length(frames{side});
        n_frames = zeros(1, n_cycles);   
        
        % Loop over the cycles, starting from the avg_window + 1 cycle.
        for cycle = avg_window + 1:n_cycles
            
            % Compute the number of frames predicted to be in that cycle -
            % from the mean of the previous avg_window cycles.
            for inner_cycle = cycle - avg_window:cycle - 1
                n_frames(cycle) = n_frames(cycle) + ...
                    length(frames{side}{inner_cycle});
            end
            n_frames(cycle) = round(n_frames(cycle)/avg_window);
            
            % Next, generate the torque pattern that would be applied by
            % the given number of parameters.
            profile = generateAssistiveProfile(n_frames(cycle), ...
                params.force, params.rise, params.peak, params.fall);
            
            % Compare the predicted and true number of frames in the cycle.
            disparity = length(frames{side}{cycle}) - n_frames(cycle);
            if disparity > 0
                % If the gait was longer than expected, loop the profile.
                apo_torques(...
                    frames{side}{cycle}(1:end - disparity), side) = profile;
                apo_torques(frames{side}{cycle}...
                    (end - disparity + 1:end), side) = profile(1:disparity);
            % If the gait was as expected, it's a perfect match.
            elseif disparity == 0
                apo_torques(frames{side}{cycle}, side) = profile;
            % If the gait was shorter than expected, simply complete as
            % much of the profile as you can.
            else
                apo_torques(frames{side}{cycle}, side) = ...
                    profile(1:end + disparity);  % + since it's negative
            end
        end
    end
    
    % Create a new GRF object which has the correct APO forces appended to
    % it.
    grfs = createAPOGRFs(grfs, ...
        apo_torques(:, left_index), apo_torques(:, right_index));
    
    % Slice the GRF data to the point after which both the left & right APO
    % torques are well defined.
    good_frames = find(apo_torques(:, left_index) ~= init & ...
        apo_torques(:, right_index) ~= init);
    grfs = grfs.slice(good_frames); %#ok<*FNDSB>
    
    % If requested, slice the marker data.
    if nargin == 4
        grf_times = grfs.getTimesteps();
        marker_times = markers.getTimesteps();
        marker_frames = find(marker_times(marker_times >= grf_times(1) & ...
            marker_times <= grf_times(end)));
        grf_frames = find(grf_times(grf_times >= marker_times(1) & ...
            grf_times <= marker_times(end)));
        grfs.slice(grf_frames);
        markers.slice(marker_frames);
    end
    
end