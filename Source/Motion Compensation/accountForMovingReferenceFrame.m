function corrected_positions = accountForMovingReferenceFrame(...
    positions, time, speed)
% Transform data to account for a moving reference frame (e.g. walking on
% treadmill).
%
% Input: 
%   positions - array of positions
%   time - e.g. time at positions(end) - time at positions(1)
%   speed - speed of travel
%
% Output:
%   speed-adjusted positions

    n_frames = length(positions);
    travel = speed*time;
    tx = linspace(0, travel, n_frames);
    corrected_positions = reshape(positions, n_frames, 1) + ...
        reshape(tx, n_frames, 1);

end
