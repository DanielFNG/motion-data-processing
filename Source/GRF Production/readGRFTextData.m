function [time, forces, moments] = readGRFTextData(input_file)
%   Read & store forces/moments from D-Flow produced .txt file.
%   Resulting format is as follows:
%   
%   forces(:, 1)/forces(:, 2)/... = left_x/left_y/...
%   forces{:, 4)/... = right_x/...
%   
%   Moments are ordered in the same way. 

% Read in text data.
grfs = importdata(input_file);

% Create arrays for storage.
row_length = size(grfs.data, 1);
forces = zeros(row_length, 6);
moments = zeros(row_length, 6);

% Save time array.
time = grfs.data(:, 1);

% Assign appropriate force/moment values.
forces(:, 1:3) = grfs.data(:, 6:8);
forces(:, 4:6) = grfs.data(:, 15:17);
moments(:, 1:3) = grfs.data(:, 9:11);
moments(:, 4:6) = grfs.data(:, 18:20);

end