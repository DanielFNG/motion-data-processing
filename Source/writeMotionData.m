function motions = writeMotionData(motions, motion_delays, speed, ...
    speed_delay, seg_index, seg_params, save_dir, save_folders)
    
    % Store the total number of input motions.
    n_motions = length(motions);
    if n_motions == 1
        motions = {motions};
    end
    
    % Synchronise motions.
    if n_motions > 1
        for i = 2:n_motions
            [motions{1}, motions{i}] = ...
                motions{1}.synchronise(motions{i}, motion_delays(i - 1));
        end
    end
    
    % Compensate for motion speed.
    if ~isempty(speed)
        for i = 1:n_motions
            motions{i}.compensateMotion(speed, speed_delay);
        end
    end
    
    % Segment motions.
    if ~isempty(seg_index)
        % Handle one or multiple segmentation parameters.
        if ~isa(seg_params, 'cell')
            seg_params = {seg_params};
        end
        
        % Perform all requested segmentations.
        for param = seg_params
            % Get cycle times.
            cycle_times = motions{seg_index}.getSegmentationTimes(param);
            
            % Segment all motions.
            for i = 1:n_motions
                save_string = [param filesep save_folder(i)];
                motions{i}.segment(cycle_times, save_dir, save_string);
            end
        end
    else
        % Produce files.
        for i = 1:n_motions
            motions{i}.Motion.writeToFile([save_dir filesep ...
                save_folders{i} filesep motions{i}.Motion.Name]);
        end
    end
    
end
