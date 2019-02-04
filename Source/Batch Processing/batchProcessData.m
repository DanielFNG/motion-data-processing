function batchProcessData(settings)
    
    switch settings.analysis
        case 'Static'
            func = @processStaticData;
            dirs = {settings.markers};
            ext = '.trc';
            args = {settings.marker_rotations, settings.save_dir};
        case 'Motion' 
            func = @processMotionData;
            dirs = {settings.markers, settings.grfs};
            args = {settings.marker_rotations, settings.grf_rotations, ...
                settings.time_delay, settings.save_dir};
        case 'Marker'
            func = @processMarkerData;
            dirs = {settings.markers};
            ext = '.trc';
            args = {settings.marker_rotations, settings.save_dir};
        case 'GRF'
            func = @processGRFData;
            dirs = {settings.grfs};
            ext = '.txt';
            args = {settings.grf_rotations, settings.save_dir};
    end
    
    if isfield(settings, 'mode')
        args = [args {settings.feet}, settings.mode, settings.cutoff];
    end
    
    n_dirs = length(dirs);
    switch n_dirs
        case 1
            [n_files, files] = getFilePaths(dirs{1}, ext);
        case 2
            [n_markers, markers] = getFilePaths(dirs{1}, '.trc');
            [n_grfs, grfs] = getFilePaths(dirs{2}, '.txt');
            if ~(n_markers == n_grfs)
                error('Unequal number of markers and grf files.');
            end
            n_files = n_markers;
            files = [markers; grfs];
    end
    
    if ~exist(settings.save_dir, 'dir')
        mkdir(settings.save_dir);
    end
    
    for i=1:n_files
        try
            func(files{:, i}, args{:});
        catch err
            fprintf('Failed to process on entry %i.\n', i);
            fprintf(err.message);
            fprintf('\n');
            if settings.info 
                disp(getReport(err, 'extended', 'hyperlinks', 'on'));
            end
        end
    end

end