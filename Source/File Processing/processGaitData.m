function processGaitData(marker_file, grf_file, marker_rotations, ...
    grf_rotations, time_delay, mode, cutoff, save_dir, info)

    % Process + load data.
    marker_data = Data(input_markers);
    grf_data = createGRFData(input_grf, save_dir);
        
    % Synchronise. 
    [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
        
    % Rotate.
    markers.rotate(marker_rotations{:});
    grfs.rotate(grf_rotations{:});
        
    % Segment & save files. 
    [~, marker_name, ~] = fileparts(marker_file);
    inner_save = [save_dir filesep marker_name];
    mkdir(inner_save);
    segment('left', mode, cutoff, grfs, markers, inner_save);
    segment('right', mode, cutoff, grfs, markers, inner_save);        
end
