function processMotionData(save_dir, markers, grfs, emg, ...
    grf_delay, emg_delay, speed, speed_delay, ...
    feet, mode, marker_folder, grf_folder, emg_folder)
    
    % Synchronise. 
    if ~isempty(grf_delay)
        [markers, grfs] = synchronise(markers, grfs, grf_delay);
    end
    if ~isempty(emg_delay)
        if ~isempty(markers)
            [markers, emg] = synchronise(markers, emg, emg_delay);
        else
            [grfs, emg] = synchronise(grfs, emg, emg_delay);
        end
    end
    
    % Speed compensation given speed history.
    if isa(speed, 'char')
        
        % Get speed as data object.
        speed_data = Data(speed);
        
        % Synchronise to markers or GRFs. Note: grfs & markers are either 
        % both present and already synced to markers, or speed_delay refers
        % to whichever one is present, hence only need for one speed
        % delay constant.
        if ~isempty(markers)
            [~, marker_speed] = synchronise(markers, speed_data, speed_delay);
            marker_speed.spline(markers.getTimesteps());
            marker_speed = calculateSpeedArray(marker_speed, 1, 0.01);
            markers = compensateSpeedMarkers(markers, marker_speed, 'x');
        end
        if ~isempty(grfs)
            [~, grf_speed] = synchronise(grfs, speed_data, speed_delay);
            grf_speed.spline(grfs.getTimesteps());
            grf_speed = calculateSpeedArray(grf_speed, 1, 0.01);
            grfs = compensateSpeedGRF(grfs, grf_speed, 'x');
        end
    elseif speed ~= 0  % Constant speed
        if ~isempty(markers)
            markers = compensateSpeedMarkers(markers, speed, 'x');
        end
        if ~isempty(grfs)
            grfs = compensateSpeedGRF(grfs, speed, 'x');
        end
    end
    
    % Segmentation of data objects
    if nargin == 17
        % Segment & save files.
        for foot = feet
            segment(foot{1}, mode, grfs, markers, ...
                marker_save_dir, grf_save_dir, marker_folder, grf_folder);
        end
    else
        % Produce files.
        markers.writeToFile(...
            [save_dir filesep marker_folder filesep markers.Name]);
        grfs.writeToFile(...
            [save_dir filesep grf_folder filesep grfs.Name]);
        emg.writeToFile(...
            [save_dir filesep emg_folder filesep emg.Name]);
    end
end

