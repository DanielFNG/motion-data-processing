function segment(...
    side, mode, cutoff, grfs, kinematics, save_dir)
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
%   CUTOFF < FY denotes the stance phase:
%           Mode = 'toe-peak' => cutoff = []
%   SAVE_DIR is the directory where output files are saved. 
%
%   Example usage:
%       segment('stance', 'left', [35], 'grf.mot', [], pwd)
%       segment('stance', 'right', [40], 'grf.mot', 'kin.mot', pwd)
%       segment('toe-peak', 'right', [], [], 'kin.mot', pwd)

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
        args = {side, cutoff};
        motion_data = grfs;
    case 'toe-peak'
        func = @segmentMarkers;
        args = {side};
        motion_data = kinematics;
end

%% Identify the correct indices
segmentation_times = func(args{:}, motion_data);

%% File output 
combined_motion_data = {grfs kinematics};
for i = 1:length(combined_motion_data)
    if ~isempty(combined_motion_data{i})
        motion_data = combined_motion_data{i};
        [~, name, ext] = fileparts(motion_data.File);
        for j = 1:length(segmentation_times)
            suitable_frames = ...
                (motion_data.Timesteps >= segmentation_times{j}(1) & ...
                motion_data.Timesteps <= segmentation_times{j}(end));
            segment = motion_data.slice(suitable_frames);
            segment.writeToFile(...
                [save_dir filesep name '_' side '_cycle' num2str(j) ext]);
        end
    end
end