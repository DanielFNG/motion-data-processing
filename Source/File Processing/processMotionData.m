function processMotionData(...
    data_folder, marker_rotations, grf_rotations, time_delay, save_dir, info)

% Check if detailed error reporting is required. 
if nargin < 6
    info = false;
end

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
        input_grf = [data_folder filesep grf_files(i).name];
        input_markers = [data_folder filesep marker_files(i).name];
        output_markers = [save_dir filesep marker_files(i).name];
        output_grf = produceMOT(input_grf, save_dir);
        [markers, grfs] = synchronise(input_markers, output_grf, time_delay);
        markers.rotate(marker_rotations{:});
        grfs.rotate(grf_rotations{:});
        markers.writeToFile(output_markers);
        grfs.writeToFile(output_grf);
    catch err
        fprintf('Failed to process on entry %i.\n', i);
        if info
            disp(getReport(err, 'extended', 'hyperlinks', 'on'))
        end
    end
end

end

