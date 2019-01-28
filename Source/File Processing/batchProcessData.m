function batchProcessData(analysis, markers, grfs, save_dir, info, ...
    marker_rotations, grf_rotations, time_delay, mode, cutoff)
    
    switch analysis
        case 'Static'
            func = @processStaticData;
            n_dirs = 1;
            args = {marker_rotations, save_dir};
        case 'Motion' 
            func = @processMotionData;
            n_dirs = 2;
            args = {marker_rotations, grf_rotations, ...
                time_delay, save_dir};
        case 'Marker'
            func = @processMarkerData;
            n_dirs = 1;
            args = {marker_rotations, save_dir};
        case 'GRF'
            func = @processGRFData;
            n_dirs = 1;
            args = {grf_rotations, save_dir};
        case 'Gait'
            func = @processGaitData;
            n_dirs = 2;
            args = {marker_rotations, grf_rotations, time_delay, mode, ...
                cutoff, save_dir};
    end
    
    switch n_dirs
        case 1
            [n_files, files] = getFilePaths(dirs{1});
        case 2
            [n_markers, markers] = getFilePaths(dirs{1});
            [n_grfs, grfs] = getFilePaths(dirs{2});
            if ~(n_markers == n_grfs)
                error('Unequal number of markers and grf files.');
            end
            n_files = n_markers;
            files = tranpose([markers; grfs]);
    end
    
    for i=1:n_files
        try
            func(files{1, :}, args{:});
        catch err
            fprintf('Failed to process on entry %i.n', i);
            if info 
                disp(getReport(err, 'extended', 'hyperlinks', 'on'));
            end
        end
    end

end