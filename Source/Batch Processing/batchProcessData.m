function status = batchProcessData(settings)

    switch settings.analysis
        case 'Static'
            func = @processStaticData;
            dirs = {settings.markers};
            ext = '.trc';
            args = {settings.marker_rotations};
            folder_names = {settings.marker_folder};
        case 'Motion'
            func = @processMotionData;
            dirs = {settings.markers, settings.grfs};
            args = {settings.marker_rotations, settings.grf_rotations, ...
                settings.time_delay};
            folder_names = {settings.marker_folder, settings.grf_folder};
        case 'Marker'
            func = @processMarkerData;
            dirs = {settings.markers};
            ext = '.trc';
            args = {settings.marker_rotations};
            folder_names = {settings.marker_folder};
        case 'GRF'
            func = @processGRFData;
            dirs = {settings.grfs};
            ext = '.txt';
            args = {settings.grf_rotations};
            folder_names = {settings.grf_folder};
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
    
    % If requested, create nested save directories according to dataset
    % structure function.
    paths = cell(n_dirs, n_files);
    if isfield(settings, 'dataset_structure_function')
        for i=1:n_dirs
            map = generateFilenameToPathMap(...
                files{i, :}, settings.context_parameters);
            paths(i, :) = {map(};
        for i=1:n_files
            paths{:, i} = settings.dataset_structure_function(files{1, i});
        end
    else
        for i=1:n_dirs
            paths(i, :) = {[settings.save_dir filesep folder_names{i}]};
        end
    end
    
    status = 0;
    for i=1:n_files
        try
            % Make the paths if they don't exist.
            for j=1:n_dirs
                if ~exist(paths{j, i}, 'dir')
                    mkdir(paths{j, i});
                end
            end
            
            % Run the desired processing function. 
            func(paths{:, i}, files{:, i}, args{:});
        catch err
            status = 1;
            fprintf('Failed to process on entry %i.\n', i);
            fprintf(err.message);
            fprintf('\n');
            if settings.info 
                disp(getReport(err, 'extended', 'hyperlinks', 'on'));
            end
        end
    end

end
