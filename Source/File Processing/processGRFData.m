function processGRFData(...
    save_dir, grfs_file, rotations, feet, mode, cutoff, save_folder)

    % Load grfs data.
    grfs = produceMOT(grfs_file, save_dir);
    
    % Rotate.
    grfs.rotate(rotations{:});
    
    if nargin == 7
        for i=1:length(feet)
            segment(feet{i}, mode, cutoff, grfs, [], [], save_dir, save_folder);
        end
    else
        % Write .mot file.
        [~, name, ~] = fileparts(grfs_file);
        grfs.writeToFile([save_dir filesep name]);
    end

end

