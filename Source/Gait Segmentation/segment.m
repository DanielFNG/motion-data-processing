function segment(...
    side, mode, cutoff, grfs, kinematics, save_dir)
% Segment marker and grf files. 
%   GRFS is a filename corresponding to the grf file to be segmented.
%   KINEMATICS is a filename corresponding to the marker file to be segmented.
%       Note: segment can be used with only one type of file, though this limits
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
        file = grfs;
    case 'toe-peak'
        func = @segmentMarkers;
        args = {side};
        file = kinematics;
end

%% Identify the correct indices
segmentation_times = func(args{:}, file);

%% File output 
files = {grfs kinematics};
for i = 1:length(files)
    if ~isempty(files{i})
        whole_file = Data(files{i});
        [~, name, ext] = fileparts(files{i});
        for j = 1:length(segmentation_times)
            suitable_frames = ...
                (whole_file.Timesteps >= segmentation_times{j}(1) & ...
                whole_file.Timesteps <= segmentation_times{j}(end));
            segment = whole_file.slice(suitable_frames);
            segment.writeToFile(...
                [save_dir filesep name '_' side '_cycle' num2str(j) ext]);
        end
    end
end