function processGaitData(marker_file, grf_file, marker_rotations, ...
    grf_rotations, time_delay, mode, cutoff, feet, save_dir)

    % Process + load data.
    marker_data = Data(marker_file);
    grf_data = produceMOT(grf_file, save_dir);
        
    % Synchronise. 
    [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
        
    % Rotate.
    markers.rotate(marker_rotations{:});
    grfs.rotate(grf_rotations{:});
        
    % Segment & save files. 
    for foot = feet
        segment(foot{1}, mode, cutoff, grfs, markers, save_dir);
    end        
end
