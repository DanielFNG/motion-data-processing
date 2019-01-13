function segmentMotionData(inputArg1,inputArg2)

for i=1:n_files
    try
        input_grf = [input_folder filesep grf_files(i).name];
        input_markers = [input_folder filesep marker_files(i).name];
        output_markers = [save_dir filesep marker_files(i).name];
        output_grf = produceMOT(input_grf);
        [grfs, markers] = synchronise(output_grf, input_markers, time_delay);
        markers.rotate(marker_rotations{:});
        grfs.rotate(grf_rotations{:});
        markers.writeToFile(output_markers);
        grfs.writeToFile(output_grf);

        segment('left', 'stance', 40, output_grf, input_markers, save_dir);
        segment('right', 'stance', 40, output_grf, input_markers, save_dir);
    catch err
        fprintf('\nFailed to process on entry %i. Error message below.\n', i);
        warning(err.message);
    end
end

end

