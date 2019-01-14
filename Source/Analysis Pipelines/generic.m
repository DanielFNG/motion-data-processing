% This script performs automatic processing of marker + grf data collected
% in the Gait lab at the University of Edinburgh.

%% Parameters.
data_folder = '';  % Folder containing .TRC and .TXT data.
static_folder = '';  % Folder containing static .TRC data.
time_delay = 0;  % Time delay of markers relative to grfs. 
marker_rotations = {0,0,0};  % [x,y,z] rotations (in deg) required to get marker
                             % data in to OpenSim coord system.
grf_rotations = {0,0,0};  % Similar to above but for GRFs.
save_static = '';  % Static save directory.
save_motion = '';  % Motion data save directory. 

%% Processing.
processStaticData(static_folder, marker_rotations, save_static);
processMotionData(...
    data_folder, marker_rotations, grf_rotations, time_delay, save_motion);