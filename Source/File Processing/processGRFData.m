function processGRFData(save_dir, grfs_file, rotations, left_handed, ...
    speed, direction, feet, mode, cutoff, save_folder)

    % Load grfs data.
    grfs = produceMOT(grfs_file, save_dir);
    
    % Rotate.
    grfs.rotate(rotations{:}, left_handed);
    
    % Compensate for motion speed.
    if ~isempty(speed)
        grfs = compensateSpeedGRF(grfs, speed, direction);
    end
    
    % Segmentation if necessary.
    if nargin == 10
        for i=1:length(feet)
            segment(...
                feet{i}, mode, cutoff, grfs, [], [], save_dir, [], save_folder);
        end
    else
        % Write .mot file.
        [~, name, ~] = fileparts(grfs_file);
        grfs.writeToFile([save_dir filesep name]);
    end

end

