% Generic script processing of motion data collected at the UoE Gait Lab.

% Ensure that no old settings are passed to the batchProcessData function.
clear('settings');

settings.analysis = 'GRF';
settings.grfs = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking';
settings.save_dir = 'D:\Dropbox\PhD\HIL Control\Automation-test\walking\test_GRF';
settings.info = 0;
settings.grf_rotations = {0, 90, 0};

% Processing.
batchProcessData(settings);