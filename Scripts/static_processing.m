% Generic processing script including & explaining all possible settings.

% Ensure that no old settings are passed to the batchProcessData function.
clear('settings');

% The analysis you want to compute: 'Static', 'Motion', 'Marker', 'GRF'.
settings.analysis = 'Static';
settings.markers = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking';
settings.save_dir = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking\test_Static';
settings.info = 0;
settings.marker_rotations = {0, 270, 0};

% Processing.
batchProcessData(settings);