% This script performs automatic processing of marker + grf data collected
% in the Gait lab at the University of Edinburgh. Gait segmentation is employed 
% to split data in to individual gait cycles.

%% Parameters.
data_folder = '';  % Folder containing .TRC and .TXT data.
static_folder = '';  % Folder containing static .TRC data.
time_delay = 0;  % Time delay of markers relative to grfs. 
marker_rotations = {0,0,0};  % [x,y,z] rotations (in deg) required to get marker
                             % data in to OpenSim coord system.
grf_rotations = {0,0,0};  % Similar to above but for GRFs.
segmentation_mode = 'stance';
save_static = '';  % Static save directory.
save_motion = '';  % Motion data save directory. 
save_segmented = '';  % Segmented motion data save directory. 

%% Processing.
processStaticData(static_folder, marker_rotations, save_static);
processGaitData(data_folder, marker_rotations, grf_rotations, time_delay, ...
    segmentation_mode, cutoff, save_motion);