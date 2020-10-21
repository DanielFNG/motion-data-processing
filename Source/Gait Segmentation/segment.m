function segmentation_times = segment(side, mode, grfs, kinematics, ...
    kin_save_dir, grf_save_dir, kin_save_folder, grf_save_folder)
% Segment marker and grf data. 
%   GRFS is a grf Data object to be segmented.
%   KINEMATICS is a kinematics Data object to be segmented.
%       Note: segment can be used with only one type of data, though this limits
%             the mode of operation (see MODE below).
%   SIDE is a string taking the value 'right' or 'left', and decides which 
%   foot/leg is used for gait cycle segmentation.
%   MODE is a string taking one of the following values: 'stance', 'toe-peak'.
%       If mode = 'stance', segmentation indices are
%       found for all grf files, and are applied to the corresponding
%       kinematics files.
%       If mode = 'toe-peak', segmentation indices are found for all
%       kinematics files, and are applied to the corresponding grf files.
%   NAME is a string which is part of the resultant filenames.
%   SAVE_DIR is the directory where output files are saved.

%% Checks
if isempty(kinematics) && strcmp(mode, 'toe-peak')
    error('Cannot segment only GRF files using hip-peak segmentation.');
elseif isempty(grfs) && strcmp(mode, 'stance')
    error('Cannot segment only marker files using stance segmentation.');
end

%% Parameter switching
switch mode
    case 'stance'
        func = @segmentGRF;
        motion_data = grfs;
    case 'toe-peak'
        func = @segmentMarkers;
        motion_data = kinematics;
end

%% File output 
combined_motion_data = {grfs kinematics};
save_dirs = {grf_save_dir kin_save_dir};
save_folders = {grf_save_folder kin_save_folder};

%% Identify the correct segmentation times
[segmentation_times, segmentation_frames] = func(side, motion_data);

%% Outlier removal
% This gets rid of gait cycles which are much shorter or longer than the
% mean, as these are assumed to be mistakes resulting from stepping on the
% wrong belt for example. Note this is problematic if we ever look at
% non-steady state walking - I'm going to make a note of this on GitHub. 
cycle_lengths = cellfun(@length, segmentation_times);
for i = 1:length(cycle_lengths)
    if cycle_lengths(i) < 600 || cycle_lengths(i) > 1600
        good_cycles(i) = 0;
    else
        good_cycles(i) = 1;
    end
end
good_cycles = logical(good_cycles);
%good_cycles = ~isoutlier(cycle_lengths);
segmentation_times = segmentation_times(good_cycles);
segmentation_frames = segmentation_frames(good_cycles);

%% Handle motion input data
if length(combined_motion_data(~cellfun('isempty', combined_motion_data))) == 2
    [marker_frames, grf_frames] = ...
        adjustSegmentationTimes(segmentation_times, grfs, kinematics);
    segmentation_frames = {grf_frames marker_frames};
else
    segmentation_frames = {segmentation_frames segmentation_frames};  % cheeky
end

%% Perform segmentation.
for i = 1:length(combined_motion_data)
    if ~isempty(combined_motion_data{i})
        side_save_dir = [save_dirs{i} filesep side filesep save_folders{i}];
        if ~exist(side_save_dir, 'dir')
            mkdir(side_save_dir);
        end
        motion_data = combined_motion_data{i};
        n_cycles = length(segmentation_frames{i});
        for j = 1:n_cycles
            digits = numel(num2str(n_cycles));
            segment = motion_data.slice(segmentation_frames{i}{j});
            segment.writeToFile([side_save_dir filesep 'cycle' ...
                sprintf(['%0' num2str(digits) 'i'], j)]);
        end
    end
end