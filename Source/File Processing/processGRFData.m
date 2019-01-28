function processGRFData(grfs_file, rotations, save_dir)

    % Load grfs data.
    grfs = createGRFData(grfs_file, save_dir);
    
    % Rotate.
    grfs.rotate(rotations{:});
    
    % Create .MOT file.
    grfs.writeToFile();

end

