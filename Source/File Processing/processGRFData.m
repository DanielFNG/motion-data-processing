function times = processGRFData(save_dir, grfs_file, system, ...
    speed, inclination, feet, mode, cutoff, save_folder)

    % Load grfs data.
    grfs = produceMOT(grfs_file, system, inclination, save_dir);
    
    % Compensate for motion speed.
    if isa(speed, 'char')
        speed_data = Data(speed);
        [grfs, speed_data] = synchronise(grfs, speed_data, 0);
        speed_data.spline(grfs.getColumn('time'));
        speed = calculateSpeedArray(speed_data, 1, 0.01);
    end
    grfs = compensateSpeedGRF(grfs, speed, 'x');
    
    % Segmentation if necessary.
    if nargin == 9
        for i=1:length(feet)
            times = segment(feet{i}, mode, cutoff, grfs, [], [], save_dir, ...
                [], save_folder);
        end
    else
        % Write .mot file.
        [~, name, ~] = fileparts(grfs_file);
        grfs.writeToFile([save_dir filesep name]);
    end

end

