function status = batchProcessData(settings)

    switch settings.analysis
        case 'Static'
            func = @processStaticData;
            dirs = {settings.markers};
            ext = '.trc';
            args = {settings.marker_rotations};
            folder_names = {settings.static_folder};
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
        args = [args {settings.feet}, settings.mode, settings.cutoff, ...
            folder_names];
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
    
    % Create save directories.
    paths = cell(n_dirs, n_files);
    for i=1:n_dirs
        if ~isfield(settings, 'mode')
            paths(i, :) = {[settings.save_dir filesep folder_names{i}]};
        else
            for j=1:n_files
                [~, name, ~] = fileparts(files{1, j});
                paths(i, j) = ...
                    {[settings.save_dir filesep name]};
            end
        end
    end
    
    status = 0;
    for i=1:n_files
        try
            % Make the paths if they don't exist - but only if not using
            % segment.
            if ~isfield(settings, 'mode')
                for j=1:n_dirs
                    if ~exist(paths{j, i}, 'dir')
                        mkdir(paths{j, i});
                    end
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
