% This script performs automatic processing of marker + grf data collected
% in the Gait lab at the University of Edinburgh.

%% Parameters.
data_folder = '';  % Folder containing .TRC data.
marker_rotations = {0,0,0};  % [x,y,z] rotations (in deg) required to get marker
                             % data in to OpenSim coord system.
save_motion = '';  % Motion data save directory. 

%% Processing.
processMarkerData(data_folder, marker_rotations, save_motion);