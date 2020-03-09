function processMotionData(marker_save_dir, grf_save_dir, ...
    marker_file, grf_file, marker_system, grf_system, ...
    x_offset, y_offset, z_offset, time_delay, ...
    speed, inclination, assistance_params, ...
    feet, mode, marker_folder, grf_folder)

    % Produce data objects.
    markers = Data(marker_file);
    markers.convert(marker_system);
    grfs = produceMOT(grf_file, grf_system, inclination);
    
    % Convert marker units to 'm' if they're not in that form already.
    markers.convertUnits('m');
    
    % Synchronise. 
    [markers, grfs] = synchronise(markers, grfs, time_delay);
    
    % Coordinate system offset compensation.
    markers = applyOffsets(markers, x_offset, y_offset, z_offset);
    
    % Speed compensation.
    if isa(speed, 'char')
        speed_data = Data(speed);
        [~, marker_speed] = synchronise(markers, speed_data, time_delay);
        grf_speed = copy(marker_speed);
        marker_speed.spline(markers.getTimesteps());
        grf_speed.spline(grfs.getTimesteps());
        marker_speed = calculateSpeedArray(marker_speed, 1, 0.01);
        grf_speed = calculateSpeedArray(grf_speed, 1, 0.01);
        markers = compensateSpeedMarkers(markers, marker_speed, 'x');
        grfs = compensateSpeedGRF(grfs, grf_speed, 'x');
    elseif speed ~= 0
        markers = compensateSpeedMarkers(markers, speed, 'x');
        grfs = compensateSpeedGRF(grfs, speed, 'x');
    end
    
    % Add assistive torques as external forces/moments.
    if ~isempty(assistance_params)
        [grfs, markers] = applyParameterisedAssistance(...
            grfs, assistance_params, markers);
    end
    
    if nargin == 17
        % Segment & save files.
        for foot = feet
            segment(foot{1}, mode, grfs, markers, ...
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

