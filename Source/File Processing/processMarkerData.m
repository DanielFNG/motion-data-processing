function processMarkerData(save_dir, marker_file, system, speed, ...
    feet, mode, cutoff, save_folder)

    % Load marker data.
    markers = Data(marker_file);
    
    % Convert units to 'm' if they're not in that form already.
    markers.convertUnits('m');
    
    % Convert co-ordinates to OpenSim default.
    markers.convert(system);
    
    % Compensate for motion speed. Only supports fixed speed since we only
    % have marker data. 
    if ~isempty(speed)
        if isa(speed, 'char')
            speed_data = Data(speed);
            [markers, speed_data] = synchronise(markers, speed_data, 0);
            speed_data.spline(markers.getColumn('time'));
            speed = calculateSpeedArray(speed_data, 1, 0.01);
        end
        markers = compensateSpeedMarkers(markers, speed, 'x');
    end
    
    % Segmentation if requested.
    if nargin == 8
        for i=1:length(feet)
            segment(feet{i}, mode, cutoff, [], markers, save_dir, [], ...
                save_folder, []);
        end
    else
        % Write updated marker file.
        [~, name, ~] = fileparts(marker_file);
        markers.writeToFile([save_dir filesep name]);
    end
end

