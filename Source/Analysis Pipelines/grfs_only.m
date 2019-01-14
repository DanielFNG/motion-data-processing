% This script performs automatic processing of marker + grf data collected
% in the Gait lab at the University of Edinburgh.

%% Parameters.
data_folder = '';  % Folder containing .TXT data.
grf_rotations = {0,0,0};  % [x,y,z] rotations (in deg) required to get grf
                          % data in to OpenSim coord system.
save_grfs = ''; 

%% Processing.
processGRFData(data_folder, grf_rotations, save_grfs);