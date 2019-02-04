% Processing of marker data collected at the UoE Gait Lab.

% Ensure that no old settings are passed to the batchProcessData function.
clear('settings');

settings.analysis = 'Marker';
settings.markers = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking';
settings.save_dir = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking\test_Marker_segment';
settings.info = 0;
settings.marker_rotations = {0, 270, 0};
settings.feet = {'left', 'right'};
settings.mode = 'toe-peak';

% Processing.
batchProcessData(settings);