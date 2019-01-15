% This script performs automatic processing of marker + grf data collected
% in the Gait lab at the University of Edinburgh.

%% Parameters.

% Folder containing .TRC and .TXT data.
data_folder = 'C:\Users\danie\Documents\GitHub\motion-data-processing\Source\billy';

% Time delay of markers relative to grfs.
time_delay = 16*(1/600);  % 16 frames at 600Hz as measured by GH in 2017 

% [x,y,z] rotations (in deg) required to get marker/grf data in to OpenSim 
% coord system.
marker_rotations = {0,270,0};  
grf_rotations = {0,90,0};

% Motion data save directory.
save_motion = 'C:\Users\danie\Documents\GitHub\motion-data-processing\Source\billy_test';   

%% Processing.
processMotionData(...
    data_folder, marker_rotations, grf_rotations, time_delay, save_motion);