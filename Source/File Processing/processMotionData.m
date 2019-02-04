function processMotionData(marker_file, grf_file, marker_rotations, ...
    grf_rotations, time_delay, save_dir, feet, mode, cutoff)

    % Produce data objects.
    marker_data = Data(marker_file);
    grf_data = produceMOT(grf_file, save_dir);
    
    % Syncronise. 
    [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
    
    % Rotate.
    markers.rotate(marker_rotations{:});
    grfs.rotate(grf_rotations{:});
    
    [~, marker_name, ~] = fileparts(marker_file);
    [~, grfs_name, ~] = fileparts(grf_file);
    if nargin == 9
        % Segment & save files.
        for foot = feet
            segment(...
                foot{1}, mode, cutoff, grfs, markers, marker_name, save_dir);
        end
    else
        % Produce files.
        markers.writeToFile([save_dir filesep marker_name]);
        grfs.writeToFile([save_dir filesep grfs_name]);
    end
end

