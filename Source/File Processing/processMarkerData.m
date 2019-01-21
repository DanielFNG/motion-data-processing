function processMarkerData(data_folder, rotations, save_dir, info)

% Check if detailed error reporting is required.
if nargin < 4
    info = false;
end

% Get the files.
marker_files = dir([data_folder filesep '*.trc']);
n_files = length(marker_files);

for i=1:n_files
    try
        input_markers = [data_folder filesep marker_files(i).name];
        output_markers = [save_dir filesep marker_files(i).name];
        markers = Data(input_markers);
        markers.rotate(rotations{:});
        markers.writeToFile(output_markers);
    catch err
        fprintf('\nFailed to process on file %s.\n', input_markers);
        if info
            disp(getReport(err, 'extended', 'hyperlinks', 'on'))
        end
    end
end

end

