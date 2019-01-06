function segment(...
    side, mode, cutoff, grfs, kinematics, save_dir)
% Segment marker and grf files. 
%   GRFS is a filename or cell array of filenames, corresponding to grf files
%   which are to be segmented.
%   KINEMATICS is a filename or cell array of filenames, corresponding to
%   marker files which are to be segmented.
%       Note: if both grfs and kinematics are provided, they are assumed to be
%       1:1 and so length(grfs) == length(kinematics) is required.
%   SIDE is a string taking the value 'right' or 'left', and decides which 
%   foot/leg is used for gait cycle segmentation.
%   MODE is a string taking one of the following values: 'stance', 'toe-peak'.
%       If mode = 'stance', segmentation indices are
%       found for all grf files, and are applied to the corresponding
%       kinematics files.
%       If mode = 'toe-peak', segmentation indices are found for all
%       kinematics files, and are applied to the corresponding grf files.
%   CUTOFF < FY denotes the stance phase:
%           Mode = 'toe-peak' => cutoff = []
%   SAVE_DIR is the directory where output files are saved. 
%
%   Example usage:
%       segment('stance', [0.0122, 40], {'grf1.mot', 'grf2.mot'}, [])
%       segment('stance', [0, 40], 'grf.mot', 'kin.mot')
%       segment('toe-peak', [0.05], {'grf1.mot', 'grf2.mot'}, ...
%           {'kin1.mot', 'kin2.mot'})

%% Checks

n_grfs = length(grfs);
n_kinematics = length(kinematics);

if n_grfs ~= n_kinematics && min(n_grfs, n_kinematics) ~= 0
    error('If both provided, grfs and kinematics must have same length.');
end

if n_kinematics == 0 && strcmp(mode, 'toe-peak')
    error('Cannot segment only GRF files using hip-peak segmentation.');
end

if n_grfs == 0 && ~strcmp(mode, 'toe-peak')
    error('Cannot segment only marker files using grf-based segmentation.');
end

%% Parameter switching
switch mode
    case 'stance'
        primary = n_grfs;
        func = @segmentGRF;
        args = {side, cutoff};
        files = grfs;
    case 'toe-peak'
        primary = n_kinematics;
        func = @segmentMarkers;
        args = {side};
        files = kinematics;
end

%% Main loop to identify the correct indices
segmentation_indices = cell(1, primary);
for i=1:primary
    segmentation_indices{i} = func(args{:}, files(i));
end

%% File output 
files = [grfs kinematics];
for i = 1:length(files)
    whole_file = Data(files(i));
    cycles = segmentation_indices{i};
    [~, name, ext] = fileparts(files(i));
    for j = 1:length(cycles)
        segment = whole_file.slice(cycles{j});
        segment.writeToFile(...
            [save_dir filesep name '_' side '_cycle' num2str(j) ext]);
    end
end