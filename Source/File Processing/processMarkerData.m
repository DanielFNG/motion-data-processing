function processMarkerData(save_dir, marker_file, system, speed, ...
    feet, save_folder)

    % Load marker data.
    markers = produceMarkers(marker_file, system);
    
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
    if nargin == 6
        for i=1:length(feet)
            segment(feet{i}, 'toe-peak', [], markers, save_dir, [], ...
                save_folder, []);
        end
    else
        % Write updated marker file.
        [~, name, ~] = fileparts(marker_file);
        markers.writeToFile([save_dir filesep name]);
    end
end

