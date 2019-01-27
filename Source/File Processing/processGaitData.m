function processGaitData(data_folder, marker_rotations, grf_rotations, ... time_delay, mode, cutoff, save_dir, info)

% Check if detailed error reporting is required. 
if nargin < 8
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
        % Load kinematic data.
        input_markers = [data_folder filesep marker_files(i).name];
        marker_data = Data(input_markers);
        
        % Process + load grf data.
        input_grf = [data_folder filesep grf_files(i).name];
        grf_data = createGRFData(input_grf, save_dir);
        
        % Synchronise. 
        [markers, grfs] = synchronise(marker_data, grf_data, time_delay);
        
        % Rotate.
        markers.rotate(marker_rotations{:});
        grfs.rotate(grf_rotations{:});
        
        % Segment & save files. 
        inner_save = [save_dir filesep 'Trial' sprintf('%03i', i)];
        mkdir(inner_save);
        segment('left', mode, cutoff, grfs, markers, inner_save);
        segment('right', mode, cutoff, grfs, markers, inner_save);        
    catch err
        fprintf('Failed to process on entry %i.\n', i);
        if info
            disp(getReport(err, 'extended', 'hyperlinks', 'on'))
        end
    end
end

end
