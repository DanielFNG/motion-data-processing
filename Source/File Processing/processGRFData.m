function times = processGRFData(save_dir, grfs_file, system, ...
    speed, direction, feet, mode, cutoff, save_folder)

    % Load grfs data.
    grfs = produceMOT(grfs_file, system, save_dir);
    
    % Compensate for motion speed.
    if ~isempty(speed)
        if isa(speed, 'char')
            speed_data = Data(speed);
            [grfs, speed_data] = synchronise(grfs, speed_data, 0);
            speed_data.spline(grfs.getColumn('time'));
            speed = calculateSpeedArray(speed_data);
        end
        grfs = compensateSpeedGRF(grfs, speed, direction);
    end
    
    % Segmentation if necessary.
    if nargin == 10
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

