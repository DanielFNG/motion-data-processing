function processMotionData(marker_file, grf_file, marker_rotations, ...
    grf_rotations, time_delay, save_dir)

    % Produce data objects.
    marker_data = Data(input_markers);;
    grf_data = produceMOT(input_grf, save_dir);
    
    % Syncronise. 
    [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
    
    % Rotate.
    markers.rotate(marker_rotations{:});
    grfs.rotate(grf_rotations{:});
    
    % Produce files.
    [~, marker_name, marker_ext] = fileparts(marker_file);
    markers.writeToFile([save_dir filesep marker_name marker_ext]);
    grfs.writeToFile();
end

