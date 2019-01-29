% Automatic processing of motion data collected at the UoE Gait Lab.

% The analysis you want to compute. Options: 'Static', 'Motion', 'Marker', 
% 'GRF', 'Gait'.
analysis = 'GRF'

% The directory/directories containing the data. These need not be different.
markers = '';
grfs = '';

% The location you want your processed files to be saved. This should exist.
save_dir = '';

% Enable/disable detailed output - useful for error checking.
info = 0;

% Rotations for grf/marker data - standard values for UoE setup.
marker_rotations = {0, 270, 0};
grf_rotations = {0, 90, 0};

% Time delay between grf + marker data - standard value for UoE setup.
time_delay = 16*(1/600);

% Segmentation mode. Options are 'stance' or 'toe-peak'. Highly recommended 
% to use 'stance' if GRF data is available; 'toe-peak' otherwise. Cutoff is the 
% force required to recognise start of stance; leave as [] for 'toe-peak' mode.
mode = 'stance';
cutoff = 40;

% Processing.
batchProcessData(analysis, markers, grfs, save_dir, info, ...
    marker_rotations, grf_rotations, time_delay, mode, cutoff);