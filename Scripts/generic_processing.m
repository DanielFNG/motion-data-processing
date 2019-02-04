% Generic processing script including & explaining all possible settings.

% Ensure that no old settings are passed to the batchProcessData function.
clear('settings');

% The analysis you want to compute: 'Static', 'Motion', 'Marker', 'GRF'.
settings.analysis = 'Motion';

% The directory/directories containing the data. These need not be different.
settings.markers = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking';
settings.grfs = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking';

% The location you want your processed files to be saved. 
settings.save_dir = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking\test_Motion_segment';

% Enable/disable detailed output - useful for error checking.
settings.info = 0;

% Rotations for grf/marker data - standard values for UoE setup.
settings.marker_rotations = {0, 270, 0};
settings.grf_rotations = {0, 90, 0};

% Time delay between grf + marker data - standard value for UoE setup.
settings.time_delay = 16*(1/600);

% Segmentation mode. Options are 'stance' or 'toe-peak'. Highly recommended 
% to use 'stance' if GRF data is available; 'toe-peak' otherwise. Cutoff is the 
% force required to recognise start of stance.
settings.feet = {'left', 'right'};
settings.mode = 'stance';
settings.cutoff = 40;

% Processing.
batchProcessData(settings);