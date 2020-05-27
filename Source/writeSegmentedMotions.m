function writeSegmentedMotions(motions, save_dirs)
% Input motions are a N x K cell array, K are the number of sources of
% motions (e.g Markers, GRF), with corresponding entries in save_dir. Each
% motion motions{i, j} can itself be a cell array of motions.

    % Note number of motions & segmentation sides.
    n_sides = size(motions, 1);
    n_motions = size(motions, 2);
    
    % Ensure inputs
    if length(save_dirs) ~= n_motions
        error('Number of save directories does not match input motions.');
    end

    % Produce files.
    for i = 1:n_motions
        for j = 1:n_sides
            n_segments = length(motions{j, i});
            if n_segments == 1
                motions{j, i} = motions(1);  % Contain char in cell
            end
            for k = 1:n_segments
                % Write motion
                motions{j, i}{k}.writeToFile(save_dirs{i});
            end
        end
    end

end