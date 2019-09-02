function status = batchProcessData(settings)

    switch settings.analysis
        case 'Static'
            func = @processStaticData;
            dirs = {settings.markers};
            ext = '.trc';
            args = {settings.marker_system};
            folder_names = {settings.static_folder};
        case 'Motion'
            func = @processMotionData;
            dirs = {settings.markers, settings.grfs};
            args = {settings.marker_system, settings.grf_system, ...
                settings.x_offset, settings.y_offset, settings.z_offset, ...
                settings.time_delay, settings.speed, settings.inclination, ...
                settings.assistance_params};
            folder_names = {settings.marker_folder, settings.grf_folder};
        case 'Marker'
            func = @processMarkerData;
            dirs = {settings.markers};
            ext = '.trc';
            args = {settings.marker_system, settings.speed, ...
                settings.inclination};
            folder_names = {settings.marker_folder};
        case 'GRF'
            func = @processGRFData;
            dirs = {settings.grfs};
            ext = '.txt';
            args = {settings.grf_system, settings.speed, ...
                settings.inclination, settings.assistance_params};
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
            else
                n_files = n_markers;
            end
            files = [markers; grfs];
    end
    
    % Reconstruct file list to take in to account the possibility of a
    % subset of files being specified. Note that settings.FileSubset can
    % be 1:n_files, in which case files is unchanged. 
    if isfield(settings, 'subset')
        file_list = settings.subset;
        files = files(:, file_list);
        n_files = size(files, 2);
    end
    
    % Get the paths to the speed files if necessary. 
    if isfield(settings, 'speed') && isa(settings.speed, 'char')
        [~, speeds] = getFilePaths(settings.speed, '.txt');
        speeds = speeds(file_list);
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
            
            % If necessary find and replace the speeds argument.
            if isfield(settings, 'speed') && isa(settings.speed, 'char')
                args{strcmp(args, settings.speed)} = speeds{i};
            end
            
            % Run the desired processing function. 
            func(paths{:, i}, files{:, i}, args{:});
            
            % Re-set the speeds argument.
            if isfield(settings, 'speed') && isa(settings.speed, 'char')
                args{strcmp(args, speeds{i})} = settings.speed;
            end
        catch err
            % If there are gaps at the start or end of a trial, and
            % auto-crop is selected, and we have marker data...
            if strcmp(err.identifier, 'Data:Gaps') && ...
                    settings.crop && ~strcmp(settings.analysis, 'GRF')
                try
                    % Crop the current trial.
                    removeMissingFrames(files{:, i});

                    % Re-run processing step.
                    func(paths{:, i}, files{:, i}, args{:});
                catch err2
                    status = 1;
                    fprintf('Failed to process on entry %i.\n', i);
                    fprintf(err2.message);
                    fprintf('\n');
                    fprintf(['It is likely that gaps are present in the '...
                        'data. Please correct within Vicon Nexus.\n']);
                    if settings.info
                        disp(getReport(err, 'extended', 'hyperlinks', 'on'));
                    end
                end
                
                % Re-set the speeds argument.
                if isfield(settings, 'speed') && isa(settings.speed, 'char')
                    args{strcmp(args, speeds{i})} = settings.speed;
                end
            else
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

end
