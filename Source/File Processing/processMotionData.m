function processMotionData(marker_save_dir, grf_save_dir, ...
    marker_file, grf_file, marker_system, grf_system, time_delay, ...
    speed, inclination, feet, mode, cutoff, marker_folder, grf_folder)

    % Produce data objects.
    marker_data = Data(marker_file);
    marker_data.convert(marker_system);
    grf_data = produceMOT(grf_file, grf_system, inclination, grf_save_dir);
    
    % Convert marker units to 'm' if they're not in that form already.
    marker_data.convertUnits('m');
    
    % Synchronise. 
    [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
    
    % Speed compensation.
    if isa(speed, 'char')
        speed_data = Data(speed);
        [~, speed_data] = ...
            synchronise(marker_data, speed_data, time_delay);
        grf_speed = copy(speed_data);
        speed_data.spline(markers.getColumn('time'));
        grf_speed.spline(grfs.getColumn('time'));
        speed = calculateSpeedArray(speed_data, 1, 0.01);
        grf_speed = calculateSpeedArray(grf_speed, 1, 0.01);
    end
    markers = compensateSpeedMarkers(markers, speed, 'x');
    grfs = compensateSpeedGRF(grfs, grf_speed, 'x');
    
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

