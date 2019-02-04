function processMarkerData(marker_file, rotations, save_dir, feet, mode, cutoff)

    % Load marker data.
    markers = Data(marker_file);
        
    % Rotate.
    markers.rotate(rotations{:});
    
    [~, name, ~] = fileparts(marker_file);
    if nargin == 6
        for i=1:length(feet)
            segment(feet{i}, mode, cutoff, [], markers, name, save_dir);
        end
    else
        % Write updated marker file.
        markers.writeToFile([save_dir filesep name]);
    end
end

