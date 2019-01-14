function processMotionData(...
    data_folder, marker_rotations, grf_rotations, time_delay, save_dir)

% Get the files.
marker_files = dir([data_folder filesep '*.trc']);
grf_files = dir([data_folder filesep '*.txt']);
n_files = length(grf_files);

% Need the same amount of files (for synchronisation).
if length(marker_files) ~= n_files
    error('Require access to GRF and marker data for all files.');
end

for i=1:n_files
    try
        input_grf = [input_folder filesep grf_files(i).name];
        input_markers = [input_folder filesep marker_files(i).name];
        output_markers = [save_dir filesep marker_files(i).name];
        output_grf = produceMOT(input_grf, save_dir);
        [grfs, markers] = synchronise(output_grf, input_markers, time_delay);
        markers.rotate(marker_rotations{:});
        grfs.rotate(grf_rotations{:});
        markers.writeToFile(output_markers);
        grfs.writeToFile(output_grf);
    catch err
        fprintf('\nFailed to process on entry %i. Error message below.\n', i);
        warning(err.message);
    end
end

end

