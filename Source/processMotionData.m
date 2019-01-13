% This script performs automatic processing of marker + grf data collected
% in the Gait lab at the University of Edinburgh. 

%% Setup parameters.
input_folder = 'C:\Users\danie\Documents\GitHub\motion-data-processing\Source\billy';  % Folder containing .TRC and .TXT data.
static_folder = [input_folder filesep 'static'];  % Folder containing static .TRC data.
time_delay = 0;  % Time delay of markers relative to grfs. 
marker_rotations = {0,0,0};  % [x,y,z] rotations (in deg) required to get marker
                             % data in to OpenSim coord system.
grf_rotations = {0,0,0};  % Similar to above but for GRFs.
save_dir = 'billy_test';  % Directory in which resultant fils are saved. 

%% Get the files.
marker_files = dir([input_folder filesep '*.trc']);
grf_files = dir([input_folder filesep '*.txt']);
static_files = dir([static_folder filesep '*.trc']);
n_files = length(grf_files);
n_static = length(static_files);

% Need the same amount of files (for synchronisation).
if length(marker_files) ~= n_files
    error('This script assumes access to GRF and marker data for all files.');
end

%% Processing. Steps are as follows: 
% Processing of GRF data + .MOT creation.
% Synchronisation of data.
% Co-ordinate system correction. 
% Gait cycle segmentation. 
for i=1:n_files
    try
        input_grf = [input_folder filesep grf_files(i).name];
        input_markers = [input_folder filesep marker_files(i).name];
        output_markers = [save_dir filesep marker_files(i).name];
        output_grf = produceMOT(input_grf);
        [grfs, markers] = synchronise(output_grf, input_markers, time_delay);
        markers.rotate(marker_rotations{:});
        grfs.rotate(grf_rotations{:});
        markers.writeToFile(output_markers);
        grfs.writeToFile(output_grf);

        segment('left', 'stance', 40, output_grf, input_markers, save_dir);
        segment('right', 'stance', 40, output_grf, input_markers, save_dir);
    catch err
        fprintf('\nFailed to process on entry %i. Error message below.\n', i);
        warning(err.message);
    end
end

% %% Static processing.
% for i=1:n_static
%     static_input = [static_folder filesep static_files(i).name];
%     static_output = [savedir filesep static_files(i).name];
%     produceStatic(static_input, static_output); 
% end