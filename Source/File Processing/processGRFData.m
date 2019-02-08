function processGRFData(save_dir, grfs_file, rotations, feet, mode, cutoff)

    % Load grfs data.
    grfs = produceMOT(grfs_file, save_dir);
    
    % Rotate.
    grfs.rotate(rotations{:});
    
    [~, name, ~] = fileparts(grfs_file);
    if nargin == 6
        for i=1:length(feet)
            segment(feet{i}, mode, cutoff, grfs, [], name, save_dir);
        end
    else
        % Write .mot file.
        grfs.writeToFile([save_dir filesep name]);
    end

end

