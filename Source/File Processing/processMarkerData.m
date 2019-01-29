function processMarkerData(marker_file, rotations, save_dir)

    % Load marker data.
    markers = Data(marker_file);
        
    % Rotate.
    markers.rotate(rotations{:});
        
    % Write updated marker file.
    [~, name, ext] = fileparts(marker_file);
    markers.writeToFile([save_dir filesep name ext]);
end

