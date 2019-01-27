function processGRFData(data_folder, rotations, save_dir)

% Get the files.
grf_files = dir([data_folder filesep '*.mot']);
n_files = length(grf_files);

for i=1:n_files
    % Process & create GRF data.
    input_grf = [data_folder filesep grf_files(i).name];
    grfs = createGRFData(input_grf, save_dir);
    
    % Rotate.
    grfs.rotate(rotations{:});
    
    % Create .MOT file.
    grfs.writeToFile();
end

end

