function processGRFData(data_folder, rotations, save_dir)

% Get the files.
grf_files = dir([data_folder filesep '*.mot']);
n_files = length(grf_files);

for i=1:n_files
    input_grf = [data_folder filesep grf_files(i).name];
    output_grf = produceMOT(input_grf, save_dir);
    grfs = Data(output_grf);
    grfs.rotate(rotations{:});
    grfs.writeToFile(output_markers);
end

end

