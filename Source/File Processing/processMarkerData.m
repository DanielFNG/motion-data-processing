function processMarkerData(save_dir, marker_file, system, speed, direction, ...
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
        markers = compensateSpeedMarkers(markers, speed, direction);
    end
    
    % Segmentation if requested.
    if nargin == 10
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

