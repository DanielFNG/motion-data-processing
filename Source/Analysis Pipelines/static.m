% This script performs automatic processing of static data collected
% in the Gait lab at the University of Edinburgh.

%% Parameters

% Folder containing static .TRC data.
static_folder = '';  

% [x,y,z] rotations (in deg) required to get marker data in to OpenSim 
% coord system.
marker_rotations = {0, 270, 0}; 

% Static save directory.
save_static = '';

%% Processing.
processStaticData(static_folder, marker_rotations, save_static);