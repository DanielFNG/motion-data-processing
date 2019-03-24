function processMotionData(marker_save_dir, grf_save_dir, ...
    marker_file, grf_file, marker_rotations, grf_rotations, time_delay, ...
    speed, direction, feet, mode, cutoff, marker_folder, grf_folder)

    % Produce data objects.
    marker_data = Data(marker_file);
    grf_data = produceMOT(grf_file, grf_save_dir);
    
    % Convert marker units to 'm' if they're not in that form already.
    marker_data.convertUnits('m');
    
    % Synchronise. 
    [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
    
    % Rotate.
    markers.rotate(marker_rotations{:});
    grfs.rotate(grf_rotations{:});
    
    % Speed compensation.
    if ~isempty(speed)
        markers = compensateSpeedMarkers(markers, speed, direction);
        grfs = compensateSpeedGRF(grfs, speed, direction);
    end
    
    if nargin == 14
        % Segment & save files.
        for foot = feet
            segment(foot{1}, mode, cutoff, grfs, markers, ...
                marker_save_dir, grf_save_dir, marker_folder, grf_folder);
        end
    else
        % Produce files.
        [~, marker_name, ~] = fileparts(marker_file);
        [~, grfs_name, ~] = fileparts(grf_file);
        markers.writeToFile([marker_save_dir filesep marker_name]);
        grfs.writeToFile([grf_save_dir filesep grfs_name]);
    end
end

