function segmentMotionData(markers, grfs, cutoff, mode, save_dir)

% Get the files.
n_files = length(markers);

% Need the same amount of files (for synchronisation).
if length(grfs) ~= n_files
    error('Require access to GRF and marker data for all files.');
end

for i=1:n_files
    segment('left', mode, cutoff, grf_files(i), marker_files(i), save_dir);
    segment('right', mode, cutoff, grf_files(i), marker_files(i), save_dir);
end

end

