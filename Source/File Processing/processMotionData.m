function processMotionData(marker_save_dir, grf_save_dir, ...
    marker_file, grf_file, marker_rotations, grf_rotations, ...
    time_delay, feet, mode, cutoff)

    % Produce data objects.
    marker_data = Data(marker_file);
    grf_data = produceMOT(grf_file, grf_save_dir);
    
    % Syncronise. 
    [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
    
    % Rotate.
    markers.rotate(marker_rotations{:});
    grfs.rotate(grf_rotations{:});
    
    [~, marker_name, ~] = fileparts(marker_file);
    [~, grfs_name, ~] = fileparts(grf_file);
    if nargin == 10
        % Segment & save files.
        for foot = feet
            segment(foot{1}, mode, cutoff, grfs, markers, ...
                marker_name, marker_save_dir, grf_save_dir);
        end
    else
        % Produce files.
        markers.writeToFile([marker_save_dir filesep marker_name]);
        grfs.writeToFile([grf_save_dir filesep grfs_name]);
    end
end

