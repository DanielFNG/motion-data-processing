function processMarkerData(save_dir, marker_file, rotations, speed, ...
    direction, feet, mode, cutoff, save_folder)

    % Load marker data.
    markers = Data(marker_file);
        
    % Rotate.
    markers.rotate(rotations{:});
    
    % Compensate for motion speed.
    if ~isempty(speed)
        markers = compensateSpeedMarkers(markers, speed, direction);
    end
    
    % Segmentation if requested.
    if nargin == 9
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

