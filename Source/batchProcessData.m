function status = batchProcessData(folder_paths, settings)

    sources = fieldnames(folder_paths);
    n_sources = length(sources);
    
    % Get paths to all files
    n = zeros(1, n_sources);
    for i = 1:n_sources
        [n(i), file_paths.(sources{i})] = dirNoDots(folder_paths.(sources{i}));
    end
    
    % Check we have the same number of files for each source
    if n/n(1) ~= ones(1, n_sources)
        error('Must have same number of files for each data source.');
    end
    
    % Get class and class arguments from settings info. Also create save
    % directories for each source.
    handles = cell(1, n_sources);
    class_args = cell(1, n_sources);
    save_dirs = cell(1, n_sources);
    for i = 1:n_sources
        handles{i} = getClassHandle(sources{i});
        class_args{i} = getClassArguments(sources{i}, settings);
        save_dirs{i} = [settings.SaveDirectory filesep sources{i}];
    end
    
    % Get processing arguments
    processing_args = getProcessingArguments(sources, settings);
    
    status = 0;
    for i = 1:n(1)
        
        % Create an array for the motions and save directories
        motions = cell(1, n_sources);
        
        % For each motion...
        for j = 1:n_sources
        
            % Add it to the motion array
            motions{j} = ...
                handles{j}(file_paths.(sources{j}){i}, class_args{j}{:});
        
        end
        
        try
            % Process the resulting motions
            processed_motions = processMotionData(motions, processing_args{:});

            % Write the processed motions
            writeSegmentedMotions(processed_motions, save_dirs);
        catch err
            status = 1;
            fprintf('Failed to process on entry %i.\n%s\n', i, err.message);
            if settings.info
                disp(getReport(err, 'extended', 'hyperlinks', 'on'));
            end
        end
        
    end
 
    
    function handle = getClassHandle(str)
        
        switch str
            case 'Markers'
                handle = @MarkerData;
            case 'GRF'
                handle = @GRFData;
            case 'EMG'
                handle = @EMGData;
            case 'Calorimetry'
                handle = @CalorimetryData;
        end
        
    end
    
    function args = getClassArguments(str, settings)
    
        switch str
            case 'Markers'
                args = {settings.CoordinateTranslation, ...
                    settings.CoordinateRotation};
            case 'GRF'
                args = {settings.GRFSystem, settings.Inclination};
            case 'EMG'
                args = {};
            case 'Calorimetry'
                % Not yet implemented
        end
    
    end

    function args = getProcessingArguments(sources, settings)
        
        args = {[], [], [], [], [], []};
        
        if isfield(settings, 'Baseline')
            sync_index = find(strcmp(settings.Baseline, sources));
            delays = zeros(1, length(sources));
            for k = 1:length(sources)
                delays(k) = settings.([sources{k} 'Delay']);
            end
            args{1} = sync_index;
            args{2} = delays;
        end
        
        if isfield(settings, 'Speed')
            args{3} = settings.Speed;
            args{4} = settings.GRFDelay;
        end
        
        if isfield(settings, 'SegmentationMode')
            switch settings.SegmentationMode
                case 'Stance'
                    source = 'GRF';
                case 'Kinematics' 
                    source = 'Markers';
            end
            seg_index = find(strcmp(source, sources));
            if strcmp(settings.Feet, 'Both')
                side = {'Left', 'Right'};
            else
                side = settings.Feet;
            end
            args{5} = seg_index;
            args{6} = side;
        end
        
        
    end

end