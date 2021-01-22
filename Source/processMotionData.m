function processed_motions = processMotionData(motions, sync_index, delays, ...
    speed, speed_delay, seg_index, seg_params)
    
    % Store the total number of input motions.
    n_motions = length(motions);
    if n_motions == 1 && ~isa(motions, 'cell')
        motions = {motions};
    end
    
    % Synchronise motions.
    if n_motions > 1 && ~isempty(sync_index)
        for i = 1:n_motions
            if i ~= sync_index  % Don't sync to yourself
                motions{sync_index}.synchronise(motions{sync_index}, delays(i));
            end
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
        processed_motions = cell(n_params, n_motions);
        for i = 1:n_motions
            for j = 1:n_params  % Multiple sides at once
                processed_motions{j, i} = ...
                    motions{i}.segment(motions{seg_index}, seg_params{j});
            end
        end
    else
        processed_motions = motions;
    end
    
end
