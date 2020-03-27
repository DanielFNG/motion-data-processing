function writeSegmentedMotions(motions, save_dirs)

    % Produce files.
    n_motions = size(motions, 2);
    n_segments = size(motions, 1);
    for i = 1:n_motions
        for j = 1:n_segments
            motions{j, i}.Motion.writeToFile([save_dirs(i) filesep ...
                motions{i}.Motion.Name]);
        end
    end

end