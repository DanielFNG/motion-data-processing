function motions = processMotionData(motions, motion_delays, speed, ...
    speed_delay, seg_index, seg_params)
    
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
        n_params = length(seg_params);
        
        % Perform all requested segmentations.
        k = 1;
        for i = 1:n_motions
            for j = 1:n_params
                motions{k} = motions{i}.segment(seg_params{j});
                k = k + 1;
            end
        end
    end
    
end
