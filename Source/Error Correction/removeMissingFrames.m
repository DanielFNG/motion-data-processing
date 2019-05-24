function removeMissingFrames(markers_file, grfs_file)
% Detect & remove missing frames in a marker file, & optionally a grf file.

    % Use missingData function in TRCData class.
    [~, ~, markers] = TRCData.missingData(markers_file);
    
    % Deal with GRFs also. 
    if nargin > 1 && ~isempty(grfs_file)
    
        % Identify the start/end of the problematic data - in terms of timesteps
        % to account for data frequency mismatch.
        marker_timesteps = markers.getTimesteps();
        marker_timesteps = marker_timesteps - marker_timesteps(1);
        start_time = marker_timesteps(1);
        end_time = marker_timesteps(end);
        
        % Load the grf file and isolate the non-problematic frames.
        grfs = Data(grfs_file);
        grf_timesteps = grfs.getTimesteps();
        grf_timesteps = grf_timesteps - grf_timesteps(1);
        grf_frames = grf_timesteps >= start_time & ...
            grf_timesteps <= end_time;
            
        % Slice only the good frames and print to file.
        grfs.slice(grf_frames);
        grfs.writeToFile(grfs_file);
    end
    
    % Write resulting TRCData object to file.
    markers.writeToFile(markers_file);
                
end