function removeMissingFrames(markers_file, grfs_file)
% Detect & remove missing frames in a marker file, & optionally a grf file.

    % Use missingData function in TRCData class.
    [gaps_start, gaps_end, markers] = TRCData.missingData(markers_file);
    
    % Write resulting TRCData object to file.
    markers.writeToFile(markers_file);
    
    % Deal with GRFs also. 
    if nargin > 1 && ~isempty(grfs_file)
    
        % Identify the start/end of the problematic data - in terms of timesteps
        % to account for data frequency mismatch.
        marker_timesteps = markers.getColumn('time');
        start_time = marker_timesteps(gaps_start+1);
        end_time = marker_timesteps(gaps_end-1);
        
        % Load the grf file and isolate the non-problematic frames.
        grfs = Data(grfs_file);
        grf_timesteps = grfs.getColumn('time');
        grf_frames = grf_timesteps(grf_timesteps >= start_time & ...
            grf_timesteps <= end_time);
            
        % Slice only the good frames and print to file.
        grfs.slice(grf_frames);
        grfs.writeToFile(grfs_file);
    end
                
end